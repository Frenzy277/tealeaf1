# Exercise 7
# class Student
#   attr_accessor :name

#   def initialize(name, grade)
#     @name = name
#     @grade = grade
#   end

#   def better_grade_than?(obj)
#     self.grade < obj.grade
#   end

#   protected

#   def grade
#     @grade
#   end
# end

# joe = Student.new("Joe", 4)
# bob = Student.new("Bob", 5)
# puts "Well done!" if joe.better_grade_than?(bob)


# Exercise 8

# its because we are calling private method 'hi'
# make it public
class Person
  def hi
    puts "say hi!"
  end
end

bob = Person.new
bob.hi