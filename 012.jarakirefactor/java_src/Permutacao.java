package permutacao;

public class Permutacao 
{
	public void TrocaPosicao(int v[], int i, int j) 
	{
		int t;
		t = v[i];
		v[i] = v[j];
		v[j] = t;
	}

	public void GiraEsquerda(int v[], int go, int n) 
	{
		int temp = v[go];
		for (int i = go; i < n; i++) 
		{
			v[i] = v[i + 1];
		}
		v[n] = temp;
	}

	public void Imprime(int s[], int k) 
	{
		for (int i = 1; i <= k; i++) 
		{
			System.out.print(s[i]);
			//System.out.print("\t");
		}
	}

	public void Permuta(int v[], int inicio, int n) 
	{
		Imprime(v, n);
		if (inicio < n) 
		{
			int i, j;
			for (i = n - 1; i >= inicio; i--) 
			{
				for (j = i + 1; j <= n; j++) 
				{
					TrocaPosicao(v, i, j);
					Permuta(v, i + 1, n);
				}
				GiraEsquerda(v, i, n);
			}
		}
	}
}
