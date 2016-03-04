class Event
  def initialize(attributes={})
    @event = attributes
  end

  def name(t)
    case t
    when Regexp
      @event[:name][t]
    when String
      @event[:name] == t
    end
  end

  def country(g)
    @event[:country] == g
  end

  def importance(y)
    @event[:importance] == y
  end

  def details
    @event
  end

end
