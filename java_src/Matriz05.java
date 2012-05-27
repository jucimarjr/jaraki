package matriz;

public class Matriz05 {
	public static void main(String[] args) {
		float total = 0;
		float[][] matriz = { { 1, 1, 1 }, { 2, 2, 2 }, { 3, 3, 3 } };

		for (int i = 0; i < 3; i++) {
			for (int j = 0; j < 3; j++) {
				total = matriz[i][j] + total;
			}
		}
		System.out.println("Total: ");
               System.out.print(total);
	}

}
