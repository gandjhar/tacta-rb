require './contacts_file.rb'

contacts = []

contacts << { id: 1, name: "Thomas Jefferson", phone: "+1 206 310 1369" , email: "tjeff@us.gov"       }
contacts << { id: 2, name: "Charles Darwin"  , phone: "+44 20 7123 4567", email: "darles@evolve.org"  }
contacts << { id: 3, name: "Nikola Tesla"    , phone: "+385 43 987 3355", email: "nik@inductlabs.com" }
contacts << { id: 4, name: "Genghis Khan"    , phone: "+976 2 194 2222" , email: "contact@empire.com" }
contacts << { id: 5, name: "Malcom X"        , phone: "+1 310 155 8822" , email: "x@theroost.org"     }

write_contacts( contacts )