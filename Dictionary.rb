require 'set'
require_relative 'Word'

class Dictionary
  attr_reader :all_words, :word_length, :letter_positions, :contains_letter
  def initialize(filename)

    @all_words = {}
    # index of all words in dictionary
    # { "CAT" => Word(CAT) }

    @word_length = {}
    # all words sorted into buckets based on their length
    # {
    #   3 => <Set: Word(CAT), Word(BAG)>,
    #   4 => <Set: Word(BEAR)>
    # }

    @letter_positions = []
    # trie of words with letter at positions
    # [
    #   {
    #     B => <Set: Word(BAT), Word(BAG)>,
    #     C => <Set: Word(CAT)>
    #   },
    #   {
    #     A => <Set: Word(CAT), Word(BAT), Word(BAG)>
    #   },
    #   {
    #     G => <Set: Word(BAG)>,
    #     T => <Set: Word(CAT), Word(BAT)>
    #   }
    # ]
    #

    @contains_letter = {}
    # buckets of words based on letters they contain
    # {
    #   A => <Set: Word(CAT), Word(BAT), Word(BAG)>,
    #   B => <Set: Word(BAT), Word(BAG)>,
    #   G => <Set: Word(BAG)>,
    #   T => <Set: Word(CAT), Word(BAT)>
    # }

    # TODO: error handling for loading file
    words = File.new(filename)

    words.each_line do |word|
      # create a new word object from the word
      word = Word.new(word.strip)

      # add word to all words
      @all_words[word.word] = word

      # add word to length bucket
      @word_length[word.length] ||= Set.new
      @word_length[word.length] << word

      # add letters to position bucket
      (0...(word.length)).each do |i|
        ch = word.word[i]
        @letter_positions[i] ||= {}
        @letter_positions[i][ch] ||= Set.new
        @letter_positions[i][ch] << word
      end

      # add to contains letter
      word.unique_letters.each do |ch|
        @contains_letter[ch] ||= Set.new
        @contains_letter[ch] << word
      end

    end # words.each_line

  end # initialize

  def getWordsWithLetterAtPosition(letter, position)
    @letter_positions[position][letter]
  end


  # TODO: remove position_sanity
  def position_sanity
    count = 1
    @letter_positions.each do |hash|
      print "pos:#{count} | "
      hash.each do |k,v|
        print "#{k}:{"
        v.each do |word|
          print "#{word} "
        end
        print "}"
      end
      count +=1
      puts
    end
  end #position_sanity


end
