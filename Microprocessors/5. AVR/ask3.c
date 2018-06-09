#include <avr/io.h>

int main ()
{
  SP = RAMEND;
  int outpt=0, inpt=0, s1=0, s2=0, past=0;
  // Set Port D bits as inputs
  DDRB = 0xff;
  PORTB=0x80;
  outpt = 0x80;
  DDRD = 0x00;
  inpt = PIND;
  while (1) {
	// mask bit 4 of current and past input
	s1 = inpt & 0x10;
	s2 = past & 0x10;
	if ((s2 - s1) == (0x10)) {
		outpt = 0x80;
		PORTB = outpt;
		past = inpt;
		inpt = PIND;
		continue;
	}
	// now mask bit 3...
	s1 = inpt & 0x08;
	s2 = past & 0x08;
	if ((s2 - s1) == (0x08)) {
		if (outpt <= 0b00100000)
			outpt = outpt * 4;
		else if (outpt == 0x40)
			outpt = 0x01;
		else
			outpt = 0x02;
		PORTB = outpt;
		past = inpt;
		inpt = PIND;
		continue;
	}
	// now mask bit 2...
	s1 = inpt & 0x04;
	s2 = past & 0x04;
	if ((s2 - s1) == (0x04)) {
		if (outpt >= 0b00000100)
			outpt = outpt / 4;
		else if (outpt == 0x02)
			outpt = 0x80;
		else
			outpt = 0x40;
		PORTB = outpt;
		past = inpt;
		inpt = PIND;
		continue;
	}
	// now mask bit 1...
	s1 = inpt & 0x02;
	s2 = past & 0x02;
	if ((s2 - s1) == (0x02)) {
		if (outpt <= 0b01000000)
			outpt = outpt * 2;
		else
			outpt = 0x01;
		PORTB = outpt;
		past = inpt;
		inpt = PIND;
		continue;
	}
	// now mask the LSB...
	s1 = inpt & 0x01;
	s2 = past & 0x01;
	if ((s2 - s1) == (0x01)) {
		if (outpt >= 0b00000010)
			outpt = outpt / 2;
		else
			outpt = 0x80;
		PORTB = outpt;
		past = inpt;
		inpt = PIND;
	}
  }
  return 0;
}
