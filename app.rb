require 'sinatra'
require 'sinatra/reloader'
require 'haml'
require 'json'
require 'coffee-script'
require 'coffee-filter'

get '/' do
  haml :index, :format => :html5
end

get '/app.js' do
  coffee :'app.js'
end
