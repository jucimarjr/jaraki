
public class TesteRecursao3 {

	public static long soma(long n){
		long f;
		f = 0;
		if (n == 0)
			f = 0;
		else 
			f = n + soma(n-1);
		return f;
	}

	public static void main(String[] args) {
		//int n;
		long n;
		long a;
		n = 10;
		a = soma(n);
		System.out.println(a);
	}
}
