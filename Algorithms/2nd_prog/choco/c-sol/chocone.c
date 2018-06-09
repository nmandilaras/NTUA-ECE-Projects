#include<stdio.h>
#include<stdlib.h>
#include <math.h>

int heapsize = 0;
/*
 * Find the parent node
 */
int parent(int i){
    return (i-1) / 2;
}

struct node{
    int id;
    int di;
    long current;
};
/*
 * Called initially to create a min heap
 * Also called after a node extraction from min heap
 * Since the smallest value node is at the root of min heap
 * After extraction min heapify is called on root node
 * It compares parent with its children
 * If a smaller child found then its swapped with parent and
 * Min heapify is again called on that child to apply same procedure
 */
void minHeapify(int i,node *A){
    int smaller = i;
    int l = 2*i +1; // first child
	int r = l+1; // second child
 
    if (l < heapsize && ( A[l].current < A[i].current || (A[l].current == A[i].current && A[l].id < A[i].id) ) ){
        smaller = l;
	//printf("1\n");
 	}
    if (r < heapsize && (A[r].current < A[smaller].current || (A[r].current == A[smaller].current && A[r].id < A[smaller].id) ) ){
        smaller = r;
	//printf("2");
	}
 
    if (smaller != i){
        std::swap(A[i], A[smaller]);
        minHeapify(smaller,A);
    }
}
/*
 * Does not extract any items only show the minimum element
 */
node heapMinimum(node *A){
    return A[0];
}
/*
 * Increase heap size to create space for new node
 * Insert the node at that space by calling decrease key function
 */
void heapInsert(node *A){ 
    int i = heapsize;
    while(i > 0 && A[parent(i)].current > A[i].current){
        std:: swap(A[i], A[parent(i)]);
        i = parent(i);
	//printf("3\n");
    }
    ++heapsize; 
}
/*
 * Heap size less than zero mean no items in heap so nothing to extract
 * For min heap minimum value is at the root which in here is A[0]
 * Save the root and replace root with last element in the heap and decrease the heap size
 * So the root is still in the array in last position but no longer in the heap
 * Since the last element is now the root the heap may be unbalanced
 * So to balance the heap call min heapify on the root node again
 * Lastly return the saved root
 */
node extractMin(node *A){
    if(heapsize < 0)
        printf("Heap Underflow\n");
 
    node min = A[0];
    A[0].current += A[0].di;
    minHeapify(0,A);
    return min;
}
/*
 * Every time we extract heap size is automatically reduced
 * So no need change heap size in while loop
 */
void printPriorityQueue(node *A){
    printf("Main Output:\n");
    while(heapsize){
        node ext = extractMin(A);
        printf("%ld\n",ext.current );
    }
}

int main(int argc, char *argv[])
{
	int N,K,j,sum=0,*A,p;
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
    j=0;
    while (j<N){
    	p=j;
    	while(A[j]<A[j+1]){
    		j++;
    	}
    	if (p!=j) heapinsert(A[j]-A[p]);
    	j++;
    }
    for(int i=0; i<K; i++) sum+=heapmax();
	// result
	printf("%d",sum);	
	return 0;	
}
