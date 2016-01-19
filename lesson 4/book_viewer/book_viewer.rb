require "sinatra"
require "sinatra/reloader"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @toc = File.readlines("data/toc.txt")

  erb :home
end

get "/chapters/:number" do
  @toc = File.readlines("data/toc.txt")

  number = params[:number].to_i
  chapter_name = @toc[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do 
  params[:name]
end
