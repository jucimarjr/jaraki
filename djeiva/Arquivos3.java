

import java.io.FileWriter;
import java.io.FileReader;
import java.io.IOException;

public class Arquivos3 {
	
	public static void main(String[] args) throws IOException{
		
		int caracter;

		FileReader	arq = new FileReader("/home/pec/teste.txt");
		
		FileWriter writer = new FileWriter("/home/pec/saida.txt", true);
		
		caracter = arq.read();		

		writer.write(caracter);

		arq.close();
		
		writer.close();
	}
}
