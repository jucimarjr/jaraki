public class Particao 
{


	// metodo para particionar o numero passado.
	public static void particionar(int numero, int[] VetorOriginal, int[] VetorParticao, String ListaParticao) 
	{
		

		for (int contador = 0; contador < numero; contador++) 
		{
			VetorOriginal[contador] = contador + 1;
		}
		particiona(numero, 1, ListaParticao, VetorOriginal, VetorParticao);
	}

	// metodo para verificar se a particao e valida.
	public static boolean VerificaParticao(int numero, int[] VetorParticao) 
	{
		for (int i = 1; i < numero; i++) 
		{
			boolean VerificaParticaoAuxiliar = false;

			for (int j = i - 1; j >= 0; j--) 
			{
				if (VetorParticao[i] > VetorParticao[j]) 
				{
					VerificaParticaoAuxiliar = VerificaParticaoAuxiliar || ((VetorParticao[i] - VetorParticao[j]) <= 1);
				}
				else 
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
	// faz a particao e chama o metodo verificaParticao(int numero) para
	// verificar se a particao e valida.

	public static void particiona(int numero, int posicao, String ListaParticao, int[] VetorOriginal, int[] VetorParticao) 
	{
		if (posicao > numero) 
		{
			if (VerificaParticao(numero, VetorParticao)) 
			{
				mostrar(numero, ListaParticao, VetorOriginal, VetorParticao);
			}
		} 
		else 
		{
			for (VetorParticao[posicao - 1] = 1; VetorParticao[posicao - 1] <= posicao; VetorParticao[posicao - 1]++) 
			{
				particiona(numero, posicao + 1, ListaParticao, VetorOriginal, VetorParticao);
			}
		}
	}

	public static void mostrar(int numero, String ListaParticao, int[] VetorOriginal, int[] VetorParticao) 
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
		
		System.out.println(ListaParticao);
	}

	public static void main(String[] args)
	{
		int numero = 5;

		int[] VetorParticao = new int[numero];

		int[] VetorOriginal = new int[numero];

		String ListaParticao = new String();

		particionar(numero, VetorOriginal, VetorParticao, ListaParticao);
	}
}
