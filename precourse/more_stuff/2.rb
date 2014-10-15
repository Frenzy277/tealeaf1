# Exercise 2
def execute(&block)
  block
end

execute { puts "Hello from inside the execute block!" }

puts "It returns a Proc object but prints out nothing because block was not called"