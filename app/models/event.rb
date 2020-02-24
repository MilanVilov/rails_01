class Event < ApplicationRecord
  def self.availabilities(start_date)
    raise ArgumentError unless valid_argument(start_date)

    availabilities = Hash.new
    end_date = start_date + 6.day

    #doing and chaining multiple scopes so that it would be one query to db
    # to load data and process in memory and avoid n+1 problem
    openings_and_appointments(start_date, end_date)
      .group_by { |event| event.starts_at.to_date.wday } #group by wday instead of date to overlap with recurring openings
      .map { |day, events|
      date_for_wday = get_date(start_date, end_date, day)
      availabilities[date_for_wday] = free_slots(events)
    }
    #this grouping by wday works for 7 days range , in case of more then
    #that we would probably need to check for the comparison
    #between current date and reccuring openings for that day using
    # sql query like (strftime('%w', '2018-08-04') as integer) and compare with
    # date.wday ( query mentioned is compatible with SQLite)
    map_to_response_model(start_date, end_date, availabilities)
  end

  scope :same_day_of_week_but_earlier, ->(start_date) {
      where(:kind => "opening", weekly_recurring: true).where(Event.arel_table[:starts_at].lt(start_date))
    }

  scope :exact_date_openings, ->(start_date, end_date) {
      where(:kind => "opening").where(starts_at: start_date.beginning_of_day..end_date.end_of_day)
    }

  scope :openings, ->(start_date, end_date) {
      same_day_of_week_but_earlier(start_date).or(exact_date_openings(start_date, end_date))
    }

  scope :appointments, ->(start_date, end_date) {
      where(:kind => "appointment").where(starts_at: start_date.beginning_of_day..end_date.end_of_day)
    }

  scope :openings_and_appointments, ->(start_date, end_date) {
          openings(start_date, end_date).or(appointments(start_date, end_date))
        }

  def self.get_date(start_date, end_date, wday)
    date = nil
    start_date.upto(end_date).each { |day|
      if day.wday == wday
        date = day
        break
      end
    }
    date.strftime("%Y/%m/%d")
  end

  def self.free_slots(events)
    #using Hash as searching trough key is fast for these type of usecases
    slots = Hash.new
    events.each { |event|
      if event.kind == "opening"
        add_slots(event, slots)
      elsif event.kind == "appointment"
        remove_slots(event, slots)
      end
    }
    slots = slots.filter { |key, value| value }.keys
  end

  def self.add_slots(event, slots)
    (event.starts_at.to_datetime.to_i..(event.ends_at.to_datetime - 30.minutes).to_i)
      .step(30.minutes) { |slot|
      slots[Time.at(slot).utc.strftime("%-H:%M")] = true
    }
  end

  def self.remove_slots(event, slots)
    (event.starts_at.to_datetime.to_i..(event.ends_at.to_datetime - 30.minutes).to_i)
      .step(30.minutes) { |slot|
      slots[Time.at(slot).utc.strftime("%-H:%M")] = false
    }
  end

  def self.valid_argument(date)
    date.is_a?(Date)
  end

  def self.map_to_response_model(start_date, end_date, availabilities)
    start_date.upto(end_date.to_date).map { |day|
      {
        :date => day.strftime("%Y/%m/%d"),
        :slots => availabilities[day.strftime("%Y/%m/%d")] == nil ? [] : availabilities[day.strftime("%Y/%m/%d")],
      }
    }
  end
end
