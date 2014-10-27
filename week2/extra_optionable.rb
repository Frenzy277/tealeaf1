require_relative 'questionable'
require_relative 'shared_constants'

module ExtraOptionable
  include SharedConstants
  include Questionable

  def offer_extra_option(option)
    # Set up feature, extra bet, update balance and status
    if yes_no_question?("Dealer has an Ace! Do you want to take #{option}?")
      self.player.status = option.downcase
      self.player.extra_bet = self.player.bet / 2
      self.player.decrease_balance!(self.player.extra_bet)
      self.feature = "#{option} taken!"
    end
  end

  def extra_options
    # Check if dealer has ace as first card and player has enough for extra bet
    if self.dealer.hand.first.ace? && self.player.has_enough_for?('extra')
      if player.has_blackjack?
        # Offer even money bet if Player has Blackjack
        offer_extra_option("Even money bet")
      else
        # Offer insurance if Player does not have Blackjack 
        offer_extra_option("Insurance")
      end
    end

    if EXTRA_OPTIONS.include?(self.player.status)
      # Dealer unhides his second card (hole) and calculates for Blackjack
      self.dealer.show_hole
      self.dealer.calculate_hand
      display_board

      # If dealer does not have Blackjack
      unless self.dealer.has_blackjack?
        # Player loses extra bet
        self.player.extra_bet = nil
        
        if self.player.status == 'insurance'
          # Player has to decide after insurance loss
          self.feature = "Insurance is lost!"
          self.player.status = 'decide'          
        else 
          # Player wins with even money bet taken
          self.player.status = 'win'
        end
        
        display_board
      end
      
      # If dealer has Blackjack then continue to result handler
    end

  end
end