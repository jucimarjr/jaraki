
public class FiboRecursivo {
	
	public static int fibo(int n) {  
        int f;
        f = 0;
	if(n == 0)
        	f = 0;
        else if (n == 1)
        	f = 1;
        else if (n > 1)
        	f = fibo(n-1) + fibo(n-2);
        return f;	
       }
	
	public static void main(String[] args) {
		int a, n;
		n = 100;
		
		for(int i = 0; i < n; i++){		
			a = fibo(i);			
			System.out.println(a);	
		}
	} 
}
