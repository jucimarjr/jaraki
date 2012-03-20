package arquivos;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class Arquivos2 {

	public static void main(String[] args) throws IOException{
		
		float media;
		String linha, nota1, nota2, nomeAluno;
		int qtdAlunos;
		
		BufferedReader arq = null;
 
    
		try{
			arq = new BufferedReader(new FileReader("/home/josie/arquivos2.txt"));
		}catch (FileNotFoundException fnfe) {  
			System.out.println("O arquivo não foi encontrado");  
			System.exit(1);  
		}
	
		linha = arq.readLine();	
		qtdAlunos = Integer.parseInt(linha);
		
		System.out.println("A quantidade de alunos é:" + qtdAlunos);
		
		System.out.println("alunos com media menor que 7:");
		for(int i = 0; i < qtdAlunos; i++){
			nomeAluno = arq.readLine();
			nota1 = arq.readLine();
			nota2 = arq.readLine();
			media = (Float.parseFloat(nota1) + Float.parseFloat(nota2))/2;
			
			if(media < 7){
				System.out.println(nomeAluno);
			}
			
		}
		
		arq.close();
	}
}

