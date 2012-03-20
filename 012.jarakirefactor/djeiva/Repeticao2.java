package repeticao;

import java.util.Scanner;

public class Repeticao2 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String usuario, senha;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe o nome do usuário");		
		usuario = input.nextLine();
		
		System.out.println("Informe a senha");		
		senha = input.nextLine();
		
	while(true){
				
		if(!usuario.equals(senha)){
			System.out.println("ok");
			break;
		}
		else
			System.out.println("Senha inválida! A senha deve ser diferente do nome do usuário");
			System.out.println("Informe novamente o nome do usuario");
			usuario = input.nextLine();
			
			System.out.println("Informe novamente a senha do usuario");
			senha = input.nextLine();
		}
	}
}

