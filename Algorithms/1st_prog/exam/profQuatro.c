#include<stdio.h>
#include<stdlib.h>
#include <math.h>
#include <stdbool.h>

unsigned long long binarySearch(int *a,unsigned long long low,unsigned long long up,unsigned long long K,int N) // first stage we return only time in which K was served
{
	unsigned long long safe=0,sum,safeSum=0, mid,secure=0,temp=K+N;
	bool flag=false;
	
	while (low <= up) {
		mid = (low + up) / 2;
		sum=0;
		for (int i=0; i<N; i++){
			sum += mid/a[i] + 1 ;
			if (sum > temp) break;
		}
		if ( sum == K ){ // we continue searching cause we want the minimum timing that K candicates are under examination
			secure = mid;
			flag = true;
			if (mid == 0) break;
			else up = mid -1; // maybe we can adjust also low barrier
		}
		else if (sum >= K+N)
				if (mid == 0) break;
				else	up = mid -1;
		else if (sum < K)  low = mid + 1;
		else { // case that we are inside K+N area , maybe K+i participants had finished all together
			safe = mid;
			safeSum = sum; 
			if (mid == 0) break;
			else	up = mid -1;
		} 
	}
	if (flag){
		for(int i=N-1; i>=0; i--)
			if (secure%a[i]==0)	{
				secure += a[i];
				printf("%d ",i+1);
				break;
			}			
			return secure;		
	}	
	else{
		for(int i=N-1; i>=0; i--)
			if (safe%a[i]==0 && safeSum > K) safeSum--;
			else if (safe%a[i]==0){
				safe += a[i];
				printf("%d ",i+1);
				break;
			}	
	}	
	return safe; 
}

int main()
{
	int N,*a,min = 100000,max = 0;
	unsigned long long maxBound,minBound,temp,K;
	
	scanf("%d %llu",&N,&K);
    //getc(f); // in order to read newline
    a = (int*)malloc(N*sizeof(int));
    if (a == NULL) {
    	printf("Not enough Memory for array A\n");
    	return -1;
    }
    for (int i=0; i<N; i++){
		scanf("%d",&a[i]);
    	if (a[i]>max) max =a[i];
    	if (a[i]< min) min = a[i];
    } 
	// end of input

	minBound = (K-N)/N*min;
	if (minBound < 0)  minBound = 0;
    maxBound = K*max/N;
	temp = binarySearch(a,minBound,maxBound,K,N);
	printf("%llu\n",temp);
	free(a);
	return 0;	
}
