package arquivos;

import java.io.FileWriter;
import java.io.IOException;

public class Arquivos3 {
	
	public static void main(String[] args) throws IOException{
		
		FileWriter writer = new FileWriter("/home/josie/saida.txt", true);
		
		writer.write("testando o modo write");
		
		writer.close();
	}
}
