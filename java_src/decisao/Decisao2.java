package decisao;

import java.util.Scanner;

public class Decisao2 {
	public static void main(String[] args){
		int num;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Entre com um numero");
		num = input.nextInt();
				
		if(num > 0)
			System.out.println("O numero informado é positivo");
		else
			System.out.println("O numero informado é negativo");
	}
}

