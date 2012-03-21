public class Quadrado {
	float lado;

	public void mudarLado(float lado) {
		this.lado = lado;
	}

	public float getLado(){
		return lado;
	}

	public float calcArea(){
		return lado*lado;
	}
}