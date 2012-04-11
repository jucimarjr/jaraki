package buscaSequencial;

public class BuscaSequencial {

	public static int buscaSequencial( int chave, int vetor[] ) {
		for (int i = 0; i < vetor.length; i++) {
			if (vetor[i] == chave) {
				return i;
			}
		}
		return -1;
	}
	public static void main(String[] args) {

		int vetor[] = {5,9,20,3};
		int chave = 0;
		System.out.println(buscaSequencial(chave, vetor));
	}

}
