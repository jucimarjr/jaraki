package vetor;

public class Vetor2 {
	public static void main(String[] args) {
		int[] vet1 = {1, 3, 5, 7, 9}; 
		int[] vet2 = {2, 4, 6, 8, 10}; 
		float[] vet3 = {0, 0, 0, 0, 0}; 
		int n = 10;
		float total = 0;

		for(int i=0; i < 5; i++){
			vet3[i] = vet2[i]/vet1[i] * n + total;
			total = vet3[i] + total;
		}

		for(int i=0; i < 5; i++)
			System.out.println(vet3[i]);
		
		System.out.println("Total: ");
		System.out.print(total);

		
	}
}
