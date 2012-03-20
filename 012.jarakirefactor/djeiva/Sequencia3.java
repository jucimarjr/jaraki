package sequencia;

import java.util.Scanner;

public class Sequencia3 {
	public static void main(String[] args){
		
		int num1, num2, soma;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe o primeiro numero");
		num1 = input.nextInt();
		
		System.out.println("Informe o segundo numero");
		num2 = input.nextInt();
		
		soma = num1 + num2;
		System.out.println("A soma é: " + soma);
	}
}
