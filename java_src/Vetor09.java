package vetor;

public class Vetor09 {
	public static void main(String[] args) {
		int[] vet1 = {1, 3, 5, 7, 9}; 
		int[] vet2 = {2, 4, 6, 8, 10}; 
		int[] vet3 = {0, 0, 0, 0, 0}; 
		int n = 10;

		for(int i=0; i < 5; i++)
			vet3[i] = vet2[i] * vet1[i] * n;
		
		for(int i=0; i < 5; i++)
			System.out.println(vet3[i]);

		
	}
}
