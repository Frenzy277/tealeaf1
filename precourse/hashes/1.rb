# Exercise 1
family = {  uncles: ["bob", "joe", "steve"],
            sisters: ["jane", "jill", "beth"],
            brothers: ["frank","rob","david"],
            aunts: ["mary","sally","susan"]
          }

immediate_family_members = []
family.select do |k, v|
  immediate_family_members << v if k == :sisters || k == :brothers
end

p immediate_family_members.flatten
