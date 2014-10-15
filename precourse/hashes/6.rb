# Exercise 6
words = ['demo', 'none', 'tied', 'evil', 'dome', 'mode', 'live', 'fowl', 'veil', 'wolf', 'diet', 'vile', 'edit', 'tide', 'flow', 'neon']
h = {}
words.map do |word|
  key = word.split(//).sort
  if h[key].nil?
    h[key] = [word]
  else
    h[key] << word
  end
end

h.each_value do |value|
  puts "#{value}"
end