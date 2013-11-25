
public class main {

    
    private Integer run(GuessingStrategy strategy, HangmanGame game) {
        
        while(game.gameStatus() == HangmanGame.Status.KEEP_GUESSING) {
            Guess guess = strategy.nextGuess(game);
            guess.makeGuess(game);
        }
        return game.currentScore();
    }

    public static void main(String[] args) {
        long startTime = System.nanoTime();
        Dictionary d = new Dictionary("/home/ken/Desktop/factual/words.txt");
        long endTime = System.nanoTime();
        System.out.println("Dictionary initiation time: " + ((endTime-startTime)/1000000000.0) + " seconds" );
    }
    

    
}
