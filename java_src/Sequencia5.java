package sequencia;

import java.util.Scanner;

public class Sequencia5 {
	public static void main(String[] args){

		int metro, centimetro;
		
		Scanner input = new Scanner(System.in);
		
		System.out.println("Informe o numero em metros ser convertido");
		metro = input.nextInt();

		centimetro = metro*100;	
		
		System.out.println(metro + " metros corresponde a " + centimetro + " centimetros  ");
	}
}
