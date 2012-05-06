package ex1;

// bonus salarial
public class Tecnico extends Assistente {
	float bonusSalarial;

	public Tecnico(String nome, float salario, int matricula, float bonusSalarial) {
		super(nome, salario, matricula);
		this.bonusSalarial = bonusSalarial;
	}

	public void exibeDados() {
		super.exibeDados();
		System.out.println("Salario + bonus: " + (salario + bonusSalarial));
	}
}