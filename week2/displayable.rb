module Displayable

  def display_board
    system 'clear'
    puts "+-----------------------+"
    puts "| Frenzy's HOUSE         "
    puts "| €#{@dealer.house}  "
    puts "| Games count: #{@game_count}"
    puts "+-----------------------+"
    puts "| Dealer:   #{@dealer.status if @dealer.status}"
    puts "|   #{display_hand(@dealer.hand, @dealer.hide_hole) if @dealer.hand.any?}"
    puts "|                        "
    puts "|...Blackjack pays 3:2..."
    puts "| Dealer must hit soft 17"
    puts "|========================"
    puts "|...Insurance pays 2:1..."
    puts "|  extra bet is €#{@player.extra_bet}" if @player.extra_bet
    puts "|========================"
    puts "| #{@player.name}: bet is €#{@player.bet}"
    puts "|  #{display_hand(@player.hand) if @player.hand.any?}"
    puts "|  #{@player.status if %w(loss win push).include?(@player.status)}"
    puts "|  #{@feature}"
    puts "+-----------------------+"
    puts "| Balance: €#{@player.balance}"
    puts "| #{@player.name}\'s score is #{@player.score}." if @player.score
    puts "| Dealers score is #{@dealer.score}." if @dealer.score
    puts "+-----------------------+"
    puts
    sleep 1
  end

  def display_hand(hand, hide = false)
    cards = []
    unless hide
      hand.each { |card| cards << card.label }
      cards.join(', ')
    else
      hand.first.label # Shows dealers first card only and hole is hidden.
    end
  end

  def deal_calculate_display_for(obj)
    obj.hand << @pack.deal_card
    obj.calculate_hand
    display_board
  end

end