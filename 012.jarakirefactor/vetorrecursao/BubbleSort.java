
public class BubbleSort {

	public static void bolha_rec (int n, int[] v)
	{
		int j;
		int troca = 0;
		for (j=0; j<n-1; j++)
			if (v[j]>v[j+1]) { 
				int temp = v[j];
				v[j] = v[j+1];
				v[j+1] = temp;
				troca = 1;
			}
		if (troca != 0)   
			bolha_rec(n-1,v);
		for(int i=0; i<= v.length-1; i++)
			System.out.println(v[i]);	
	}


	public static void main(String[] args) {

		int[] vet = new int[10];
		vet[0] = 301;
		vet[1] = 203;
		vet[2] = 481;
		vet[3] = 890;
		vet[4] = 204;
		vet[5] = 1230;
		vet[6] = 30;
		vet[7] = 12;
		vet[8] = 5;
		vet[9] = 145;	
		bolha_rec(vet.length, vet);
	}
}
