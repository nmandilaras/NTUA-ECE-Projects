import java.util.Set;
import java.util.HashSet;

import java.util.Queue;
import java.util.ArrayDeque;

/**
 * This class represents solvers that attempt to solve problems by performing a
 * breadth-first search in their state space.  They keep track of the states
 * they have visited.  They typically produce optimal (i.e., with the minimum
 * number of moves) solutions.
 */
public class BFSolver implements Solver
{
    public State solve (State initial)
    {
        Set<State> seen = new HashSet<State>();
        Queue<State> remaining = new ArrayDeque<State>();

        // Add the initial state to the queue.
        seen.add(initial);
        remaining.add(initial);

        // While the queue contains states to be examined.
        while (!remaining.isEmpty()) {
           // System.out.println("1");
            // Remove the first remaining state from the queue.
            State s = remaining.remove();
            // If s is final, then just return it.
            if (s.isfinal()) return s;
            // Find the states that can be reached from this one.
            for (State n : s.next())
                // If n has not been seen before, add it to the queue.
                if (!seen.contains(n)) {
                    seen.add(n);
                    remaining.add(n);
                }
        }
        // If the queue is empty and no solution was found, return null.
        return null;
    }
}