import java.util.Random;

/** Generate 10 random integers in the range 0..99. */
public class Random1 {
  
  public static void main(String[] Args){

	int randomInt;
	randomInt = 6;
    System.out.println("Generating 10 random integers in range 0..99.");
    
    //note a single Random object is reused here
    Random randomGenerator = new Random();
    for (int idx = 1; idx <= 10; idx++){
      randomInt = randomGenerator.nextInt(100);
      System.out.println("Generated : " + randomInt);
    }
    
    System.out.println("Done.");
  }
  
}
 
