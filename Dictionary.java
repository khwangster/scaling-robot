import java.util.*;
import java.io.*;

public class Dictionary {
    
    public final HashMap<String, Word> allWords = new HashMap<>();
    public final HashMap<Integer, HashSet<Word>> wordLength = new HashMap<>();
    public final ArrayList<HashMap<Character, HashSet<Word>>> letterPositions = new ArrayList<>();
    public final HashMap<Character, HashSet<Word>> containsLetter = new HashMap<>();
    
    public Dictionary(String filepath) {
        
        try {
            FileReader fr = new FileReader(filepath);
            BufferedReader br = new BufferedReader(fr);
            String line = br.readLine();
            
            while (line != null) {
                // create word object from string
                if (line.length() > 0) {
                    Word word = new Word(line);
                
                    // insert word object into allwords
                    allWords.put(word.word, word);

                    // insert word object into length bucket
                    if (wordLength.get(word.length) == null) {
                        wordLength.put(word.length, new HashSet<Word>());
                    }
                    wordLength.get(word.length).add(word);

                    // add every character into char-position bucket
                    // add set to map
                    for (int i = 0; i < word.length; i++) {
                        if (i >= letterPositions.size()) {
                            // create map for positions that do not have maps
                            letterPositions.add(i, new HashMap<Character, HashSet<Word>>());
                        }

                        HashMap<Character, HashSet<Word>> hm = letterPositions.get(i);
                        // create set if it doesn't exist
                        if (hm.get(word.word.charAt(i)) == null) {
                            hm.put(word.word.charAt(i), new HashSet<Word>());
                        }
                        // add word to set
                        hm.get(word.word.charAt(i)).add(word);
                    }

                    Iterator<Character> iter = word.uniqueLetters.iterator();
                    while (iter.hasNext()) {
                        Character ch = iter.next();
                        if (containsLetter.get(ch) == null) {
                            containsLetter.put(ch, new HashSet<Word>());
                        }
                        containsLetter.get(ch).add(word);
                    }
                }
                
                // read next line
                line = br.readLine();
            } 
        } catch(IOException e) {
            e.printStackTrace();
            System.exit(1);
        }
    } // public Dictionary
    
    public Word find(String word) {
        return allWords.get(word);
    }
    
    public Set<Word> getWordsWithLetterAtPosition(Character ch, int position) {
        Set<Word> set = letterPositions.get(position).get(ch);
        if (set == null) {
            return new HashSet<>();
        } else {
            return set;
        }
    }
    
    public Set<Word> getWordsWithLetter(Character ch) {
        Set<Word> set = containsLetter.get(ch);
        if (set == null) {
            return new HashSet<>();
        } else {
            return set; 
        }
    }
    
    public Set<Word> getWordsWithLength(int length) {
        Set<Word> set = wordLength.get(length);
        if (set == null) {
            return new HashSet<>();
        } else {
            return set;
        }
    }
    
}
