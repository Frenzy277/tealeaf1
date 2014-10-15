def some_method(arr)
  arr.select! { |a| a > 2 }
end

arr = [1, 2, 3, 4]
some_method(arr)

p arr

a = [1, 2, 3, 3]
b = a
c = a.uniq!

p a
p c