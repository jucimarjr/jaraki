class Retangulo {
	int altura;
	int largura;
	Ponto vertice = new Ponto(); // vertice inferior esquerdo

	public Ponto getCentro() {
		Ponto centro = new Ponto();
		centro.x = vertice.x + largura/2;
		centro.y = vertice.y + altura/2;
		return centro;
	}
}