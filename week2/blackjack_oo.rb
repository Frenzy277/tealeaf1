# Blackjack OOP v0.2, by Tomas tomecek on 10/27/2014

require_relative 'pack'
require_relative 'player'
require_relative 'dealer'           # is a subclass of player
require_relative 'difficulty'
require_relative 'displayable'
require_relative 'extra_optionable'
require_relative 'questionable'
require_relative 'params_helpers'
require_relative 'shared_constants'

class Blackjack
  include SharedConstants   
  include Displayable       # display_board, display_hand, deal_calculate_display_for
  include ExtraOptionable   # extra_options, offer_extra_option
  include Questionable      # yes_no_question?
  include ParamsHelpers     # name, bet, difficulty, decision params, offer_double_down?

  attr_accessor :game_count, :minimal_bet, :dealer, :feature, :extra_bet, :pack
  attr_reader :player, :difficulty
  
  def initialize
    @player      = Player.new(name_params)
    @dealer      = Dealer.new
    @difficulty  = Difficulty.new(difficulty_params)
    @minimal_bet = @difficulty.minimal_bet
    @new_pack    = true
    @game_count  = 1
  end

  def make_bet
    @player.bet = bet_params
    @player.decrease_balance!(@player.bet)
    display_board
  end

  def initialize_accessories
    @player.hand = []
    @dealer.hand = []

    if @new_pack
      @pack = Pack.new(@difficulty.decks)
      @pack.shuffle(3)
      @pack.cut
      @dealer.says('burns first card from')
      @pack.burn_card
      @new_pack = false
    end
  end

  def deal_initial_cards
    2.times do
      @player.hand << @pack.deal_card
      display_board
      @dealer.hand << @pack.deal_card
      display_board
    end
  end

  def players_turn
    @player.calculate_hand
    display_board

    extra_options # Insurance or Even money bet

    if @player.decide?
      @player.update_status!(decision_params)

      if @player.double?
        self.feature = "Double down!"
        @player.decrease_balance!(@player.bet) # Decrease balance for doubled bet.
        @player.bet *= 2                       # Bet increased.
        puts "Doubling your bet!! Your bet is now €#{@player.bet}."
        sleep 2
        deal_calculate_display_for(@player)
        player.status = 'stay' unless @player.loss?
      end

      while @player.hit?
        deal_calculate_display_for(@player) # changes status based on score
        if @player.decide?
          @player.update_status!(decision_params)
        end
      end

    end
  end

  def dealers_turn
    @dealer.show_hole
    @dealer.calculate_hand
    display_board

    # Dealer hits under 17
    while @dealer.score < 17
      self.dealer.status = 'hit'
      deal_calculate_display_for(@dealer)
    end

    # Dealer stays on soft 17.
    self.dealer.status = 'stay' if @dealer.score < 21
    # Dealer busts - Player wins.
    self.player.status = 'win' if @dealer.score > 21
  end

  def compare_players
    if @player.score > @dealer.score
      self.player.status = 'win' 
      self.player.comment = "Player greater" unless @player.has_blackjack?
    elsif @player.score < @dealer.score
      if @dealer.has_blackjack?
        self.player.status = 'loss'
        self.player.comment = "Dealer Blackjack"
      else
        self.player.status = 'loss'
        self.player.comment = "Dealer greater"
      end
    elsif @player.score == @dealer.score
      if @player.comment == "21 but no Blackjack" && @dealer.has_blackjack?
        self.player.status = 'loss'
      elsif @player.has_blackjack? && @dealer.comment == "21 but no Blackjack"
        self.player.status = 'win'
      else
        self.player.status = 'push'
      end
    end
  end

  def reshuffle
    unless @pack.has_any?(SHUFFLE_REMINDER)
      @dealer.says("shuffles the discard rack to")
      @new_pack = true
      sleep 2
    end
  end

  # Start
  def run
    puts "Hello #{@player.name}! You have been granted €#{@player.balance}."
    puts "We will be using #{@difficulty.decks} decks."
    loop do
      # Initializes and resets hands, Initializes pack first time and then once SHUFFLE_REMINDER 
      # was drawn last game
      initialize_accessories

      # Increments minimal bet based on games count and difficulty chosen
      if difficulty.escalate?(game_count)
        self.minimal_bet = @difficulty.increase_minimal_bet
        break unless @player.has_sufficient_balance?(@minimal_bet)
      end

      # Player makes bet here
      make_bet

      # Initial cards to player and dealer
      deal_initial_cards
     
      # Calculates hand, extra options if available, then hit/stay/double down
      players_turn

      # if player stays then dealer turn follows but if player busts then results handler follows
      if @player.stay?
        dealers_turn
        compare_players if @dealer.stay?
      end

      display_board

      # Handling results, messages, adjusts balance for winnings
      @player.results_handler

      # Adjust house balance based on what player won/lost
      @dealer.house = HOUSE_TOTAL - (@player.balance - START_BALANCE)

      # Checks whether player achieved 100 games on challenge
      if @game_count == 100 && @difficulty.name == 'challenge' 
        if @dealer.house > @player.balance
          puts "#{@player.name} has not met objectives."
        else
          puts "Winner, winner, chicken dinner!!!"
          puts "Congratulations, #{@player.name} has brought down the house!"
          sleep 10
        end
        break
      end
      
      break unless @player.has_sufficient_balance?(@minimal_bet) && yes_no_question?("Play again?")

      # new_pack will be set to true if pack does not include SHUFFLE_REMINDER
      reshuffle

      @dealer.clean_up!
      @player.clean_up!
      self.feature = nil
      @game_count += 1
    end
  end

end

Blackjack.new.run
puts "Have a good time!"