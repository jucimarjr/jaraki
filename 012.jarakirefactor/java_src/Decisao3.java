package decisao;

import java.util.Scanner;

public class Decisao3 {
	public static void main(String[] args){
		String sexo;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe o sexo");
		
		sexo = input.nextLine();
		
		if(sexo.equalsIgnoreCase("F"))
			System.out.println("F - feminino");		
			else if(sexo.equalsIgnoreCase("M"))			
				System.out.println("M - masculino");
				else 
					System.out.println("Sexo inválido");
		
	}
}
