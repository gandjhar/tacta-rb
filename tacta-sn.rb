require 'sinatra'
require './contacts_file'

set :port, 4567

get '/' do
   "<h1>Tacta Contact Manager</h1>"
end

get '/contacts' do
   @contacts = read_contacts
   erb :'contacts/index'
end

get '/contacts/:i' do
   i = params[:i].to_i
   contacts = read_contacts
   @contact = contacts[i - 1]
   erb :'contacts/show'
end
