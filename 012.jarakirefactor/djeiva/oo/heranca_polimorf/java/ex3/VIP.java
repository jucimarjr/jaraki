package ex3;

public class VIP extends Ingresso {
	private float adicional;

	public VIP(float valor, float adicional) {
		super(valor, "VIP");
		this.adicional = adicional;
	}

	public float getValor(){
		return super.getValor() + adicional;
	}
}