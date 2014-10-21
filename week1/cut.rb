require 'pry'
pack = Array(1..20)
LOWER = 20
UPPER = 80
def cut_pack(pack, cut, cutter)
  puts "Cutting the pack..."
  sleep 1
  if cutter == "Player"
    pack += pack.slice!(0..cut)
  else
    sliced_pack = pack.slice!(0..cut)
    sliced_pack.push('time to shuffle')
    pack = sliced_pack + pack
  end

  binding.pry
  pack.reverse!
  binding.pry
end

def ask_cut(pack)
  begin
    puts "Do you wish to cut the deck? (Y/N)"
    answer = gets.chomp.downcase
  end until ['y', 'n'].include?(answer)

  binding.pry
  
  if answer == 'y'
    low_edge = (pack.size * LOWER/100.to_f).ceil
    up_edge = (pack.size * UPPER/100.to_f).floor
    begin
      puts "Where do you want to cut it ?"
      puts "Select a number from #{low_edge} to #{up_edge}: (#{LOWER}% - #{UPPER}%)"
      player_cut = gets.chomp.to_i
    end until (player_cut >= low_edge) && (player_cut <= up_edge)
    cut_pack(pack, player_cut - 1, "Player")

    binding.pry
  end

  binding.pry
end


ask_cut(pack)
binding.pry
p pack
binding.pry
cut_pack(pack, (pack.size * UPPER/100.to_f).floor, "Dealer")
binding.pry
p pack