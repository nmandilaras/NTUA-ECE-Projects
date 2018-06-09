#include <avr/io.h>

int main(){
	SP=RAMEND;
	DDRB=0xFF;
	DDRD=0x00;
	
	int output=0x80;	// aristero LED anoixto
	PORTB=output;

	int input,prevnoe;
	input = PIND;
	prevnoe = input;
   while(1) {

	if (prevnoe != input ) {
		

	input &= 0x1F;		// kratame ta 5 deksiotera psifia
	if ((prevnoe >> 4) == 1 && (input >> 4) == 0)	// gia to SW4
		output=0x80;
	else if ((((prevnoe >> 3) & 0x01) == 1) && (((input >> 3) & 0x01) == 0) )	// gia to SW3
		if (output==0x80) 
			output=0x02;
		else if (output == 0x40)
			output = 0x01;
		else 
			output <<= 2;
	else if ((((prevnoe >> 2) & 0x01) == 1) && (((input >> 2) & 0x01) == 0))  	// gia to SW2
		if (output == 0x02)
			output = 0x80;
		else if (output == 0x01)
			output = 0x40;
		else 
			output >>= 2;
	else if ((((prevnoe >> 1) & 0x01) == 1) && (((input >> 1) & 0x01) == 0))	// gia to SW1	
		if (output == 0x80)
			output = 0x01;
		else 
			output <<= 1;
	else if ((((prevnoe) & 0x01) == 1) && (((input) & 0x01) == 0))		// gia to SW0	
		if (output == 0x01)
			output = 0x80;
		else 
	
			output >>= 1;
	
	}  
	  PORTB=output;
	prevnoe=input;
	input = PIND;
	}
	return 0;
}