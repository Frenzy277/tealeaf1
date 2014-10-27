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

  # def change_car_info(year, color, model)
  #   self.year = year
  #   self.color = color
  #   self.model = model

  # end

  # def car_info
  #   "#{color} colored #{model} was manufactured in #{year}."
  # end

end

ford = MyCar.new(1985, "Red", "Ford Mustang")

ford.speed_up(120)
p ford.current_speed
ford.brake(80)
p ford.current_speed
ford.brake(40)
p ford.current_speed
ford.shut_the_car_off
p ford.current_speed

ford.change_view("purple")
ford.view

#ford.change_car_info(1996, "Silver", "Dodge Viper")