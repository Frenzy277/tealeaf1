# Blackjack v0.2, Bring down the house!
# by Tomas Tomecek on 10/21/2014
# 
# Features + description:
# 1) Double down - works on all 2 card hands except Blackjack. Doubles players bet and 
#    player draws only 1 card.
# 2) Insurance - if dealers first card is an Ace, player has an option to place 
#    insurance wager what is 1/2 of normal bet. If dealer has a Blackjack, insurance is 
#    payed out 2:1 but normal bet is lost. Otherwise extra bet is lost and game continues
#    as usual.
# 3) Even money bet - if player has Blackjack & dealers first card is an Ace, 
#    player has an option to place even money extra bet what is 1/2 of normal bet.
#    If dealer has Blackjack too, player wins 2:1 for extra bet and gets normal bet back.
# 4) No surrendering allowed - sorry
# 5) Deck cutting offered to a player, cutting edges are 20-80% of pack size for player.
#    Dealer always cuts at 80% edge. and inserts SHUFFLE_REMINDER in the deck.
# 6) Pack is not reshuffled after every game - this is to simulate real casino play. 
#    You can card-count but the number of decks depends on difficulty chosen.
# 7) Pack is reshuffled once SHUFFLE_REMINDER is about to be drawn.
# 8) 3-2 pay-off, how awesome is that?
# 9) Board is fully featured and should reflect behavior of the game.
#    Dealer hides hole until player stands.
# 10) Game modes available, player has to choose from easy/hard/challenge difficulties.
# 11) Bets can only be positive numbers and in range of players balance.
#     Minimum bet is implemented and it scales with difficulty, 
#     also increments periodically depending on difficulty
# 12) After every reshuffle, first card of the pack is burned.
# 13) Intentionally slowing game in certain dialogues or when dealing cards.
# 14) Player and Dealer are represented by hashes.
# 
# Also methods indentation is intentional, it helps me to scroll text in text editor.

# Constants  
  DIFFICULTY = %w(easy hard challenge)
  EASY_MIN_BET = 10
  HARD_MIN_BET = 100
  CHALLENGE_MIN_BET = 200
  HOUSE_BALANCE = 100_000
  START_BALANCE = 2_000
  EXTRA_OPTIONS = ['insurance', 'even money bet']
  # Cut edges LOWER 20% UPPER 80%
  LOWER = 20
  UPPER = 80
  SHUFFLE_REMINDER = 'shuffle reminder'
  YES_NO = %w(y n)
  # Types are spades, clubs, hearts, diamonds in that order
  CARD_TYPES = ["\u2660", "\u2663", "\u2665", "\u2666"] 
  CARDS_WITHOUT_TYPES = Array(2..10).push(%w(J Q K A)).flatten

# Initialize pack         (initialize_pack)
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

# Display methods         (display_board, display_hand, say_dealer, say_game_result)
  def display_board(player, dealer)
    system 'clear'
    puts "+-----------------------+"
    puts "| Frenzy's HOUSE         "
    puts "| €#{dealer[:house]}     "
    puts "+-----------------------+"
    puts "| Dealer:  #{dealer[:status] if dealer[:status]}"
    puts "|   #{display_hand(dealer[:hand], dealer[:hide_hole]) if dealer[:hand].any?}"
    puts "|                        "
    puts "|...Blackjack pays 3:2..."
    puts "| Dealer must hit soft 17"
    puts "|========================"
    puts "|...Insurance pays 2:1..."
    puts "|  extra bet is €#{player[:extra_bet]}" if player[:extra_bet]
    puts "|========================"
    puts "| #{player[:name]}: bet is €#{player[:bet]}"
    puts "|  #{display_hand(player[:hand]) if player[:hand]}"
    puts "|                        "
    puts "|  #{player[:feature] if player[:feature]}"
    puts "+-----------------------+"
    puts "| Balance: €#{player[:balance]}"
    puts "| #{player[:name]}\'s score is #{player[:score]}." if player[:score]
    puts "| Dealers score is #{dealer[:score]}." if dealer[:score]
    puts "+-----------------------+"
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

  def say_dealer(word, add = '')
    puts "Dealer #{word} the pack#{add}..."
  end

  def say_game_result(msg, player)
    puts "#{msg} #{player[:name]}\'s balance is €#{player[:balance]}."
  end

