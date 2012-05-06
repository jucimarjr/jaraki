package vetor;

public class Vetor4 {
	public static void main(String[] args) {
		int[] vet = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}; 
		int a = 10;
		int[] vet1 = new int[a];
		
		
		for(int i=0; i < 10; i++)
			vet1[i]= vet[i];
		
		
		for(int i=0; i < 10; i++)
		{
			System.out.println(vet1[i]);
		}
		
		
	}
}
