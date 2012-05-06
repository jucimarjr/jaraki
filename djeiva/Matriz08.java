package matriz;

public class Matriz08 {
	public static void main(String[] args) {
		int[][] matriz1 = { { 1, 3 }, { 5, 7 } };
		int[][] matriz2 = { { 2, 4 }, { 6, 8 } };
		int n = 2;

		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				matriz1[i][j] = matriz2[i][j];
			}
		}

		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				System.out.println(matriz1[i][j]);
			}
		}

	}
}
