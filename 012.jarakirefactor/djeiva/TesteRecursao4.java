
public class TesteRecursao4 {
	public static long x(long m, long n){
		long x;
		x = 0;
		if ((n == 0) || (m == 0)) 
			x = 1; 
		else x = x(n-1, m) + x(n, m -1);
		return x;
	}

	public static void main(String[] args) {
		int m, n;
		long a;
		m = 2;
		n = 3;
		a = x(m, n);
		System.out.println(a);
	}
}
