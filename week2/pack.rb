require_relative 'card'
require_relative 'questionable'
require_relative 'shared_constants'

class Pack
  include SharedConstants
  include Questionable
  SUITS = ["\u2660", "\u2663", "\u2665", "\u2666"]
  CARD_NAMES = Array(2..10).push(%w(J Q K A)).flatten
  LOWER = 20
  UPPER = 80
  
  attr_accessor :pack
  def initialize(number_of_decks = 4)
    @pack = []
    number_of_decks.times do
      SUITS.each do |suit|
        CARD_NAMES.each { |name| @pack << Card.new(name, suit) }
      end
    end
  end

  def shuffle(n = 1)
    n.times { pack.shuffle! }
  end
  alias :shuffle_n_times :shuffle

  def deal_card
    check_shuffle_reminder
    pack.pop
  end
  alias :burn_card :deal_card

  def has_any?(reminder)
    pack.include?(reminder)
  end

  def cut
    @up_edge = (@pack.size * UPPER/100.to_f).floor
    offer_cut
    cut_pack('Dealer')
  end

  private

  def cut_pack(cutter) # Cuts the pack between 20% and 80%.
    if cutter == "Player"
      puts "Cutting the pack ..."
      sleep 1
      self.pack += self.pack.slice!(0..(@player_cut - 1))
    else # Dealer cuts here
      puts "Dealer cuts the pack!"
      # Dealer inserts shuffle reminder.
      self.pack += self.pack.slice!(0..(@up_edge)).unshift(SHUFFLE_REMINDER)
      self.pack.reverse! # Need to flip order because dealer will deal from bottom (#pop).
    end
  end

  def offer_cut
    if yes_no_question?("Do you wish to cut the pack?")
      low_edge = (@pack.size * LOWER/100.to_f).ceil
      # up_edge was defined in outer scope.
      begin
        puts "Where do you want to cut it?"
        puts "Select a number from #{low_edge} to #{@up_edge}: (#{LOWER}% - #{UPPER}%)"
        @player_cut = gets.chomp.to_i
      end until (@player_cut >= low_edge) && (@player_cut <= @up_edge)
      cut_pack("Player")
    end
  end

  def check_shuffle_reminder
    if pack.last == SHUFFLE_REMINDER
      pack.pop
      puts "After this game dealer will have to shuffle the pack."
      sleep 3
    end
  end

end