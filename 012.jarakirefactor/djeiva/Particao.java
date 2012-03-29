public class Particao 
{
	int[] VetorParticao;
	int[] VetorOriginal;

	String ListaParticao = new String();

	// m�todo para particionar o numero passado.
	public String particionar(int numero) 
	{
		VetorParticao = new int[numero];
		VetorOriginal = new int[numero];

		for (int contador = 0; contador < numero; contador++) 
		{
			VetorOriginal[contador] = contador + 1;
		}

		particiona(numero, 1);

		ListaParticao = ListaParticao.replace("() ", "");

		return ListaParticao;
	}

	// m�todo para verificar se a particao � valida.
	public boolean VerificaParticao(int numero) 
	{
		for (int i = 1; i < numero; i++) 
		{
			boolean VerificaParticaoAuxiliar = false;

			for (int j = i - 1; j >= 0; j--) 
			{
				if (VetorParticao[i] > VetorParticao[j]) 
				{
					VerificaParticaoAuxiliar = VerificaParticaoAuxiliar
							|| ((VetorParticao[i] - VetorParticao[j]) <= 1);
				} else 
				{
					VerificaParticaoAuxiliar = true;
					break;
				}
			}
			if (!VerificaParticaoAuxiliar) 
			{
				return false;
			}
		}
		return true;
	}

	// p
	// faz a partic�o e chama o m�todo verificaPartic�o(int numero) para
	// verificar se a partic�o � v�lida.

	public void particiona(int numero, int posicao) 
	{
		if (posicao > numero) 
		{
			if (VerificaParticao(numero)) 
			{
				mostrar(numero);
			}
		} 
		else 
		{
			for (VetorParticao[posicao - 1] = 1; VetorParticao[posicao - 1] <= posicao; VetorParticao[posicao - 1]++) 
			{
				particiona(numero, posicao + 1);
			}
		}
	}

	public void mostrar(int numero) 
	{
		ListaParticao += "{";

		for (int i = 1; i <= numero; i++) 
		{
			ListaParticao += "(";
			for (int j = 0; j < numero; j++) 
			{
				if (VetorParticao[j] == i) 
				{
					ListaParticao += VetorOriginal[j] + " ";
				}
			}
			ListaParticao += ") ";
		}
		ListaParticao += "} ";
	}
}
