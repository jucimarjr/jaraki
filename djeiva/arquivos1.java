package arquivos;

package arquivos;


import java.io.FileReader;
import java.io.IOException;

public class Arquivos1 {
	
	public static void main(String[] args) throws IOException{
    
		int caracter;
		int counter = 0;
		FileReader	arq = new FileReader("/home/josie/teste.txt");
				
    	
		caracter = arq.read();
    
		while(!(caracter == -1)){    		
			//if(caracter != ' '){
				counter ++;
			//}		
			caracter = arq.read();
		}
     
		//arq.close();
		System.out.println("O numero de caracteres do arquivo é:" + counter);
    
	}
}


