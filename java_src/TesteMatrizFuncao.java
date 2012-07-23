package matriz;

import java.util.Random;


public class TesteMatrizFuncao {

	public static void lerMatriz(int[][] matriz, int tam) {
		Random valor = new Random(); 	
		for (int i = 0; i < tam; i++) {
			for (int j = 0; j < tam; j++) {
				matriz[i][j] = valor.nextInt(10)+1;
			}
		}

	}
	public static void imprimirMatriz(int[][] matriz, int tam) {
		System.out.println("Imprimindo Matriz...");
		for (int i = 0; i < tam; i++) {
			for (int j = 0; j < tam; j++) {
				System.out.print(matriz[i][j] + " ");
			}
			System.out.println("");
		}
	}

	public static void main(String[] args) {
		int[][] matA = new int[4][4];
		int[][] matB = new int[4][4];
		int[][] matC = new int[4][4];
		int[][] matD = new int[4][4];
		int[][] matE = new int[4][4];
		int[][] mat = new int[4][4];
		int[][] Mat = new int[3][3];
		int[][] MatTeste = new int[5][5];
			
				
		lerMatriz(MatTeste, 5);
		imprimirMatriz(MatTeste, 5);
			
		lerMatriz(matA, 4);	
		lerMatriz(matB, 4);
		
		System.out.println("MatA...");
		imprimirMatriz(matA, 4);
	    imprimirMatriz(matA, 4);

		System.out.println("MatB...");
		imprimirMatriz(matB, 4);
		
		imprimirMatriz(matA, 4);


		
		}
}

