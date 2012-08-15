public class PrincipalHerPoli{
	public static void main(String[] args) {
		//------------ EXMPLO 1------------//
		//java:
		//Assistente adm = new Administrativo("Rodrigo Administrativo", 1000, 1, 'D', 100);
		//Administrativo adm = new Administrativo("Rodrigo Administrativo", 1000.0f, 1, 1, 100.0f);
		Administrativo adm = new Administrativo("Rodrigo Administrativo", 1000.0, 1, 1, 100.0);

		//java:
		//Assistente tecnico = new Tecnico("Rodrigao", 100, 2, 50);
		//Tecnico tecnico = new Tecnico("Rodrigao", 100.0f, 2, 50.0f);
		Tecnico tecnico = new Tecnico("Rodrigao", 100.0, 2, 50.0);

		adm.exibeDados();
		System.out.println("");
		tecnico.exibeDados();
		System.out.println("");
	}
}