# Communication methods   (offer_double_down?, offer_split? decide_action, yes_no_question?, 
#                          offer_extra_option, extra_options)
  def offer_double_down?(player)
    player[:hand].size == 2 && has_enough_for?('double', player)
  end

  def decide_action(player)
    begin
      if offer_double_down?(player)
        puts "Hit, Stay or Double down? (type either: hit/stay/double)"
      else
        puts "Hit or Stay? (type either: hit/stay)"
      end    
      answer = gets.chomp.downcase
    end until %w(hit stay double).include?(answer)
    answer
  end

  def yes_no_question?(question)
    begin
      puts question + " (Y/N)"
      answer = gets.chomp.downcase
    end until YES_NO.include?(answer)
    answer == 'y' ? true : false
  end

  # Insurance or Even money bet
  def offer_extra_option(player, subject)
    if yes_no_question?("Dealer has an Ace! Do you want to take #{subject}?")
      extra_bet = player[:bet] / 2
      player.merge!(status: subject.downcase, 
                    extra_bet: extra_bet, 
                    balance: (player[:balance] -= extra_bet), 
                    feature: "#{subject} taken!")
    end
  end

  def extra_options(player, dealer)
    if dealer[:hand].first[0].start_with?("A") && has_enough_for?('extra', player)
      if player[:comment] == "Blackjack"
        offer_extra_option(player, "Even money bet")
      else
        offer_extra_option(player, "Insurance")
      end
    end
  end

# Cutting methods         (cutting, offer_cut, cut_pack)
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
    if yes_no_question?("Do you wish to cut the pack?")
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

# Business methods        (make_bet, sufficient_balance?, has_enough_for?, calculate)
  def make_bet(balance, minimal_bet)    
    begin
      puts "Your balance is €#{balance}."
      puts "Minimum bet is €#{minimal_bet}. How much do you want to bet?"
      bet = gets.chomp.to_i
      
      # Invalid bets.
      if bet < minimal_bet || bet > balance || bet.odd?
        puts "We accept only even bets. Odd bets will not be accepted"
        puts "Invalid bet. Insert even value in range your balance - €#{balance}."
      end
      
      # All-in comment.
      puts "Wow, you are going all-in. Good luck!" if bet == balance
    end until bet >= minimal_bet && bet <= balance && bet.even?
    
    puts "Bet accepted. Your bet is €#{bet}."
    sleep 1
    bet
  end

  def sufficient_balance?(player, dealer)
    if player[:balance] < dealer[:minimal_bet]
      puts "We are sorry, but your balance is insufficient."
      return false
    end
    true
  end

  def has_enough_for?(option, player)
    if %w(double split).include?(option)
      player[:balance] >= player[:bet]
    elsif option == 'extra'
      player[:balance] >= player[:bet] / 2
    end
  end
  
  def calculate(hand)
    values = hand.map { |card| card[1] }
    value = values.inject(:+)
    
    # Blackjack only.
    if (value == 21) && (hand.size == 2)
      return { score: 21, status: 'stay', comment: "Blackjack" }
    end

    # Aces only.
    if values.count == (value / 11)
      ace_count = values.count
      if ace_count > 21
        return { score: ace_count, status: 'loss', comment: "Busted" }
      elsif (ace_count == 21) || (ace_count == 11)
        return { score: 21, status: 'stay', comment: "21 but not Blackjack" }
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
        { score: 21, status: 'stay', comment: "21 but no Blackjack" }
      elsif gap < ace_count
        { score: no_ace_value + ace_count, status: 'loss', comment: "Busted" }
      elsif gap > ace_count
        z = gap - ace_count
        if z == 10
          { score: 21, status: 'stay', comment: "21 but no Blackjack" }
        elsif z < 10
          { score: ace_count + no_ace_value }
        elsif z > 10 
          { score: 31 - z }
        end
      end
    else # No aces drawn.
      if value > 21
        { score: value, status: 'loss', comment: "Busted" }
      elsif value == 21
        { score: 21, status: 'stay', comment: "21 but no Blackjack" }
      else 
        { score: value }
      end
    end
  end

