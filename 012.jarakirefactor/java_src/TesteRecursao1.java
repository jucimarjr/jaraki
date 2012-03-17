
public class TesteRecursao1 {
	
	public static int fibo(int n) {  
        int f;
        f = 0;
		if(n == 0)
        	return 0;
        else if (n == 1)
        	return 1;
        else if (n > 1)
        	f = fibo(n-1) + fibo(n-2);
        	return f;	
       }
	
	public static void main(String[] args) {
		int n = 10;
		int a;
		a = fibo(n-1);
		System.out.print(a);	
	} 
}