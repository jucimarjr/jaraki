package repeticao;

import java.util.Scanner;

public class Repeticao3 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String nome, sexo, estadoCivil;
		int idade;
		float salario;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe seu nome");		
		nome = input.nextLine();
		
		while(true){
			if(nome.length() > 3){
				System.out.println("Nome ok");
				break;
			}else
				System.out.println("Nome invalido");
				System.out.println("Nome novamente seu nome");
				nome = input.nextLine();
		}
	
		System.out.println("Informe sua idade");		
		idade = input.nextInt();
		
		while(true){
			if(idade >= 0 && idade<=150){
				System.out.println("Idade ok");
				break;
			}else
				System.out.println("Idade inválida");
				System.out.println("Informe novamente sua idade");
				idade = input.nextInt();
		}
		
		System.out.println("Informe seu salario");		
		salario = input.nextFloat();
		
		while(true){
			if(salario > 0){
				System.out.println("Salario ok");
				break;
			}else
				System.out.println("Salario inválido");
				System.out.println("Informe novamente seu salario");
				salario = input.nextFloat();
		}
		
		System.out.println("Informe seu sexo");		
		sexo = input.nextLine();
		
		while(true){
			if(sexo.equalsIgnoreCase("f") || sexo.equalsIgnoreCase("m")){
				System.out.println("sexo ok");
				break;
			}else
				System.out.println("Sexo invalido");
				System.out.println("Informe novamente seu sexo");
				sexo = input.nextLine();
		}
		
		System.out.println("Informe seu estado civil");		
		estadoCivil = input.nextLine();
		
		while(true){
			if(estadoCivil.equals("s") || estadoCivil.equals("c") ||
					estadoCivil.equals("v") || estadoCivil.equals("d")){
				System.out.println("Estado civil ok");
				break;
			}else
				System.out.println("Estado civil invalido invalido");
				System.out.println("Informe novamente seu estado civil");
				estadoCivil = input.nextLine();
		}
		
	}
}
