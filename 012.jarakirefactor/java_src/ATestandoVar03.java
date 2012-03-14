
public class TestandoVar {

	public static float foo(float x, float y){
		float r;
		
		r = ( x + y )/2;
		
		return r;
	}
	
	public static void main(String[] args) {
		float a;
		float b;
		boolean d;
		
		a = 10;
		
		b = 5;
		
		d = foo(a,b);
		
		System.out.println(d);
		
	}

}
