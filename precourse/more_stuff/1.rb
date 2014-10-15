# Exercise 1
words = ["laboratory", "experiment", "Pans Labyrinth", "elaborate", "polar bear"]

def regex_lab(word)
  if word =~ /lab/
    puts "Characters 'lab' exist in #{word}!"
  else
    #puts "No match here."
  end
end

words.each do |word|
  regex_lab(word)
end