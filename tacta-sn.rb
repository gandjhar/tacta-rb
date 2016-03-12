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

# Must come before 'show', since route
# also matches show with id='new'
get '/contacts/new' do
   erb :'contacts/new'
end

post '/contacts' do
   new_contact = { name: params[:name], phone: params[:phone], email: params[:email] }

   contacts = read_contacts

   contacts << new_contact

   write_contacts( contacts )

   i = contacts.length

   redirect "/contacts/#{i}"
end

get '/contacts/:i' do
   i = params[:i].to_i
   contacts = read_contacts
   @contact = contacts[i - 1]
   erb :'contacts/show'
end
