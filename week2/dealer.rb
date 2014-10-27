require_relative 'shared_constants'

class Dealer < Player
  include SharedConstants

  attr_accessor :hide_hole, :house
  def initialize
    @house = HOUSE_TOTAL
    @hide_hole = true
  end

  def show_hole
    self.hide_hole = false
  end

  def says(words, add = '')
    puts "Dealer #{words} the pack#{add}."
    #sleep 1
  end

  def clean_up!
    super
    self.hide_hole = true
  end

end