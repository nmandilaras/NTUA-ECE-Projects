#define BSIZE 1<<15

char buffer[BSIZE];
int bpos = 0, bsize = 0;

int readInt() 
{
	int d = 0, x = 0;
	char c;

	while (1)  {
		if (bpos >= bsize) {
			bpos = 0;
			if (feof(stdin)) return x;
			bsize = fread(buffer, 1, BSIZE, stdin);
		}
		c = buffer[bpos++];
		if (c >= '0' && c <= '9') { x = x*10 + (c-'0'); d = 1; }
		else if (d == 1) return x;
	}
	return -1;
}

int main(){
	int n;
	for (int i=0; i<10; i++){
		n=readLong();
		printf("%d\n",n);
	}
	return 0;
}
