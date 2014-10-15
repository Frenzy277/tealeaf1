# Exercise 3
array = [1, 2, 3, 4, 5]

array.each_with_index do |n, index|
  puts "#{n} + #{index} = #{n + index}"
end