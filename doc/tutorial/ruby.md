We will make a Tacta, a Contact list manager with a simple text menu interface.

## Contacts List

Display a list of contacts.

File: tacta.rb

```ruby
contacts = []

contacts << { name: "Thomas Jefferson", phone: "+1 206 310 1369" , email: "tjeff@us.gov"       }
contacts << { name: "Charles Darwin"  , phone: "+44 20 7123 4567", email: "darles@evolve.org"  }
contacts << { name: "Nikola Tesla"    , phone: "+385 43 987 3355", email: "nik@inductlabs.com" }
contacts << { name: "Genghis Khan"    , phone: "+976 2 194 2222" , email: "contact@empire.com" }
contacts << { name: "Malcom X"        , phone: "+1 310 155 8822" , email: "x@theroost.org"     }

contacts.each_with_index do |contact, i|
   puts "#{i}) #{contact[:name]}"
end
```

Run with

```
ruby tacta.rb
```

Output:

```
0) Thomas Jefferson
1) Charles Darwin
2) Nikola Tesla
3) Genghis Khan
4) Malcom X
```

Oops, maybe better to number from 1 instead of 0.

```ruby
contacts.each_with_index do |contact, i|
   puts "#{i+1}) #{contact[:name]}"
end
```

Output:

```
1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X
```


## Show Selected Contact

```ruby
puts
print "Who would you like to see? "
response = gets.chomp

i = response.to_i

contact = contacts[i-1]

puts
puts "#{contact[:name]}"
puts "phone: #{contact[:phone]}"
puts "email: #{contact[:email]}"
```

Ouput:

```
1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see? 3

Nikola Tesla
phone: +385 43 987 3355
email: nik@inductlabs.com
```

## Factor Methods

Create methods from the code for listing the contacts (index) and displaying a contact (show).

```ruby
def index( contacts )
   contacts.each_with_index do |contact, i|
      puts "#{i+1}) #{contact[:name]}"
   end
end

def show( contact )
   puts "#{contact[:name]}"
   puts "phone: #{contact[:phone]}"
   puts "email: #{contact[:email]}"
end
```

Main code becomes simpler.

```ruby
index( contacts )

puts
print "Who would you like to see? "
response = gets.chomp

i = response.to_i

contact = contacts[i-1]

puts
show( contact )
```

## Ask

Factor further with method to prompt user.

```ruby
def ask( prompt )
   print prompt
   gets.chomp
end
```

Main becomes simpler again.

```ruby
index( contacts )

puts
response = ask "Who would you like to see? "

i = response.to_i

contact = contacts[i-1]

puts
show( contact )
```

## Loop

Loop instead of exiting after a single contact lookup.

```ruby
loop do
   index( contacts )

   puts
   response = ask "Who would you like to see? "

   i = response.to_i

   contact = contacts[i-1]

   puts
   show( contact )
   puts
end
```

Output

```
1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see? 3

Nikola Tesla
phone: +385 43 987 3355
email: nik@inductlabs.com

1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see? 4

Genghis Khan
phone: +976 2 194 2222
email: contact@empire.com
```

## Quit

Add option to quit.  Break out of loop.

```ruby
loop do
   # ...

   response = ask "Who would you like to see (q to quit)? "

   break if response == "q"

   # ...
end

puts
puts "Bye!"
```

Output
```
1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see (q to quit)? 3

Nikola Tesla
phone: +385 43 987 3355
email: nik@inductlabs.com

1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see (q to quit)? q

Bye!
```

## New Contact

Add option to create a new contact.

```ruby
loop do
   index( contacts )

   puts
   response = ask "Who would you like to see (n for new, q to quit)? "

   break if response == "q"

   if response == "n"
      contact = {}

      puts
      puts "Enter contact info:"

      contact[:name ] = ask "Name? "
      contact[:phone] = ask "Phone? "
      contact[:email] = ask "Email? "

      contacts << contact

      puts
      puts "New contact created:"
      puts

      show( contact )
      puts
   else
      i = response.to_i

      contact = contacts[i-1]

      puts
      show( contact )
      puts
   end

end
```

Output:

```
Who would you like to see (n for new, q to quit)? n

Enter contact info:
Name? Oscar Wilde
Phone? +353 1 677 9549
Email? ageless@graypic.com

New contact created:

Oscar Wilde
phone: +353 1 677 9549
email: ageless@graypic.com

1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X
6) Oscar Wilde

Who would you like to see (n for new, q to quit)?
```

