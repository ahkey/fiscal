require "nokogiri"
require "open-uri"
require "pry"
require "models/calendar"
require "models/event"

class Parse
  CONTENT_DIV = "#calendarbody"
  DATE_RANGE_ROW = 5

 def initialize(url)
  page = open(url)
  @document = Nokogiri::HTML(page)
 end

 def content_body
   @document.css(CONTENT_DIV) rescue nil
 end

 def date_row
   content_body.css(".row")[DATE_RANGE_ROW].at_css("div").css("span") rescue nil
 end

 def cweek(from_index = 1, to_index = 3)
    row = date_row
    start_date = Date.parse row[from_index].content rescue Date.today
    [start_date.cweek, start_date.cwyear]
 end

 def current_week(from_index = 1, to_index = 3)
    row = date_row
    start_date = Date.parse row[from_index].content rescue Date.today
    to_date =  Date.parse row[to_index].content rescue Date.today
    "#{start_date.strftime("%d-%b-%Y")} to #{to_date.strftime("%d-%b-%Y")}"
 end

 def events
   events = Array.new
   content_body.css(".event").each do |r|
    row = r.css("td")
    events << Event.new(
      date: Date.parse(row[1].content),
      country: row[2].at_css("div").values.first[-3,3],
      name: row[3].children.last.content,
      importance: row[4].css("span").first.content
    )
   end
  events
 end
end
