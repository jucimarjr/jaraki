class Animal {
	private String nome;
	private String raca;

	public Animal() {
		this.nome = "SemNome_='(";
		this.raca = "Viralata_=(";
	}

	public Animal(String nome) {
		this.nome = nome;
		this.raca = "Viralata_=(";
	}

	public void caminha() {
		System.out.println("Caminhei!!\n" + "Nome: " + nome);
	}
}