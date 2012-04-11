package ex3;

public class Ingresso {
	private float valor;
	private String tipo;

	public Ingresso(float valor, String tipo){
		this.valor = valor;
		this.tipo = tipo;
	}

	public float getValor() {
		return valor;
	}

	public void imprimeValor() {
		System.out.println("Valor: " + valor);
	}

	public void imprimeTipo() {
		System.out.println("Tipo do ingresso " + tipo);
	}
}