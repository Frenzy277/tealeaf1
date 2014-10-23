# Paper, Rock, Scissors by Tomas Tomecek on 10/23/2014
# my first OOP with Ruby.

module Pickable
  private

  def pick(choice, condition = nil)
    case choice
    when 'p'
      return "Paper wraps Rock!" if condition
      "Paper"
    when 'r'
      return "Rock beats Scissors!" if condition
      "Rock"
    when 's'
      return "Scissors cuts Paper!" if condition
      "Scissors"
    end
  end
  alias :win :pick
end

class Player
  
  def chooses
    question("Choose one:", "P/R/S")
  end

  def play_again?
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
  include Pickable
  
  attr_reader :player, :computer
  
  def initialize(player, computer)
    @player = player
    @computer = computer
  end

  def results
    if self.player == self.computer
      puts "It's a tie."
    elsif paper_wraps_rock? || rock_beats_scissors? || scissors_cut_paper?
      puts win(self.player, true)
      puts "You won!"
    else
      puts win(self.computer, true)
      puts "Computer won!"
    end
  end

  private

  def paper_wraps_rock?
    self.player == 'p' && self.computer == 'r'
  end

  def rock_beats_scissors?
    self.player == 'r' && self.computer == 's'
  end

  def scissors_cut_paper?
    self.player == 's' && self.computer == 'p'
  end
end

class PaperRockScissors
  include Pickable
  attr_accessor :player

  def initialize
    @player = Player.new
  end

  def run
    puts "Play Paper Rock Scissors!"
    loop do
      player_choice = @player.chooses
      comp_choice = %w(p r s).sample
      puts "You picked #{pick(player_choice)} and computer picked #{pick(comp_choice)}."
      comparison = Comparison.new(player_choice, comp_choice)
      comparison.results
      break unless @player.play_again?
    end
  end
end

PaperRockScissors.new.run