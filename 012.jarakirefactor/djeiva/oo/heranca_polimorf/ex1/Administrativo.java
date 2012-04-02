package ex1;

// turno e adicional noturno
public class Administrativo extends Assistente {
	char turno; // D - dia, N - noite
	float adicionalNoturno;

	public Administrativo(String nome, float salario, int matricula, char turno, float adicionalNoturno) {
		this.nome = nome;
		this.salario = salario;
		this.matricula = matricula;
		this.turno = turno;
		this.adicionalNoturno = adicionalNoturno;
	}

	public void exibeDados() {
		super.exibeDados();
		String turnoExtenso;
		float salarioTotal = 0.0f;

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