# Exercise 5
def number_if(num)
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

def number_case(num)
  case
  when num < 0
    "Negative number is not allowed"
  when num <= 50
    "#{num} is between 0 and 50"
  when num <= 100
    "#{num} is between 51 and 100"
  else
    "#{num} is greater than 100"
  end
end

def evaluate_case2_num(num)
  case num
  when 0..50
    "#{num} is between 0 and 50"
  when 51..100
    "#{num} is between 51 and 100"
  else
    if num < 0
      "Negative number is not allowed"
    else
      "#{num} is greater than 100"
    end
  end
end

puts "Please provide a number between 0 and 100"
number = gets.chomp.to_i

puts number_if(number)
puts number_case(number)
puts evaluate_case2_num(number)
