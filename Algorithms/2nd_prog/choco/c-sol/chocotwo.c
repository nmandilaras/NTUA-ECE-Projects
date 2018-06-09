#include<stdio.h>
#include<stdlib.h>
#include <math.h>

int* T[1001];	

int main(int argc, char *argv[])
{
	int N,K,*A,temp;
	FILE *f;
	
	f = fopen(argv[1],"r");	
	if(!f){
    	printf("Error opening file %d!",1);
    	return 1;
    }
    fscanf(f,"%d %d",&N,&K);
	getc ( f ); // in order to read \n
    A = (int*)malloc(N*sizeof(int));
    for (int i=0; i<N; i++){
    	fscanf(f,"%d",&A[i]);
    }
    fclose(f);
    
    //T = (int**)malloc((K+1)*sizeof(int*));
	for(int i = 0; i < K+1; i++)
    	T[i] =(int*)malloc(N*sizeof(int));    
    for (int j=0; j<N; j++) T[0][j]=0;
    for (int i=0; i<K+1; i++) T[i][0]=0;

    for (int i = 1; i <= K; i++) {
        int maxDiff = -100000; // sketo meion ?
        for (int j = 1; j < N; j++) {
			temp = T[i-1][j-1] - A[j-1];
			maxDiff = (maxDiff<temp)?temp:maxDiff;        	
        	temp = A[j]+maxDiff;
			T[i][j]=(T[i][j-1]<temp)?temp:T[i][j-1];
            //maxDiff = std::max(maxDiff,temp); // h diafora gia ton epomeno gyro! 
        }
        free(T[i-1]);
    }    
	printf("%d\n",T[K][N-1]);
/*	free(T[K]); 	
	free(T);	*/		
	return 0;		
}
