import java.util.Scanner;

class Principal9 {
	public static void main(String[] args) {
		Retangulo r = new Retangulo();
		Scanner s = new Scanner(System.in);

		System.out.println("Digite os valores do retangulo");
		System.out.print("altura: ");
		r.altura = s.nextInt();
		System.out.print("largura: ");
		r.largura = s.nextInt();

		System.out.println("\nvertice inferior esquerdo: ");
		System.out.print("x: ");
		r.vertice.x = s.nextInt();
		System.out.print("y: ");
		r.vertice.y = s.nextInt();

		System.out.println("\nO centro do retangulo eh: ");
		r.getCentro().printPoint();
	}
}