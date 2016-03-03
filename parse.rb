require "minitest/autorun"
require "minitest/utils"
require "httparty"
require "csv"
require "json"
require "nokogiri"
require "pry"
#require "sinatra"



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
   content_body.css(".row")[DATE_RANGE_ROW].at_css("div").css("span")
 end

 def current_week(from_index = 1, to_index = 3)
    row = date_row
    start_date = Date.parse row[from_index].content
    to_date =  Date.parse row[to_index].content
    "#{start_date.strftime("%d-%b-%Y")} to #{to_date.strftime("%d-%b-%Y")}"
 end

end

class ParseTest < MiniTest::Test

  def setup
    url = "./cal.html"
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



end
