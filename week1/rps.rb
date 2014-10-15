# Paper, Rock, Scissors assignment
puts "Play Paper Rock Scissors!"

def pick_or_win(choice, opt = 'win')
  case choice
  when 'p' then opt == 'win' ? puts("Paper wraps Rock!") : "Paper"
  when 'r' then opt == 'win' ? puts("Rock beats Scissors!") : "Rock"
  when 's' then opt == 'win' ? puts("Scissors cuts Paper!") : "Scissors"
  end
end

def player_wins(player, computer)
  (player == 'p' && computer == 'r') || (player == 'r' && computer == 's') || 
  (player == 's' && computer == 'p')
end

def prs
  puts "Choose one: (P/R/S)"
  player = gets.chomp.downcase
  arr = %w(p r s)
  computer = arr.shuffle.first

  prs unless arr.include?(player)
  puts "You picked #{pick_or_win(player, 'pick')} and computer picked #{pick_or_win(computer, 'pick')}."

  if player == computer
    puts "It's a tie."
  elsif player_wins(player, computer)
    pick_or_win(player)
    puts "You won!"
  else
    pick_or_win(computer)
    puts "Computer won!"
  end

  puts "Play again? (Y/N)"
  prs if gets.chomp.downcase == 'y' 
  # must explicitly exit because if player wrongly picked it stacks wrong answers
  exit 
end

prs