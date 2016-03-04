class Events < Array
  def initialize(*events)
    super(events)
  end

  def filter(criteria={})
    self.select{ |m|
      criteria.all?{ |c, v|
        m.send(c, v)
      }
    }
  end
end
