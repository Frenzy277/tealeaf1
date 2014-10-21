balance = 1000
def make_bet(balance)
  bet = 0
  until bet > 0 && bet <= balance 
    puts "How much do you want to bet?"
    bet = gets.chomp.to_i
    sleep 1
    
    # Invalid bets
    if bet <= 0 || bet > balance
      puts "Invalid bet. Insert value in range your balance - €#{balance}."
      sleep 1
    end
    
    # All-in comment
    puts "Wow, you are going all-in. Good luck!" if bet == balance
  end
  puts "Bet accepted. Your bet is €#{bet}."
  sleep 1
  bet
end

bet = make_bet(balance)
balance -= bet
p "Balance is #{balance}."
p "Bet is #{bet}."