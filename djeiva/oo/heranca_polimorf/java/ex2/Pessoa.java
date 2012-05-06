package ex2;

class Pessoa {
	private String nome;
	private int idade;

	public Pessoa() {
		this.nome = "Pessoa sem nome";
	}

	public Pessoa(String nome){
		this.nome = nome;
	}

	public int getIdade() {
		return idade;
	}

	public String getNome() {
		return nome;
	}
}