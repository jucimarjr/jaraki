public class Bola {
	String cor;
	float c;
	String material;

	public void trocaCor(String cor2) {
		// this.cor = cor;
		cor = cor2;
		cor2 = "cor2 diferente de cor";
		System.out.println("cor2: \"" + "\"");
	}

	public void mostraCor() {
		System.out.println("Cor: " + cor);
	}
}