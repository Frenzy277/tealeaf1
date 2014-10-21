require 'pry'

player = { bet: 10, insurance_wager: 10, feature: "Insurance", status: "loss", comment: "xxx", balance: 1000 }

def clean_up!(*keys, obj)
  keys.each { |key| obj.delete(key) }
end


clean_up!(:bet, :feature, :status, :comment, :insurance_wager, player)
binding.pry