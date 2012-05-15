public class Ferramentas {
	public static void printAreaRet(int x, int y){
		int area;

		area = calcAreaRet(x, y);

		System.out.println("Print area: " + area);
	}

	public static int calcAreaRet(int x, int y){
		int area = x*y;

		return area;
	}
}