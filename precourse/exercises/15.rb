# Exercise 15
arr = ['snow', 'winter', 'ice', 'slippery', 'salted roads', 'white trees']
new_arr = arr.delete_if { |a| a.start_with?("s") }
p new_arr

arr = ['snow', 'winter', 'ice', 'slippery', 'salted roads', 'white trees']
new_arr = arr.delete_if { |a| a.start_with?("s", "w") }
p new_arr