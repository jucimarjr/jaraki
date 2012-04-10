import java.util.Scanner;

public class Decisao5 {
	public static void main(String[] args){
		float nota1, nota2, media;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe as notas parciais");
		nota1 = input.nextFloat();
		nota2 = input.nextFloat();
		
		media = (nota1 + nota2)/2;
		
		if(media >= 7 && media < 10)
			System.out.println("Aprovado");
			else if(media < 7)
				System.out.println("Reprovado");
				else 
					System.out.println("Aprovado com distinção");
		
	}
}

