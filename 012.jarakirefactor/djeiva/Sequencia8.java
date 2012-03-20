package sequencia;

import java.util.Scanner;

public class Sequencia8 {

	/**
	 * @param args
	 */
	public static void main(String[] args) {		
		float custoHora, salario;
		int qtdHora;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe quanto voce ganha por hora");		
		custoHora = input.nextFloat();
		
		System.out.println("Informe quantas horas voce trabalhou nesse mês");		
		qtdHora = input.nextInt();
		
		salario = qtdHora*custoHora;
		System.out.println("O salario correspondente as horas trabalhadas é: " + salario);	

	}
}
