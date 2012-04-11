import ex1.*;
import ex2.*;
import ex3.*;

public class PrincipalHerPoli{
	public static void main(String[] args) {
		//------------ EXMPLO 1------------//
		Assistente adm = new Administrativo("Rodrigo Administrativo", 1000, 1, 'D', 100);
		Assistente tecnico = new Tecnico("Rodrigao", 100, 2, 50);

		adm.exibeDados();
		System.out.println("");
		tecnico.exibeDados();
		System.out.println("");
		//---------------------------------//
		
		//------------ EXMPLO 2------------//
// TEMPORARIAMENTE SUSPENSO o exemplo 2...
//		Cachorro cachorro = new Cachorro("Dogui");
//		Gato gato = new Gato("Keti");
//
//		cachorro.late();
//		gato.mia();
//		
//		cachorro.caminha();
//		gato.caminha();
		//---------------------------------//
		
		//------------ EXMPLO 3 ------------//
		Ingresso i;
		int tipo, localVIP;

		System.out.println("Criar ingresso:" +
							"\t 1- Normal (R$50)" +
							"\t 2- VIP (R$100)\n");
		
		// le do usuario
		tipo = 2;//...

		if(tipo == 1)
			i = new Normal(50);
		else
			i = new VIP(50, 50);

		System.out.println("Ingresso escolhido!");
		i.imprimeTipo();

		if(tipo == 2)
			System.out.println("Escolha local do ingresso:" +
					"\t 1- Camarote Superior" +
					"\t 2- Camarote Inferior\n");

		// le do usuario
		localVIP = 1; //...
			

		//---------------------------------//
	}
}