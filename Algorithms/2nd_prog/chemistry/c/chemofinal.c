#include <stdio.h>
#include <stdlib.h>
/* run this program using the console pauser or add your own getch, system("pause") or input loop */
void m(long long int a,long long int b,long long int i,long long int j,long long int *A){
	if(a==-1){
		A[0]=b;
		A[1]=j;
	}
	else if(b==-1){
			A[0]=a;
			A[1]=i;
		}
	else if(a>b){
				A[0]=b;
				A[1]=j;
			}
	else{
				A[0]=a;
				A[1]=i;
	}
}
	

long long int cost(int j, int i,long long int **S){
	if(j==0) return S[i-1][i];
	else return S[i-1][i]-S[j-1][i];
}
int mini(int a,int b){
	if(a>=b) return b;
	else return a;
}
void slope(int s,int f,long long int **E,int start,int finish,int l,long long int **S){
	int q=(f+s)/2,j;
	int i=q;
	int x=mini(finish,i-1);
	if(start<=x){
		long long int min[2]={-1,-1};
		if(s<f){
			for(j=start; (j<=x); j++) m(min[0],((E[j][l-1]+cost(j+1,i,S)+1)*(E[j][l-1]!=-1))-1,min[1],j,min);
			E[q][l]=min[0];
			//ta s,q - q,f exoun allazei arketes fores
			slope(s,q-1,E,start,(int)min[1],l,S);
			slope(q+1,f,E,(int)min[1],finish,l,S);
		}
		else{
			//dokimase kai to f-s>1
			if(s==f){
				for(j=start; (j<=x); j++) m(min[0],((E[j][l-1]+cost(j+1,i,S)+1)*(E[j][l-1]!=-1))-1,min[1],j,min);
				E[q][l]=min[0];
			}
		}	
	}
}
int main(int argc, char *argv[]) {
	int u,i,j,N,K;
	long long int **E, **A, **S;
	int d;
	scanf("%d %d",&N,&K);
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
		if (( E[i] = malloc( (u)*sizeof(long long int))) == NULL ){
		printf("Cannot allocate memory-> check memory settings\n");
		}
		A[i][i]=0;
		if(i==0){
			S[0][0]=0;
			for(j=1; j<N; j++){
				scanf("%d", &d);
				A[i][j]=d;
				if(j==1) S[i][j]=A[i][j];			
				else S[0][j]=S[0][j-1]+A[0][j];		
			}
		}
		else{
			S[i][i]=0;
			for(j=i+1; j<N; j++){
				scanf("%d", &d);
				A[i][j]=d;
				if(j==i+1) S[i][i+1]=S[i-1][j]+A[i][j];
				else S[i][j]=S[i][j-1]-S[i-1][j-1]+S[i-1][j]+A[i][j];			
			}
		}
	}
	for(i=0; i<N; i++){
		for(j=i+1; j<N; j++){
			A[j][i]=A[i][j];
			S[j][i]=S[i][j];
		}
	}
	K=u;
	int l;
	///dp starting ----
	E[0][0]=0;
	for(i=1; i<N; i++) E[i][0]=cost(0,i,S);
	for(l=1; l<=K-1; l++){
		for(i=0; i<=l; i++) E[i][l]=0;
		slope(l+1,N-1,E,0,N-1,l,S);
	}
	///dp ending ----
	long long int result=E[N-1][K-1];
	///dp ending -----
	printf("%lld\n",result);
	return 0;
}
