# Exercise 3
arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

new_arr = arr.select { |n| n if n.odd? }

p new_arr