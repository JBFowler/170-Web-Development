require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @toc = File.readlines("data/toc.txt")

  erb :home
end

get "/chapters/1" do
  @title = "Chapter 1"
  @toc = File.readlines("data/toc.txt")
  @ch1_text = File.read("data/chp1.txt")

  erb :chapter
end
