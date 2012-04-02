package ex1;

// bonus salarial
public class Tecnico extends Assistente {
	float bonusSalarial;

	public void exibeDados() {
		super.exibeDados();
		System.out.println("Salario + bonus: " + (salario + bonusSalarial));
	}
}