package testandoFor45;

public class TestandoFor45 {
    public static void main(String[] Args) {

        int n;
		n = 5;

        for (int i=0; i <= n; i++) {

            System.out.print("Estou contando dentro o for :D ");

            System.out.println(i);

            for (int j=0; j <= n; j++) {

                System.out.print("Estou contando dentro do 2o for :D ");

                System.out.println(j);
            }
        }
    }
}
