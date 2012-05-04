import java.util.Random;

public class Vetor {

	public static void gerarVetorRand(int[] v){
		Random randomGenerator = new Random();
		for (int i = 0; i < v.length; i++){
			v[i] = randomGenerator.nextInt(10000);
		}
	}

	public static void quick(int[] v, int ini, int fim) {
		int meio;
		if (ini < fim) {
			meio = partition(v, ini, fim);
			quick(v, ini, meio);
			quick(v, meio + 1, fim);
		}
	}

	public static int partition(int[] v, int ini, int fim) {
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

	public static void merge(int[] vet, int inicio, int fim) {
		int meio;		
		if (inicio < fim) {
			meio = (inicio + fim) / 2;
			merge(vet, inicio, meio);
			merge(vet, meio + 1, fim);
			mesclar(vet, inicio, meio, fim);
		}
	}

	public static void mesclar(int[] vet, int inicio, int meio, int fim)
	{

		int[] vetAux = new int[vet.length];


		for (int i = inicio; i <= fim; i++)
		{
			vetAux[i] = vet[i];
		}

		int z = inicio;
		int j = meio + 1;
		int k = inicio;

		while (z <= meio && j <= fim)
		{
			if (vetAux[z] <= vetAux[j])
			{
				vet[k] = vetAux[z];
				z++;
			}
			else
			{
				vet[k] = vetAux[j];
				j++;
			}
			k++;
		}

		while (z <= meio)
		{
			vet[k] = vetAux[z];
			k++;
			z++;
		}
	}

	public static void main(String[] args) {
		for(int i = 1000; i <= 10000; i++){
			int[] vet = new int[i];
			gerarVetorRand(vet);
			int [] vet_merge = new int[i];
			int [] vet_quick = new int[i];
			for(int j =0; j < vet.length; j++){
				vet_merge[j] = vet[j];
				vet_quick[j] = vet[j];
			}
			System.out.println(i + "º: ----------------------------------------");
			System.out.println("Quick Sort");
			quick(vet_quick, 0, vet_quick.length);
			for(int j =0; j < vet_quick.length; j++){
				System.out.println(vet_quick[j]);
			}
			System.out.println("Merge Sort");
			merge(vet_merge, 0, vet_merge.length-1);
			for(int j =0; j < vet_merge.length; j++){
				System.out.println(vet_merge[j]);
			}
		}	
	}
}
