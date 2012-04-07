public class Principal2 {
	public static void main(String args[]){
		Quadrado q = new Quadrado();

		q.mudarLado(10.0f);
		System.out.println("lado: " + q.getLado() + "m");
		System.out.println("area: " + q.calcArea() + "m^2");
	}
}