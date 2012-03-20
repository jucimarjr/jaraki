package decisao;

import java.util.Scanner;

public class Decisao1 {
	public static void main(String[] args){
		int num1, num2;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Entre com dois numeros");
		num1 = input.nextInt();
		num2 = input.nextInt();
		
		if(num1 > num2)
			System.out.println("O maior numero é " + num1);
		else
			System.out.println("O maior numero é " + num2);
		
	}
}
