package tryCatch;

import java.util.Scanner;

public class TryCatch {
	public static void main(String[] args) {
		
		int i;
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe um número inteiro");
		
		try{
			i = input.nextInt();
		}catch (Exception A) {
			System.out.println("Entrada inválida!");
		}
	}

}
