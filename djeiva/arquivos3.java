package arquivos;

import java.io.FileWriter;
import java.io.IOException;

public class Arquivos3 {
	
	public static void main(String[] args) throws IOException{
		
		int caracter;
		int counter = 0;
		FileReader	arq = new FileReader("/home/josie/teste.txt");
		
		FileWriter writer = new FileWriter("/home/josie/saida.txt", true);
		
		caracter = arq.read();		

		writer.write(caracter);

		//arq.close();
		
		//writer.close();
	}
}
