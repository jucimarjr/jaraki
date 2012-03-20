package vetor;

public class vetor4 {
	// 4. Faça um Programa que leia um vetor de 10 caracteres, 
	//e diga quantas consoantes foram lidas. Imprima as consoantes. 
	public static void main(String[] args) {
		char[] vet = {'a','b','c', 'd', 'e','f','g','h','i','j'};
		int count = 0;

		
		for(int i=0; i < vet.length; i++){
			if((vet[i] != 'a') && (vet[i] != 'e') && (vet[i] != 'i') &&
					(vet[i] != 'o') && (vet[i] != 'u')){
					count = count + 1;
					System.out.println(vet[i]);
			}
		}
		
		System.out.print("Número de Consoantes: ");
		System.out.print(count);
		
	}
}
