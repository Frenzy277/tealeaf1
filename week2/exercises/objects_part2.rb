# 1., 2. answer
class MyCar
  attr_accessor :color, :model
  attr_reader :year
  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
  end

  def speed_up(speed)
    @current_speed += speed
    puts "speeding up to #{speed} kmph!"
  end

  def brake(speed)
    @current_speed -= speed
    puts "braking to #{speed} kmph!"
  end

  def current_speed
    @current_speed
  end

  def shut_the_car_off
    @current_speed = 0
    puts "#{model}' engine was shut down!"
  end

  def change_view(c)
    self.color = c
    puts "the color of car was changed to #{color}"
  end

  def view
    puts "Year of the car is: #{year}"
  end

  def spray_paint(c)
    self.color = c
  end

  def self.gas_mileage(liters, kms)
    puts "#{kms / liters} kms per liter of gas"
  end

  def to_s
    "sdsdsdsds"
  end
end

my_car = MyCar.new("2010", "Ford Focus", "silver")
puts MyCar.gas_mileage(5, 100)
puts my_car
p "#{my_car}"


# 3. because we are trying to set bob.name to "Bob" but we do not have any setter method
#    neither attr_accessor or writter.
  
