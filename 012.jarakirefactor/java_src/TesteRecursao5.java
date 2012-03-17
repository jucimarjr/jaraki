public class TesteRecursao5 {
	public static double x(double m, double n){
		double x;
		x = 0;
		if (n == 0) 
			x = 1; 
		else x = m * x(m, n-1);
			return x;
	}

	public static void main(String[] args) {
		double m, n, a;
		m = 4;
		n = 20;
		a = x(m, n);
		System.out.println(a);
	}
}