
class Word
  attr_reader :word, :unique_letters, :length
  def initialize(string)
    @word = string.upcase
    @length = string.length
    @unique_letters = Set.new
    @word.each_char do |ch|
      @unique_letters << ch
    end
  end

  def to_s
    @word
  end
end