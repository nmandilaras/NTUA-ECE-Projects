#include<iostream>
#include<cstdio>
#include<climits>
#include<cmath>
using namespace std;

int main(int argc, char *argv[])
{
	int N,K,*A,**T,temp;
	FILE *f;
	
	f = fopen(argv[1],"r");	
	if(!f){
    	printf("Error opening file %d!",1);
    	return 1;
    }
    fscanf(f,"%d %d",&N,&K);
	getc ( f ); // in order to read \n
    A = new int[N];
    for (int i=0; i<N; i++){
    	fscanf(f,"%d",&A[i]);
    }
    fclose(f);
    
    T = new int*[K+1];
	for(int i = 0; i < K+1; i++)
    	T[i] = new int[N];    
    for (int j=0; j<N; j++) T[0][j]=0;
    for (int i=0; i<K+1; i++) T[i][0]=0;

    for (int i = 1; i < K+1; i++) {
        int maxDiff = -A[0]; // sketo meion ?
        for (int j = 1; j < N; j++) {
			T[i][j]=std::max(T[i][j-1], prices[j] + maxDiff);
            maxDiff = std::max(maxDiff,T[i-1][j] - A[j]); // h diafora gia ton epomeno gyro! 
        }
        delete T[i-1];
    }    
	printf("%d\n",T[K][N-1]);
	delete T[K]; 	
	delete T;			
	return 0;
			//maxDiff = (maxDiff<temp)?temp:maxDiff;		
}
