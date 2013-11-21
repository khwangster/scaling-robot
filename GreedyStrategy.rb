require_relative 'HangmanGame'
require_relative 'Guess'
require_relative 'GuessingStrategy'
require_relative 'GuessLetter'
require_relative 'GuessWord'
require_relative 'Dictionary'

class GreedyStrategy < GuessingStrategy

  def initialize(dictionary)
    @dictionary = dictionary || Dictionary.new('')
    # strategy needs access to processed list of all possible words
  end

  def nextGuess(game = HangmanGame.new('',0))

    # start possible words with words of right length
    possible_words = @dictionary.word_length[game.getSecretWordLength]

    if possible_words.nil?
      raise "No possible words"
    end

    # only keep words that are of the right length and have letters in the right position
    (0...(game.getSecretWordLength)).each do |i|
      if game.getGuessedSoFar[i] != HangmanGame::MYSTERY_LETTER
        position_matching = @dictionary.getWordsWithLetterAtPosition(game.getGuessedSoFar[i], i)

        if position_matching.nil?
          raise "No possible words"
        end

        possible_words = possible_words & position_matching
      end
    end

    # remove words containing wrong letters
    game.getIncorrectlyGuessedLetters.each do |ch|
      possible_words = possible_words - @dictionary.getWordsWithLetter(ch)
    end

    # remove wrong words
    game.getIncorrectlyGuessedWords.each do |word|
      possible_words.delete(@dictionary.find(word))
    end


    case possible_words.size
      when 1
        return GuessWord.new(possible_words.first.word)
      when 2
        return GuessWord.new(possible_words.first.word)
      when game.numWrongGuessesRemaining
        return GuessWord.new(possible_words.first.word)
      else
        frequency = calc_letter_frequency(possible_words)

        # remove already guessed letters
        game.getAllGuessedLetters.each do |ch|
          frequency.delete(ch)
        end

        return GuessLetter.new(pick_char(frequency))
    end
  end #nextGuess

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