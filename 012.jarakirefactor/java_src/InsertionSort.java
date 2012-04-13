package insertionSort;

public class InsertionSort {

	public static int[] insertionSort(int vetor[]) {
		for (int i = 1; i < vetor.length; i++) {
			int a = vetor[i];
			int j;
			for (j = i - 1; j >= 0 && vetor[j] > a; j--) {
				vetor[j + 1] = vetor[j];
				vetor[j] = a;
			}
		}
		return vetor;
	}

	public static void main(String[] args) {
		int vetor[] = {8,5,2,7,1,10,4,3,6,50,9,25};
		
		insertionSort(vetor);
		
		for (int i = 0; i < vetor.length; i++) {
			System.out.print(vetor[i]+" ");
		}
	}

}
