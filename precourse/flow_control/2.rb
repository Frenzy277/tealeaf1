# Exercise 2
def hi_there(string = "")
  if string.length > 10
    string.upcase
  else
    string
  end
end

puts hi_there("Hi The")