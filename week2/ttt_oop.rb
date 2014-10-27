# Tic, Tac, Toe OOP by Tomas Tomecek on 10/23/2014

module Available
  def available
    @board.fields.select { |k,v| v == ' ' }.keys
  end
end

class Board
  attr_reader :fields
  def initialize
    @fields = {}
    (1..9).each { |f| fields[f] = ' ' }
  end

  def displays
    system 'clear'
    puts "     |     |     "
    puts "  #{fields[1]}  |  #{fields[2]}  |  #{fields[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{fields[4]}  |  #{fields[5]}  |  #{fields[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{fields[7]}  |  #{fields[8]}  |  #{fields[9]}  "
    puts "     |     |     "
    puts ""
  end
end

class Player

  attr_accessor :fields
  
  def picks_from(available)
    begin
      puts "Choose a position #{available} to place a piece:"
      pick = gets.chomp.to_i
      unless available.include?(pick)
        puts "Not a correct choice! Try again."
      end
    end until available.include?(pick)
    
    @fields[player_pick] = 'X'

    #pick
  end
end

class Computer
  def picks_from(available)
    available.sample
  end
end

class TicTacToe
  include Available
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 5, 9], [7, 5, 3], [1, 4, 7], [2, 5, 8], [3, 6, 9]]

  attr_accessor :board, :fields, :player, :computer
  def initialize
    @player = Player.new
    @computer = Computer.new
    @board = Board.new
    @fields = @board.fields
  end

  def play
    @board.displays
    loop do
      player_pick = @player.picks_from(available)
      #@fields[player_pick] = 'X'
      @board.displays
      evaluate_winner(@player)
      
      computer_pick = @computer.picks_from(available)
      @fields[computer_pick] = 'O'
      @board.displays
      evaluate_winner(@computer)
    end
  end

  private

  def taken?(line, obj)
    if obj == @player
      # checks if player has 3 Xs in a line
      @fields.values_at(*line).count('X') == 3
    else
      # checks if computer has 3 Os in a line
      @fields.values_at(*line).count('O') == 3
    end
  end

  def evaluate_winner(obj)
    WINNING_LINES.each do |line|
      if taken?(line, obj)
        @board.displays
        binding.pry
        puts "#{obj.class.name} won!"
        exit
      elsif available.empty?
        "It's a tie!"
      end
    end
  end
end

TicTacToe.new.play