public class Principal {

	public static void main(String args[]){
		Pessoa p = new Pessoa();

		printPessoa(p);

		System.out.println("Alterando valores...");

		p.envelhecer(1);
		p.engordar(3);
		p.crescer(2);

		printPessoa(p);
	}

	public static void printPessoa(Pessoa p) {
		System.out.println("Nome: " + p.nome);
		System.out.println("Idade: " + p.idade);
		System.out.println("Peso: " + p.peso);
		System.out.println("Altura: " + p.altura);
	}
}