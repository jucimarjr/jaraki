package mediauea;

import jaraki.AlgumaCoisa;

public class Mediauea {
	
	public static void main(String[] Args) {
		float n1;
		float n2;
		float n3;

		float media;
		float mediaFinal;

		n1 = 1;
		n2 = 6;
		n3 = 3;
				
		media = (n1 + n2)/2;
		mediaFinal = ((media * 2) + n3)/3 ;
		
		if (media < 4) {
			System.out.print("Reprovado direto com: ");
			System.out.println(media);
		}	
       }
}
