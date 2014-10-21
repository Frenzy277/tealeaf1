require 'pry'
player1 = { balance: 900, bet: 100, status: 'Loss', comment: "Busted" }
player2 = { balance: 900, bet: 100, status: 'Loss', comment: "Dealer greater" }
player3 = { balance: 900, bet: 100, status: 'Loss', comment: "21 but no Blackjack" }
player4 = { balance: 900, bet: 100, status: 'Win', comment: "Blackjack" }
player5 = { balance: 900, bet: 100, status: 'Win', comment: "Player greater" }
player6 = { balance: 900, bet: 100, status: 'Push' }



def win(player)
  case player[:status]
  when 'Loss'
    case player[:comment]
    when "Busted"
      puts "You are over 21 - busted! Your balance is €#{player[:balance]}."
    when "Dealer greater"
      puts "You lose, dealer was closer to 21. Your balance is €#{player[:balance]}."
    when "21 but no Blackjack"
      puts "You lose, dealer had a Blackjack. Your balance is €#{player[:balance]}."
    end
  when 'Win'
    if player[:comment] == "Blackjack"
      player[:balance] += ((player[:bet] * 2) + (player[:bet]/2))
      puts "You win! Your balance is €#{player[:balance]}"
    elsif player[:comment] == "Player greater"
      player[:balance] += (player[:bet] * 2)
      puts "You win! Your balance is €#{player[:balance]}"
    end
  when 'Push'
    player[:balance] += (player[:bet])
    puts "It's a push. Your balance is €#{player[:balance]}"
  end
end

win(player1)
win(player2)
win(player3)
win(player4)
win(player5)
win(player6)

binding.pry