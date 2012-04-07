import ex1.*;

public class PrincipalHerPoli{
	public static void main(String[] args) {
		Assistente adm = new Administrativo("Rodrigo Administrativo", 1000, 1, 'D', 100);
		Assistente tecnico = new Tecnico("Rodrigao", 100, 2, 50);

		adm.exibeDados();
		System.out.println("");
		tecnico.exibeDados();
	}
}