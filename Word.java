import java.util.HashSet;
import java.util.Set;

public class Word {
    public final String word;
    public final int length;
    public final Set<Character> uniqueLetters = new HashSet<>();

    public Word(String string) {
        this.word = string.toUpperCase();
        this.length = string.length();
        for (int i=0; i<string.length(); i++) {
            uniqueLetters.add(this.word.charAt(i));
        }
//        System.out.println("Creating new word:" + this.word);
    }
          
   
    @Override
    public String toString() {
        return this.word;
    }

}