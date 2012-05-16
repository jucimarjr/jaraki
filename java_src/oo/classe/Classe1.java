public class Classe1 {
	public static void calcAreaRet2(int x, int y){
		Ferramentas.printAreaRet(x, y);
	}

	public static void main(String[] args){
		int area;

		Ferramentas.printAreaRet(4, 3);

		area = Ferramentas.calcAreaRet(2, 3);

		System.out.println("calc area: " + area);
	}
}