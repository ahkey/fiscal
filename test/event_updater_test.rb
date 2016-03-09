require "test_helper"
require "event_updater"

class EventUpdaterTest < MiniTest::Test

  def setup
    Calendar.delete_all
    @calendar = Calendar.new
  end

  def test_updater_class
    assert_instance_of Calendar, @calendar
  end

  def test_data_exits_for_week_and_year
    assert EventUpdater.have_data_for_week? == false
  end

  def test_create_events_for_week
    EventUpdater.start
    assert Calendar.count == 1
  end


  def test_create_event_dublicate_for_week
    EventUpdater.start
    EventUpdater.start
    assert Calendar.count == 1
  end

end
