package ex3;

class VIP extends Ingresso {
	private float adicional;

	public VIP() {
		super();
	}
	
	public VIP(float valor, float adicional) {
		super(valor);
		this.adicional = adicional;
	}

	public float getValor(){
		return super.getValor() + adicional;
	}
}