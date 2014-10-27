module Towable
  def can_tow?(tons)
    tons < 1000 ? true : false
  end
end

class Vehicle
  @@number_of_vehicles = 0

  attr_accessor :color, :model
  attr_reader :year

  def self.number_of_vehicles
    puts "This program has created #{@@number_of_vehicles} vehicles"
  end

  def self.gas_mileage(liters, kms)
    puts "#{kms / liters} kms per liter of gas"
  end

  def age
    puts "Show cards age! #{calculate_age}"
  end

  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up(speed)
    @current_speed += speed
    puts "speeding up to #{speed} kmph!"
  end

  def brake(speed)
    @current_speed -= speed
    puts "braking to #{speed} kmph!"
  end

  def shut_the_car_off
    @current_speed = 0
    puts "#{model}' engine was shut down!"
  end

  def change_view(c)
    self.color = c
    puts "the color of car was changed to #{color}"
  end

  def current_speed
    @current_speed
  end

  def view
    puts "Year of the car is: #{year}"
  end

  def spray_paint(c)
    self.color = c
  end

  private
    def calculate_age
      Time.now.year - year
    end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4
  def to_s
    "my car is #{model}, from #{year}"
  end
end

class MyTruck < Vehicle
  include Towable
  NUMBER_OF_DOORS = 2

  def to_s
    "my truck is #{model}, from #{year}"
  end
end


car = MyCar.new(1985, "Ford Siesta", "Black")
puts car.age
