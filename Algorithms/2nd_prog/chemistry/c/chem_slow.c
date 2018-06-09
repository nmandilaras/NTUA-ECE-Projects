#include <stdio.h>
#include <stdlib.h>
/* run this program using the console pauser or add your own getch, system("pause") or input loop */
int m(int a,int b){
	if(a==-1) return b;
	else if(b==-1) return a;
	else if(a>b) return b;
	else return a;
}

long long int cost(int j, int i,long long int **S){
	if(j==0) return S[i-1][i];
	else return S[i-1][i]-S[j-1][i];
}

int main(int argc, char *argv[]) {
	int u,i,j,N,K,d;
	long long int **E,**A,**S;
	FILE *f;
	
	f = fopen(argv[1],"r");	
	if(!f){
    	printf("Error opening file %d!",1);
    	return 1;
    }
    fscanf(f,"%d %d",&N,&K);
	u=K;
	
	if (( A = malloc( N*sizeof(long long int* ))) == NULL ){
	 	printf("Cannot allocate memory-> check memory settings\n");
	}
	if (( S = malloc( N*sizeof(long long int* ))) == NULL ){
		printf("Cannot allocate memory-> check memory settings\n");
	}	
	if (( E = malloc( N*sizeof(long long int* ))) == NULL ){
		printf("Cannot allocate memory-> check memory settings\n");
	}
	for(i=0; i<N; i++){
		if (( A[i] = malloc( N*sizeof(long long int) )) == NULL ){
			printf("Cannot allocate memory-> check memory settings\n");
		}
		if (( S[i] = malloc( N*sizeof(long long int))) == NULL ){
			printf("Cannot allocate memory-> check memory settings\n");
		}
		if (( E[i] = malloc( u*sizeof(long long int))) == NULL ){
		printf("Cannot allocate memory-> check memory settings\n");
		}
		A[i][i]=0;
		if(i==0){
			S[0][0]=0;
			for(j=1; j<N; j++){
				fscanf(f,"%d",&d);
				A[i][j]=d;
				if(j==1) S[i][j]=A[i][j];			
				else	S[0][j]=S[0][j-1]+A[0][j];			
			}
		}
		else{
			S[i][i]=0;
			for(j=i+1; j<N; j++){
				fscanf(f,"%d",&d);
				A[i][j]=d;
				if(j==i+1) S[i][i+1]=S[i-1][j]+A[i][j];
				else S[i][j]=S[i][j-1]-S[i-1][j-1]+S[i-1][j]+A[i][j];			
			}
		}
	}
   	fclose(f);	
	for(i=0; i<N; i++){
		for(j=i+1; j<N; j++){
			A[j][i]=A[i][j];
			S[j][i]=S[i][j];
		}
	}
	K=u;
	long long int min;
	int l;
	///dp starting ----
	E[0][0]=0;
	for(i=1; i<N; i++){
		E[i][0]=cost(0,i,S);
	}
	for(l=1; l<K; l++){
		for(i=0; i<N; i++){
			if(i<=l) E[i][l]=0;
			else{
				min=-1;
				for(j=0; j<i; j++) min=m(min,((E[j][l-1]+cost(j+1,i,S)+1)*(E[j][l-1]!=-1))-1);
				E[i][l]=min;
			}
		}
	}
	///dp ending ----
	l=0;
	long long int result=E[N-1][K-1];
	///dp ending -----
	printf("%lld\n",result);
	return 0;
}
