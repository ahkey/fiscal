require "test_helper"
require "parse"

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
