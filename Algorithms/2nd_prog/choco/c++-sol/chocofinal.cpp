#include<iostream>
#include<cstdio>
using namespace std;

int main(int argc, char *argv[])
{
	int N,K,*b,*c;
	
    scanf("%d %d",&N,&K);
    int p[N],q[N],A[N];
    for (int i=0; i<N; i++) scanf("%d",&A[i]);
    for (int j=0; j<N; j++) q[j]=p[j]=0;			
    b=p;
    c=q;
    for (int i = 1; i < K+1; i++) {
        int maxDiff = -A[0]; // sketo meion ?
        for (int j = 1; j < N; j++) {
			b[j] = std::max(b[j-1], A[j] + maxDiff);
            maxDiff = std::max(maxDiff,c[j] - A[j]); // h diafora gia ton epomeno gyro! 
        }
        std::swap(b,c);
    }    
	printf("%d\n",std::max(b[N-1],c[N-1]));		
	return 0;		
}
