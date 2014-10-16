# Tic Tac Toe assignment!
# Start up definitions.
positions = { '1' => ' ', '2' => ' ', '3' => ' ', 
              '4' => ' ', '5' => ' ', '6' => ' ', 
              '7' => ' ', '8' => ' ', '9' => ' ' }
available = positions.keys

# Board.
def lattice(positions)
  system 'clear'
  puts "     |     |     "
  puts "  #{positions['1']}  |  #{positions['2']}  |  #{positions['3']}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{positions['4']}  |  #{positions['5']}  |  #{positions['6']}  "
  puts "     |     |     "
  puts "-----+-----+-----"
  puts "     |     |     "
  puts "  #{positions['7']}  |  #{positions['8']}  |  #{positions['9']}  "
  puts "     |     |     "
  puts ""
end

# Checks whether 3 x's or 3 o's consecutively are taken.
def taken?(p1, p2, p3, positions, obj)
  x_or_o = 'X' if obj == "Player"
  x_or_o = 'O' if obj == "Computer"
  (positions[p1] == x_or_o) && (positions[p2] == x_or_o) && (positions[p3] == x_or_o)
end

# Evaluates winning combo.
def evaluate_winner(positions, obj)
  if taken?('1','2','3', positions, obj) || taken?('4','5','6', positions, obj) || 
     taken?('7','8','9', positions, obj) || taken?('1','5','9', positions, obj) || 
     taken?('7','5','3', positions, obj) || taken?('1','4','7', positions, obj) || 
     taken?('2','5','8', positions, obj) || taken?('3','6','9', positions, obj)
    lattice(positions)
    puts "#{obj.capitalize} won!"
    exit
  end
end

# Marks position to lattice and evaluates winner right after.
def execute_pick(available, positions, pick, obj)
  available.delete(pick)
  positions[pick] = 'X' if obj == "Player"
  positions[pick] = 'O' if obj == "Computer"
  evaluate_winner(positions, obj)
end

loop do
  # Player picks a position.
  begin
    lattice(positions)
    puts "Choose a position (from 1 to 9) to place a piece:"
    player_pick = gets.chomp
  end until available.include?(player_pick)
  execute_pick(available, positions, player_pick, "Player")
  
  # Computer-easy picks a position.
  comp_pick = available.sample
  execute_pick(available, positions, comp_pick, "Computer")
end