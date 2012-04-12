package buscaBinaria;

public class BuscaBinaria
{

	public static int BuscaBinaria( int[] array, int valor )
	{
		int esquerda = 0;
		int direita = array.length - 1;
		int ValorMeio;
 
		while ( esquerda <= direita )
		{
			ValorMeio = esquerda + ((direita - esquerda) / 2);
    	    if ( array[ValorMeio] < valor )
			{
				esquerda = ValorMeio + 1;
			}
			else if ( array[ValorMeio] > valor )
			{
				direita = ValorMeio - 1;
			}
			else
			{
				return ValorMeio;
			}
		}

		return -1;
	}

	public static void main( String[] args )
	{
		int numero = 0;
		int[] lista = new int[100];

		for(int i=0; i<100; i++)
			lista[i] = i;

		numero = 120;
		
		System.out.println(BuscaBinaria(lista, numero));
		
	}

}
