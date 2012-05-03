package matriz;

public class Matriz {
	
	private static int[][] somarMatriz(int[][] A, int[][] B) {
		int[][] C = new int[4][4];
		for (int i = 0; i < A.length; i++) {
			for (int j = 0; j < B.length; j++) {
				C[i][j] = A[i][j] + B[i][j] ;
			}
		}
		return C;
	}
	private static void lerMatriz(int[][] matriz) {
		for (int i = 0; i < matriz.length; i++) {
			for (int j = 0; j < matriz.length; j++) {
				matriz[i][j] = i+2;
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
		int[][] matriz = new int[3][3];
		int[][] matA= new int[4][4];
		int[][] matB = new int[4][4];
		int[][] matC = new int[4][4];
		
		lerMatriz(matriz);
		imprimirMatriz(matriz);
		
		lerMatriz(matA);
		lerMatriz(matB);
		matC = somarMatriz(matA, matB);
		
	}

}
