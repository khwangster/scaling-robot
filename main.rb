require_relative 'HangmanGame'
require_relative 'Guess'
require_relative 'GuessingStrategy'
require_relative 'GuessLetter'
require_relative 'GuessWord'
require_relative 'GreedyStrategy'
require_relative 'Dictionary'

# tested with ruby 1.9.3, 2.0.0-p247 (slowest), 2.1.0dev (faster), and rbx 2.2.1 (fastest)

def run(strategy, game)
  strategy.newGame
  while game.gameStatus == :KEEP_GUESSING
    #puts game
    guess = strategy.nextGuess(game)
    #puts guess
    guess.makeGuess(game)
  end
  puts game
  game.currentScore
end

init_start = Time.now

# load the dictionary file
d = Dictionary.new('words.txt')

gs = GreedyStrategy.new(d)

secrets = %w(comaker cumulative eruptive factual monadism mus nagging
oses remembered spodumenes stereoisomers toxics trichromats triose uniformed)

init_finish = Time.now
#puts "Took #{init_finish-init_start} seconds to build dictionary"


overall_start = Time.now

total_score = 0
secrets.each do |secret|
  game_start = Time.now
  game = HangmanGame.new(secret, 5)
  score = run(gs,game)
  total_score += score
  #puts "Took #{Time.now-game_start} seconds to guess #{game}"
end
#
#total_time = Time.now-overall_start
#puts "Average time per guess: #{total_time/secrets.length}"
#puts "Score: #{total_score} Average: #{total_score.to_f/secrets.length}"

