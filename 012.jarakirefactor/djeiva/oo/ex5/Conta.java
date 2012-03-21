public class Conta {
	int numero;
	String nome;
	float saldo;

	public Conta(int numero, String nome){
		this.numero = numero;
		this.nome = nome;
		this.saldo = 0.0f;
	}

	public Conta(int numero, String nome, float saldo){
		this.numero = numero;
		this.nome = nome;
		this.saldo = saldo;
	}

	public void alterarNome(String nome ) {
		this.nome = nome;
	}

	public void deposito(float quantia){
		saldo = saldo + quantia;
	}

	public void saque(float quantia){
		saldo = saldo - quantia;
	}
}