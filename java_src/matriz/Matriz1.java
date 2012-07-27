package matriz;

import java.util.Random;


public class Matriz1 {
	
	
	/*public static int[][] matrizTransposta(int[][] mat){
		int aux = 0;
		for(int i=0; i < mat.length; i++){
			for(int j=i+1; j< mat.length; j++ ){
				aux = mat[i][j];
				mat[i][j] = mat[j][i];
				mat[j][i] = aux; 
			}
		}
		return mat;
	}*/

	public static int[][] multiplicarMatriz(int[][] A, int[][] B) {
		int[][] mult = new int[4][4];
		int total = 0;
		for (int l = 0; l < 4; l++) {
			for (int c = 0; c < 4; c++) {
				total = 0;
				for (int i = 0; i < 4; i++) {
					total = total + (A[l][i] * B[i][c]);
					System.out.println(total);
				}
				mult[l][c] = total;
					
			}
		}
		return mult;
	}

	public static int[][] somarMatriz(int[][] A, int[][] B) {
		int[][] C = new int[4][4];
		for (int i = 0; i < A.length; i++) {
			for (int j = 0; j < B.length; j++) {
				C[i][j] = A[i][j] + B[i][j];
			}
		}
		return C;
	}

	public static void lerMatriz(int[][] matriz, int tam) {
		Random valor = new Random(); 	
		for (int i = 0; i < tam; i++) {
			for (int j = 0; j < tam; j++) {
				matriz[i][j] = valor.nextInt(10)+1;
			}
		}

	}
	public static void imprimirMatriz(int[][] matriz, int tam) {
		//System.out.println("Imprimindo Matriz...");
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
		int[][] mat = new int[4][4];
		int[][] Mat = new int[3][3];
		int[][] MatTeste = new int[5][5];
			
				
		lerMatriz(MatTeste, 5);
		imprimirMatriz(MatTeste, 5);
			
		lerMatriz(matA, 4);	
		lerMatriz(matB, 4);
		
		System.out.println("MatA...");
		imprimirMatriz(matA, 4);
		System.out.println("MatB...");
		imprimirMatriz(matB, 4);
		System.out.println("Soma...");
		matC = somarMatriz(matA, matB);
		
		imprimirMatriz(matC, 4);
		System.out.println("Multiplicacao..");
		matD = multiplicarMatriz(matA, matB);
		imprimirMatriz(matD, 4);
		
		}
}

