class Principal5 {
	public static void main(String args[]) {
		Conta c = new Conta(1345, "Rodrigo");

		System.out.println("Numero: " + c.numero);
		System.out.println("Nome: " + c.nome);
		System.out.println("Saldo: " + c.saldo);

		System.out.println("\nalterando...\n");
		c.alterarNome("Rodrigo Bernardino");
		c.depositar(1000f);
		c.sacar(100f);

		System.out.println("Numero: " + c.numero);
		System.out.println("Nome: " + c.nome);
		System.out.println("Saldo: " + c.saldo);
	}
}