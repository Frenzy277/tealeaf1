module Displayable

  def display_board
    system 'clear'
    puts "+-----------------------+"
    puts "| Frenzy's HOUSE         "
    puts "| €#{self.dealer.house}  "
    puts "| Games count: #{self.game_count}"
    puts "+-----------------------+"
    puts "| Dealer:   #{self.dealer.status if self.dealer.status}"
    puts "|   #{display_hand(self.dealer.hand, self.dealer.hide_hole) if self.dealer.hand.any?}"
    puts "|                        "
    puts "|...Blackjack pays 3:2..."
    puts "| Dealer must hit soft 17"
    puts "|========================"
    puts "|...Insurance pays 2:1..."
    puts "|  extra bet is €#{self.player.extra_bet}" if player.extra_bet
    puts "|========================"
    puts "| #{self.player.name}: bet is €#{self.player.bet}"
    puts "|  #{display_hand(self.player.hand) if self.player.hand.any?}"
    puts "|  #{self.player.status if %w(loss win push).include?(self.player.status)}"
    puts "|  #{self.feature}"
    puts "+-----------------------+"
    puts "| Balance: €#{self.player.balance}"
    puts "| #{self.player.name}\'s score is #{self.player.score}." if self.player.score
    puts "| Dealers score is #{self.dealer.score}." if self.dealer.score
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

end