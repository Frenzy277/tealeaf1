# Blackjack game - procedural. By Tomas Tomecek
# Features & Description:
# Deck cutting offered to player, cutting edges are 20-80% of pack size for player.
# Dealer always cuts at 80% edge.
# 
# Bets can only be positive number and in range of players balance.
# 3-2 pay-off when you get Blackjack and dealer does not.
# 
# Pack = 4 to 8 decks mixed, although everytime you start the game it selects randomly.
# Pack is not reshuffled after every game. This is to simulate real Blackjack casino play.
# Pack is reshuffled after each game where dealer finds card called SHUFFLE_REMINDER. 
# SHUFFLE_REMINDER is a card that is put into deck after dealers cut.
# Every game, the first card of pack is burned.
# 
# Player and Dealer are being represented by hashes.
# Dealer hides hole on purpose.
# Board is present and split on dealers side and players side.
# Intentionally slowing game in certain dialogues or when dealing cards.
# Also methods indentation is intentional, it helps me to scroll text in text editor.


# Constants
  # Cut edges LOWER 20% UPPER 80%
  LOWER = 20
  UPPER = 80
  SHUFFLE_REMINDER = 'shuffle reminder'
  YES_NO = %w(y n)
  # Types are spades, clubs, hearts, diamonds in that order
  CARD_TYPES = ["\u2660", "\u2663", "\u2665", "\u2666"] 
  CARDS_WITHOUT_TYPES = Array(2..10).push(%w(J Q K A)).flatten
# Randomly selects number of decks used at the beginning.
  number_of_decks = Array(4..8).sample

# Initialize pack
  def initialize_pack(number_of_decks = 4) # By default pack consists of 4 decks
    pack = []
    (1..number_of_decks).each do |deck|
      CARD_TYPES.each do |type|
        CARDS_WITHOUT_TYPES.each do |card|
          if card == "A"
            pack << ["#{card + type}", 11]
          elsif %w(J Q K).include?(card)
            pack << ["#{card + type}", 10]
          else
            pack << ["#{card.to_s + type}", card]
          end
        end
      end
    end

    pack
  end
# Display & Communication methods
  def display_board(player, dealer)
    system 'clear'
    puts 
    puts "+----------------------+"
    puts "| Dealer:               "
    puts "|   #{display_hand(dealer[:hand], dealer[:hide_hole]) if dealer[:hand].any?}"
    puts "|                       "
    puts "|                       "
    puts "| #{player[:name]}: bet is €#{player[:bet]}"
    puts "|   #{display_hand(player[:hand]) if player[:hand].any?}"
    puts "|                       "
    puts "|                       "
    puts "+----------------------+"
    puts "Balance: €#{player[:balance]}"
    puts "Your score is #{player[:score]}."    if player[:score] != 0
    puts "Dealers score is #{dealer[:score]}." if dealer[:score]
    puts
    sleep 1
  end

  def display_hand(hand, hide = false)
    cards = []
    unless hide
      hand.each_index { |x| cards << hand[x].first }
      cards.join(', ')
    else
      hand[0].first  # Shows dealers first card only and hole is hidden.
    end
  end

  # Say methods
  def say_dealer(word, add = '')
    puts "Dealer #{word} the pack#{add}..."
  end

  def say_game_result(msg, player)
    puts "#{msg} Your balance is €#{player[:balance]}."
  end

  def hit_or_stay
    begin
      puts "Hit or Stay? (type either: hit|stay)"
      answer = gets.chomp.capitalize
    end until %w(Hit Stay).include?(answer)
    answer
  end

  def play_again?
    begin
      puts "Play again? (Y/N)"
      answer = gets.chomp.downcase
    end until YES_NO.include?(answer)
    answer == 'y' ? true : false
  end
# Cutting methods
  def cut_pack(pack, cut, cutter) # Cuts the pack between 20% and 80%.
    puts "Cutting the pack..."
    sleep 1
    if cutter == "Player"
      pack += pack.slice!(0..cut)
    else # Dealer cuts here
      sliced_pack = pack.slice!(0..cut)
      # Dealer inserts shuffle reminder.
      sliced_pack.push(SHUFFLE_REMINDER)
      pack = sliced_pack + pack
    end
    pack.reverse # Need to flip order because dealer will deal from bottom (#pop).
  end

  def offer_cut(pack, up_edge)
    begin
      puts "Do you wish to cut the pack? (Y/N)"
      answer = gets.chomp.downcase
    end until YES_NO.include?(answer)
   
    if answer == 'y'
      low_edge = (pack.size * LOWER/100.to_f).ceil
      # up_edge was defined in outer scope.
      begin
        puts "Where do you want to cut it?"
        puts "Select a number from #{low_edge} to #{up_edge}: (#{LOWER}% - #{UPPER}%)"
        player_cut = gets.chomp.to_i
      end until (player_cut >= low_edge) && (player_cut <= up_edge)
      pack = cut_pack(pack, player_cut - 1, "Player")
    end
    pack
  end

  def cutting(pack)
    up_edge = (pack.size * UPPER/100.to_f).floor
    pack = offer_cut(pack, up_edge)
    say_dealer('cuts')
    pack = cut_pack(pack, up_edge, 'Dealer')
    pack
  end
# Shuffling methods
  def shuffle_n_times(pack, n)
    say_dealer('shuffles', " #{n} times")
    n.times { pack.shuffle! }
  end
