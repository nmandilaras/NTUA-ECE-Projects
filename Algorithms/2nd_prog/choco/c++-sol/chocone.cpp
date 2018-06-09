#include<iostream>
#include<cstdio>
#include<climits>
#include<cmath>
using namespace std;

int heapsize = 0,K;
/*
 * Find the parent node
 */
int parent(int i){
    return (i-1) / 2;
}

/*
 * Called initially to create a min heap
 * Also called after a node extraction from min heap
 * Since the smallest value node is at the root of min heap
 * After extraction min heapify is called on root node
 * It compares parent with its children
 * If a smaller child found then its swapped with parent and
 * Min heapify is again called on that child to apply same procedure
 */
void minHeapify(int i,int *A){
    int smaller = i;
    int l = 2*i +1; // first child
	int r = l+1; // second child
 
    if (l < heapsize && ( A[l] < A[i] ) ){
        smaller = l;
	//printf("1\n");
 	}
    if (r < heapsize && (A[r] < A[smaller] ) ){
        smaller = r;
	//printf("2");
	}
 
    if (smaller != i){
        std::swap(A[i], A[smaller]);
        minHeapify(smaller,A);
    }
}

void heapInsert(int diff,int *B){ 
    int i = heapsize;
    if (heapsize==K && diff < B[0] ) return;
    else if (heapsize==K) { 
    	B[0]=diff;
    	minHeapify(0,B);
    	return;
    }
	B[i]=diff;
    while(i > 0 && B[parent(i)] > B[i]){
        std:: swap(B[i], B[parent(i)]);
        i = parent(i);
	//printf("3\n");
    }
    ++heapsize; 
}

int main(int argc, char *argv[])
{
	int N,j,sum=0,*A,p,B[1000];
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
    j=0;
    while (j<N-1){
    	p=j;
    	while(j<N-1 && A[j]<A[j+1]){
    		j++;
    	}
    	if (p!=j) { //printf("%d\n",p); 
		heapInsert(A[j]-A[p],B); 
		}
    	j++;
    }
    //printf("%d\n",heapsize);
    for(int i=0; i<heapsize; i++) sum+=B[i];
	// result
	printf("%d\n",sum);	
	return 0;	
}
