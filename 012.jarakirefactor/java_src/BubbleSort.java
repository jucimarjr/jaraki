package bubbleSort;

public class BubbleSort {

	public static int[] bubbleSort(int vetor[]){
		int i, j, aux;

		for (i = 0; i < vetor.length; i++) {
			for (j = 0; j < vetor.length - 1; j++) {
				if (vetor[j] > vetor[j + 1]) {
					aux = vetor[j];
					vetor[j] = vetor[j + 1];
					vetor[j + 1] = aux;
				}
			}
		}
		
		return vetor;
	}

	public static void main(String[] args) {

		int vetor[] = {5,2,1,4,3};
		
		bubbleSort(vetor);
		
		for (int i = 0; i < vetor.length; i++) {
			System.out.print(vetor[i]+" ");
		}
		
	}

}
