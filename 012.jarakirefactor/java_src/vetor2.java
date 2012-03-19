package vetor;

import java.util.Scanner;

public class vetor2 {
	// 2.Faça um Programa que leia um vetor de 10 números reais e mostre-os na
	// ordem inversa.
	public static void main(String[] args) {
		int[] vet = new int[10];

		for (int i = 0; i < 10; i++) {
			vet[i] = i;
		}

		for (int i = vet.length - 1; i >= 0; i--) {
			System.out.print(vet[i]);
		}

	}
}
