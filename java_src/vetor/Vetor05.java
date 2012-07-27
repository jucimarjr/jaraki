package vetor;

public class Vetor05 {
	public static void main(String[] args) {
		int[] vet = { 1, 2, 3, 4, 5 };
		int total;
		total = 0;

		for (int i = 0; i < 5; i++)
			total = vet[i] + total + vet[1];

		System.out.println(total);
	}
}
