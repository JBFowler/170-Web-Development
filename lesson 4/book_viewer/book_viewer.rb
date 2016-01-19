require "sinatra"
require "sinatra/reloader"

helpers do
  def in_paragraphs(content)
    content.split("\n\n").map do |line|
      "<p>#{line}</p>"
    end.join
  end
end

before do
  @toc = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"

  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @toc[number - 1]
  @title = "Chapter #{number}: #{chapter_name}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do 
  params[:name]
end

not_found do
  redirect "/"
end
