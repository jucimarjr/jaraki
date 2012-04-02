// turno e adicional noturno
class Administrativo extends Assistente {
	char turno; // D - dia, N - noite
	float adicionalNoturno;

	public void exibeDados() {
		super.exibeDados();
		String turnoExtenso;
		float salarioTotal;

		if(turno == 'D') {
			turnoExtenso = "diurno";
		}else {
			salarioTotal = salario + adicionalNoturno;
			turnoExtenso = "noturno";
		}

		System.out.println("Turno: " + turnoExtenso);

		if(turno == 'N')
			System.out.println("Salario + adicional noturno: " + salarioTotal);
	}
}