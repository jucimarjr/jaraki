package vetor;

public class TesteVetorFuncao {
	
	public static void lerVetor(int[] vetor, int tam) {
		Random valor = new Random(); 	
		for (int i = 0; i < tam; i++) {
				vetor[i] = valor.nextInt(10)+1;
		}

	}
	
	public static void imprimirVetor(int[]vet, int tam) {
		System.out.println("Imprimindo Matriz...");
		for (int i = 0; i < tam; i++) {
				System.out.print(vet[i] + " ");
		}
	}
	public static void main(String[] args) {

		int[] vet = new int[8];
                lerVetor(vet, 8);
       		imprimirVetor(vet, 8);
       		imprimirVetor(vet, 8);
	}
}

