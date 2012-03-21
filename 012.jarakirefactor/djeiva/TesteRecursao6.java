
public class TesteRecursao6 {
	public static long x(long m){
		long x;
		x = 0;
		if (m <= 0) 
			x = m; 
		else x = x(m-1) + x(m -2) + x(m-3);
		return x;
	}

	public static void main(String[] args) {
		int m;
		long a;
		m = 25;
		a = x(m);
		System.out.println(a);
	}
}
