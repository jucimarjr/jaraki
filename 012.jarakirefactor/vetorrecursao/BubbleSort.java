
public class BubbleSort {

	public static int[] bolha_rec (int n, int[] v)
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
		return v;	
	}


	public static void main(String[] args) {

		int[] vet = {8,5,2,7,1,10,4,3,6,50,9,25};
		int[] v = bolha_rec(vet.length, vet);

		for(int i=0; i<= v.length-1; i++)
			System.out.println(v[i]);
	}
}
