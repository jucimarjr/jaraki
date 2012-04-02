// bonus salarial
class Tecnico extends Assistente {
	float bonusSalarial;

	public void exibeDados() {
		super.exibeDados();
		System.out.println("Salario + bonus: " + (salario + bonusSalarial));
	}
}