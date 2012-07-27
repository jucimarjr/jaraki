package testandoFor;

public class TestandoFor7 {
	  public static void main(String[] Args) {

	    float s;
		s = 0;  


		int denominador;
		denominador = 1;

		int numerador;
		numerador = 1;

	    for (int i = 1; i <= 10; i++) {

	        System.out.print(numerador);
	        System.out.print("/");
	        System.out.print(denominador);
	        System.out.print(" , ");
	        
			denominador = denominador + i;
			numerador = numerador * i;

			s = s + ( numerador/denominador );
	    } 
		
		System.out.println(s);
	  }

}