## Factor Create New

Loop is getting complex.  Factor the create new contact.

```ruby
def create_new
   contact = {}

   puts
   puts "Enter contact info:"

   contact[:name ] = ask "Name? "
   contact[:phone] = ask "Phone? "
   contact[:email] = ask "Email? "

   contact
end
```

The loop becomes simpler

```ruby
if response == "n"

   contact = create_new

   contacts << contact

   puts
   puts "New contact created:"
   puts

   show( contact )
   puts
else
   ...
```

## Actions

Loop still seems too complicated.  Factor the actions for new and show.

```ruby
def action_new( contacts )
   contact = create_new

   contacts << contact

   puts
   puts "New contact created:"
   puts

   show( contact )
   puts
end

def action_show( contacts, i )
   contact = contacts[i-1]

   puts
   show( contact )
   puts
end
```

Loop is back to a manageable size.

```ruby
loop do
   index( contacts )

   puts
   response = ask "Who would you like to see (n for new, q to quit)? "

   break if response == "q"

   if response == "n"
      action_new( contacts )
   else
      action_show( contacts, response.to_i )
   end
end
```

## Delete Contact

Add an action to delete a contact.

```ruby
def action_delete( contacts )
   puts
   response = ask "Delete which contact? "

   i = response.to_i

   puts
   puts "Contact for #{contacts[i-1][:name]} deleted."

   contacts.delete_at( i-1 )

   puts
end
```

Offer it in the menu.

```ruby
loop do
   index( contacts )

   puts
   response = ask "Who would you like to see (n for new, d for delete, q to quit)? "

   break if response == "q"

   if response == "n"
      action_new( contacts )
   elsif response == "d"
      action_delete( contacts )
   else
      action_show( contacts, response.to_i )
   end
end
```

Can now delete contacts.

```
1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see (n for new, d for delete, q to quit)? d

Delete which contact? 3

Contact for Nikola Tesla deleted.

1) Thomas Jefferson
2) Charles Darwin
3) Genghis Khan
4) Malcom X

Who would you like to see (n for new, d for delete, q to quit)?
```

## Unknown Commands

Should graciously handle unknown commands.  First, need to recognize numbers by matching a pattern.  Then show message if response is not a command or a number.

The pattern `[0-9]+` matches a sequence of one or more digits.

```ruby
def action_error
   puts
   puts "Sorry, I don't recognize that command."
   puts
end
```

```ruby
if response == "n"
   action_new( contacts )
elsif response == "d"
   action_delete( contacts )
elsif response =~ /[0-9]+/
   action_show( contacts, response.to_i )
else
   action_error
end
```

Output

```
1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see (n for new, d for delete, q to quit)? 1

Thomas Jefferson
phone: +1 206 310 1369
email: tjeff@us.gov

1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see (n for new, d for delete, q to quit)? x

Sorry, I don't recognize that command.

1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see (n for new, d for delete, q to quit)?
```

## Search

Offer a search option.  In the pattern, the \b means a word boundary, and the 'i' at the end makes it case insensitive.

Define the action

```ruby
def action_search( contacts )
   puts
   pattern = ask "Search for? "
   puts

   contacts.each do |contact|
      if contact[:name] =~ /\b#{pattern}/i
         show( contact )
         puts
      end
   end
end
```

Offer search in the menu.

```ruby
loop do
   index( contacts )

   puts
   response = ask "Who would you like to see (n for new, d for delete, s for search, q to quit)? "

   break if response == "q"

   if response == "n"
      action_new( contacts )
   elsif response == "d"
      action_delete( contacts )
   elsif response == "s"
      action_search( contacts )
   elsif response =~ /[0-9]+/
      action_show( contacts, response.to_i )
   else
      action_error
   end
end
```

Output

```
1) Thomas Jefferson
2) Charles Darwin
3) Nikola Tesla
4) Genghis Khan
5) Malcom X

Who would you like to see (n for new, d for delete, s for search, q to quit)? s

Search for? t

Thomas Jefferson
phone: +1 206 310 1369
email: tjeff@us.gov

Nikola Tesla
phone: +385 43 987 3355
email: nik@inductlabs.com
```

## Persist Contacts

Contacts disappear on exit.  Persist contacts in a file instead of an array.  Use JSON format.

File: contacts.json

