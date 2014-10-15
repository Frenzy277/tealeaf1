arr = Array(1..17)
 
arr.each do |n| 
  puts "Creating a file for Exercise #{n}."

  file = File.new("#{n}.rb", "a+")
  file.puts("# Exercise #{n}")
  file.close
end