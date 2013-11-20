require 'set'

class HangmanGame
	MYSTERY_LETTER = '-'

	def initialize(secretWord, maxWrongGuesses)
    @correctlyGuessedLetters = Set.new
    @incorrectlyGuessedLetters = Set.new
    @incorrectlyGuessedWords = Set.new
		@secretWord = secretWord.upcase
		@guessedSoFar = MYSTERY_LETTER*@secretWord.length
		@maxWrongGuesses = maxWrongGuesses
  end

  def guessLetter(ch)
    assertCanKeepGuessing
    ch.upcase!
    goodGuess = false
    @secretWord.length.times do |i|
      if @secretWord[i] == ch
        @guessedSoFar[i] = ch
        goodGuess = true
      end
    end

    if goodGuess
      @correctlyGuessedLetters << ch
    else
      @incorrectlyGuessedLetters << ch
    end
    return @guessedSoFar
  end

  def guessWord(guess)
    assertCanKeepGuessing
    guess.upcase!

    if guess == @secretWord
      @guessedSoFar.replace @secretWord
    else
      @incorrectlyGuessedWords << guess
    end
    return @guessedSoFar
  end

  def currentScore
    if gameStatus == :GAME_LOST
      25
    else
      numWrongGuessesMade + @correctlyGuessedLetters.size
    end
  end

  def assertCanKeepGuessing
    if gameStatus != :KEEP_GUESSING
      raise "Cannot keep guessing in current game state: #{gameStatus}"
    end
  end

  def gameStatus
    if @secretWord == @guessedSoFar
      :GAME_WON
    elsif numWrongGuessesMade > @maxWrongGuesses
      :GAME_LOST
    else
      :KEEP_GUESSING
    end
  end

  def numWrongGuessesMade
    @incorrectlyGuessedLetters.size + @incorrectlyGuessedWords.size
  end

  def numWrongGuessesRemaining
    @maxWrongGuesses - numWrongGuessesMade
  end

  def getMaxWrongGuesses
    @maxWrongGuesses
  end

  def getGuessedSoFar
    String.new(@guessedSoFar)
  end

  def getCorrectlyGuessedLetters
    Set.new(@correctlyGuessedLetters).freeze
  end

  def getIncorrectlyGuessedLetters
    Set.new(@incorrectlyGuessedLetters).freeze
  end

  def getAllGuessedLetters
    Set.new(@correctlyGuessedLetters + @incorrectlyGuessedLetters).freeze
  end

  def getIncorrectlyGuessedWords
    Set.new(@incorrectlyGuessedWords).freeze
  end

  def getSecretWordLength
    @secretWord.length
  end

  def to_s
    "#{@guessedSoFar}; score=#{currentScore}; status=#{gameStatus}"
  end

end
