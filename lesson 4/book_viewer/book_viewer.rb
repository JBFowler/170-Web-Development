require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "Some title"
  @toc = File.readlines("data/toc.txt")

  erb :home
end
