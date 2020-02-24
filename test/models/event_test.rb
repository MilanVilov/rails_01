require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "one simple test example" do
    Event.create kind: "opening", starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: "appointment", starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal "2014/08/10", availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal "2014/08/11", availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]
    assert_equal [], availabilities[2][:slots]
    assert_equal "2014/08/16", availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "that .availabities raises exception if argument not date" do
    assert_raises ArgumentError do
      availabilities = Event.availabilities SecureRandom.random_number
    end
    assert_raises ArgumentError do
      availabilities = Event.availabilities SecureRandom.hex
    end
  end

  test "that all slots are taken if opening and appointment time and date overlap" do
    Event.create kind: "opening", starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: "appointment", starts_at: DateTime.parse("2014-08-11 09:30"), ends_at: DateTime.parse("2014-08-11 12:30")

    availabilities = Event.availabilities DateTime.parse("2014-08-11")
    assert_equal "2014/08/11", availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
  end

  test "that two recurring openings same day different time are both added to open slots" do
    Event.create kind: "opening", starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 10:30"), weekly_recurring: true
    Event.create kind: "opening", starts_at: DateTime.parse("2014-08-04 11:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true

    availabilities = Event.availabilities DateTime.parse("2014-08-11")
    assert_equal "2014/08/11", availabilities[0][:date]
    assert_equal 4, availabilities[0][:slots].count
  end

  test "that one recurring one fixed opening same day different time are both added to open slots" do
    Event.create kind: "opening", starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 10:30"), weekly_recurring: true
    Event.create kind: "opening", starts_at: DateTime.parse("2014-08-11 11:30"), ends_at: DateTime.parse("2014-08-11 12:30"), weekly_recurring: false

    availabilities = Event.availabilities DateTime.parse("2014-08-11")
    assert_equal "2014/08/11", availabilities[0][:date]
    assert_equal 4, availabilities[0][:slots].count
  end

  test "that two openings same start different end time do not add duplicate slots" do
    Event.create kind: "opening", starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 10:30"), weekly_recurring: true
    Event.create kind: "opening", starts_at: DateTime.parse("2014-08-11 09:30"), ends_at: DateTime.parse("2014-08-11 12:30"), weekly_recurring: false

    availabilities = Event.availabilities DateTime.parse("2014-08-11")
    assert_equal "2014/08/11", availabilities[0][:date]
    assert_equal 6, availabilities[0][:slots].count
  end
end
