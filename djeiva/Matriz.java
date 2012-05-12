package matriz;

import java.util.Random;

public class Matriz {

	private static double cofator(int x, int tam, int[][] Mat){
		int p = 0;
		for(int i = 1; i < tam; i++){
			int s = 0;
			for(int j=0; j<tam; j++){
				if(j != x){
					s++;
					Mat[p][s] = Mat[i][j];
				}
			}
		}
		return (Math.pow(-1, 1 +x) * calcularDeterminante(p, Mat));
	}


	
	private static int calcularDeterminante(int tam,int [][] Mat){
		
		int det = 0;
		if(tam == 1){
			return Mat[0][0];
			
		}else if (tam == 2){
			det = Mat[0][0] * Mat[1][1] - Mat[0][1] * Mat[1][0];
			return det;		
		}else{
			for(int i = 0; i<tam; i++){
				if(Mat[0][i] != 0){
					det += Mat[0][i] * cofator(i, tam, Mat);					
				}
			} 
			
			return det;
		}
	}
	
	
	/*-----------------------------Codigo da net*------------------------------------------------/
	/**
	 * Calcula el determinante de la matriz. 
	 * Para ello coge la primera fila y se va multiplicando cada coeficiente por el 
	 * determinante de la matriz de orden n-1 que resulta de suprimir la fila y columna
	 * del coeficiente. Hay que ir alternando los signos.
	 * Ver http://www.marcevm.com/determinantes/determinantes_def.php
	 * @param matriz
	 * @return
	 */
	public static double determinante (int[][] mat)
	{
		assert mat != null;
		assert mat.length>0;
		assert mat.length == mat[0].length;
		
		double determinante = 0.0;
		
		int filas = mat.length;
		int columnas = mat[0].length;
		
		// Si la matriz es 1x1, el determinante es el elemento de la matriz
		if ((filas==1) && (columnas==1))
			return mat[0][0];
		

		int signo=1;
		
		for (int columna=0;columna<columnas;columna++)
		{
			// Obtiene el adjunto de fila=0, columna=columna, pero sin el signo.
			int[][] submatriz = getSubmatriz(mat, filas, columnas,
					columna);
			determinante = determinante + signo*mat[0][columna]*determinante(submatriz);
			signo*=-1;
		}
		
		return determinante;
	}

	/**
	 * Obtiene la matriz que resulta de eliminar la primera fila y la columna que se
	 * pasa como parámetro.
	 * @param matriz Matriz original
	 * @param filas Numero de filas de la matriz original
	 * @param columnas Numero de columnas de la matriz original
	 * @param columna Columna que se quiere eliminar, junto con la fila=0
	 * @return Una matriz de N-1 x N-1 elementos
	 */
	public static int[][] getSubmatriz(int[][] matriz, 
			int filas,
			int columnas, 
			int columna) {
		int [][] submatriz = new int[filas-1][columnas-1];
		int contador=0;
		for (int j=0;j<columnas;j++)
		{
			if (j==columna) continue;
			for (int i=1;i<filas;i++)
				submatriz[i-1][contador]=matriz[i][j];
			contador++;
		}
		return submatriz;
	}
	
	/*-----------------------------------------------------------------------------------------------*/
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
		int[][] Mat = new int[3][3];
		int[][] MatTeste = new int[3][3];
		int tam = Mat.length;
		int determ = 0;
		
		lerMatriz(Mat);
		imprimirMatriz(Mat);
		
		System.out.println("O calculo do determinante" + calcularDeterminante(tam, Mat));
		
		lerMatriz(MatTeste);
		imprimirMatriz(MatTeste);
		System.out.println("O calculo do determinante net " + determinante(MatTeste));
		
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

