public class TestandoWhile8{

	public static void main(String[] args) {

	int i;
	i = 1;

	int j;
	j = 1;

	while(i < 10) {

		System.out.println("1 - Estou dentro do 1o while!!" + i);

		while(j < 10) {

			System.out.println("2 - Estou dentro do 2o while!!" + j);
			j++;
		}
		
		i++;
	}

    }

}

