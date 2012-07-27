package matriz;

public class Matriz04 {
	public static void main(String[] args) {
		int a, b, c, d;
		int[] vet = { 1, 2, 3 };
		int[][] matriz = { { 1, 2, 3 }, { 4, 5, 6 }, {7, 8, 9} };

		for(int i=0; i<3; i++){
			for(int j=0; j<3; j++){
				System.out.println(matriz[i][j]);
			}
		}
	}

}
