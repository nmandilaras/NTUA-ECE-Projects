#include<stdio.h>
#include<stdlib.h>
#include <math.h>

unsigned long long binarySearch(unsigned long long *b,int *a,unsigned  long long L,unsigned long long K,int N) { // first stage we return only time in which K was served
	unsigned long long safe=0,sum,safeSum=0,up = L-1, mid,low=0;
	while (low <= up) {
		mid = (low + up) / 2;
		sum=0;
		for (int i=0; i<N; i++)
			sum += b[mid]/a[i] + 1 ;
			if ( sum == K ){
				for(int i=N-1; i>=0; i--)
					if (b[mid]%a[i]==0)	{
						b[mid] += a[i];
						printf("%d ",i+1);
						break;
					}	
				return(b[mid]);
		}
		else if (sum >= K+N) up = mid - 1;
		else if (sum < K) low = mid + 1;
		else {
//			printf("3 "); 
			up = mid -1;
			safe = mid;
			safeSum = sum; 
		} 
	}
//	printf("2 ");
	for(int i=N-1; i>=0; i--)
		if (b[safe]%a[i]==0 && safeSum > K)	safeSum--;
		else if (b[safe]%a[i]==0){
				b[safe] += a[i];
				printf("%d ",i+1);
				break;
		}			
	return b[safe]; 
}

int main(int argc, char *argv[])
{
	int N,*a,min = 100000,max = 0;
	unsigned long long maxBound,minBound,L,*b,pace,temp,K;
	FILE *f;
	
	f = fopen(argv[1],"r");	
	if(!f){
    	printf("Error opening file %d!",1);
    	return 1;
    }
    fscanf(f,"%d %llu",&N,&K);  
    getc ( f ); // in order to read newline
    a = (int*)malloc(N*sizeof(int));
    if (a == NULL) {
    	printf("Not enough Memory for array A\n");
    	return -1;
    }
    for (int i=0; i<N; i++){
    	fscanf(f,"%d",&a[i]);
    	if (a[i]>max) max =a[i];
    	if (a[i]< min) min = a[i];
    } 
    fclose(f);
	// end of input
	
	minBound = (K-N)/N*min;
	if (minBound < 0) minBound = 0;
    maxBound = K*max/N;
	L = (maxBound - minBound)/min + 1;
    b = (unsigned long long*)malloc(L*sizeof(unsigned long long));
    if (b == NULL) {
    	printf("Not enough Memory for array B\n");
    	return -1;
    }
    pace = minBound;
	for (long i = 0; i<L; i++){
		b[i] = pace;
		pace += min;
	}
	temp = binarySearch(b,a,L,K,N);
	printf("%llu\n",temp);
	return 0;	
}
