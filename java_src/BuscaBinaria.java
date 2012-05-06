public class BuscaBinaria {

	public static int buscabinaria(int valor, int e, int d, int[] vetor){

		int m = (e + d)/2;
		int Return = -1;

		if (m == 0) 
			if (vetor[0] == valor)
				Return = 0;
		if (e == d-1) 
			if (vetor[d] == valor)
				Return = d;
			else Return =  -1;
		else {

			if (vetor[m] < valor)  
				Return =  buscabinaria (valor, m, d, vetor);
			else  
				Return =  buscabinaria (valor, e, m, vetor); 
		} 
		return Return;
	} 

	public static void main(String[] args) {

		int[] vet = new int[10];

		for(int i = 0; i< vet.length; i++)
			vet[i] = i*10;
		int indice = buscabinaria(30, 0, vet.length-1, vet);
		System.out.println(indice);
	}
}
