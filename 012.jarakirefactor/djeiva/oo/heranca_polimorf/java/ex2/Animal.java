package ex2;

public class Animal {
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

	public Animal(String nome, String raca) {
		this.nome = nome;
		this.raca = raca;
	}
	
	public void caminha() {
		System.out.println(nome + " diz: Caminhei!!");
	}
}