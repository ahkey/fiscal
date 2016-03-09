class Event
  include Mongoid::Document
  belongs_to :calendar

  field :date, type: DateTime
  field :name, type: String
  field :country, type: String
  field :importance, type: String


end