```json
[
  {
    "name": "Thomas Jefferson",
    "phone": "+1 206 310 1369",
    "email": "tjeff@us.gov"
  },
  {
    "name": "Charles Darwin",
    "phone": "+44 20 7123 4567",
    "email": "darles@evolve.org"
  },
  {
    "name": "Nikola Tesla",
    "phone": "+385 43 987 3355",
    "email": "nik@inductlabs.com"
  },
  {
    "name": "Genghis Khan",
    "phone": "+976 2 194 2222",
    "email": "contact@empire.com"
  },
  {
    "name": "Malcom X",
    "phone": "+1 310 155 8822",
    "email": "x@theroost.org"
  }
]
```

Remove the old array of contacts

```ruby
contacts = []

contacts << { name: "Thomas Jefferson", phone: "+1 206 310 1369" , email: "tjeff@us.gov"       }
contacts << { name: "Charles Darwin"  , phone: "+44 20 7123 4567", email: "darles@evolve.org"  }
contacts << { name: "Nikola Tesla"    , phone: "+385 43 987 3355", email: "nik@inductlabs.com" }
contacts << { name: "Genghis Khan"    , phone: "+976 2 194 2222" , email: "contact@empire.com" }
contacts << { name: "Malcom X"        , phone: "+1 310 155 8822" , email: "x@theroost.org"     }
```

Replace with code to read and write the contacts file

```ruby
require 'json'

def read_contacts
   json = File.read( 'contacts.json' )
   array = JSON.parse( json, { :symbolize_names => true } )
end

def write_contacts( contacts )
   File.open( "contacts.json", "w" ) do |f|
      json = JSON.pretty_generate( contacts )
      f.write( json  )
   end
end
```

Use read_contacts to load the contacts

```ruby
loop do
   contacts = read_contacts

   index( contacts )

   puts
   response = ask "Who would you like to see (n for new, d for delete, s for search, q to quit)? "

   # ...
end
```

Use write_contacts to update the file after adding or deleting a contact

```ruby
def action_new( contacts )
   contact = create_new

   contacts << contact

   write_contacts( contacts )

   puts
   puts "New contact created:"
   puts

   show( contact )
   puts
end

def action_delete( contacts )
   puts
   response = ask "Delete which contact? "

   i = response.to_i

   puts
   puts "Contact for #{contacts[i-1][:name]} deleted."

   contacts.delete_at( i-1 )

   write_contacts( contacts )

   puts
end
```

## Seeding Test Data

Common in development to seed the data for testing.  Can write a seeds.rb program which will setup contacts.json with the test data.

Move the read and write methods to a file that can be shared by both the main app `tacta.rb` and the seeding script `seeds.rb`

File: contacts_file.rb

```ruby
require 'json'

def read_contacts
   json = File.read( 'contacts.json' )
   array = JSON.parse( json, { :symbolize_names => true } )
end

def write_contacts( contacts )
   File.open( "contacts.json", "w" ) do |f|
      json = JSON.pretty_generate( contacts )
      f.write( json  )
   end
end
```

Create the seeding script.

File: seeds.rb

```ruby
require './contacts_file'

contacts = []

contacts << { name: "Thomas Jefferson", phone: "+1 206 310 1369" , email: "tjeff@us.gov"       }
contacts << { name: "Charles Darwin"  , phone: "+44 20 7123 4567", email: "darles@evolve.org"  }
contacts << { name: "Nikola Tesla"    , phone: "+385 43 987 3355", email: "nik@inductlabs.com" }
contacts << { name: "Genghis Khan"    , phone: "+976 2 194 2222" , email: "contact@empire.com" }
contacts << { name: "Malcom X"        , phone: "+1 310 155 8822" , email: "x@theroost.org"     }

write_contacts( contacts )
```

Run the script with

```
ruby seeds.rb
```

This command should create or overwrite the existing contacts.json file, setting it to the original test data.

Also remove the file code from tacta.rb and replace it with a require statement as well.

File: tacta.rb
```ruby
require './contacts_file'

# rest of app ...
```

## Summary

The simple Tacta application illustrates many basic Ruby and application programming aspects.

- Console I/O
- Control flow with branching and looping
- Working with arrays and hashes
- String Interpolation
- Factoring with methods
- Actions in response to requests
- String Patterns (regular expressions)
- File I/O
- Persisting Data
- JSON format
- Seeding test data
