package sequencia;

import java.util.Scanner;

public class Sequencia4 {
	public static void main(String[] args){
		
		float nota1, nota2, nota3, nota4, media;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe as quatro notas bimestrais");
		nota1 = input.nextFloat();
		nota2 = input.nextFloat();
		nota3 = input.nextFloat();
		nota4 = input.nextFloat();
		
		media = (nota1 + nota2 + nota3 + nota4)/4;	
		
		System.out.println("A média é: " + media);
	}
}
