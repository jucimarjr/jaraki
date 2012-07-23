
public class TesteRecursao8 {

	public static void x(long m){
		// artificio para pular checagem de tipos
		long aux = 0;
		x(m, m, aux);
	}
	public static void x(long m, long n, long o){
		// artificio para pular checagem de tipos
		long aux;

		if (m == 0){
			System.out.println(m);
			aux = 1;
			x(m+1, n, aux);
		}
		else if (o == 0){
			System.out.println(m);
			aux = 0;
			x(m-1, n, aux);
		}
		else if (o == 1){
			if(m == n) System.out.println(m);
			else {
				System.out.println(m);
				aux = 1;
				x(m+1, n, aux);
			}
		}
	}

	public static void main(String[] args) {
		long m;
		//int m;
		m = 10;
		x(m);
	}
}
