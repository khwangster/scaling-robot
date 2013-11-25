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

    if game.currentScore == 0
      # no guesses have been made yet
      # start possible words with words of right length
      @possible_words += @dictionary.word_length[game.getSecretWordLength]
      raise "No possible words" if @possible_words.empty?
      return make_guess(game)
    end

    # only filter out letters that haven't already been filtered
    new_correct_letter = (game.getCorrectlyGuessedLetters - @correctly_guessed_letters).first
    if new_correct_letter
      (0...(game.getSecretWordLength)).each do |i|
        if game.getGuessedSoFar[i] == new_correct_letter
          # only keep words that have the letter in the right position
          position_matching = @dictionary.getWordsWithLetterAtPosition(new_correct_letter, i)
          raise "No possible words" if position_matching.nil?
          @possible_words = @possible_words & position_matching
        end

        if game.getGuessedSoFar[i] == HangmanGame::MYSTERY_LETTER
          # remove words that have letter in non-revealed position
          position_mismatch = @dictionary.getWordsWithLetterAtPosition(new_correct_letter, i)
          @possible_words = @possible_words - position_mismatch
        end
      end

      @correctly_guessed_letters << new_correct_letter
      return make_guess(game)
    end

    # remove words containing wrong letters
    new_wrong_letter = (game.getIncorrectlyGuessedLetters - @incorrectly_guessed_letters).first
    if new_wrong_letter
      @possible_words = @possible_words - @dictionary.getWordsWithLetter(new_wrong_letter)
      @incorrectly_guessed_letters << new_wrong_letter
      return make_guess(game)
    end

    # remove wrong words
    new_wrong_word = (game.getIncorrectlyGuessedWords - @incorrectly_guessed_words).first
    if new_wrong_word
      @possible_words.delete(@dictionary.find(new_wrong_word))
      @incorrectly_guessed_words << new_wrong_word
      return make_guess(game)
    end

    # one of the 4 if statements should be the only 4 possible outcomes
    raise 'No changes detected in game :('
    return make_guess(game, @possible_words)
  end #nextGuess

  def make_guess(game)
    case @possible_words.size
      when 1,2
        return GuessWord.new(@possible_words.first.word)
      else
        frequency = calc_letter_frequency(@possible_words, game.getAllGuessedLetters)
        return GuessLetter.new(pick_most_used(frequency))
    end
  end

  def newGame
    # call at beginning of run()
      @possible_words = Set.new
      @incorrectly_guessed_words = Set.new
      @correctly_guessed_letters = Set.new
      @incorrectly_guessed_letters = Set.new
  end

  def calc_letter_frequency(words, used_letters)
    frequency = {}
    words.each do |word|
      word.unique_letters.each do |ch|
        if frequency[ch].nil?
          frequency[ch] = 1
        else
          frequency[ch] += 1
        end
      end
    end

    used_letters.each do |ch|
      frequency.delete(ch)
    end

    frequency
  end

  def pick_most_used(frequency)
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