package vetor;

import java.util.Scanner;

public class vetor3 {
	// 3. Faça um Programa que leia 4 notas, mostre as notas e a média na tela. 
	public static void main(String[] args) {
		float[] vet = {8, 9, 7, 6};
		float media;
		
		for(int i=0; i < vet.length; i++){
			System.out.println(vet[i]);
		}
		
		media = (vet[0] + vet[1] + vet[2] + vet[3]) / 4 ;
		
		System.out.print(media);
				
	}
}
