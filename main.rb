require_relative 'HangmanGame'
require_relative 'Guess'
require_relative 'GuessingStrategy'
require_relative 'GuessLetter'
require_relative 'GuessWord'
require_relative 'GreedyStrategy'
require_relative 'Dictionary'

# tested with ruby 2.0.0-p247 and rbx 2.2.1 (faster)

def run(strategy, game)
  strategy.newGame
  while game.gameStatus == :KEEP_GUESSING
    guess = strategy.nextGuess(game)
    guess.makeGuess(game)
  end
  game.currentScore
end

start = Time.now

#d = Dictionary.new('test_dict.txt')
d = Dictionary.new('words.txt')

finish = Time.now
puts "Took #{finish-start} seconds to build dictionary"

gs = GreedyStrategy.new(d)

overall_start = Time.now

secrets = %w(comaker cumulative eruptive factual monadism mus nagging
oses remembered spodumenes stereoisomers toxics trichromats triose uniformed)

#secrets = %w(factual)

total_score = 0
secrets.each do |secret|
  game_start = Time.now
  game = HangmanGame.new(secret, 5)
  score = run(gs,game)
  total_score += score
  puts "Took #{Time.now-game_start} seconds to guess #{game.getGuessedSoFar} in #{score} turns."
end

total_time = Time.now-overall_start
puts "Average time per guess: #{total_time/secrets.length}"
puts "Score: #{total_score} Average: #{total_score.to_f/secrets.length}"

