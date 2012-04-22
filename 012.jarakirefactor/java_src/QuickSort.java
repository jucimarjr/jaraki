
public class QuickSort {
	public static int[] quick_sort(int[] v,int ini, int fim) {
		int meio;
		
		if (ini < fim) {
			meio = partition(v, ini, fim);
			v = quick_sort(v, ini, meio);
			v = quick_sort(v, meio + 1, fim);
		}
		return v;
	}

	public static int partition(int []v, int ini, int fim) {
		int pivo, topo;
		pivo = v[ini];
		topo = ini;

		for (int i = ini + 1; i < fim; i++) {
			if (v[i] < pivo) {
				v[topo] = v[i];
				v[i] = v[topo + 1];
				topo++; 
			}
		}
		v[topo] = pivo;
		return topo;
	}

	public static void main(String[] args) {

		int[] vet = {8,5,2,7,1,10,4,3,6,50,9,25};
		vet = quick_sort(vet, 0, vet.length);

		for(int i=0; i< vet.length; i++)
			System.out.println(vet[i]);	
	}
}
