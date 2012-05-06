package vetor;

import java.util.Scanner;

public class Vetor21 {
	// 2.Faça um Programa que leia um vetor de 10 números reais e mostre-os na ordem inversa. 
	
	public static void main(String[] args) {
		Scanner input = new Scanner(System.in);
		int[] vet = new int[10];
		
		for(int i=0; i<10; i++){
			vet[i] = input.nextInt();
		}
		
		for(int i=0; i<10; i++){
			System.out.print(vet[i]);
		}
	}
}
