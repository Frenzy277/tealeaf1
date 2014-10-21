require 'pry'
p0 = { hand: [["10S", 10], ["10S", 10]], score: 20, balance: 1000, bet: 600 }         # no double
p1 = { hand: [["AS", 11], ["9S", 9]], score: 20,    balance: 1000, bet: 900 }         # no double
p2 = { hand: [["9S", 9], ["10S", 10]], score: 19,   balance: 1000, bet: 100 }         # double
p3 = { hand: [["4S", 4], ["6S", 6]], score: 10,     balance: 1000, bet: 100 }         # double
p4 = { hand: [["2S", 2], ["7S", 7]], score: 9,      balance: 1000, bet: 700 }         # no double
p5 = { hand: [["4S", 4], ["7S", 7]], score: 11,     balance: 1000, bet: 100 }         # double
p6 = { hand: [["4S", 4], ["5S", 5], ["2S", 2]], score: 11, balance: 1000, bet: 100 }  # no double
p7 = { hand: [["8S", 8], ["AS", 11]], score: 19,    balance: 1000, bet: 500 }         # double
p8 = { hand: [["2S", 2], ["6S", 6]], score: 8,      balance: 1000, bet: 100 }         # double

def has_enough_for_double?(player)
  player[:balance] >= player[:bet] * 2
end

def offer_double_down?(player)
  player[:hand].size == 2 && has_enough_for_double?(player)
end

def decide_action(player)
  begin
    p player
    if offer_double_down?(player)
      puts "Hit, Stay or Double down? (type either: hit/stay/double)"
    else
      puts "Hit or Stay? (type either: hit/stay)"
    end    
    answer = gets.chomp.downcase
  end until %w(hit stay double).include?(answer)
  answer
end

decision0 = decide_action(p0)
decision1 = decide_action(p1)
decision2 = decide_action(p2)
decision3 = decide_action(p3)
decision4 = decide_action(p4)
decision5 = decide_action(p5)
decision6 = decide_action(p6)
decision7 = decide_action(p7)
decision8 = decide_action(p8)
p decision0
p decision1
p decision2
p decision3
p decision4
p decision5
p decision6
p decision7
p decision8
binding.pry