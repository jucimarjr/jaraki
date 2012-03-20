package sequencia;

import java.util.Scanner;

public class Sequencia6 {
	public static void main(String[] args){		
		final float PI = 3.14159265f;
		float raio, area;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe o raio do círculo");		
		raio = input.nextFloat();
		
		area = 2*PI*raio*raio;
		
		System.out.println("A área do círculo é: " + area);
		
	}
}
