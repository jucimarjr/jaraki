package matriz;

public class Erro1 {
	public static void main(String[] args) {
		int[][] matriz = { { 1, 3 }, { 5, 7 } };
		int n = 2;

		int i = 1;
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				System.out.println(matriz[i][j]);
			}
		}

	}
}

