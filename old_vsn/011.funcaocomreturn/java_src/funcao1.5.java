package funcao15;

public class Funcao15 {

		public static void imprimeVariavel () {
			int a;
			a = 5;
			
			for( int i = 0; i<3; i++ ){
				System.out.print("Valor de a: ");
				System.out.println(a);
				a = a + 1;
				System.out.print("Iteracao: ");
				System.out.println(i);
			}
			
			System.out.print("Valor de a: ");
			System.out.println(a);
			
		}

		public static void main(String[] Args) {
			imprimeVariavel();
		}
}
