class MergeSort{

	public static int[] merge(int[] vet, int inicio, int fim) {
		int[] vet3 = new int[vet.length];
		if (inicio < fim) {
			int meio = (inicio + fim) / 2;
			int[] vet1 = merge(vet, inicio, meio);
			int[] vet2 = merge(vet1, meio + 1, fim);
			vet3 = mesclar(vet2, inicio, meio, fim);
		}
		else {
			vet3 = vet;
		}
		return vet3;
	}

	public static int[] mesclar(int[] vet, int inicio, int meio, int fim)
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
		return vet;
	}

	public static void main(String[] args) {

		int[] vet = {8,5,2,7,1,10,4,3,6,50,9,25};
		int[] newvet = merge(vet, 0, vet.length-1);

		for(int i=0; i<= newvet.length-1; i++)
			System.out.println(newvet[i]);	
	}
}
