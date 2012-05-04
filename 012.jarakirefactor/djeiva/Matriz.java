package matriz;

import java.util.Random;

public class Matriz {

	private	static void matrizTransposta(int[][] mat){
		int aux = 0;
		for(int i=0; i < mat.length; i++){
			for(int j=i+1; j< mat.length; j++ ){
				aux = mat[i][j];
				mat[i][j] = mat[j][i];
				mat[j][i] = aux; 
			}
		}
	}

	private static int[][] multiplicarMatriz(int[][] A, int[][] B) {
		int[][] mult = new int[4][4];
		int total;
		for (int l = 0; l < A.length; l++) {
			for (int c = 0; c < A.length; c++) {
				total = 0;
				for (int i = 0; i < 4; i++) {
					total = total + (A[l][i] * B[i][c]);
				}
				mult[l][c] = total;
			}
		}
		return mult;
	}

	private static int[][] somarMatriz(int[][] A, int[][] B) {
		int[][] C = new int[4][4];
		for (int i = 0; i < A.length; i++) {
			for (int j = 0; j < B.length; j++) {
				C[i][j] = A[i][j] + B[i][j];
			}
		}
		return C;
	}

	private static void lerMatriz(int[][] matriz) {
		Random valor = new Random(); 	
		for (int i = 0; i < matriz.length; i++) {
			for (int j = 0; j < matriz.length; j++) {
				matriz[i][j] = valor.nextInt(10);
			}
		}

	}
	private static void imprimirMatriz(int[][] matriz) {
		System.out.println("Imprimindo Matriz...");
		for (int i = 0; i < matriz.length; i++) {
			for (int j = 0; j < matriz.length; j++) {
				System.out.print(matriz[i][j] + " ");
			}
			System.out.println();
		}
	}

	public static void main(String[] args) {
		int[][] matA = new int[4][4];
		int[][] matB = new int[4][4];
		int[][] matC = new int[4][4];
		int[][] matD = new int[4][4];
		int[][] mat = new int[4][4];

		lerMatriz(matA);
		imprimirMatriz(matA);
		lerMatriz(matB);
		imprimirMatriz(matB);
		matC = somarMatriz(matA, matB);

		matD = multiplicarMatriz(matA, matB);
		imprimirMatriz(matD);
		
		lerMatriz(mat);
		imprimirMatriz(mat);
		matrizTransposta(mat);
		imprimirMatriz(mat);
	}
}

