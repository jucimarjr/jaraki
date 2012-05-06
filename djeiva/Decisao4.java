package decisao;

import java.util.Scanner;

public class Decisao4 {
	public static void main(String[] args){
		
		String letra;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe a letra");
		
		letra = input.nextLine();
		
		if(letra.equalsIgnoreCase("a") || letra.equalsIgnoreCase("e") || letra.equalsIgnoreCase("i")
				|| letra.equalsIgnoreCase("o") || letra.equalsIgnoreCase("u"))
			System.out.println("A letra digitada é vogal");		
		else 
			System.out.println("a letra digitada é consoante");
		
	}
}
