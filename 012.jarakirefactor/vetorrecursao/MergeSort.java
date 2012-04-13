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

		int[] vet = new int[12];
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
		vet[10] = 146;
		vet[11] = 100;
		int[] newvet = merge(vet, 0, vet.length-1);
		for(int i=0; i<= newvet.length-1; i++)
			System.out.println(newvet[i]);	
	}
}
