
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
        
        
        // array of sample input words
        String[] secrets = new String[]{ 
            "comaker", "cumulate", "eruptive", "factual", "monadism", "mus", 
            "nagging", "oses", "remembered", "spodumenes", "stereoisomers",
            "toxics", "trichromats", "triose", "uniformed"           
        };
        
        float totalScore = 0;
        long overallStart = System.nanoTime();
        
        for (String secret : secrets) {
            HangmanGame game = new HangmanGame(secret, 5);
            totalScore += run(gs, game);
        }
        
        long overallEnd = System.nanoTime() - overallStart;
//        System.out.println("Average time per guess: " + (overallEnd/1000000000.0/secrets.length));
//        System.out.println("Score: " + totalScore + " Average: " + (totalScore/secrets.length));
        

    }
    

    
}
