// C++ Implementation of Kosaraju's algorithm to print all SCCs
#include <iostream>
#include <list>
#include <stack>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
using namespace std;

//int a[];
class Node {
	int number;
	int id;
	bool final;
	public:
		Node(int id,int number, bool final){
			this->id=id;
			this->number=number;
			this->final=final;
		} 
		int getNumber(){
			return number;
		}
		int getID(){
			return id;
		}
		bool isFinal(){
			return final;
		}
		void printNode(){
			printf("%d %d %d\n", id, final, number);
		}
};
vector<Node> nodeVector; 
class Graph
{
    int V;    // No. of vertices
    list<Node> *adj;    // An array of adjacency lists
 
    // Fills Stack with vertices (in increasing order of finishing
    // times). The top element of stack has the maximum finishing 
    // time
    void fillOrder(int v, bool visited[], stack<Node> &Stack);
 
    // A recursive function to print DFS starting from v
    int DFSUtil(int v, bool visited[]);
public:
    Graph(int V);
    void addEdge(int v, int w);
 
    // The main function that finds and prints strongly connected
    // components
    void printSCCs();
 
    // Function that returns reverse (or transpose) of this graph
    Graph getTranspose();
};
 
Graph::Graph(int V)
{
    this->V = V;
    adj = new list<Node>[V];
}
 
// A recursive function to print DFS starting from v
int Graph::DFSUtil(int v, bool visited[])
{
	int sum=0;
    // Mark the current node as visited and print it
    visited[v] = true;
    cout << v << " ";
    
   sum=nodeVector[v].number;
 
    // Recur for all the vertices adjacent to this vertex
    list<Node>::iterator i;
    for (i = adj[v].begin(); i != adj[v].end(); ++i)
        if (!visited[*i])
            sum+=DFSUtil(*i, visited);
    return sum;        
}
 
Graph Graph::getTranspose()
{
    Graph g(V);
    for (int v = 0; v < V; v++)
    {
        // Recur for all the vertices adjacent to this vertex
        list<Node>::iterator i;
        for(i = adj[v].begin(); i != adj[v].end(); ++i)
        {
            g.adj[*i].push_back(v);
        }
    }
    return g;
}
 
void Graph::addEdge(Node v, Node w)
{
    adj[v].push_back(w); // Add w to v’s list.
}
 
void Graph::fillOrder(int v, bool visited[], stack<Node> &Stack)
{
    // Mark the current node as visited and print it
    visited[v] = true;
 
    // Recur for all the vertices adjacent to this vertex
    list<Node>::iterator i;
    for(i = adj[v].begin(); i != adj[v].end(); ++i)
        if(!visited[*i])
            fillOrder(*i, visited, Stack);
 
    // All vertices reachable from v are processed by now, push v 
    Stack.push(v);
}
 
// The main function that finds and prints all strongly connected 
// components
void Graph::printSCCs()
{
    stack<Node> Stack;

    // Mark all the vertices as not visited (For first DFS)
    bool *visited = new bool[V];
    for(int i = 0; i < V; i++)
        visited[i] = false;
 
    // Fill vertices in stack according to their finishing times
    for(int i = 0; i < V; i++)
        if(visited[i] == false)
            fillOrder(i, visited, Stack);
 
    // Create a reversed graph
    Graph gr = getTranspose();
 
    // Mark all the vertices as not visited (For second DFS)
    for(int i = 0; i < V; i++)
        visited[i] = false;
 
    // Now process all vertices in order defined by Stack
    while (Stack.empty() == false)
    {
        // Pop a vertex from stack
        int v = Stack.top();
        Stack.pop();
 
        // Print Strongly connected component of the popped vertex
        if (visited[v] == false)
        {	
        	//a[i]=
            gr.DFSUtil(v, visited);
           // i++;
            cout << endl;
        }
    }
}
 
// Driver program to test above functions
int main()
{
	int n,m,u,v,final,number;
    // Create a graph given in the above diagram
    scanf("%d %d",&n, &m);
    Graph g(n);

    for (int i=0; i<n; i++){
    	scanf("%d %d",&final, &number);
    	Node newNode(i,number,final);
    	nodeVector.push_back(newNode);
    }
	for (int i=0; i<m; i++){
		scanf("%d %d",&u,&v);
		u--;
		v--;   
    	g.addEdge(nodeVector[u], nodeVector[v]);
	}  
	  
	//for (int i = 0; i<n; i++) nodeVector[i].printNode();

    cout << "Following are strongly connected components in "
            "given graph \n";
    //g.printSCCs();
 
    return 0;
}
