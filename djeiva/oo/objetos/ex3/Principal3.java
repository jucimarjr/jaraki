import java.util.Scanner;

class Principal3 {
	public static void main(String args[]){
		Scanner s = new Scanner(System.in);
		
		Retangulo r = new Retangulo();

		System.out.println("Informe as medidas do local: ");
		
		r.mudarLadoA(s.nextInt());
		r.mudarLadoB(s.nextInt());
		
		System.out.println("Rodapes necessarios: " + r.calcularPerimetro() + "m");
		System.out.println("Piso necessario: " + r.calcularArea() + "m^2");
	}
}
