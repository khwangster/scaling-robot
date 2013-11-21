require_relative 'HangmanGame'
require_relative 'Guess'
require_relative 'GuessingStrategy'
require_relative 'GuessLetter'
require_relative 'GuessWord'
require_relative 'GreedyStrategy'
require_relative 'Dictionary'

# tested with ruby 2.0.0-p247

def run(strategy, game)
  start = Time.now
  while game.gameStatus == :KEEP_GUESSING
    strategy.nextGuess(game).makeGuess(game)
    #puts game
  end

  puts "Took #{Time.now-start} seconds to guess #{game.getGuessedSoFar} in #{game.currentScore} turns."
  game.currentScore
end

start = Time.now

#d = Dictionary.new('test_dict.txt')
d = Dictionary.new('words.txt')

finish = Time.now
puts "Took #{finish-start} seconds to build dictionary"

gs = GreedyStrategy.new(d)

%w(comaker cumulative eruptive factual monadism mus nagging oses remembered spodumenes stereoisomers toxics trichromats triose uniformed).each do |secret|
  hmg = HangmanGame.new(secret, 5)
  run(gs,hmg)
end


