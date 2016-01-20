require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  session[:lists] ||= []
end

get "/" do
  redirect "/lists"
end

# View list of lists
get "/lists" do
  @lists = session[:lists]
  erb :lists#, layout: :layout  # A way to pass something into the layout template in one line
end

# Render new list form
get "/lists/new" do
  erb :new_list, layout: :layout
end

# Create a new list form
post "/lists" do
  list_name = params[:list_name].strip
  if (1..100).cover? list_name.size
    session[:lists] << { name: params[:list_name], todos: [] }
    session[:success] = "The list hash been created."
    redirect "/lists"
  else
    session[:error] = "The list name must be between 1 and 100 characters."
    erb :new_list, layout: :layout
  end
end