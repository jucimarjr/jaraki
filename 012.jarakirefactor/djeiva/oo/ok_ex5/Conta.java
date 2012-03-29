class Conta {
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

	public void alterarNome(String nome) {
		this.nome = nome;
	}

	public void depositar(float quantia){
		saldo = saldo + quantia;
	}

	public void sacar(float quantia){
		saldo = saldo - quantia;
	}
}