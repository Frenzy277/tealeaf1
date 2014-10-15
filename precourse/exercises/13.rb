# Exercise 13
contacts = {"Joe Smith"=> {:email=>"joe@email.com", 
                           :street=>"123 Main st.", 
                           :phone=>"555-123-4567"}, 
            "Sally Johnson"=> {:email=>"sally@email.com", 
                               :street=>"404 Not Found Dr.", 
                               :phone=>"123-234-3454"}
           }

p contacts["Joe Smith"][:email]
p contacts["Sally Johnson"][:phone]