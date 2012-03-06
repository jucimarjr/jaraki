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

	public static int ehprimo(int m) {
		int primo;
		primo = 0;
		for (int j = 2; j <= m-1; j++){
			if ((m % j) == 0){
					primo = primo + 1;	
				}
		}
		return primo;
	}	
}
