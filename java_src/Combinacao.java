public class Combinacao 
{
	public static void imprime_posicao(int posicao[], int k) 
	{
		for (int i = 0; i < k; i++)
			System.out.print(posicao[i]);
		//transformar String
			System.out.println(" ");
	}

	public static void combinacao(int posicao[], int n, int k, int atual) 
	{
		if (atual < k) 
		{
			for (posicao[atual] = posicao[atual - 1] + 1; posicao[atual] <= (n - k) + atual; posicao[atual]++) 
			{
				combinacao(posicao, n, k, atual + 1);
				//System.out.println("");
				imprime_posicao(posicao, k);
				//System.out.println("");
			}
		}
	}

	public static int Combinacao(int NumeroDeTermos, int NumeroDeCombinacoes) 
	{
		// ArrayList<Integer> posicoes = new ArrayList<Integer>();
		if (NumeroDeCombinacoes == 0) 
		{
			System.out.println("A combinacao e: 1");
			return (0);
		}
		else if (NumeroDeTermos == 0 || NumeroDeCombinacoes > NumeroDeTermos) 
		{
			System.out.println("\nErro: verifique os numeros digitados\n");
			return (0);
		}

		int posicoes[] = new int[1000];

		//consertar...
		int vetor[] = {1,2,3,4,5,6,7};
		int n = vetor.length;
		//consertar...

		if (NumeroDeTermos == NumeroDeCombinacoes) 
		{
			for (int i = 0; i < n; i++)
				posicoes[i] = i + 1;
			imprime_posicao(posicoes, NumeroDeCombinacoes);
		} 
		else 
		{
			for (posicoes[0] = 1; posicoes[0] <= NumeroDeTermos - NumeroDeCombinacoes + 1; posicoes[0]++) 
			{
				combinacao(posicoes, NumeroDeTermos, NumeroDeCombinacoes, 1);
				imprime_posicao(posicoes, NumeroDeCombinacoes);
			}

		}
		return (0);
	}

	public static void main(String[] args)
	{
		int vetor[] = {1,2,3,4,5,6,7};
		Combinacao(vetor.length, 5);
	}
}
