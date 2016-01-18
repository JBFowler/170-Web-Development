require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "Some title"
  erb :home
end
