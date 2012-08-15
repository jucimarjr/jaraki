public class PrincipalHerPoli{
	public static void main(String[] args) {
		//------------ EXMPLO 1------------//
		//java:
		//Assistente adm = new Administrativo("Rodrigo Administrativo", 1000.0f, 1, 1, 100.0f);
		Assistente asstAdm = new Administrativo("Rodrigo Administrativo", 1000.0, 1, 1, 100.0);

		//java:
		//Assistente tecnico = new Tecnico("Rodrigao", 100.0f, 2, 50.0f);
		Assistente asstTecnico = new Tecnico("Rodrigao", 100.0, 2, 50.0);

		asstAdm.exibeDados();
		System.out.println("");
		asstTecnico.exibeDados();
		System.out.println("");
	}
}