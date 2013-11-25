/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author ken
 */
public class GreedyStrategy implements GuessingStrategy {
    
    public GreedyStrategy(Dictionary d) {
        
    }
    
    public Guess nextGuess(HangmanGame game) {
        return new GuessLetter('c');
    }
    
    public void newGame() {
        
    }
}
