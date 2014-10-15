# Exercise 3
pets = { dog: "andy", cat: "nikita", mouse: "jerry" }

pets.keys.each do |k|
  puts k
end

pets.values.each do |v|
  puts v
end

pets.each do |k, v|
  puts "#{k} is a key and a value should be here #{v}"
end