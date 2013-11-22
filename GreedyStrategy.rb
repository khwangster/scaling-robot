require_relative 'HangmanGame'
require_relative 'Guess'
require_relative 'GuessingStrategy'
require_relative 'GuessLetter'
require_relative 'GuessWord'
require_relative 'Dictionary'

class GreedyStrategy < GuessingStrategy

  def initialize(dictionary)
    @dictionary = dictionary
    # strategy needs access to processed list of all possible words
  end

  def nextGuess(game)
    # load last known game state to prevent repeating relatively expensive dictionary operations
    possible_words = @last_known_state[:possible_words]

    if game.currentScore == 0
      # no guesses have been made yet
      # start possible words with words of right length
      possible_words += @dictionary.word_length[game.getSecretWordLength]
      raise "No possible words" if possible_words.nil?
      return make_guess(game, possible_words)
    end

    # only filter out letters that haven't already been filtered
    new_correct_letter = (game.getCorrectlyGuessedLetters - @last_known_state[:correctly_guessed_letters]).first
    if new_correct_letter
      # only keep words that are of the right length and have letters in the right position
      # there should only ever be one letter if there's a new letter
      (0...(game.getSecretWordLength)).each do |i|
        if game.getGuessedSoFar[i] == new_correct_letter
          position_matching = @dictionary.getWordsWithLetterAtPosition(new_correct_letter, i)
          raise "No possible words" if position_matching.nil?
          possible_words = possible_words & position_matching
        end
      end
      # update correctly guessed letters state
      # merge them to update existing copy instead of just referencing game's copy
      @last_known_state[:correctly_guessed_letters] << new_correct_letter
      return make_guess(game, possible_words)
    end

    # remove words containing wrong letters
    new_wrong_letter = (game.getIncorrectlyGuessedLetters - @last_known_state[:incorrectly_guessed_letters]).first
    if new_wrong_letter
      possible_words = possible_words - @dictionary.getWordsWithLetter(new_wrong_letter)

      # update incorrectly guessed letters state
      @last_known_state[:incorrectly_guessed_letters] << new_wrong_letter
      return make_guess(game, possible_words)
    end

    # remove wrong words
    new_wrong_word = (game.getIncorrectlyGuessedWords - @last_known_state[:incorrectly_guessed_words]).first
    if new_wrong_word
      possible_words.delete(@dictionary.find(new_wrong_word))
      @last_known_state[:incorrectly_guessed_words] << new_wrong_word
      return make_guess(game, possible_words)
    end

    # one of the 4 if statements should be the only 4 possible outcomes
    raise 'No changes detected in game :('
    return make_guess(game, possible_words)
  end #nextGuess

  def make_guess(game, possible_words)
    puts "guessing from possible words: #{possible_words.size}"
    @last_known_state[:possible_words] = possible_words

    case possible_words.size
      when 1,2
        return GuessWord.new(possible_words.first.word)
      else
        frequency = calc_letter_frequency(possible_words)

        # remove already guessed letters
        game.getAllGuessedLetters.each do |ch|
          frequency.delete(ch)
        end

        return GuessLetter.new(pick_char(frequency))
    end
  end

  def newGame
    # call at beginning of run()
    @last_known_state = {
        :possible_words => Set.new,
        :incorrectly_guessed_words => Set.new,
        :correctly_guessed_letters => Set.new,
        :incorrectly_guessed_letters => Set.new
    }
  end

  def calc_letter_frequency(possible_words)
    frequency = {}
    possible_words.each do |word|
      word.unique_letters.each do |ch|
        if frequency[ch].nil?
          frequency[ch] = 1
        else
          frequency[ch] += 1
        end
      end
    end
    frequency
  end

  def pick_char(frequency)
    max = 0
    char = ''
    frequency.each do |key,value|
      if value > max
        char = key
        max = value
      end
    end
    char
  end # pick_char

end