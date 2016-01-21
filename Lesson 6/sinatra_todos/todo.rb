require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
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
  erb :lists, layout: :layout  # A way to pass something into the layout template in one line
end

# Render new list form
get '/lists/new' do
  erb :new_list, layout: :layout
end

# View individual list
get '/lists/:id' do
  id = params[:id].to_i
  @list = session[:lists][id]
  erb :list, layout: :layout
end

# Return an error message if the name is invalid.  Return nil if name is valid.
def error_for_list_name(name)
  if !(1..100).cover? name.size
    "The list name must be between 1 and 100 characters."
  elsif session[:lists].any? { |list| list[:name] == name }
    "List name must be unique."
  end
end

# Create a new list form
post "/lists" do
  list_name = params[:list_name].strip
  
  error = error_for_list_name(list_name) 
  if error
    session[:error] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << { name: params[:list_name], todos: [] }
    session[:success] = "The list hash been created."
    redirect "/lists"
  end
end

# Edit an existing todo list
get "/lists/:id/edit" do
  id = params[:id].to_i
  @list = session[:lists][id]
  erb :edit_list, layout: :layout
end

post "/lists/:id" do
  list_name = params[:list_name].strip
  id = params[:id].to_i
  list = session[:lists][id]
  
  error = error_for_list_name(list_name) 
  if error  
    session[:error] = error
    erb :edit_list, layout: :layout
  else
    list[:name] = list_name
    session[:success] = "The list hash been created."
    redirect "/lists/#{id}"
  end
end

post "/lists/:id/destroy" do
  id = params[:id].to_i
  session[:lists].delete_at(id)
  session[:success] = "The list has been deleted."
  redirect "/lists"
end

# Add a new todo to a list
post "/lists/:list_id/todos" do
  list_id = params[:list_id].to_i
  list = session[:lists][list_id]
  list[:todos] << {name: params[:todo], completed: false}
  session[:success] = "The todo has been added."
  redirect "/lists/#{list_id}"
end