
public class TesteRecursao2 {

	public static long fat(long n){
		long f;
		f = 0;
		if (n == 0)
			f = 1;
		else if (n == 1)
			f = 1;	
		else 
			f = n * fat(n-1);
		return f;
	}

	public static void main(String[] args) {
		int n;
		long a;
		n = 5;
		a = fat(n);
		System.out.println(a);
	}
}