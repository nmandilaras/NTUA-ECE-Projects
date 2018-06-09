#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
using namespace std;

/*
 * Find the parent node
 */
 	 
int parent(int i){
    return (i-1) / 2;
}

struct node{
    int id;
    long long int key;
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
void minHeapify(int i,node *A, int  heapsize){
    int smaller = i;
    int l = 2*i +1; // first child
	int r = l+1; // second child
 
    if (l < heapsize && ( A[l].key < A[i].key ) ){
        smaller = l;
	//printf("1\n");
 	}
    if (r < heapsize && (A[r].key < A[smaller].key ) ){
        smaller = r;
	//printf("2");
	}
 
    if (smaller != i){
        std::swap(A[i], A[smaller]);
        minHeapify(smaller,A, heapsize);
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
void heapInsert(node *A, int * heapsize){ 
    int i = *heapsize;
    while(i > 0 && A[parent(i)].key > A[i].key){
        std:: swap(A[i], A[parent(i)]);
        i = parent(i);
	//printf("3\n");
    }
    ++*heapsize; 
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
node extractMin(node *A , int * heapsize){
    if(*heapsize < 0)
        printf("Heap Underflow\n");
 
    node min = A[0];
    A[0] = A[*heapsize - 1];
    --*heapsize;
    minHeapify(0,A, *heapsize);
    return min;
}
/*
 * Every time we extract heap size is automatically reduced
 * So no need change heap size in while loop
 */
void printPriorityQueue(node *A, int * heapsize){
    printf("Main Output:\n");
    while(*heapsize){
        node ext = extractMin(A,heapsize);
        printf("%d %lld\n",ext.id,ext.key );
    }
}

int main()
{
	long long int N,K,si,fi,sum=0,active=1,currentN,currentT=0,endT,preT,penalty=0,oldN=0;
	int heapsizeA=0,heapsizeB=0;
	node *A,*B;
	scanf("%lld %lld",&N, &K);
	A = new node[N];
	B = new node[N];
	for(int i=0; i<N; i++){
		scanf("%lld %lld",&si, &fi);
		A[i].id = i;
		B[i].id = i;
		A[i].key = si;
		B[i].key = fi;
		heapInsert(A,&heapsizeA);
		heapInsert(B,&heapsizeB);
	}
	currentN = extractMin(A,&heapsizeA).key;
	endT = extractMin(B,&heapsizeB).key;
	while(sum<K){
		preT = currentN;
		if (heapsizeA>0){
			currentT = currentN;
			if (penalty == 1) {
				currentN = oldN;
				heapsizeA--;
			}
			else {
				currentN = extractMin(A,&heapsizeA).key;
			}
			penalty=-1;
			while (currentT == currentN && heapsizeA>0){
				active++;
				currentN = extractMin(A,&heapsizeA).key;
			}
			if (currentN > endT) {
				oldN = currentN;
				heapsizeA++;
				currentN = endT+1;
				penalty = 1;
				endT= extractMin(B,&heapsizeB).key;
			}
		}
		else{	
			currentN = endT	+1;
			penalty = 1;
			endT= extractMin(B,&heapsizeB).key;
		}
		sum += active * (currentN - preT);
		active -= penalty;
	}
	active+=penalty;
	while (sum>=K) {
		sum-=active;
		currentN-=1;
	}
	printf("%lld\n",currentN);
	return 0;
}
