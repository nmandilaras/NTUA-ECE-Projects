#include<stdio.h>
#include<math.h>
#include<stdlib.h>
void pinakas1 (int a[], int b[])
{
	int t,i,s,ps; 
	
	for(i=1;i<730; i++)
  {
  	t=i;
  	b[i]=0;
  	while (t!=89)
  	{
  		s=0;
  		while (t!=0)
		{
			ps=t%10;
			t=t/10;
			s+=a[ps];
  		}
  		t=s;
  		if (s==1)
  		{
  			b[i]=1;
  			break;
  		}
  	}
  }
}
void pinakas2 (int a[], int c[])
{
  int t,i,s,ps;	
  for(i=0; i<100000; i++)
  {
   	s=0;
   	t=i;
  	while (t!=0)
	{
    	ps=t%10;
		t=t/10;
		s+=a[ps];
  	}
  	c[i]=s;	
  }
}

int main(int argc , char *argv[])
{
int t1=1,t2=1,num=0,i,e1,e2,e3;
int a[10],c[100000];
int b[730];
b[0]=0; 
FILE *hfile; 

      hfile = fopen(argv[1],"r");
      if(!hfile){
            printf("Error opening file %d!",1);
      }else{
      fscanf(hfile,"%d %d",&t1,&t2);
      fclose(hfile);
  for(i=0; i<10; i++) a[i]=pow(i,2);
  pinakas1(a,b);
  pinakas2(a,c); 

  if (t1>100000) 
  {
  	e1=t1/100000;
  	e3=c[e1];
  	e2=t1%100000;
  	while(t1<=t2)
	{  
		if (b[e3+c[e2]]) num++;
		if (e2==99999) { e1++; e3=c[e1]; e2=0; }
  		else e2++;
		t1++;  	
  	}
  }
  else if (t2>100000) 
  {  
     for(i=t1; i<100000; i++) if (b[c[i]]) num++;
  	e1=1;
  	e3=1;
  	e2=0;
  	t1=100000;
  	while(t1<=t2)
	{  
		if (b[e3+c[e2]]) num++;
		if (e2==99999) { e1++; e3=c[e1]; e2=0; }
  		else e2++;
		t1++;  	
  	}     
  }
  else for(i=t1; i<=t2; i++) if (b[c[i]]) num++;
 printf("%d",num);
    }
}
  
