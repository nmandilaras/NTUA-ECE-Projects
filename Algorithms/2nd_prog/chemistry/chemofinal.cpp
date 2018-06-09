#include<iostream>
#include<cstdio>
using namespace std;
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
//long long A[1500][1500];

int main(int argc, char *argv[])
{
	int N,K,min,**A,p;

    scanf("%d %d",&N,&K);
	if (K==N){
		printf("%d\n",0);
		return 0;			
	} 
	  
	int B[K][N];
	//if (N>=2000) printf("%d\n",B[2000][2000]); just for debugging the script 
	A = new int*[N];
	for(int i = 0; i <N; i++)
    	A[i] = new int[N];	
    /*	
	B = new int*[K];
	for(int i = 0; i <K; i++)
    	B[i] = new int[N];    	
    */
   	for(int i=0; i<N; i++){
   		A[i][i]=0;
   		for (int j=i+1; j<N; j++)
   			A[i][j]=readInt();	
   	}
	for (int j=2; j<N; j++)
   		for(int i=j-1; i>0; i--)
   			A[i-1][j]+=A[i][j];
   			
   	for(int i=0; i<N; i++)
   		for (int j=i+2; j<N; j++)
   			A[i][j]+=A[i][j-1];

	for(int i=0; i<K; i++)
		for(int j=0; j<=i; j++)
			B[i][j]=0;

	for(int j=1; j<N; j++)
		B[0][j]=A[0][j];	
	
	if (K==1){
	printf("%d\n",B[0][N-1]);
	return 0;			
	}
	p=N-K+1;		      			
	for(int i=1; i<K-1; i++)
   		for (int j=i+1; j<p+i; j++){
   			min=2147483647;
   			for(int l=i; l<j; l++)
   				min=std::min(min,B[i-1][l]+A[l+1][j]);
			B[i][j] = min;	   	
   		}
   	min=2147483647;
   	for(int l=K-1; l<N-1; l++)
   		min=std::min(min,B[K-2][l]+A[l+1][N-1]);	     		

	printf("%d\n",min);	
	return 0;		
}
