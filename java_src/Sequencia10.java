package sequencia;

import java.util.Scanner;

public class Sequencia10 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int grausFarenheit, grausCelsius;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe uma temperatura em graus Celsius");		
		grausCelsius = input.nextInt();
		
		grausFarenheit = (9*grausCelsius + 160)/ 5;
		
		System.out.println(grausCelsius + " graus Celsius corresponde a "
				+  grausFarenheit + " graus Farenheit");

	}
}

