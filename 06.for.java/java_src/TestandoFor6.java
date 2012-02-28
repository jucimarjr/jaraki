package testandoFor6;

public class TestandoFor6 {
	  public static void main(String[] Args) {

	        int anterior = 0;  

	        int proximo = 1;

	        int temp = 0;

	        int n = 10;

	        

	        for (int i = 1; i <= n; i++) {

	            System.out.print(anterior);

	            System.out.print(", ");

	            temp = anterior;

	            anterior = proximo;

	            proximo = temp + proximo;

	        }  

	    }
}
