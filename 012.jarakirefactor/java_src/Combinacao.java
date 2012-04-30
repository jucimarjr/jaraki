package combinacao;

public class Combinacao 
{
	public void imprime_posicao(int posicao[], int k) 
	{
		for (int i = 0; i < k; i++)
			System.out.println(posicao[i]);
		//transformar String
			System.out.println(" ");
	}

	public void combinacao(int posicao[], int n, int k, int atual) 
	{
		if (atual < k) 
		{
			for (pos[atual] = posicao[atual - 1] + 1; posicao[atual] <= (n - k) + atual; posicao[atual]++) 
			{
				combinacao(posicao, n, k, atual + 1);
				System.out.println("");
				imprime_posicao(posicao, k);
				System.out.println("");
			}
		}
	}

	public int Combinacao(int NumeroDeTermos, int NumeroDeCombinacoes) 
	{
		// ArrayList<Integer> posicoes = new ArrayList<Integer>();
		if (NumeroDeCombinacoes == 0) 
		{
			System.out.println("A combinacao e: 1");
			return (0);
		} else if (NumeroDeTermos == 0 || NumeroDeCombinacoes > NumeroDeTermos) 
		{
			System.out.println("\nErro: verifique os numeros digitados\n");
			return (0);
		}

		int posicoes[] = new int[1000];
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
}
