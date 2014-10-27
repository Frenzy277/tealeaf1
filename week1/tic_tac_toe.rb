# Tic Tac Toe assignment!
# Start up definitions.
WINNING_LINES = [%w(1 2 3),%w(4 5 6),%w(7 8 9),%w(1 5 9),%w(7 5 3),%w(1 4 7),%w(2 5 8), %w(3 6 9)]
positions = {}
(1..9).each { |p| positions[p.to_s] = ' ' }
available = positions.keys

# Board.
def board(positions)
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

# Shows a winner or a tie.
def win_or_tie(positions, result, obj)
  board(positions)
  result == 'win' ? puts("#{obj} won!") : puts("It's a tie!")
  exit
end

# Checks whether 3 x's or 3 o's consecutively are taken.
def taken?(line, p, obj)
  p.values_at(*line).count('X') == 3 if obj == "Player"
  p.values_at(*line).count('O') == 3 if obj == "Computer"
end

# Evaluates winning combo.
def evaluate_winner(available, positions, obj)
  WINNING_LINES.each do |line|
    win_or_tie(positions, 'win', obj) if taken?(line, positions, obj)
  end

  win_or_tie(positions, 'tie', obj) if available.empty?
end

# Marks position on board and evaluates winner right after.
def execute_pick(available, positions, pick, obj)
  available.delete(pick)
  positions[pick] = 'X' if obj == "Player"
  positions[pick] = 'O' if obj == "Computer"
  evaluate_winner(available, positions, obj)
end

loop do
  # Player picks a position.
  begin
    board(positions)
    puts "Choose a position (from 1 to 9) to place a piece:"
    player_pick = gets.chomp
  end until available.include?(player_pick)
  execute_pick(available, positions, player_pick, "Player")
  
  # Computer picks a position.
  comp_pick = available.sample
  execute_pick(available, positions, comp_pick, "Computer")
end