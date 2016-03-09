class Calendar
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
  embeds_many :events

  field :week, type: Integer
  field :year, type: Integer

end
