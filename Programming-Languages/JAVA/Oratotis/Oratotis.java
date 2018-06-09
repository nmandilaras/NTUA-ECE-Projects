import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.Scanner;
import java.util.Locale;

public class Oratotis {
 
 public static void main(String[] args) {
 
  try (BufferedReader br = new BufferedReader(new FileReader(args[0])))
  {
   int flag;
   int result=0;
   int max=0;
   MyQuickSort sorter = new MyQuickSort();
   Locale.setDefault(Locale.US);
   String sCurrentLine;
   int n =  Integer.parseInt(br.readLine());
   int[][] a = new int[n][4];
   float[] b = new float[n];
   for (int i=0; i<n; i++){
    Scanner scanner = new Scanner(br.readLine());
     for (int j =0; j<4; j++) a[i][j]= scanner.nextInt();
     if (a[i][2]>max) max=a[i][2];
     b[i]= scanner.nextFloat();
   } 
   float[] c= new float[max];
   sorter.sort(a,b,n);
   for (int i=0; i<n; i++){
      flag=0;
      for (int j=a[i][0]; j<a[i][2]; j++){
         if (b[i]>c[j]){
          flag=1;
          c[j]=b[i];
         }
      }
      result+=flag;
    }
   System.out.printf("%d\n",result);
  } catch (IOException e) {
   e.printStackTrace();
  } 
 }
}