
class GuessWord < Guess
  def initialize(guess)
    @guess = guess
  end

  def makeGuess(game)
    game.guessWord(@guess)
  end

  def to_s
    "GuessWord[#{@guess}]"
  end
end