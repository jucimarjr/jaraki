package Classes3;

public class Retangulo {
	int ladoA;
	int ladoB;

	public void mudarLadoA(int lado){
		ladoA = lado;
	}
	
	public void mudarLadoB(int lado){
		ladoB = lado;
	}
	
	public int calcularArea(){
		return ladoA * ladoB;
	}
	
	public int calcularPerimetro(){
		return ladoA*2 + ladoB*2;
	}
}
