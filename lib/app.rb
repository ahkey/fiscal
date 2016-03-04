class App < Sinatra::Base

  require "parse"

  get '/' do
    content_type :json
      @parse = Parse.new "https://www.dailyfx.com/calendar"
      @parse.parse_rows.to_json
  end

end
