package teste.com.pacote;

import java.util.Scanner;

public class Pacote01 {
	
	public static void imprimirMedia(float media) {
		System.out.println("A média é " + media);
	}

	public static float calcularMedia(float a, float b) {
		return ((a+b)/2);
	}
	
	public static float lerVar() {
		
		Scanner scanner = new Scanner(System.in);
		System.out.print("Informe um valor: ");

		return scanner.nextFloat();
	}
	
	public static void main(String[] args) {
		float a, b, media;
		
		a = lerVar();
		System.out.println("");
		b = lerVar();
		
		media = calcularMedia(a, b);
		
		imprimirMedia(media);
	}
}
