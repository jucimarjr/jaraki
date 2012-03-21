package Classes3;

import java.util.Scanner;

public class Classes3Principal {
	public static void main(String args[]){
		Scanner s = new Scanner(System.in);
		
		Retangulo r = new Retangulo();

		System.out.println("Informe as medidas do local: ");
		
		r.ladoA = s.nextInt();
		r.ladoB = s.nextInt();
		
		System.out.println("Rodapes necessarios: " + r.calcularPerimetro() + "m");
		System.out.println("Piso necessario: " + r.calcularArea() + "m^2");
	}
}
