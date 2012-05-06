package funcao16;

public class Funcao16 {

		public static void imprimeVariavel () {
			int a;
			a = 5;
			
			System.out.print("Valor de a: ");
			System.out.println(a);
		}


		public static void imprime () {
			System.out.println("Hello World");
		}

		public static void testandoFor () {
			int a;
			a = 8;

			for( int i = 0; i<=5; i++ ){
				System.out.print("Valor de a: ");
				System.out.println(a);
				a = a + 1;
				System.out.print("Iteracao: ");
				System.out.println(i);
			}

		}

		public static void testandoIf () {
			int a;
			a = 3;
			
			if( a < 2 )
				System.out.println(a);
			
		}
			
		public static void main(String[] Args) {
			imprime();			
			imprimeVariavel();
			testandoFor();
			testandoIf();
		}
}
