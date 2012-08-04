public class Principal1 {
	public static void main(String args[]){
		Bola b = new Bola();

		b.c = 10.0;

		System.out.println("Teste circunferencia: " + b.c);

		b.circ(1.0);
		System.out.println("Teste circunferencia2: " + b.c);

		b.trocaCor1("rosa");
		b.mostraCor();

		b.trocaCor2("azul");
		b.mostraCor();

		b.trocaCor2("preto");
		b.mostraCor();


		Bola b2 = new Bola(5.0, "opaaasa");
		System.out.println("circunferencia:  " + b2.c);
		System.out.println("cor: " + b2.cor);
	}
}