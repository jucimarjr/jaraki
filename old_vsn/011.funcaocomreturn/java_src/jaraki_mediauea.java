package mediauea;

public class Mediauea {
	
	public static void main(String[] Args) {

		float nota1, nota2, nota3, media;
		
        float mediaFinal;
		
		nota1 = 6;	nota2 = 6;	nota3 = 5;
				
		media = (nota1 + nota2)/2;
		mediaFinal = ((media * 2) + nota3)/3 ;
		
		if (media < 4) {
			System.out.print("Reprovado direto com: ");
			System.out.println(media);
		} else 
			if (media >= 8) {
				System.out.print("Aprovado direto com: ");
				System.out.println(media);
			} 
			else if (mediaFinal >= 6) {
					System.out.print("Aprovado na prova final com: ");
					System.out.println(mediaFinal);
				} 
				else {
					System.out.print("Reprovado na prova final com: ");
					System.out.println(mediaFinal);
				}		
	}
}
