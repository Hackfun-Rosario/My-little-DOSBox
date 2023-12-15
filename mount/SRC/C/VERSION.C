#include <stdio.h>
#include <dos.h>

union REGS inregs, outregs;
float dosversion(void);

int main(void)
{
	printf("Your system is running MS-DOS version %.1f", dosversion());
}

float dosversion(void)
{

	inregs.h.ah = 0x30;
	intdos(&inregs, &outregs);
	return (outregs.h.al + outregs.h.ah / 100.0);
}

