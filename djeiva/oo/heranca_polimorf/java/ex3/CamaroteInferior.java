package ex3;

public class CamaroteInferior extends VIP {
	private char localizacao;

	public CamaroteInferior(float valor, float adicional){
		super(valor, adicional);
	}

	public char getLocalizacao() {
		return localizacao;
	}

	public void imprimeLocalizacao() {
		System.out.println("Localizacao: " + localizacao);
	}
}