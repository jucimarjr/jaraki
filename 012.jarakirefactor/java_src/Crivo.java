/*
 * testes de comentario
 *
 */
public class Crivo {

	public static void main(String[] args) {
		int n, cont;
		double maior;
		cont = 0;
	/*
		double maior;
		cont = 0;
		n = 1000;
		maior = Math.sqrt(n);
*/

		n = 1000;
		maior = Math.sqrt(n);


	/* int n, cont; */
	/* 	double maior; */
	/* 	cont = 0; */
	/* 	n = 1000; */
	/* 	maior = Math.sqrt(n); */


		for(int i = 2; i <= n; i++){
			cont  = 0;

			// este eh um comentario

			for(int j = 2; j <= maior; j++)
				if (i != j)
					if ((i % j) == 0)
						cont = cont + 1;
			if (cont == 0)
				System.out.println(i);	
			//if (cont == 0)
			//	System.out.println(i);	
		}
	}
}
