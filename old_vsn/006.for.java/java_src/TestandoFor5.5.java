package testandoFor55;

public class TestandoFor55 {
    public static void main(String[] Args) {

        int n = 5;

        int x = 0;

        int y = 0;

        for (int i=0; i <= n; i++) {

            x = x + i;

            for (int j=0; j <= n; j++) 

                y = x + j;

        }

        System.out.println(x);

        System.out.println(y);

    }
}
