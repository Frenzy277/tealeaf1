require_relative 'shared_constants'
require 'pry'

class Player
  include SharedConstants

  attr_accessor :balance, :hand, :score, :status, :comment, :bet, :extra_bet
  attr_reader :name

  def initialize(name)
    @name = name
    @balance = START_BALANCE
  end

  def has_two_cards?
    @hand.size == 2
  end

  def determine_status_comment
    if @score > 21
      self.status = 'loss'
      self.comment = 'Busted'
    elsif @score == 21 && has_two_cards?
      self.status = 'stay'
      self.comment = 'Blackjack'
    elsif @score == 21
      self.status = 'stay'
      self.comment = "21 but no Blackjack"
    else
      self.status = 'decide'
    end
  end

  def calculate_hand
    values = self.hand.map { |card| card.value }
    self.score = values.inject(:+)

    values.select { |v| v == 11 }.count.times do
      self.score -= 10 if self.score > 21
    end

    determine_status_comment
  end

  def has_blackjack?
    @comment == "Blackjack"
  end

  def clean_up!
    self.status  = nil
    self.comment = nil
    self.score   = nil
  end

  def decrease_balance!(amount)
    self.balance -= amount
  end

  def increase_balance!(amount)
    self.balance += amount
  end

  def update_status!(action)
    @status = action
  end

  def stay?
    @status == 'stay'
  end

  def decide?
    @status == 'decide'
  end

  def double?
    @status == 'double'
  end

  def hit?
    @status == 'hit'
  end

  def loss?
    @status == 'loss'
  end

  def has_sufficient_balance?(minimal_bet)
    if @balance < minimal_bet
      puts "We are sorry, but your balance #{@balance} is insufficient."
      return false
    end
    true
  end

  def has_enough_for?(subject)
    if %w(double split).include?(subject)
      @balance >= @bet
    elsif subject == 'extra'
      @balance >= @bet / 2
    end
  end

  def say_game_result(msg)
    puts "#{msg} #{@name}\'s balance is €#{@balance}."
  end

  def results_handler
    case @status
      when 'loss'
        case @comment
        when "Busted"
          say_game_result("#{@name} is over 21 - busted!")
        when "Dealer Blackjack"
          say_game_result("#{@name} loses, dealer has Blackjack.")
        when "Dealer greater"
          say_game_result("#{@name} loses, dealer was closer to 21.")
        when "21 but no Blackjack"
          say_game_result("#{@name} loses, dealer has Blackjack.")
        end
      when 'win'
        if has_blackjack?
          increase_balance!((@bet * 2) + (@bet / 2))
          say_game_result("#{@name} has a Blackjack and wins!")
        elsif @comment == "Player greater"
          increase_balance!(@bet * 2)
          say_game_result("#{@name} wins! #{@name}\'s score was closer to 21.")
        else # Dealer busted
          increase_balance!(@bet * 2)
          say_game_result("#{@name} wins! Dealer busts!")
        end
      when 'push'
        increase_balance!(@bet)
        say_game_result("It's a push.")
      when 'insurance'
        increase_balance!(@extra_bet * 3)
        say_game_result("Dealer has Blackjack but #{@name} is insured.")
      when 'even money bet'
        increase_balance!((@extra_bet * 3) + @bet)
        say_game_result("Dealer has Blackjack but Even money bet saved #{@name}.")
      end
  end
end