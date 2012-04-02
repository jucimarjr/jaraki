class Assistente extends Funcionario {
	int matricula;

	public int getMatricula() {
		return matricula;
	}

	public void exibeDados() {
		super.exibeDados();
		System.out.println("Matricula: " + matricula);
	}
}