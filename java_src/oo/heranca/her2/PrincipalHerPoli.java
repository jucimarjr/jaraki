public class PrincipalHerPoli{
	public static void main(String[] args) {
		// exemplo 1 - heranca de campos
		Assistente asst = new Assistente();
		asst.fala(2);

		asst.nome = "Rodrigo";
		asst.diz_nome();

		//------------ EXMPLO 1------------//
		// Assistente adm = new Administrativo("Rodrigo Administrativo", 1000, 1, 'D', 100);
		// Assistente tecnico = new Tecnico("Rodrigao", 100, 2, 50);

		// adm.exibeDados();
		// System.out.println("");
		// tecnico.exibeDados();
		// System.out.println("");
	}
}