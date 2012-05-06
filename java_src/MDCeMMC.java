package mdcemmc;

public class MDCeMMC
{

	public static void main(String[] args)
	{
		int x, y, mdc,mmc;
		mdc = 0; 
		x = 2; 
		y = 9;
		for (int contador = 1; contador <= x; contador++)
		{
			if ((x % contador == 0) && (y % contador == 0))
				mdc = contador;
		}
		mmc = (x * y)/mdc;
		System.out.println("MDC(" + x + "," + y + ") = " + mdc);
		System.out.println("MMC(" + x + "," + y + ") = " + mmc);
		
	 }
}
