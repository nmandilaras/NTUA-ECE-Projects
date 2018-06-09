#include <stdio.h>
#include <unistd.h>


long long int find_time(long int a[], long long int high, long long int low, long int K, long int N){//gia K>1

   long long int mid;
   long int i,people;  
   while(low<high){
      people=0; 
      mid=(high+low)/2 ;
      for(i=0;i<N;i++){
         people=people+mid/a[i]+1;
      }
   //printf("K=%li\n\n",K);     
       if (K<people || K==people){ 
          high=mid;
       }
       else
          low=mid+1;
       
   } //printf("highhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh=%lli\n",high);
   return(high);
} 


long int find_examer(long int a[], long int K,long int N,long long int time){  
  int h;
  long int i;
  long int people=0;
  long int before_him;
  for(i=0; i<N; i++){
     if (time%a[i]==0) h=0; else h=1;
     people=people+time/a[i]+h;
        }// autos pou exei exetasei tous perissoterous exei ton mikrotero xrono,opote autos einai pou tha anelave ton teleutaio mathiti mexri to xrono time, An duo max idia kratame auto me to megalutero i, dhladh thn mikroterh proteraiothta, autos tha exetase ton teleutaio mathiti 
//printf("peopleeeeeeeeeeeeee=%ld \n", people);  
   before_him=K-people;
//printf("before_him=%ld \n", before_him);
   i=0;
   while(i<N && before_him>0){
       if (time%a[i]==0)
          before_him--;
       i++;
   }
   return(i);
}


int main (){
     
   long int N; //N-->num:number of examers,K--> priority
   long int K;
   //FILE *fp;
   long int help;
   //long long int help2;
  /* if ((fp=fopen(argv[1],"r"))==NULL){
       printf("Error opening file\n");
       return(1);
   }*/
  if (scanf("%ld",&help)==1)
       N=help ;
  else {
     printf("error on input2");
     return(1);
   }
  if ( scanf("%li",&help)==1)
       K=help ;
  else {
     printf("error on input1");
     return(1);
   }

   /*if(part>num){
      printf("Wrong input\n");
      return(1);
   }*/
   long int a[N];// a: contains the times 
   long int i;
  if ( scanf("%li",&help)==1)
       a[0]=help ;
  else {
     printf("error on input3");
     return(1);
   }

   long long int min=0;
   long long int max=a[0];
   for(i=1;i<N;i++){
      if ( scanf("%li",&help)==1)
          a[i]=help;
      else {
          printf("error on input4");
          return(1);
      }
      if(a[i]>max)
          max=a[i];
   }
//printf ("aaaaaaaaaaaaaaaaa");
//for(i=0;i<num;i++){
  //printf("%lli ",a[i]);}
max=max*K;
long long int K_time=find_time(a,max,min,K,N);
//printf("K_time=%lli \n",K_time);// o xronos pou bhke gia exetash o K
//printf("max_part=%lli\n",max_part);
// printf("%lli aaaaaaaaaa",a[0]);
long int examer=find_examer(a, K, N,K_time);


 //printf("%lli aaaaaaaaaa",a[0]);

 //printf("%lli aaaaaaaaaa",a[0]);

  printf("%li %lli",examer,K_time+a[examer-1]);

printf("\n");   

//fclose(fp);
return (0);
}


