public class Bola {
	String cor;
	float c;
	String material;

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