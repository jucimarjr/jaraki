public class Permutacao 
{
	public static int[] TrocaPosicao(int v[], int i, int j) 
	{
		int t;
		t = v[i];
		v[i] = v[j];
		v[j] = t;
		return v;
	}

	public static int[] GiraEsquerda(int v[], int go, int n) 
	{
		int temp = v[go];
		for (int i = go; i < n; i++) 
		{
			v[i] = v[i + 1];
		}
		v[n] = temp;
		return v;
	}

	public static void Imprime(int s[], int k) 
	{
		for (int i = 1; i <= k; i++) 
		{
			System.out.print(s[i]);
		}
		System.out.print("\n");
	}

	public static int[] Permuta(int v[], int inicio, int n) 
	{
		Imprime(v, n);
		if (inicio < n) 
		{
			for (int i = n - 1; i >= inicio; i--) 
			{
				for (int j = i + 1; j <= n; j++) 
				{
					TrocaPosicao(v, i, j);
					Permuta(v, i + 1, n);
				}
				GiraEsquerda(v, i, n);
			}
		}
		return v;
	}

	public static void main(String[] args)
	{
		int[] vetor = {1,2,3,4,5,6,7};
		int vetor_auxiliar[];
		vetor_auxiliar = Permuta(vetor, 0, 3);
	}
}
