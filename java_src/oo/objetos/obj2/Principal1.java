public class Principal1 {
	public static void main(String args[]){
		Bola b = new Bola();

		b.cor = "azul";
		b.circunferencia = 1.4;
		b.material = "papel";

		b.circunferencia = b.circunferencia * 2;

		System.out.println(b.cor);
		System.out.println(b.circunferencia);
		System.out.println(b.material);
	}
}