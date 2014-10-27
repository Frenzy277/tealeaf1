require_relative 'shared_constants'

class Difficulty
  include SharedConstants
  
  attr_reader :name, :level, :decks, :minimal_bet
  def initialize(options)
    @name        = options[:name]
    @level       = options[:level]
    @minimal_bet = options[:minimal_bet]
    @decks       = options[:decks]
  end

  def challenge?
    self.name == 'challenge'
  end

  def escalate?(game_count)
    game_count % level == 0
  end

  def increase_minimal_bet
    case name
    when 'easy'       then minimal_bet.increment_by!(EASY_MIN_BET)
    when 'hard'       then minimal_bet.increment_by!(HARD_MIN_BET)
    when 'challenge'  then minimal_bet.increment_by!(CHALLENGE_MIN_BET)
    end
    puts "Minimal bet has increased. Now, it is €#{minimal_bet}."
    sleep 2
    minimal_bet
  end

end