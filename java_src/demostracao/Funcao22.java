//package funcao22;

public class Funcao22 {

		public static boolean bo(boolean a) {
			boolean b;
			b = false;

			if (a == true)
				b = false;
			else b = true; 

			return b;
		}		
			
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
			boolean b;

			x = 5;
			t = quadrado(x);
			cubo(x);
			System.out.print("O valor de a ao quadrado eh: ");
			System.out.println(t);
			
			b = bo(true);

			System.out.print("O valor de b ao quadrado eh: ");
			System.out.println(b);
		}
}
