
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;


public class main {

    
    private static Integer run(GreedyStrategy strategy, HangmanGame game) {
        strategy.newGame();
        while(game.gameStatus() == HangmanGame.Status.KEEP_GUESSING) {
            Guess guess = strategy.nextGuess(game);
//            System.out.println(guess);
            guess.makeGuess(game);
//            System.out.println(game);
        }
        System.out.println(game);
        return game.currentScore();
    }

    public static void main(String[] args) {
        long startTime = System.nanoTime();
        Dictionary d = new Dictionary("words.txt");
        long endTime = System.nanoTime();
//        System.out.println("Dictionary initiation time: " + ((endTime-startTime)/1000000000.0) + " seconds" );
        
        GreedyStrategy gs = new GreedyStrategy(d);


        int count = 0;
        float totalScore = 0;
        long overallStart = System.nanoTime();
        
        // play hangman with every word from file
        try {
            FileReader fr = new FileReader("test_dict.txt");
            BufferedReader br = new BufferedReader(fr);
            String line = br.readLine();
            
            while (line != null) {
                if (line.length() > 0) {
                    HangmanGame game = new HangmanGame(line, 5);
                    totalScore += run(gs, game);
                    count++;
                }
                line = br.readLine();
            }
        } catch(IOException e) {
            e.printStackTrace();
            System.exit(1);
        }
       
        long overallEnd = System.nanoTime() - overallStart;

//        System.out.println("Average time per guess: " + (overallEnd/1000000000.0/count));
//        System.out.println("Score: " + totalScore + " Average: " + (totalScore/count));
        

    }
    

    
}
