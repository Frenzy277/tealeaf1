# Calculator assignment
require 'pry'
def ask_number(arg = '')
  puts "Please, write a #{arg} number."
end

def operation(num, sign)
  puts "#{num} = (#{sign})"
end

puts "Welcome to Frenzy277's calculator program"

ask_number('first')
num1 = gets.chomp
ask_number('second')
num2 = gets.chomp

puts "Decide what operation you want to perform:"
def calculator(num1, num2)
  puts "Select a number."
  operation(1, '+')
  operation(2, '-')
  operation(3, '*')
  operation(4, '/')
  operator = gets.chomp

  case operator
  when '1' then returned = num1.to_i + num2.to_i
  when '2' then returned = num1.to_i - num2.to_i
  when '3' then returned = num1.to_i * num2.to_i
  when '4'
    unless num2 == '0' 
      returned = num1.to_f / num2.to_f
    else
      puts("Can't divide by 0")
    end
  else 
    puts "--> You have entered wrong operator, calculator is restarting!"
    calculator(num1, num2)
  end

  if returned
    puts "Please, wait - calculating ..."
    sleep 1 # makes you think its working hard.
    puts "The result is #{returned}." 
  end
end

calculator(num1, num2)