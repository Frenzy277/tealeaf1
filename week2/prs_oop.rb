# Paper, Rock, Scissors by Tomas Tomecek on 10/23/2014
# my first OOP with Ruby.

class Player
  
  def chooses
    question("Choose one:", "P/R/S")
  end

  def plays_again?
    question("Play again?", "Y/N") == 'y' ? true : false
  end

  private

  def question(question, answers)
    begin
      puts "#{question} (#{answers})"
      answer = gets.chomp.upcase
      unless answers.include?(answer)
        puts "That was not a correct choice! (type either #{answers})"
      end
    end until answers.include?(answer)
    answer.downcase
  end
end

class Comparison
  attr_reader :player, :computer
  
  def initialize(player, computer)
    @player = player
    @computer = computer
  end

  def results
    if @player == @computer
      puts "It's a tie."
    elsif (@player == 'p' && @computer == 'r') || (@player == 'r' && @computer == 's') || 
          (@player == 's' && @computer == 'p')
      display_winning_message(@player)
      puts "You won!"
    else
      display_winning_message(@computer)
      puts "Computer won!"
    end
  end

  private

  def display_winning_message(choice)
    case choice
    when 'p' then puts "Paper wraps Rock!"
    when 'r' then puts "Rock beats Scissors!" 
    when 's' then puts "Scissors cuts Paper!"
    end
  end
end

class PaperRockScissors
  attr_accessor :player
  CHOICES = { 'p' => "Paper", 'r' => "Rock", 's' => "Scissors" }

  def initialize
    @player = Player.new
  end

  def run
    puts "Play Paper Rock Scissors!"
    loop do
      player_choice = @player.chooses
      comp_choice = CHOICES.keys.sample
      puts "You picked #{CHOICES[player_choice]} and computer picked #{CHOICES[comp_choice]}."
      comparison = Comparison.new(player_choice, comp_choice)
      comparison.results
      break unless @player.plays_again?
    end
  end
end

PaperRockScissors.new.run