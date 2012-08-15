public class Assistente extends Funcionario {
	int matricula;

	public Assistente(String nome, float salario, int matricula) {
		this.nome = nome;
		this.salario = salario;
		this.matricula = matricula;
	}

	public int getMatricula() {
		return matricula;
	}

	public void exibeDados() {
		//java:
		//super.exibeDados();

		System.out.println("======== DADOS ========");
		System.out.println("Nome: " + nome);
		System.out.println("Salario: " + salario);
		//-----------------------------------------------

		System.out.println("Matricula: " + matricula);
	}
}