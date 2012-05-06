package sequencia;

import java.util.Scanner;

public class Sequencia7 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		final float PI = 3.14159265f;
		float raio, area, dobroArea;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe o raio do círculo");		
		raio = input.nextFloat();
		
		area = 2*PI*raio*raio;
		
		dobroArea = 2*area;
		
		System.out.println("O dobro da área do círculo é: " + dobroArea);

	}
}
