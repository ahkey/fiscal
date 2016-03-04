require "minitest/autorun"
require "minitest/utils"
require "nokogiri"
require "open-uri"
require "pry"
require "events"
require "event"

class Parse
  CONTENT_DIV = "#calendarbody"
  DATE_RANGE_ROW = 5

 def initialize(url)
   @page || @page = open(url)
 end

 def call
    Nokogiri::HTML(@page) rescue nil
 end

 def content_body
   call.css(CONTENT_DIV) rescue nil
 end

 def date_row
   content_body.css(".row")[DATE_RANGE_ROW].at_css("div").css("span") rescue nil
 end

 def current_week(from_index = 1, to_index = 3)
    row = date_row
    start_date = Date.parse row[from_index].content rescue Date.today
    to_date =  Date.parse row[to_index].content rescue Date.today
    "#{start_date.strftime("%d-%b-%Y")} to #{to_date.strftime("%d-%b-%Y")}"
 end

 def parse_rows
    events = Events.new
      content_body.css(".event").each do |r|
       row = r.css("td")
       events << Event.new(
         date: Date.parse(row[1].content),
         country: row[2].at_css("div").values.first[-3,3],
         name: row[3].children.last.content,
         importance: row[4].css("span").first.content,
         actual: row[5].content,
         forcast: row[6].content,
         previous: row[6].content
       )
     end
    events
 end

end

class ParseTest < MiniTest::Test

  def setup
    url = "./cal.html"
  #  url = "https://www.dailyfx.com/calendar"
    @parse = Parse.new url
  end

  def test_creates_a_parse_obect
    assert_instance_of Parse, @parse
  end

  def test_nokogiri_parse
    assert_kind_of Nokogiri::HTML::Document, @parse.()
  end

  def test_parse_content_body
    assert @parse.content_body.first.content.include?("from")
  end

  def test_parse_current_week
    assert_match @parse.current_week, "28-Feb-2016 to 05-Mar-2016"
  end

  def test_parse_row_count
    assert @parse.parse_rows.count == 194
  end

  def test_parse_data_row
    assert_match @parse.parse_rows.first.details[:name], "NZD Building Permits (MoM) (JAN)"
  end

  def test_country_code_substring
    assert_match @parse.parse_rows.filter(country: "nzd").sample.details[:country], "nzd"
  end

  def test_regex_name_search
    assert @parse.parse_rows.filter(name: /PMI/i).sample.details[:name].include?("PMI")
  end

  def test_country_filter
    assert_match @parse.parse_rows.filter(country:"usd").sample.details[:country], "usd"
  end

  def test_filter_by_country_and_importance
   assert_match @parse.parse_rows.filter(country:"usd", importance:"high").sample.details[:country], "usd"
  end

end
