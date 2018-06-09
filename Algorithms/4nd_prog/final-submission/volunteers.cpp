#include <iostream>
#include <list>
#include <stack>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <limits.h>
#define NINF INT_MIN
using namespace std;

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
	/*	void printNode(){
			printf("%d %d %d\n", id, final, number);
		} */
};

vector<Node> nodeVector; 
vector<Node> vectorNode;

class Graph
{
    int V;    // No. of vertices
    list<int> *adj;    // An array of adjacency lists
	list<Node> *adjacent;
	 
    // Fills Stack with vertices (in increasing order of finishing
    // times). The top element of stack has the maximum finishing 
    // time
    void fillOrder(int v, bool visited[], stack<int> &Stack);
 
    // A recursive function to print DFS starting from v
    void DFSUtil(int v, bool visited[],list<int> &l1);
    
    // A function used by longestPath
   void topologicalSortUtil(int v, bool visited[], stack<int> &Stack);    
public:
    Graph(int V);
    void addEdge(int v, int w);
 	list<int>* getAdjacent();
 	list<Node>* getAdjacentNode(); 	
    // The main function that finds and prints strongly connected
    // components
    int printSCCs(list<int> *ptr);
 
    // Function that returns reverse (or transpose) of this graph
    Graph getTranspose();
    
    // Finds longest distances from given source vertex
    void longestPath(int s);    
    
    //changes the size of the graph 
    void changeSize(int V);
};
 
Graph::Graph(int V)
{
    this->V = V;
    adj = new list<int>[V];
    adjacent = new list<Node>[V];
}

void Graph::changeSize(int V){
	this->V = V;
}

list<int> * Graph::getAdjacent(){
	return adj;
}
 
list<Node> * Graph::getAdjacentNode(){
	return adjacent;
} 
// A recursive function to print DFS starting from v
void Graph::DFSUtil(int v, bool visited[], list<int> &l1 )
{
    // Mark the current node as visited and print it
    visited[v] = true;
    //cout << v << " ";
    l1.push_back(v);
    
    // Recur for all the vertices adjacent to this vertex
    list<int>::iterator i;
    for (i = adj[v].begin(); i != adj[v].end(); ++i)
        if (!visited[*i])
            DFSUtil(*i, visited,l1);       
}
 
Graph Graph::getTranspose()
{
    Graph g(V);
    for (int v = 0; v < V; v++)
    {
        // Recur for all the vertices adjacent to this vertex
        list<int>::iterator i;
        for(i = adj[v].begin(); i != adj[v].end(); ++i) g.adj[*i].push_back(v);
    }
    return g;
}
 
void Graph::addEdge(int v, int w)
{
    adj[v].push_back(w); // Add w to v’s list.
}
 
void Graph::fillOrder(int v, bool visited[], stack<int> &Stack)
{
    // Mark the current node as visited and print it
    visited[v] = true;
 
    // Recur for all the vertices adjacent to this vertex
    list<int>::iterator i;
    for(i = adj[v].begin(); i != adj[v].end(); ++i)
        if(!visited[*i])
            fillOrder(*i, visited, Stack);
 
    // All vertices reachable from v are processed by now, push v 
    Stack.push(v);
}
 
// The main function that finds and prints all strongly connected 
// components
int Graph::printSCCs(list<int> *ptr)
{
    stack<int> Stack;
	int counter=0;
	
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
        	//list<int> l1;
            //gr.DFSUtil(v, visited,l1);
            gr.DFSUtil(v, visited,ptr[counter]);
			counter++;
            //lol.push_back(l1);
          //  cout << endl;
        }
    }
    //checking the old adjacent lists
    /*
	for(int i = 0; i<counter; i++){	
		list<int>::iterator j;
		for (j = ptr[i].begin(); j!=ptr[i].end() ; ++j)
			cout<<*j<<" ";
		cout<<endl;	
	}
	*/	
	return counter;
}

void Graph::topologicalSortUtil(int v, bool visited[], stack<int> &Stack)
{
    // Mark the current node as visited
    visited[v] = true;
 
    // Recur for all the vertices adjacent to this vertex
    list<Node>::iterator i;
    for (i = adjacent[v].begin(); i != adjacent[v].end(); ++i){
        Node node = *i;
        if (!visited[node.getID()]) topologicalSortUtil(node.getID(), visited, Stack);
    }
    // Push current vertex to stack which stores topological sort
    Stack.push(v);
}
 
