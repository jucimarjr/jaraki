package repeticao;

import java.util.Scanner;

public class Repeticao1 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		int num;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe uma nota");
		
		num = input.nextInt();
		
	while(true){
				
		if(num >= 0 && num <=10){
			System.out.println("ok");
			break;
		}
		else
			System.out.println("Nota invalida, informe outra nota");
			num = input.nextInt();

		}
		
	}

}
