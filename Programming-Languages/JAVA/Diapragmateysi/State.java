import java.util.Collection;
import java.util.ArrayList;
import java.util.Arrays;

public class State {
 private String[] thesi = new String[12]; 
 private State previous; 
 private String num;
 public State (String[] arxika, State p,String ar)
 { 
  for (int i=0; i<12; i++)  thesi[i]=arxika[i];
  previous=p;
  num=ar;
  arxika=null;
 }
 public State getPrevious()
 {
  return previous;
 }
 public boolean isfinal()
 {  
  return (thesi[0].equals("b")) && (thesi[1].equals("g"))&& (thesi[2].equals("b"))&& (thesi[4].equals("g"))&& (thesi[7].equals("r"))&& (thesi[9].equals("y"))&& (thesi[10].equals("r"))&& (thesi[11].equals("y"));//&& (thesi[1]=="g") && (thesi[2]=="b"); //&& (thesi[4]=="g") && (thesi[7]=="r") && (thesi[9]=="y") && (thesi[10]=="r") && (thesi[11]=="y");
 }
 private static void totheright (String[] pin, int ar){
   String tmp;
   tmp=pin[ar+3];
   pin[ar+3]=pin[ar];
   pin[ar]=pin[ar+5];
   pin[ar+5]=tmp;
   tmp=pin[ar+2];
   pin[ar+2]=pin[ar];
   pin[ar]=tmp;
 }
 public Collection<State> next ()  // epistrefei syllogh apo State
 {
     Collection<State> result = new ArrayList<State>();
     String[] neos = new String[12];
     for (int i=0; i<12; i++)  neos[i]=thesi[i];
     totheright(neos,0);  
     State s = new State (neos, this,"1" );
     result.add(s);
     //String[] neos = new String[12];
     for (int i=0; i<12; i++)  neos[i]=thesi[i];
     totheright(neos,1);  
      s = new State (neos, this,"2" );
     result.add(s);
     //String[] neos = new String[12];
     for (int i=0; i<12; i++)  neos[i]=thesi[i];
     totheright(neos,5); 
      s = new State (neos, this,"3" );
     result.add(s);
     //String[] neos = new String[12];
     for (int i=0; i<12; i++)  neos[i]=thesi[i];
     totheright(neos,6);  
      s = new State (neos, this,"4" );
     result.add(s);
     neos=null;
     s=null;
     return result;     
 }
 @Override // epanegrafw th methodo
 public String toString()
 {
    return num;
}
 @Override
 public boolean equals (Object other)
 {
  State s = (State) other;
  return Arrays.deepEquals(s.thesi,thesi);
 }
 @Override
 public int hashCode (){
 return toString().hashCode(); 
 }
 
}