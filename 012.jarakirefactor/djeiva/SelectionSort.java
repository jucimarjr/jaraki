package selectionSort;

public class SelectionSort {

	public static int[] selectionSort(int[] vetor) {
		int index, aux;

		for (int i = 0; i < vetor.length; i++) {
			index = i;
			for (int j = i + 1; j < vetor.length; j++) {
				if (vetor[j] < vetor[index]) {
					index = j;
				}
			}
			if (index != i) {
				aux = vetor[index];
				vetor[index] = vetor[i];
				vetor[i] = aux;
			}
		}
		
		return vetor;
	}

	public static void main(String[] args) {

		int[] vetor = {5,2,1,4,3,50,25};
		
		selectionSort(vetor);
		
		for (int i = 0; i < vetor.length; i++) {
			System.out.print(vetor[i]+" ");
		}
	}

}
