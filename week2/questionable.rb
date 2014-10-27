require_relative 'shared_constants'

module Questionable
  include SharedConstants

  def yes_no_question?(question)
    begin
      puts question + " (Y/N)"
      answer = gets.chomp.downcase
    end until YES_NO.include?(answer)
    answer == 'y' ? true : false
  end

end