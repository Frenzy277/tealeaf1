require_relative 'shared_constants'

module ParamsHelpers
  include SharedConstants
  
  private

  def name_params
    puts "Welcome to the house, what is your name?"
    gets.chomp.capitalize
  end

  def difficulty_params
    begin
      puts "Select game difficulty (type either: easy/hard/challenge)"
      answer = gets.chomp.downcase
    end until DIFFICULTY.include?(answer)
    
    case answer
    when 'easy'
      { name: answer, level: 10, minimal_bet: EASY_MIN_BET, decks: [4, 5].sample }
    when 'hard'
      { name: answer, level: 5, minimal_bet: HARD_MIN_BET, decks: [6, 7].sample }
    when 'challenge'
      { name: answer, level: 5, minimal_bet: CHALLENGE_MIN_BET, decks: 8 }
    when 'MIT student'
      # todo
    end
  end

  def bet_params
    begin
      puts "Your balance is €#{self.player.balance}."
      puts "Minimum bet is €#{self.minimal_bet}. How much do you want to bet?"
      answer = gets.chomp.to_i
      
      # Invalid bets.
      if answer < self.minimal_bet || answer > self.player.balance || answer.odd?
        puts "We accept only even bets. Odd bets will not be accepted"
        puts "Invalid bet. Insert even value in range your balance - €#{self.player.balance}."
      end
      
      # All-in comment.
      puts "Wow, you are going all-in. Good luck!" if answer == self.player.balance
    end until answer >= self.minimal_bet && answer <= self.player.balance && answer.even?
    
    puts "Bet accepted. Your bet is €#{answer}."
    sleep 1
    answer
  end

  def decision_params
    if offer_double_down?
      begin
        puts "Hit, Stay or Double down? (type either: hit/stay/double)"
        answer = gets.chomp.downcase
      end until %w(hit stay double).include?(answer)
    else
      begin
        puts "Hit or Stay? (type either: hit/stay)"
        answer = gets.chomp.downcase
      end until %w(hit stay).include?(answer)
    end
    answer
  end

  def offer_double_down?
    self.player.has_two_cards? && self.player.has_enough_for?('double')
  end

end