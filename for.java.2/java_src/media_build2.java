package jaraki;



import jaraki.AlgumaCoisa;

import jaraki.core.*;



public class MediaUeaB2 {


    public static void main(String[] Args) {

            float n1;

            float n2;

            float n3;

            float media;

            float mediaFinal;

            

            n1 = 8;

            n2 = 7;

            n3 = 3;


            media = (n1 + n2)/2;

            mediaFinal = ((media * 2) + n3)/3 ;


            if (media < 4) {

                 System.out.print("Perdeu Preiboi! ");

                 System.out.println(media);

            }

            else {

                System.out.print("Aeeeeh ");

                System.out.println(media);

            }



            if (mediaFinal >= 8)

               System.out.print("To no IF de uma linha! Feel like a ninja! ");

            System.out.println(mediaFinal);

       }

}
