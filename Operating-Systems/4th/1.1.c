#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <signal.h>
#include <string.h>
#include <assert.h>

#include <sys/wait.h>
#include <sys/types.h>

#include "proc-common.h"
#include "request.h"

/* Compile-time parameters. */
#define SCHED_TQ_SEC 2                /* time quantum */
#define TASK_NAME_SZ 60               /* maximum size for a task's name */



typedef struct pcb {
	int Id;
	pid_t PID;
	char name[TASK_NAME_SZ];
	struct pcb * next;
} ProcessControlBlock;

/* The Process queue is a list with the last element showing to the first one */
/* One pointer to show to the current process and one to the previous one */

static ProcessControlBlock *CurrentProcess, *LastNode;

/* SIGALRM handler: Gets called whenever an alarm goes off.
 * The time quantum of the currently executing process has expired,
 * so send it a SIGSTOP. The SIGCHLD handler will take care of
 * activating the next in line.
 */

static void sigalrm_handler(int signum)
{
	kill(CurrentProcess->PID, SIGSTOP);
}

/* SIGCHLD handler: Gets called whenever a process is stopped,
 * terminated due to a signal, or exits gracefully.
 *
 * If the currently executing task has been stopped,
 * it means its time quantum has expired and a new one has
 * to be activated.
 */

static void SearchAndDequeue(pid_t pid)
{
	ProcessControlBlock *a=CurrentProcess, *b=CurrentProcess->next; 	/* Temporary pointers */

	while (b!=CurrentProcess)
	{
		if (b->PID==pid)
		{
			printf("Process %d with PID %d is dead due to external reason ", b->Id, pid);
			a->next=b->next;
			free(b);
			printf("and is now removed from the process list.\n");
			return;
		}
		a=a->next;
		b=b->next;
	}
}

static void sigchld_handler(int signum)
{
	int status;
	pid_t pid;
	for (;;)
	{
		if ((pid=waitpid(-1, &status, WNOHANG | WUNTRACED))<0) // gyrizei to pid tis diadikasias sthn opoia anaferetai
		{
			perror("waitpid");
			exit(1);
		}
		if (pid==0)
			break;
			explain_wait_status(pid, status);
		if (WIFSTOPPED(status)) /* A child has received SIGSTOP */
		{//termatise logo kvantou
			LastNode=CurrentProcess;
			CurrentProcess=CurrentProcess->next;
			alarm(SCHED_TQ_SEC);
			kill(CurrentProcess->PID, SIGCONT);
		}
		if (WIFEXITED(status) || WIFSIGNALED(status)) /* A child is dead */
		{//h termatise kanonika h me shma
			if (CurrentProcess==LastNode) /* All children are now dead */
			{
				free(CurrentProcess);
				printf("No processes left to schedule. Exiting... \n");
				exit(1);
			}
			if (pid==CurrentProcess->PID)
			{//termatise kanonika

				/* The child that was running died before time quantum expired */
				/* Remove child fromn the list */
				LastNode->next=CurrentProcess->next;
				free(CurrentProcess);
				/* Go to the next process in the list */
				CurrentProcess=LastNode->next;
				/* Set the alarm */
				alarm(SCHED_TQ_SEC);
				/* Send SIGCONT to the next process to continue */
				kill(CurrentProcess->PID, SIGCONT);
			}
			else /* A child in the list has died from an external signal */
			{
				/* Dequeue the child without reseting the alarm */
				SearchAndDequeue(pid);
			}
		}
	}
}


static void Enqueue(void)
{
	if (LastNode==NULL)
	{
		LastNode=CurrentProcess;
		LastNode->next=LastNode;
		return;
	}
	CurrentProcess->next=LastNode->next;
	LastNode->next=CurrentProcess;
	LastNode=CurrentProcess;
}

/* Install two signal handlers.
 * One for SIGCHLD, one for SIGALRM.
 * Make sure both signals are masked when one of them is running.
 */
static void install_signal_handlers(void)
{
	sigset_t sigset;
	struct sigaction sa;

	sa.sa_handler = sigchld_handler;
	sa.sa_flags = SA_RESTART;
	sigemptyset(&sigset);
	sigaddset(&sigset, SIGCHLD);
	sigaddset(&sigset, SIGALRM);
	sa.sa_mask = sigset;
	if (sigaction(SIGCHLD, &sa, NULL) < 0) {
		perror("sigaction: sigchld");
		exit(1);
	}

	sa.sa_handler = sigalrm_handler;
	if (sigaction(SIGALRM, &sa, NULL) < 0) {
		perror("sigaction: sigalrm");
		exit(1);
	}

	/*
	 * Ignore SIGPIPE, so that write()s to pipes
	 * with no reader do not result in us being killed,
	 * and write() returns EPIPE instead.
	 */
	if (signal(SIGPIPE, SIG_IGN) < 0) {
		perror("signal: sigpipe");
		exit(1);
	}
}

void Child(char Executable[])
{
	raise(SIGSTOP);
	char *newargv[]={Executable, NULL, NULL, NULL};
	char *newenviron[]={NULL};
	execve(Executable, newargv, newenviron);
	perror("execve");
	exit(1);
}

int main(int argc, char *argv[])
{
	int nproc;
	/*
	 * For each of argv[1] to argv[argc - 1],
	 * create a new child process, add it to the process list.
	 */

	nproc = argc-1; /* number of proccesses goes here */

        int i;
	pid_t p;
	for (i=1; i<=nproc; i++)
	{
		if ((p=fork())<0)
		{
			perror("fork");
			exit(1);
		}
		else if (p==0)
		{
                       Child(argv[i]);
	            /* char *newargv[]={argv[i], NULL, NULL, NULL};
	               char *newenviron[]={NULL};
	               execve(argv[i], newargv, newenviron);
	               perror("execve");
         	       exit(1);
                          */
		}
                // pateras ftiaxnoume thn domh kathe diergasias
		if ((CurrentProcess=(struct pcb *) malloc(sizeof(struct pcb)))==NULL)
		{
			printf("No Memory Available! Exiting...\n");
			exit(1);
		}

		CurrentProcess->Id=i;
		CurrentProcess->PID=p;
		strncpy(CurrentProcess->name, argv[i], TASK_NAME_SZ);
		Enqueue(); // kai mpainei sth lista
	}



	/* Wait for all children to raise SIGSTOP before exec()ing. */
	wait_for_ready_children(nproc);

	/* Install SIGALRM and SIGCHLD handlers. */
	install_signal_handlers();

	/* First process on the list is LastNode->next */
	CurrentProcess=LastNode->next; //epeidh o teleytaios deixnei ston prwto

	/* Set the alarm */
	alarm(SCHED_TQ_SEC);
	/* Start scheduling from the first Process on the list */
	kill(CurrentProcess->PID, SIGCONT);

	if (nproc == 0) {
		fprintf(stderr, "Scheduler: No tasks. Exiting...\n");
		exit(1);
	}


	/* loop forever  until we exit from inside a signal handler. */
	while (pause())
		;

	/* Unreachable */
	fprintf(stderr, "Internal error: Reached unreachable point\n");
	return 1;
}