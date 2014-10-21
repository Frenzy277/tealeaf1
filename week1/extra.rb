require 'pry'
YES_NO = %w(y n)
player = { hand: [["10S", 10], ["10S", 10]], score: 20, balance: 1000, bet: 500 }
player2 = { hand: [["AS", 11], ["10S", 10]], score: 21, balance: 1000, bet: 500, comment: "Blackjack" }
dealer = { hand: [["AS", 11], ["10S", 10]], score: 21 }
dealer2 = { hand: [["10S", 10], ["AS", 11]], score: 21 }

def has_enough_for_extra?(player)
  player[:balance] >= player[:bet] / 2
end

def offer_extra_option(player, subject)
  begin
    puts "Dealer has an Ace! Do you want to take #{subject}? (Y/N)"
    answer = gets.chomp.downcase
  end until YES_NO.include?(answer)

  if answer == 'y'
    extra_bet = player[:bet] / 2
    player[:balance] -= extra_bet
    new_balance = player[:balance]
    player.merge!(status: subject.downcase, extra_bet: extra_bet, balance: new_balance, feature: "#{subject} taken!")
  end
end

def extra_options(player, dealer)
  if dealer[:hand].first[0].start_with?("A") && has_enough_for_extra?(player)
    if player[:comment] == "Blackjack"
      offer_extra_option(player, "Even money bet")
    else
      offer_extra_option(player, "Insurance")
    end
  end
end

extra_options(player, dealer2) # nothing should be offered as dealer does not have an ace
p player
binding.pry
extra_options(player, dealer)  # insurance should be offered
p player
binding.pry
extra_options(player2, dealer) # even money bet should be offered
p player2
binding.pry