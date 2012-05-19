package vetor;

public class Vetor10 {
	public static void main(String[] args) {
		int[] vet1 = {1, 3, 5, 7, 9, 10}; 
		int n = 10;
		int[] vet2;		
		int[] vet6 = {0, 0, 0, 0, 0};
		int vet[];
		int vet5[];
		vet5 = new int[10];
		int j = 2;
		int k = 1;
		
				 

		for(int i=0; i < 5; i++)
			vet6[i] = 1;

			
		vet6[j+1 + k] = 2;
		
		vet6[j+1 + k] = vet1[k+ 2*j] + 3;
			
		
		for(int i=0; i < 5; i++)
			System.out.println(vet6[i]);

		
	}
}
