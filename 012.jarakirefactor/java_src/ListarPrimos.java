public class ListarPrimos {
	public static void main(String[] args) {
		int a, i, n;
		
		a = 2;
		i = 0;
		n = 10;
		
		System.out.println("Primos");
		while (i< n){
			if (ehprimo(a) == 0){
				System.out.print("Eh primo: ");
				System.out.println(a);
				i = i + 1;
			} 
			a = a +1;
		}
	}

	public static int ehprimo(int n) {
		int primo;
		primo = 0;
		for (int i = 2; i <= n-1; i++){
			if ((n % i) == 0){
					primo = primo + 1;	
				}
		}
		return primo;
	}	
}
