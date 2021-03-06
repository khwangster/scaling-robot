
import java.util.*;

public class GreedyStrategy implements GuessingStrategy {

    private Set<Word> possibleWords;
    private Set<Character> incorrectlyGuessedLetters;
    private Set<Character> correctlyGuessedLetters;
    private Set<String> incorrectlyGuessedWords;

    public final Dictionary dictionary;

    public GreedyStrategy(Dictionary d) {
        dictionary = d;
        // strategy needs dictionary access to processed list of all possible words
    }

    @Override
    public Guess nextGuess(HangmanGame game) {

        if (game.currentScore() == 0) {
            // no guesses have been made yet
            // start possible words with words of right length
            possibleWords.addAll(dictionary.getWordsWithLength(game.getSecretWordLength()));
            if (possibleWords.isEmpty()) {
                throw new RuntimeException("No possible words");
            }
            return makeGuess(game);
        }

        // only filter out letters that haven't already been filtered
        Set<Character> newCorrectlyGuessedLetters = new HashSet<>(game.getCorrectlyGuessedLetters());
        newCorrectlyGuessedLetters.removeAll(correctlyGuessedLetters);
        if (newCorrectlyGuessedLetters.size() > 0) {
            // only keep words that have the letter in the right position
            Character newCorrectLetter = getOnlyChar(newCorrectlyGuessedLetters);
            for (int i=0; i<game.getSecretWordLength(); i++) {
                if (game.getGuessedSoFar().charAt(i) == newCorrectLetter) {
                    Set<Word> positionMatching = dictionary.getWordsWithLetterAtPosition(newCorrectLetter, i);
                    possibleWords.retainAll(positionMatching);
                }
                
                // remove words that have letter in non-revealed position
                if (game.getGuessedSoFar().charAt(i) == HangmanGame.MYSTERY_LETTER) {
                    Set<Word> positionMismatch = dictionary.getWordsWithLetterAtPosition(newCorrectLetter, i);
                    possibleWords.removeAll(positionMismatch);
                }
            }
            
            correctlyGuessedLetters.add(newCorrectLetter);
            return makeGuess(game);
        }
        
        // remove words containing wrong letters
        Set<Character> newWrongLetters = new HashSet<>(game.getIncorrectlyGuessedLetters());
        newWrongLetters.removeAll(incorrectlyGuessedLetters);
        if (newWrongLetters.size() > 0) {
            Character newWrongLetter = getOnlyChar(newWrongLetters);
            possibleWords.removeAll(dictionary.getWordsWithLetter(newWrongLetter));
            incorrectlyGuessedLetters.add(newWrongLetter);
            return makeGuess(game);
        }
        
        // remove wrong words
        Set<String> newWrongWords = new HashSet<>(game.getIncorrectlyGuessedWords());
        newWrongWords.removeAll(incorrectlyGuessedWords);
        if (newWrongWords.size() > 0) {
            String newWrongWord = getOnlyWord(newWrongWords);
            possibleWords.remove(dictionary.find(newWrongWord));
            incorrectlyGuessedWords.add(newWrongWord);
            return makeGuess(game);
        }
        
        // one of the 4 if statements should be the only 4 possible outcomes
        throw new RuntimeException("No changes detected in game");
    }

    public void newGame() {
        // call at beginning of run        
        possibleWords = new HashSet<>();
        incorrectlyGuessedLetters = new HashSet<>();
        correctlyGuessedLetters = new HashSet<>();
        incorrectlyGuessedWords = new HashSet<>();
    }

    private String getOnlyWord(Set<String> set) {
        // quite unsafe/dirty method of getting the remaining word in a set
        if (set.size() == 1) {
            Iterator<String> iter = set.iterator();
            if (iter.hasNext()) {
                return iter.next();
            } else {
                throw new RuntimeException("Something went very wrong here.");
            }
        } else {
            throw new RuntimeException("Set has more than one element.");
        }
    }

    private Character getOnlyChar(Set<Character> set) {
        // quite unsafe/dirty method of getting the remaining char in a set
        if (set.size() == 1) {
            Iterator<Character> iter = set.iterator();
            if (iter.hasNext()) {
                return iter.next();
            } else {
                throw new RuntimeException("Something went very wrong here.");
            }
        } else {
            throw new RuntimeException("Set has more than one element.");
        }
    }
    
    private HashMap<Character, Integer> CalcLetterFrequency(Set<Word> words, Set<Character> usedLetters) {
        HashMap<Character, Integer> frequency = new HashMap<>();

        for (Word word : words) {
            for (Character ch : word.uniqueLetters) {
                if (frequency.get(ch) == null) {
                    frequency.put(ch, 1);
                } else {
                    frequency.put(ch, frequency.get(ch)+1);
                }
            }
        }
        
        for (Character ch : usedLetters) {
            frequency.remove(ch);
        }
       
        return frequency;
    }
    
    private Character pickMostUsed(Map<Character, Integer> frequency) {
        Integer max = 0;
        Character ch = 'E';
        for (Map.Entry<Character, Integer> entry : frequency.entrySet()) {
            Character key = entry.getKey();
            Integer value = entry.getValue();
            if (value > max) {
                ch = key;
                max = value;
            }
        }
        return ch;
    }
    
    

    private Guess makeGuess(HangmanGame game) {
        switch(possibleWords.size()) {
            case 1:
            case 2:
                // pick the only remaining word, or pick one of the two at random
                Iterator<Word> iter = possibleWords.iterator();
                return new GuessWord(iter.next().word);
            default:
                Map<Character, Integer> frequency = CalcLetterFrequency(possibleWords, game.getAllGuessedLetters());
                return new GuessLetter(pickMostUsed(frequency));
        }
    }

}
