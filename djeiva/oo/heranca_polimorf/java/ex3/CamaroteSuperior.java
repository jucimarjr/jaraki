package ex3;

public class CamaroteSuperior extends VIP {
	private float adicional;

	public CamaroteSuperior(float valor, float adicional){
		super(valor, adicional);
	}
	public float getValor() {
		return super.getValor() + adicional;
	}
}