// The function to find longest distances from a given vertex. It uses
// recursive topologicalSortUtil() to get topological sorting.
void Graph::longestPath(int s)
{
    stack<int> Stack;
    int dist[V],max=-1;
 
    // Mark all the vertices as not visited
    bool *visited = new bool[V];
    for (int i = 0; i < V; i++)
        visited[i] = false;
 
    // Call the recursive helper function to store Topological Sort
    // starting from all vertices one by one
    for (int i = 0; i < V; i++)
        if (visited[i] == false)
            topologicalSortUtil(i, visited, Stack);
 
    // Initialize distances to all vertices as infinite and distance
    // to source as 0
    for (int i = 0; i < V; i++) dist[i] = NINF;
    dist[s] = 0;
 
    // Process vertices in topological order
    while (Stack.empty() == false)
    {
        // Get the next vertex from topological order
        int u = Stack.top();
        Stack.pop();
 
        // Update distances of all adjacent vertices
        list<Node>::iterator i;
        if (dist[u] != NINF)
        {
          for (i = adjacent[u].begin(); i != adjacent[u].end(); ++i)
             if (dist[i->getID()] < dist[u] + i->getNumber()){
                dist[i->getID()] = dist[u] + i->getNumber();
               // if(vectorNode[i->getID()].isFinal() && dist[i->getID()]>max) max=dist[i->getID()];
            }
        }
    }
 
    // Print the calculated longest distances
   // for (int i = 0; i < V; i++) (dist[i] == NINF)? cout << "INF ": cout << dist[i] << " ";
	for (int i = 0; i < V; i++) if(vectorNode[i].isFinal() && dist[i]>max) max=dist[i];
	if (max!=-1) max+=vectorNode[s].getNumber();
	//cout<< vectorNode[s].getNumber()<<endl;
	cout<< max << endl;
}

void createNewGraph(Graph g,list<int> *ptr,int counter)
{
	int n=counter,k=0,nold=nodeVector.size(),tracker[nold],gps[nold],temp,newNumber,b=-1;
	list<int> *adjold;
	list<Node> *adjnew;
	//Graph gra(n); //new graph, now nodes are the SCCs
	
	adjold = g.getAdjacent(); //pointers to the adjacent lists of each graph
	adjnew = g.getAdjacentNode();
		
    //list<list<int> >::iterator i; // iterate through the list of lists 
	for( int i = 0; i < n; ++i){
		list<int>::iterator j;
		int number=0;
		bool final = false;
		gps[ptr[i].front()]=k;
		for (j = ptr[i].begin(); j!= ptr[i].end(); ++j){
			tracker[*j]=(ptr[i].front());
			if(*j==0) b=k;
			number+=nodeVector[*j].getNumber(); //calculate number of each scc
			final = final or nodeVector[*j].isFinal(); //if one node is terminal then the whole scc is
		}
    	Node newNode(k,number,final); // create new nodes, one for each scc
    	vectorNode.push_back(newNode); // new array for those nodes
		k++;

    }
    /*
    for(int i=0; i < nold; i++) {
    	list<int>::iterator s;			
		for(s= adjold[i].begin(); s!=adjold[i].end(); s++){		
			cout<< *s << " ";
		}
		cout<< endl;
    }
    */
	//for (int i = 0; i<n; i++) vectorNode[i].printNode();
	//for (int i = 0; i<nold; i++) cout << tracker[i] << " ";
	/*
	for( int i = 0; i < n; ++i){
		bool visited[n] ;
		for(int y=0; y<n; y++) visited[y]=false;
		list<int>::iterator j;	
		int o=ptr[i].front();	
		o= tracker[o];
		for (j = ptr[i].begin(); j!= ptr[i].end(); ++j){
			list<int>::iterator s;			
			for(s= adjold[*j].begin(); s!=adjold[*j].end(); s++){
				temp = tracker[*s];
				newNumber=gps[temp];
				if (temp!=o && !visited[newNumber] ) {
					adjnew[l].push_back(vectorNode[newNumber]);
					visited[newNumber]=true;
				}
			}
		}
		l++;
	}*/
	
	for (int i = 0; i<nold; i++){
		int o = tracker[i],help =gps[o];		
		list<int>::iterator s;			
		for(s= adjold[i].begin(); s!=adjold[i].end(); s++){
			temp = tracker[*s]; //check in which components belongs in the new graph
			newNumber=gps[temp]; // take the new number of this component 			
			if (temp!=o ) adjnew[help].push_back(vectorNode[newNumber]);
				
		}
	}
	
	//for (int i=0; i<nold; i++) cout<< tracker[i];
	//cout<< endl;
	/*
	 //checking the new adjacent lists
	for(int i=0; i<n; i++ ){
		list<Node>::iterator j;		
		for(j = adjnew[i].begin(); j!= adjnew[i].end(); ++j){
			cout<< (*j).getID() <<" ";
		}
		cout<<endl;
	}
	*/
	if (b==-1) { cout<< "Error" ; return;}
	//else cout<< "B:" << b << endl;
	g.changeSize(n);
	g.longestPath(b); //maybe starter vertex is not on zero scc
	
	return ; 
}

int main()
{
	int n,m,u,v,final,number,counter;
	//list<list<int> > lol;
    // Create a graph given in the above diagram
    scanf("%d %d",&n, &m);
	list<int> *ptr = new list<int>[n]; //array of n lists    
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
    	g.addEdge(u, v);
	}  

    counter=g.printSCCs(ptr);
 	createNewGraph(g,ptr,counter);
    return 0;
}
