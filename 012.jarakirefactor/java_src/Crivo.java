public class Crivo {

	public static void main(String[] args) {
		int n, cont;
		double maior;
		cont = 0;
		n = 1000;
		maior = Math.sqrt(n);

		for(int i = 2; i <= n; i++){
			cont  = 0;

			for(int j = 2; j <= maior; j++)
				if (i != j)
					if ((i % j) == 0)
						cont = cont + 1;
			if (cont == 0)
				System.out.println(i);	
		}
	}
}