# Card dealing methods    (deal_card/burn_card, deal_initial_cards, shuffle_n_times
#                          deal_calculate_display)
  def deal_card(pack, hand = [])
    if pack.last == SHUFFLE_REMINDER # Scouts for dealers cut reminder card and removes.
      pack.pop
      puts "After this game dealer will have to shuffle deck."
      sleep 3
    end
    hand << pack.pop
  end
  alias :burn_card :deal_card

  def deal_calculate_display(pack, obj, player, dealer)
    if obj == "Player"
      deal_card(pack, player[:hand])
      player.merge!(calculate(player[:hand]))
    elsif obj == "Dealer"
      deal_card(pack, dealer[:hand])
      dealer.merge!(calculate(dealer[:hand]))
    end
    display_board(player, dealer)
  end

  def deal_initial_cards(pack, player, dealer)
    2.times do
      deal_card(pack, player[:hand])
      display_board(player, dealer)

      deal_card(pack, dealer[:hand])
      display_board(player, dealer)
    end
  end

  def shuffle_n_times(pack, n)
    say_dealer('shuffles', " #{n} times")
    n.times { pack.shuffle! }
  end

# Clean up methods        (clean_up!)
  def clean_up!(*keys, obj)
    keys.each { |key| obj.delete(key) }
  end

# Start
  player = { balance: START_BALANCE, initialize_game: true }
  dealer = { game_count: 1, house: HOUSE_BALANCE }
  puts "Welcome to the house, what is your name?"
  player[:name] = gets.chomp.capitalize
  
  # difficulty set up
  begin
    puts "Select game difficulty (type either: easy/hard/challenge)"
    difficulty = gets.chomp.downcase
  end until DIFFICULTY.include?(difficulty)
  
  if difficulty == 'easy'
    dealer.merge!(difficulty: 10, minimal_bet: EASY_MIN_BET)
    number_of_decks = Array(4..5).sample
  elsif difficulty == 'hard'
    dealer.merge!(difficulty: 5, minimal_bet: HARD_MIN_BET)
    number_of_decks = Array(6..7).sample
  elsif difficulty == 'challenge'
    dealer.merge!(difficulty: 5, 
                  minimal_bet: CHALLENGE_MIN_BET, 
                  challenge: true)
    number_of_decks = 8
  end

  puts "Hello #{player[:name]}! You have been granted €#{player[:balance]}."
  puts "We will be using #{number_of_decks} decks."
  pack = []

