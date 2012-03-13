public class Testandowhile6{
  public static void main(String[] args){
    
        int anterior;
	anterior = 0;  

        int proximo;
	proximo = 1;

        int temp;
	temp = 0;

        int n;
	n = 10;

	int i;
	i = 1;

    while(i <= n){

	System.out.print(anterior);

	System.out.print(", ");

	temp = anterior;

	anterior = proximo;

	proximo = temp + proximo;
	
	i++;	
    } 
  }
}
