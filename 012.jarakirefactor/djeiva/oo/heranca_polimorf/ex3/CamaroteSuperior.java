package ex3;

class CamaroteSuperior extends VIP {
	private float adicional;

	public float getValor() {
		return super.getValor() + adicional;
	}
}