loop do
  # Resets player and dealer from previous game and initializes defaults.
  dealer.merge!(hand: [], hide_hole: true)
  player[:hand] = []
  
  if player[:initialize_game]
    pack = initialize_pack(number_of_decks)
    shuffle_n_times(pack, 3)
    pack = cutting(pack)
    say_dealer('burns first card from')
    burn_card(pack)
    sleep 1
    player[:initialize_game] = false
  end

  # Increases bets over each difficulty level.
  if dealer[:game_count] % dealer[:difficulty] == 0
    case difficulty
    when 'easy'      then dealer[:minimal_bet] += EASY_MIN_BET
    when 'hard'      then dealer[:minimal_bet] += HARD_MIN_BET
    when 'challenge' then dealer[:minimal_bet] += CHALLENGE_MIN_BET
    end
    puts "Minimal bet has increased. Now, it is €#{dealer[:minimal_bet]}."
    sleep 2
    break unless sufficient_balance?(player, dealer)
  end
  
  player[:bet] = make_bet(player[:balance], dealer[:minimal_bet])
  player[:balance] -= player[:bet]
  display_board(player, dealer)
  deal_initial_cards(pack, player, dealer)
  player.merge!(calculate(player[:hand]))
  display_board(player, dealer)
  
  extra_options(player, dealer) # Insurance or Even money bet
  if EXTRA_OPTIONS.include?(player[:status])
    dealer[:hide_hole] = false
    dealer.merge!(calculate(dealer[:hand]))
    display_board(player, dealer)

    unless dealer[:comment] == "Blackjack"
      if player[:status] == 'insurance'
        feature = "Insurance is lost!"
        #dealer[:house] += player[:extra_bet]
        player.merge!(status: nil, feature: feature, extra_bet: nil)
        display_board(player, dealer)
      else
        player[:status] = 'win'
      end
    end
  end

  if player[:score] < 21 && player[:status] != 'insurance'
    # hit, stay, double down?
    player[:status] = decide_action(player)

    while player[:status] == 'hit'
      deal_calculate_display(pack, "Player", player, dealer)
      if player[:score] < 21
        player[:status] = decide_action(player)
      end
    end

    if player[:status] == 'double'
      player[:feature] = "Double down!"
      player[:balance] -= player[:bet] # Decrease balance for doubled bet.
      player[:bet] *= 2                # Bet increased.
      puts "Doubling your bet!! Your bet is now €#{player[:bet]}."
      sleep 2
      deal_calculate_display(pack, "Player", player, dealer)

      player[:status] = 'stay' unless player[:status] == 'loss'
    end
  end

  if player[:status] == 'stay'
    dealer[:hide_hole] = false
    dealer.merge!(calculate(dealer[:hand]))
    display_board(player, dealer)

    while dealer[:score] < 17
      dealer[:status] = 'hit'
      deal_calculate_display(pack, "Dealer", player, dealer)
    end

    # Dealer stays on soft 17.
    dealer[:status] = 'stay' if dealer[:score] < 21
    # Dealer busts - Player wins.
    player[:status] = 'win' if dealer[:score] > 21

    if dealer[:status] == 'stay'
      if player[:score] > dealer[:score]
        player[:status] = 'win' 
        player[:comment] = "Player greater" unless player[:comment] == "Blackjack"
      elsif player[:score] < dealer[:score]
        if dealer[:comment] == "Blackjack"
          player.merge!(status: 'loss', comment: "Dealer Blackjack")
        else
          player.merge!(status: 'loss', comment: "Dealer greater")
        end
      elsif player[:score] == dealer[:score]
        if (player[:comment] == "21 but no Blackjack") && (dealer[:comment] == "Blackjack")
          player[:status] = 'loss'
        elsif (player[:comment] == "Blackjack") && (dealer[:comment] == "21 but no Blackjack")
          player[:status] = 'win'
        else
          player[:status] = 'push'
        end
      end
    end
  end

  # Results handler
  player[:hand] << [[player[:status]]] unless EXTRA_OPTIONS.include?(player[:status])
  display_board(player, dealer)
  case player[:status]
  when 'loss'
    case player[:comment]
    when "Busted"
      say_game_result("#{player[:name]} is over 21 - busted!", player)
    when "Dealer Blackjack"
      say_game_result("#{player[:name]} loses, dealer has Blackjack.", player)
    when "Dealer greater"
      say_game_result("#{player[:name]} loses, dealer was closer to 21.", player)
    when "21 but no Blackjack"
      say_game_result("#{player[:name]} loses, dealer has Blackjack.", player)
    end
  when 'win'
    if player[:comment] == "Blackjack"
      player[:balance] += ((player[:bet] * 2) + (player[:bet] / 2))
      say_game_result("#{player[:name]} has a Blackjack and wins!", player)
    elsif player[:comment] == "Player greater"
      player[:balance] += player[:bet] * 2
      say_game_result("#{player[:name]} wins! #{player[:name]}\'s score was closer to 21.", player)
    else # Dealer busted
      player[:balance] += player[:bet] * 2
      say_game_result("#{player[:name]} wins! Dealer busts!", player)
    end
  when 'push'
    player[:balance] += player[:bet]
    say_game_result("It's a push.", player)
  when 'insurance'
    player[:balance] += (player[:extra_bet] * 3)
    say_game_result("Dealer has Blackjack but #{player[:name]} is insured.", player)
  when 'even money bet'
    player[:balance] += (player[:extra_bet] * 3) + player[:bet]
    say_game_result("Dealer has Blackjack but Even money bet saved #{player[:name]}.", player)
  end

  # House's balance
  dealer[:house] = HOUSE_BALANCE - (player[:balance] - START_BALANCE)

  if dealer[:game_count] == 100 && dealer[:challenge]
    if dealer[:house] > player[:balance]
      puts "#{player[:name]} has not met objectives."
    else
      puts "Winner, winner, chicken dinner!!!"
      puts "Congratulations, #{player[:name]} has brought down the house!"
      sleep 10    
    end
    break
  end
  
  break unless sufficient_balance?(player, dealer) && yes_no_question?("Play again?")
  unless pack.include?(SHUFFLE_REMINDER)
    say_dealer("shuffles the discard rack to")
    player[:initialize_game] = true
    sleep 2
  end
  clean_up!(:status, :score, :comment, dealer)
  clean_up!(:bet, :status, :score, :comment, :feature, :extra_bet, player)
  dealer[:game_count] += 1
end

puts "Have a good time!"