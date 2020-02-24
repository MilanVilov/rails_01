class Event < ApplicationRecord
  def self.availabilities(start_date)
    availabilities = Hash.new
    end_date = start_date + 6.day
    openings(start_date, end_date).or(appointments(start_date, end_date)).group_by { |event| event.starts_at.to_date.wday }.map { |day, events|
      key = get_date(start_date, end_date, day).strftime("%Y/%m/%d")
      availabilities[key] = create_availability(events)
    }

    start_date.upto(end_date.to_date).map { |day|
      {
        :date => day.strftime("%Y/%m/%d"),
        :slots => availabilities[day.strftime("%Y/%m/%d")] == nil ? [] : availabilities[day.strftime("%Y/%m/%d")],
      }
    }
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

  def self.get_date(start_date, end_date, wday)
    date = nil
    start_date.upto(end_date).each { |day|
      if day.wday == wday
        date = day
        break
      end
    }
    date
  end

  def self.create_availability(events)
    #using Hash as searching trough key is fast for these type of usecases
    slots = Hash.new
    events.each { |event|
      if event.kind == "opening"
        (event.starts_at.to_datetime.to_i..(event.ends_at.to_datetime - 30.minutes).to_i).step(30.minutes) { |slot|
          slots[Time.at(slot).utc.strftime("%-H:%M")] = true
        }
      elsif event.kind == "appointment"
        (event.starts_at.to_datetime.to_i..(event.ends_at.to_datetime - 30.minutes).to_i).step(30.minutes) { |slot|
          slots[Time.at(slot).utc.strftime("%-H:%M")] = false
        }
      end
    }
    slots = slots.filter { |key, value| value }.keys
  end
end