# Business methods
  def make_bet(balance)    
    begin
      puts "Your balance is €#{balance}."
      puts "How much do you want to bet?"
      bet = gets.chomp.to_i
      
      # Invalid bets.
      if bet <= 0 || bet > balance
        puts "Invalid bet. Insert value in range your balance - €#{balance}."
      end
      
      # All-in comment.
      puts "Wow, you are going all-in. Good luck!" if bet == balance
    end until bet > 0 && bet <= balance
    
    puts "Bet accepted. Your bet is €#{bet}."
    sleep 1
    bet
  end
# Checking / Calculate methods
  def insufficient_balance?(balance)
    if balance <= 0
      puts "We are sorry, but your balance is insufficient."
      return false
    end
    true
  end
  
  def calculate(hand)
    values = hand.map { |card| card[1] }
    value = values.inject(:+)
    
    # Blackjack only.
    if (value == 21) && (hand.size == 2)
      return { score: 21, status: 'Stay', comment: "Blackjack" }
    end

    # Aces only.
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

    # At least 1 ace drawn = Mixed.
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
    else # No aces drawn.
      if value > 21
        { score: value, status: 'Loss', comment: "Busted" }
      elsif value == 21
        { score: 21, status: 'Stay', comment: "21 but no Blackjack" }
      else 
        { score: value }
      end
    end
  end
# Card dealing methods
  def deal_card(pack)
    if pack.last == SHUFFLE_REMINDER # Scouts for dealers cut reminder card and removes.
      pack.pop
      puts "After this game dealer will have to shuffle deck."
      sleep 3
    end
    pack.pop
  end
  alias :burn_card :deal_card

  def deal_initial_cards(pack, player, dealer)
    2.times do
      player[:hand] << deal_card(pack)
      display_board(player, dealer)
      sleep 1

      dealer[:hand] << deal_card(pack)
      display_board(player, dealer)
      sleep 1
    end
  end

# Start
  player = { balance: 1000, initialize_game: true }  
  puts "Welcome to Blackjack, what is your name?"
  player[:name] = gets.chomp.capitalize
  puts "Hello #{player[:name]}! You have been granted €#{player[:balance]}."
  puts "We will be using #{number_of_decks} decks."
  pack = []

loop do
  # Resets player and dealer from previous game and initializes defaults.
  dealer = { hide_hole: true, hand: [] }
  player.merge!(hand: [], bet: 0, score: 0, status: '', comment: '')
  
  if player[:initialize_game]
    sleep 1
    pack = initialize_pack(number_of_decks)
    shuffle_n_times(pack, 3)
    pack = cutting(pack)
    player[:initialize_game] = false
  end
  
  player[:bet] = make_bet(player[:balance])
  player[:balance] -= player[:bet]
  
  display_board(player, dealer)
  say_dealer('burns first card from', ' to discard rack')
  burn_card(pack)
  sleep 2
  deal_initial_cards(pack, player, dealer)
  player.merge!(calculate(player[:hand]))
  display_board(player, dealer)

  if player[:score] < 21
    player[:status] = hit_or_stay

    while player[:status] == 'Hit'
      player[:hand] << deal_card(pack)
      player.merge!(calculate(player[:hand]))
      if player[:score] < 21
        display_board(player, dealer)
        player[:status] = hit_or_stay
      end
    end
  end

  if player[:status] == 'Stay'
    dealer[:hide_hole] = false
    dealer.merge!(calculate(dealer[:hand]))
    display_board(player, dealer)

    while dealer[:score] < 17
      puts "Dealer hits."
      sleep 2
      dealer[:hand] << deal_card(pack)
      dealer.merge!(calculate(dealer[:hand]))
      display_board(player, dealer)
    end

    # Dealer stays on soft 17.
    dealer[:status] = 'Stay' if dealer[:score] < 21
    # Dealer busts - Player wins.
    player[:status] = 'Win' if dealer[:score] > 21

    if dealer[:status] == 'Stay'
      puts "Dealer stays."
      sleep 2 
      if player[:score] > dealer[:score]
        player[:status] = 'Win'
        player[:comment] = "Player greater"
      elsif player[:score] < dealer[:score]
        player[:status] = 'Loss'
        player[:comment] = "Dealer greater"
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
  end

  display_board(player, dealer)
  case player[:status]
  when 'Loss'
    case player[:comment]
    when "Busted"
      say_game_result("You are over 21 - busted!", player)
    when "Dealer greater"
      say_game_result("You lose, dealer was closer to 21.", player)
    when "21 but no Blackjack"
      say_game_result("You lose, dealer had a Blackjack.", player)
    end
  when 'Win'
    if player[:comment] == "Blackjack"
      player[:balance] += ((player[:bet] * 2) + (player[:bet]/2))
      say_game_result("You win!", player)
    elsif player[:comment] == "Player greater"
      player[:balance] += (player[:bet] * 2)
      say_game_result("You win! Your score was closer to 21.", player)
    else # Dealer busted
      player[:balance] += (player[:bet] * 2)
      say_game_result("You win! Dealer busts!", player)
    end
  when 'Push'
    player[:balance] += (player[:bet])
    say_game_result("It's a push.", player)
  end
  
  break unless insufficient_balance?(player[:balance]) && play_again?
  unless pack.include?(SHUFFLE_REMINDER)
    say_dealer("shuffles the discard rack to")
    player[:initialize_game] = true
    sleep 5
  end
end

puts "Have a good time!"