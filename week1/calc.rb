require 'pry'
handA = [["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11]]
hand0 = [["AS", 11], ["KS", 10]]
hand  = [["AS", 11], ["2S", 2]]
hand2 = [["2S", 2], ["6H", 6]]
hand3 = [["AS", 11], ["AS", 11]]
hand4 = [["2S", 2], ["10H", 10], ["10S", 10]]
hand5 = [["2S", 2], ["10H", 10], ["AS", 11]]
hand6 = [["2S", 2], ["10H", 10], ["5S", 5], ["3S", 3]]
hand7 = [["2S", 2], ["10H", 10], ["4S", 4], ["2H", 2], ["AH", 11]]
hand8 = [["2S", 2], ["2D", 2],   ["4S", 4], ["2H", 2], ["AH", 11]]
hand9 = [["2S", 2], ["2D", 2],   ["4S", 4], ["2H", 2], ["AH", 11], ["AD", 11]]
hand10 = [["2S", 2], ["2D", 2],  ["4S", 4], ["2H", 2], ["AH", 11], ["AD", 11], ["AH", 11], ["AD", 11], ["7S", 7]]
hand11 = [["2S", 2], ["2D", 2],  ["4S", 2], ["2H", 2], ["AH", 2], ["AD", 11], ["AH", 11], ["AD", 11], ["8S", 8], ["AD", 11]]
hand12 = [["AS", 11], ["JS", 10]]
hand13 = [["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11]]
hand14 = [["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11], ["AS", 11]]

#hands = [hand10, hand11]
hands = [handA, hand0, hand, hand2, hand3, hand4, hand5, hand6, hand7, hand8, hand9, hand10, hand11, hand12, hand13, hand14]

def calculate(hand)
  values = hand.map { |card| card[1] }
  value = values.inject(:+)
  
  # Blackjack only
  if (value == 21) && (hand.size == 2)
    return { score: 21, status: 'Stay', comment: "Blackjack" }
  end

  # Aces only
  if values.count == (value / 11)
    ace_count = values.count
    if ace_count > 21
      return { score: ace_count, status: 'Loss', comment: "Busted" }
    elsif (ace_count == 21) || (ace_count == 11)
      return { score: 21, status: 'Stay', comment: "21 but not Blackjack" }
    elsif ace_count > 11
      return { score: ace_count }
    else
      return { score: ace_count + 10 }
    end
  end

  # At least 1 ace drawn = Mixed
  if values.include?(11)
    no_ace_value = values.select { |non_ace| non_ace < 11 }.inject(:+)
    gap = 21 - no_ace_value
    ace_count = values.select { |ace| ace == 11 }.count

    if gap == ace_count
      { score: 21, status: 'Stay', comment: "21 but no Blackjack" }
    elsif gap < ace_count
      { score: no_ace_value + ace_count, status: 'Loss', comment: "Busted" }
    elsif gap > ace_count
      z = gap - ace_count
      if z == 10
        { score: 21, status: 'Stay', comment: "21 but no Blackjack" }
      elsif z < 10
        { score: ace_count + no_ace_value }
      elsif z > 10 
        { score: 31 - z }
      end
    end
  else # No aces drawn
    if value > 21
      { score: value, status: 'Loss', comment: "Busted" }
    elsif value == 21
      { score: 21, status: 'Stay', comment: "21 but no Blackjack" }
    else 
      { score: value }
    end
  end
end

hands.each do |h|
  hand_value = calculate(h)
  p hand_value
  # binding.pry
end

# handA = { score: 21, status: "stay", comment: "21 but no Blackjack" }
# hand0 = { score: 21, status: "stay", comment: "Blackjack" }
# hand  = { score: 13 }
# hand2 = { score: 8 }
# hand3 = { score: 12 }
# hand4 = { score: 22, status: "loss", comment: "Busted" }
# hand5 = { score: 13 }
# hand6 = { score: 20 }
# hand7 = { score: 19 }
# hand8 = { score: 21, status: "stay", comment: "21 but no Blackjack" }
# hand9 = { score: 12 }
# hand10 = { score: 21, status: "stay", comment: "21 but no Blackjack" }
# hand11 = { score: 22, status: "loss", comment: "Busted" }
# hand12 = { score: 21, status: "stay", comment: "Blackjack" }
# hand13 = { score: 21, status: "stay", comment: "21 but no Blackjack" }
# hand14 = { score: 22, status: "loss", comment: "Busted" }