require 'pry'
player1 = { score: 20 }; dealer1 = { score: 19 }  # player wins
player2 = { score: 19 }; dealer2 = { score: 20 }  # player loses
player3 = { score: 21 }; dealer3 = { score: 21 }  # player loses
player4 = { score: 21 }; dealer4 = { score: 21 }  # player wins
player5 = { score: 20 }; dealer5 = { score: 20 }  # player pushes
player3[:comment] = "21 but no Blackjack"; dealer3[:comment] = "Blackjack"
player4[:comment] = "Blackjack"; dealer4[:comment] = "21 but no Blackjack"


def compare_scores(player, dealer)
  if player[:score] > dealer[:score]
    player[:status] = 'Win'
  elsif player[:score] < dealer[:score]
    player[:status] = 'Loss'
  elsif player[:score] == dealer[:score]
    if (player[:comment] == "21 but no Blackjack") && (dealer[:comment] == "Blackjack")
      player[:status] = 'Loss'
    elsif (player[:comment] == "Blackjack") && (dealer[:comment] == "21 but no Blackjack")
      player[:status] = 'Win'
    else
      player[:status] = 'Push'
    end
  end
end

p compare_scores(player1, dealer1)
p compare_scores(player2, dealer2)
p compare_scores(player3, dealer3)
p compare_scores(player4, dealer4)
p compare_scores(player5, dealer5)

binding.pry