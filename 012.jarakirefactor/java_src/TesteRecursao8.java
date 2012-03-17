
public class TesteRecursao8 {

	public static void x(long m){
		x(m, m, 0);
	}
	public static void x(long m, long n, long o){

		if (m == 0){
			System.out.println(m);
			x(m+1, n, 1);
		}
		else if (o == 0){
			System.out.println(m);
			x(m-1, n, 0);
		}
		else if (o == 1){
			if(m == n) System.out.println(m);
			else {
				System.out.println(m);
				x(m+1, n, 1);
			}
		}
	}

	public static void main(String[] args) {
		int m;
		m = 10;
		x(m);
	}
}