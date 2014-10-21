require 'pry'
CARD_TYPES = ["\u2660", "\u2663", "\u2665", "\u2666"]
CARDS_WITHOUT_TYPES = Array(2..10).push(%w(J Q K A)).flatten
deck_collection = []
pack = []
number_of_decks = 8

(1..number_of_decks).each do |number|
  deck_collection << "deck#{number}".to_sym
end

deck_collection.each do |deck|
  CARD_TYPES.each do |type|
    CARDS_WITHOUT_TYPES.each do |n|
      if n == "A"
        pack << [deck, { "#{n + type}" => [1, 11] }]
      elsif %w(J Q K).include?(n)
        pack << [deck, { "#{n + type}" => 10 }]
      else
        pack << [deck, { "#{n.to_s + type}" => n }]
      end
    end
  end
end

p pack