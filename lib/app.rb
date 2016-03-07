class App < Sinatra::Base

  require "parse"

  get '/' do
    "hi"
  end

  get '/current_week' do
    content_type :json

      @parse = Parse.new "https://www.dailyfx.com/calendar"
      @parse.parse_rows.to_json
  end

  get '/filter' do
    content_type :json
    country = "usd"
    importance = "high"
    if params[:country] != nil && params[:country] != ""
      country = params[:country]
    end

    if params[:importance] != nil && params[:importance] != ""
      importance = params[:importance]
    end
      @parse = Parse.new "https://www.dailyfx.com/calendar"
      @parse.parse_rows.filter(country: country, importance:importance).to_json
  end

end
