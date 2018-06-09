// C++ program for Kruskal's algorithm to find Minimum
// Spanning Tree of a given connected, undirected and
// weighted graph
#include<bits/stdc++.h>
#include <stdio.h>
#include <stdlib.h>
#define BSIZE 1<<15

char buffer[BSIZE];
long bpos = 0L, bsize = 0L;
using namespace std;
 
// Creating shortcut for an integer pair
typedef  pair<int, int> iPair;

long readLong()
{
	long d = 0L, x = 0L;
	char c;
	while (1){
		if (bpos >= bsize) {
			bpos = 0;
			if (feof(stdin)) return x;
			bsize = fread(buffer, 1, BSIZE, stdin);
		}
		c = buffer[bpos++];
		if (c >= '0' && c <= '9') { 
			x = x*10 + (c-'0');
			d = 1;
		}
		else if (d == 1) return x;
	}
	return -1;
}

// To represent Disjoint Sets 
class DisjointSets
{
    int *parent, *rnk, n;
    
public: 
    // Constructor.
    DisjointSets(int n){
        // Allocate memory
        this->n = n;
        parent = new int[n+1];
        rnk = new int[n+1];
 
        // Initially, all vertices are in
        // different sets and have rank 0.
        for (int i = 0; i <= n; i++) {
            rnk[i] = 0;
            //every element is parent of itself
            parent[i] = i; // parent defines a set 
        }					// vertices in the same set have the same parent
    }
 
    // Find the parent of a node 'u'
    // Path Compression
    int find(int u) {
        /* Make the parent of the nodes in the path
           from u--> parent[u] point to parent[u] */
        if (u != parent[u]) parent[u] = find(parent[u]);
        return parent[u];
    }
 
    // Union by rank
    void merge(int x, int y) {
        //x = find(x), y = find(y);
 
        /* Make tree with smaller height
           a subtree of the other tree  */
        if (rnk[x] > rnk[y]) // no need to increase rank cause if one tree set is already bigger is not going to be 
            parent[y] = x;  // augmened by adding a smaller tree to route node
        else // If rnk[x] <= rnk[y]
            parent[x] = y;
 
        if (rnk[x] == rnk[y]) rnk[y]++; //only in these case is necessary to increase the rank of the set
    }
}; 
 
// Class to represent a graph
class Graph
{
    int V, E;
    vector< pair<int, iPair> > edges; // weight and pair -src,dst- 
    
public: 
    // Constructor
    Graph(int V, int E){
        this->V = V;
        this->E = E;
    }
 
    // Utility function to add an edge
    void addEdge(int u, int v, int w) {
		edges.push_back({w, {u, v}});
	}	
 
    // Function to find MST using Kruskal's MST algorithm
    tuple<int, bool> kruskalMST();
	void changeVertices(int V){ this->V = V; }
	void changeEdges(int E) { this->E = E; }
};

 /* Functions returns weight of the MST and checks if it is a connected graph*/ 
tuple<int, bool> Graph::kruskalMST()
{
    int mst_wt = 0,counter=0,i=0; // Initialize result
	bool connected = false;
	
    // Sort edges in increasing order on basis of cost
    sort(edges.begin(), edges.begin()+E);
 
    // Create disjoint sets
    DisjointSets ds(V);
 
    // Iterate through all sorted edges
    //vector< pair<int, iPair> > it;
    //for (it=edges.begin(); it!=edges.end(); it++)
	while (counter<V-1)	{
		//it=edges[i];
        int u = edges[i].second.first; // we get the vertices 
        int v = edges[i].second.second; // which form the edge
 
        int set_u = ds.find(u); // we find the set 
        int set_v = ds.find(v); // in which they belong
 
        // Check if the selected edge is creating
        // a cycle or not (Cycle is created if u
        // and v belong to same set)
        if (set_u != set_v){
            // Current edge will be in the MST
			counter++;
            // Update MST weight
            mst_wt += edges[i].first;
 
            // Merge two sets
            ds.merge(set_u, set_v);
        }
	i++;	
    }
	if (counter+1==V) connected = true;
    return std::make_tuple(mst_wt,connected);
}

int main()
{
    int V,E,K,n1,n2,c,u,mst_wt,mst_wt1,result ;
	bool connected,connected1;
    
	// read input
	cin >> V >> K >> E;
    Graph g(V, E);
	int B[K][2];
	
	for (int i=0; i<K; i++){
		B[i][0]=readLong()-1;
		B[i][1]=readLong();		
    }		
	for (int i=0; i<E; i++){
		n1=readLong()-1;
		n2=readLong()-1;
		c =readLong();	
    	g.addEdge(n1, n2, c);
	}	
    std::tie(mst_wt,connected) = g.kruskalMST();
	
	// modify graph in order to check teletrasportation
	g.changeVertices(V+1);
	g.changeEdges(E+K);	
	for (int i=0; i<K; i++) g.addEdge(B[i][0], V, B[i][1]);	

	std::tie(mst_wt1,connected1) = g.kruskalMST();
	if (connected and mst_wt < mst_wt1) result = mst_wt;
	else result = mst_wt1;
	
	cout << result << endl;	
    return 0;
}
