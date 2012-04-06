package ex3;

class Ingresso {
	private float valor;

	public Ingresso(){
		super();
	}
	
	public Ingresso(float valor){
		this.valor = valor;
	}

	public float getValor() {
		return valor;
	}

	public void imprimeValor() {
		System.out.println("Valor: " + valor);
	}
}