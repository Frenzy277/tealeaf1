module SharedConstants
  
  # Business constants / arrays
  DIFFICULTY = %w(easy hard challenge)
  HOUSE_TOTAL = 100_000
  START_BALANCE = 2_000
  EASY_MIN_BET = 10
  HARD_MIN_BET = 100
  CHALLENGE_MIN_BET = 200

  # Reminder for dealer to shuffle deck - after the game
  SHUFFLE_REMINDER = 'shuffle reminder'
  
  # helper arrays
  YES_NO = %w(y n)
  EXTRA_OPTIONS = ['insurance', 'even money bet']

end