#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "tree.h"
#include "proc-common.h"

void fork_procs(struct tree_node *root)
{	
	
	pid_t p[root->nr_children],pchild;
	int status,i;
	
	/*
	 * Start
	 */
	printf("PID = %ld, name %s, starting...\n",	(long)getpid(), root->name);
	change_pname(root->name);
	
	//does not enter on leaves
	for (i=0; i < root->nr_children; i++)  
		{
			p[i] = fork();
			if (p[i]<0){
				perror("fork");
				exit(1);
			}
			else if (p[i] == 0){
				//recursively create children
				fork_procs(root->children+i);
				//no recursion = error    	
				exit(1);				
			}
			else{
				printf("Parent, PID = %ld: Created child with PID = %ld, waiting for it to terminate...\n", (long)getpid(), (long)p[i]);
			}
		}
		
		//all children must be STOPPED
		wait_for_ready_children(root->nr_children);   
		printf("PID = %ld, name = %s has stopped\n", (long)getpid(), root->name);

		//when all children are STOPPED, STOP self	
		raise(SIGSTOP);			
		//when CONTINUED				
		printf("PID = %ld, name = %s is awake\n", (long)getpid(), root->name);  

		//SIGCONT all children
		for (i=0; i < root->nr_children; i++)				
			{
				kill(p[i],SIGCONT);
				pchild = wait(&status);	
				//wait for them to exit		
				explain_wait_status(pchild,status);
			}
	
		//all processes exit normally in the end
		printf("%s: Exiting...\n",root->name);
		exit(0);						
}

/*
 * The initial process forks the root of the process tree,
 * waits for the process tree to be completely created,
 * then takes a photo of it using show_pstree().
 *
 * How to wait for the process tree to be ready?
 * In ask2-{fork, tree}:
 *      wait for a few seconds, hope for the best.
 * In ask2-signals:
 *      use wait_for_ready_children() to wait until
 *      the first process raises SIGSTOP.
 */

int main(int argc, char *argv[])
{
	pid_t pid;
	int status;
	struct tree_node *root;

	if (argc < 2){
		fprintf(stderr, "Usage: %s <tree_file>\n", argv[0]);
		exit(1);
	}

	/* Read tree into memory */
	root = get_tree_from_file(argv[1]); //READ INPUT

	/* Fork root of process tree */
	pid = fork();
	if (pid < 0) {
		perror("main: fork");
		exit(1);
	}
	if (pid == 0) {
		/* Child */
		fork_procs(root);
		exit(1);
	}

	/*
	 * Father
	 */
	/* for ask2-signals */
	wait_for_ready_children(1);

	/* Print the process tree root at pid */
	show_pstree(pid);

	/* for ask2-signals */
	kill(pid, SIGCONT);

	/* Wait for the root of the process tree to terminate */
	pid = wait(&status);
	explain_wait_status(pid, status);

	return 0;
}