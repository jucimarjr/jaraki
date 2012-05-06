package funcao21;

public class Funcao21 {

		public static void quadrado(int a) {
			a = a*a;
			System.out.print("O valor de a ao quadrado: ");
			System.out.println(a);
		}

		public static void cubo(int a) {
			a = a*a*a;
			System.out.print("O valor de a ao cubo: ");
			System.out.println(a);
		}

		public static void main(String[] Args) {
			int x;
			x = 5;
			quadrado(x);
			cubo(x);
		}
}
