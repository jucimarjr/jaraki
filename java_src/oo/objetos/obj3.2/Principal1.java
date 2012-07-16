public class Principal1 {
	public static void main(String args[]){
		Bola b = new Bola();

		b.c = 10.0;

		System.out.println("Teste circunferencia: " + b.c);

		b.trocaCor1("rosa");
		b.mostraCor();

		b.trocaCor2("azul");
		b.mostraCor();

		b.trocaCor2("preto");
		b.mostraCor();
	}
}