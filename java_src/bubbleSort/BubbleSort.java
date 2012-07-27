package bubbleSort;

public class BubbleSort {

	public static int[] bubbleSort(int[] vetor){
		int aux;
		int temp;

		for (int i = 0; i < vetor.length; i++) {
			for (int j = 0; j < vetor.length - 1; j++) {
				//if (vetor[j] > vetor[j + 1]) {
				temp = j+1;
				if (vetor[j] > vetor[temp]) {
					aux = vetor[j];
					vetor[j] = vetor[temp];
					vetor[temp] = aux;
				}
			}
		}
		
		return vetor;
	}

	public static void main(String[] args) {

		int[] vetor = {5,2,1,4,3};
		
		vetor = bubbleSort(vetor);
		
		for (int i = 0; i < vetor.length; i++) {
			System.out.print(vetor[i]+" ");
		}
		
	}

}
