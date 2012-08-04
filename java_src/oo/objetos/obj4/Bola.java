public class Bola {
	String cor;
	float c;
	String material;

	int teste;

	public Bola(float c, String cor) {
		this.c = c;
		this.cor = cor;
	}

	public void circ(float c) {
		this.c = c;
	}

	public void trocaCor1(String cor) {
		this.cor = cor;
	}

	public void trocaCor2(String cor2) {
		cor = cor2;
		cor2 = "cor2 diferente de cor";
		System.out.println("cor2: \"" + cor2 + "\"");
	}

	public void mostraCor() {
		System.out.println("Cor: " + cor);
	}
}