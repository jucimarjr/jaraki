    import java.util.Random;  
      
    public class Random2 {  
      
        public static void main(String[] args) {  
      
            Random r = new Random();  
            int[] count = new int[6];
			//double a;  
            int next, b;  
            for (int i = 0; i < 1000; i++) {  
                next = ((r.nextInt(20) + 2863311530) / 715827882);  
               	if ( next < 1 && next > 6) {  
                    System.out.println("Exception");
                }  
               // count[next - 1]++;  
            } 

			for (int i = 0; i < count.length; i++) { 
				a =  (count[i] / 1000 * 100); 
				b = (i + 1);
                System.out.println(b + " - " + count[i] + " (" + a + "%)");
				++b;  
            }  
        }  
    }  
