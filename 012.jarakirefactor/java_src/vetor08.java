package vetor;

public class vetor08 {
	public static void main(String[] args) {
		int[] vet1 = {1, 3, 5, 7, 9}; 
		int[] vet2 = {2, 4, 6, 8, 10}; 
		
		
		for(int i=0; i < 5; i++)
			vet1[i]= vet2[i];
		
		for(int i=0; i < 5; i++)
		{
			System.out.println(vet1[i]);
			System.out.println(vet2[i]);
		}
	}
}
