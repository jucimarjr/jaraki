package funcao22;

public class Funcao22 {

		public static int quadrado(int a) {
			int temp;

			temp = a*a;

			return temp;
		}

		public static void cubo(int a) {
			a = a*a*a;
			System.out.print("O valor de a ao cubo: ");
			System.out.println(a);
		}

		public static void main(String[] Args) {
			int x;
			int t;

			x = 5;
			t = quadrado(x);
			cubo(x);
			System.out.print("O valor de a ao quadrado eh: ");
			System.out.println(t);
		}
}
