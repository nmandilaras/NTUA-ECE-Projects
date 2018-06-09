public class Diapragmateysi
{
 public static void main (String[] args)
 {
    String[] thesi = new String[12];
   for (int i=0; i<12; i++)  
     thesi[i]=args[0].substring(i,i+1);
  State initial = new State (thesi,null,"0");
  BFSolver solver = new BFSolver ();
  State result = solver.solve(initial);
  if (result==null)
   System.out.println("Cannot find any solution");
  else
   printSolution(result);
 }
 public static void printSolution (State s)
 {
        // Print the piece of the solution that got us here.
     if (s.getPrevious()!=null){
    printSolution(s.getPrevious());
  System.out.print(s);}
 }
}