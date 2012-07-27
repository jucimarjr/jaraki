package matriz;

public class Matriz09 {
	public static void main(String[] args) {
		int[][] matriz1 = { { 1, 3 }, { 5, 7 } };
		int[][] matriz2 = new int[2][2];
		int[] vet = new int[2];
		
		for (int i = 0; i < matriz1.length; i++) {
			for (int j = 0; j < matriz1.length; j++) {
				matriz2[i][j] = matriz1[i][j];
				System.out.println(matriz2[i][j]);
			}
		}
	}
}
