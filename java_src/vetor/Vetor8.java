package vetor;

import java.util.Scanner;

public class Vetor8 {
	// 3. Faça um Programa que leia 4 notas, mostre as notas e a média na tela. 
	// Para
	public static void main(String[] args) {
		int[] vet = {8, 9, 7, 6};
		float media = 0;
		
		for(int i=0; i < vet.length; i++){
			System.out.println(vet[i]);
		}
		
		
		for(int i=0; i < vet.length; i++){
			media = media + vet[i];
		}
        
		media = media / 4 ;
		System.out.print(media);
		
		
		
				
	}
}
