package sequencia;

import java.util.Scanner;

public class Sequencia9 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int grausFarenheit, grausCelsius;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe uma temperatura em graus Farenheit");		
		grausFarenheit = input.nextInt();
		
		grausCelsius = (5 * (grausFarenheit-32) / 9);
		
		System.out.println(grausFarenheit + " graus Farenheit corresponde a "
				+ grausCelsius + " graus Celsius");
	}
}
