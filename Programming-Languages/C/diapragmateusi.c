#include<stdio.h>
#include<stdlib.h>
#include<math.h>

  struct node 
  {
  	int data;
  	struct node *next;
  };	
  
  struct node* enqueue(struct node *q, int x)
  {// προσθέτει το στοιχείο στην αρχή της λίστας
  	struct node *neos;
  	neos=(struct node *)malloc(sizeof(struct node));
  	if (neos==NULL) { printf("memory yiok\n"); }
  	neos->data=x;
  	neos->next=q;
  	return neos;
  }
  
    struct node* endqueue(struct node *q, int *pik, int x)
  {// προσθέτει το στοιχείο στο τέλος της λίστας αν δεν υπάρχει ήδη
  	struct node *p=q,*previous=q;
	while(q!=NULL)
  	 {
  	 	if (q->data==x) {  *pik=1; return p; }
        previous=q;
		q=q->next;   
  	}
  	struct node *neos;
  	neos=(struct node *)malloc(sizeof(struct node));
	if (neos==NULL) { printf("memory yiok\n"); }	
  	previous->next=neos; // previous
	neos->data=x;
  	neos->next=NULL;
  	return p;
}	 

void peekall (struct node *q)
  { // τυπώνει τη λίστα
  	if (q==NULL) return ;
  	printf("%d ",q->data);
  	peekall(q->next);
  } 
  
    struct node* dublicate(struct node *q)
    {
    	struct node *p=NULL;
    	while (q!=NULL)
    	{
    	   struct node *neos;
  	       neos=(struct node *)malloc(sizeof(struct node));	
  	       if (neos==NULL) { printf("memory yiok\n"); }
		   neos->data=q->data;
  	       neos->next=p;
  	       p=neos;
  	       q=q->next;
    	}
    	return p;
    }
    
	int number (struct node *q)
    {
    	int num=0;
      	while (q!=NULL) { num++; q=q->next;}
      	return num;
    }
    
struct node* answer (int c[],int n)
{
	struct node *p=NULL;
	for (int i=n; i>0; i--)
	{
		if (c[i]) p=enqueue(p,i);
	}
	return p;
} 

void checker (int c[],struct node *q)
{
	while (q!=NULL)
	{
		c[q->data]=0;
		q=q->next;
	}
}

void freelist (struct node *q)
{
	struct node *temp;
	while (q!=NULL)
	{
		temp=q->next;
		free(q);
		q=temp;
	}
}
    
  struct list 
  {
  	struct node *current ;
  	struct list *next;
  };
  
    struct list* enqueuelist (struct list *q, struct node *x)
  { // προσθέτει τη λίστα στην αρχή της λίστας από λίστες 
  	struct list *neos;
  	neos=(struct list *)malloc(sizeof(struct list));
  	if (neos==NULL) { printf("memory yiok\n"); }
  	neos->current=x;
  	neos->next=q;
  	return neos;
  }
  
void peeklist (struct list *q)
  { // τυπώνει τη λίστα
  	if (q==NULL) return ;
  	peekall(q->current);
  	printf("\n");
  	peeklist (q->next);
  } 
  
 struct node* least(struct list *q)
 {
 	int a=43,b;
 	struct node *tr=NULL;
 	while (q!=NULL)
 	{
 		b=number(q->current);
 		if (b<a) {a=b; tr=q->current; }
 		q=q->next;
 	}
 	return tr;
 }
 int checkit (struct node *q, int x)
 {
 	if (q==NULL) return 0;
 	else if (q->data==x) return 1;
 	else return checkit(q->next,x);
 }
 
struct list *synart (struct node *q, struct node *p, struct node* b[], struct list *acc, int i)
 {
 	if (q==NULL) { for (int k=i-1; k>=0; k--) {acc=enqueuelist(acc,b[k]);} return acc; }
 	else if (checkit(p,q->data)) { acc=enqueuelist(acc,p) ; return acc; }
 	else {
 		b[i]=enqueue(p,q->data);
 	    //peekall(b[i]);
 		return synart(q->next,p,b,acc,i+1);
 		
 	  }		
 } 
  
void swap(int *x,int *y);
int choose_pivot(int i,int j );
void quicksort(int list[],struct node* list2 [],int m,int n);
 
void swap(int *x,int *y)
{
    int temp;
    temp = *x;
    *x = *y;
    *y = temp;
}

void swap2(struct node* *x,struct node* *y)
{
    struct node* temp;
    temp = *x;
    *x = *y;
    *y = temp;
}
 
int choose_pivot(int i,int j )
{
    return((i+j) /2);
}
 
void quicksort(int list[],struct node* list2 [],int m,int n)
{
    int key,i,j,k;
    if( m < n)
    {
        k = choose_pivot(m,n);
        swap(&list[m],&list[k]);
        swap2(&list2[m],&list2[k]);        
        key = list[m];
        i = m+1;
        j = n;
        while(i <= j)
        {
            while((i <= n) && (list[i] <= key))
                i++;
            while((j >= m) && (list[j] > key))
                j--;
            if( i < j){
                swap(&list[i],&list[j]);
                swap2(&list2[i],&list2[j]);
			}
        }
        swap(&list[m],&list[j]);
        swap2(&list2[m],&list2[j]); 
        quicksort(list,list2,m,j-1);
        quicksort(list,list2,j+1,n);
    }
} 
  	
int main(int argc , char *argv[])
{
  int t1,t2,t3,t4,i,j;
  struct node *tp;
  struct list *tr=NULL;     
  FILE *hfile; 
      hfile = fopen("G:/report2.txt","r");
      if(!hfile){
            printf("Error opening file %d!",1);
      }else{
      fscanf(hfile,"%d %d",&t1,&t2);
      int a[t2],c[t1+1];
      struct node* b[t2];
      for (int i=0; i<t1+1; i++) c[i]=1;
      for (i=0; i<t2; i++) 
      {
      	fscanf(hfile,"%d ",&t3);
      	a[i]=t3;
      	struct node *d=NULL;
      	for (j=0; j<t3; j++)
      	{
      	  fscanf(hfile,"%d ",&t4);
		  d=enqueue( d, t4 );      		
      	}
      	b[i]=d;
      }
      quicksort(a,b,0,t2-1);
      //k=a[1];
      fclose(hfile);
      tp=b[0];
	  while (tp!=NULL)
	  {
	  	struct node *deikths=NULL;      
	  	deikths=enqueue(deikths, tp->data);
	  	tr=enqueuelist (tr, deikths);
	  	tp=tp->next;
	  }
	  struct list *tr2=tr,*temp;
	  for(i=1; i<t2; i++)
	  {
	    struct list *tr1=NULL;
	    struct node* tp1[t1]; 	
	  	while(tr2!=NULL)
	  	{
            tr1=synart (b[i],tr2->current,tp1,tr1,0);	
            //peeklist(tr1);
    	    temp=tr2->next;
    	    //freelist(tr2->current);
    	    free(tr2);
    	    tr2=temp;
	  	}
	  	  freelist(b[i]);
          tr2=tr1;
	  }
	  tp=least(tr2); 
	  checker(c,tp);
	  peekall(answer(c,t1));  
  }
}
