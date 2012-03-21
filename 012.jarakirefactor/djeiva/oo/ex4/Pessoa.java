public class Pessoa {
	String nome = new String();
	int idade;
	float peso;
	float altura;

	public void envelhecer(int anos) {
		if(idade < 21)
			altura = altura + 0.5f;

		idade = idade + anos;
	}

	public void engordar(int peso) {
		this.peso = this.peso + peso;
	}

	public void crescer(int comprimento) {
		altura = altura + comprimento;
	}
}