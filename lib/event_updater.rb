class EventUpdater


  def self.start
    parse = Parse.new "test/cal.html"
    current_week = parse.cweek
      unless self.have_data_for_week? *current_week
        self.create_events_for_week *current_week,parse.events
      end
  end

  def self.have_data_for_week? (week = Date.today.cweek, year = Date.today.cwyear)
    if Calendar.where(week:week,year:year).count > 0
      return true
    end
    return false
  end

  def self.create_events_for_week (w = Date.today.cweek, year = Date.today.cwyear, events = nil)

    e = Calendar.new
    e.week = w
    e.year = year
    e.events << events
    e.save

  end

end
