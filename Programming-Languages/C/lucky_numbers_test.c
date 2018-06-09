#include<stdio.h>
#include<stdlib.h>
#include<math.h>
 
 
void swap0(float *x,float *y)
{
    float temp;
    temp = *x;
    *x = *y;
    *y = temp;
}


void swap(int x,int y,int **a)
{
  int temp;
  for (int i=0; i<4; i++){
    temp = a[x][i];
    a[x][i] = a[y][i];
    a[y][i] = temp;
  }
  return;
}


 
int choose_pivot(int i,int j )
{
    return((i+j) /2);
}
 
void quicksort(int **a, float b [],int m,int n)
{
    int key,i,j,k;
    if( m < n)
    {
        k = choose_pivot(m,n);
        swap(m,k,a);
        swap0(&b[m],&b[k]);        
        key = a[m][1];
        i = m+1;
        j = n;
        while(i <= j)
        {
            while((i <= n) && (a[i][1] <= key))
                i++;
            while((j >= m) && (a[j][1] > key))
                j--;
            if( i < j){
                 swap(i,j,a);
                 swap0(&b[i],&b[j]);
			}
        }
         swap(m,j,a);
         swap0(&b[m],&b[j]); 
        quicksort(a,b,m,j-1);
        quicksort(a,b,j+1,n);
    }
} 
  	
int main(int argc , char *argv[])
{
  int i,j,t1,t2,result=0,flag,**a;
  float c[500000],t3,*b;
  FILE *hfile,*hfile1; 
  
      hfile = fopen("karmam.txt","r");
      hfile1 = fopen("mparmpas.txt","w");
      if(!hfile) printf("Error opening file %d!",1);
      else{
        for(i=0; i<500000; i++) c[i]=0;  
	    fscanf(hfile,"%d",&t1);
	    //printf("1");
	    //int a[t1][4];
	    a=malloc(t1*sizeof(int*));
	    for( i=0; i<t1; i++) a[i]=malloc(4*sizeof(int));
	    //printf("1");
	    b=malloc(t1*sizeof(float));
	    //printf("1");
        for (i=0; i<t1; i++) 
        {
      	 for (j=0; j<4; j++)
      	 {
      	  fscanf(hfile,"%d ",&t2);
      	  a[i][j]=t2;	
      	 }
         fscanf(hfile,"%f",&t3);
      	 b[i]=t3;
      }
      quicksort(a,b,0,t1-1);
      for (i=0; i<t1; i++) 
        {
      	 for (j=0; j<4; j++)
      	 {
      	  fprintf(hfile1,"%d ", a[i][j]);
      	 }
         fprintf(hfile1,"%f\n",b[i]);
      }
      //printf("1");
      /*
      for (i=0; i<t1; i++) 
        {
        flag=0;
      	 for (j=a[i][0]; j<a[i][2]; j++)
      	 {
           if (b[i]>c[j]){
           	flag=1;
           	c[j]=b[i];
           }
      	 }
      	 result+=flag;
      }
      printf("%d ",result);
      */
     }

 }
