# Exercise 3
def number_check(num)
  if num >= 0 && num <= 50
    "#{num} is between 0 and 50"
  elsif num > 50 && num <= 100
    "#{num} is between 51 and 100"
  elsif num > 100
    "#{num} is greater than 100"
  else
    "Negative number is not allowed"
  end

end

puts "Please provide a number between 0 and 100"
number = gets.chomp.to_i

puts number_check(number)