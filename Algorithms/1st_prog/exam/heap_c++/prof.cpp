#include<iostream>
#include<cstdio>
#include<climits>
#include<cmath>
using namespace std;
 
/*
 * Initial heap size 0 as heap is empty
 */
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
	unsigned int N,K,temp;
	node *A,n;
	FILE *f;
	
	f = fopen(argv[1],"r");	
	if(!f){
    	printf("Error opening file %d!",1);
    	return 1;
    }
    fscanf(f,"%d %d",&N,&K);
    char ch = getc ( f ); // in order to read \n
    A = new node[N];
    for (unsigned int i=0; i<N; i++){
    	fscanf(f,"%d",&temp);
    	A[i].id = i+1;
		A[i].di = temp;
		A[i].current = 0;
    	heapInsert(A);
    }
    fclose(f); 
	
	for (unsigned int i=0; i<K-1; i++)
		extractMin(A);	
	n = extractMin(A);
	printf("%d ",n.id);
	printf("%ld",n.current + n.di);	
	delete A;
	return 0;	
}
