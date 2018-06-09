#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "tree.h"
#include "proc-common.h"

#define SECS_PROC 4
#define SECS_MAIN 2

pid_t fork_procedure(struct tree_node *t)
{
	pid_t pid;
	int status,i;

	pid = fork();	//create process
	if (pid<0)
	{
		perror("fork");
		exit(1);
	}
	else if (pid == 0)
	{
		change_pname(t->name);
		printf("Process %s created\n", t->name);
		if (t->nr_children == 0)
		{	//if the node has no children, the process is sleeping
			printf("%s is sleeping...\n", t->name);
			sleep(SECS_PROC);
			printf("%s is exiting...\n", t->name);
			exit(0);
		}
		else
		{
			for (i=0; i< t->nr_children; i++)
			{
				fork_procedure(t->children+i); //recursively
			}
			printf("%s is waiting...\n", t->name);
			for (i=0; i< t->nr_children; i++)
			{	//for every node/process
				pid = wait(&status);//wait for all of its children
				explain_wait_status(pid, status);
			}
			printf("%s is exiting...\n", t->name);
			exit(0);
		}
	}
	return pid;
}


int main (int argc, char *argv[])
{
	struct tree_node *root;
	pid_t pid;
	int status;
	
	if (argc !=2)
	{
		fprintf(stderr, "Usage: %s <input_tree_file>\n\n", argv[0]);
		exit(1);
	}
	
	root = get_tree_from_file(argv[1]); //read file

	if (!root)
		printf("The input file is empty\n");
	else
	{
	//	print_tree(root);
		pid = fork_procedure(root);
		sleep(SECS_MAIN);	//sleep for the creation of the tree
		show_pstree(pid);
		pid = wait(&status);	//wait for the root of the tree
		explain_wait_status(pid, status);
		printf("Exit!");
	}
	return 0;

}
