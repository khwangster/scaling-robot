
class GuessLetter < Guess
  def initialize(guess)
    @guess = guess
  end

  def makeGuess(game)
    game.guessLetter(@guess)
  end

  def to_s
    "GuessLetter[#{@guess}]"
  end
end