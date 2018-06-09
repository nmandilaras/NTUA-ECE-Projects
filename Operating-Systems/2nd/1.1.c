#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/wait.h>

#include "proc-common.h"

#define SLEEP_PROC_SEC  10
#define SLEEP_TREE_SEC  3

/*
 * Create this process tree:
 * A-+-B---D
 *   `-C
 */

void fork_procs(void)
{
    pid_t pid;
	int status;
	
	printf("A: Starting...\n");
	change_pname("A");
	pid = fork();			//Create B
	if (pid < 0)
	{
		perror("A fork B");
		exit(1);
	}
	else if (pid == 0)
	{
		printf("A: Waiting...\n");//A has 2 children		
		printf("B: Starting...\n");
		change_pname("B");

		pid = fork();		//Create D
		if (pid < 0)
		{
			perror("B fork D");
			exit(1);
		}
		else if (pid == 0)
		{
			printf("B: Waiting...\n"); //B is waiting for show_pstree
			printf("D: Starting...\n");
			change_pname("D");
			printf("D: Sleeping...\n");	//sleep for show_pstree
			sleep(SLEEP_PROC_SEC);
			printf("D: Exiting...\n");
			exit(13);
		}
		pid = wait(&status);	 //B has a child, so one wait
		explain_wait_status(pid,status);
		printf("B: Exiting...\n");
		exit(19);
	}

	pid = fork();			//Create C
	if (pid < 0)
	{
		perror("A fork C");
		exit(1);
	}
	else if (pid == 0)
	{
		printf("C: Starting...\n");
		change_pname("C");
		printf("C: Sleeping...\n");		//sleep for show_pstree
		sleep(SLEEP_PROC_SEC);
		printf("C: Exiting...\n");
		exit(17);
	}
	pid = wait(&status);		//A has 2 wait one for
	explain_wait_status(pid,status);		//each children
	pid = wait(&status);
	explain_wait_status(pid,status);
	printf("A: Exiting...\n");
	exit(16);
}



int main(void)
{
    pid_t pid;
    int status;

    pid = fork();	//Create process A
    if (pid < 0) {	//the root of our processes
        perror("main: fork");
        exit(1);
    }
    if (pid == 0) {	//After process is ready root-A
        fork_procs();	//We are going to create the tree
        exit(1);
    }
	printf("Start!\n");
	sleep(SLEEP_TREE_SEC);	//Father is waiting until
	show_pstree(pid);
	pid = wait(&status);	//Wait until it's complited
	explain_wait_status(pid, status);
	printf("Exit!\n");
	return 0;
}
