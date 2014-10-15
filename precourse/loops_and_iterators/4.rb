# Exercise 4
def countdown(x)
  puts x
  if x > 0
    countdown(x - 1)
  end
end

countdown(5)
countdown(-2)