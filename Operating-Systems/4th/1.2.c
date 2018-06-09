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
#define SHELL_EXECUTABLE_NAME "shell" /* executable for shell */

void child(char *executable)
{
	raise(SIGSTOP);
	char *newargv[]={executable, NULL, NULL, NULL};
	char *newenviron[]={NULL};
	execve(executable, newargv, newenviron);
	perror("execve");
	exit(1);
}


/* The Process queue is a list with the last element showing to the first one */
/* One pointer to show to the current process and one to the previous one */
typedef struct pcb
{
	int Id;
	pid_t PID;
	char name[TASK_NAME_SZ];
	struct pcb * next;
} ProcessControlBlock;

static ProcessControlBlock *CurrentProcess, *LastNode;
int nproc;
int flag=0;

static void Enqueue(void){
	if (!LastNode)
	{
		LastNode=CurrentProcess;
		LastNode->next=LastNode;
		return;
	}
	CurrentProcess->next=LastNode->next;
	LastNode->next=CurrentProcess;
	LastNode=CurrentProcess;
}

static void SearchAndDequeue(pid_t pid)
{
	ProcessControlBlock *a=CurrentProcess, *b=CurrentProcess->next; /* Temporary pointers */
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


/* Print a list of all tasks currently being scheduled.  */
static void sched_print_tasks(void){

	ProcessControlBlock *temp=CurrentProcess->next;

	printf("|Task name|\t|Id |\t|PID |\n");
	printf("-------------------------------\n");
	printf("|%9s|\t|%3d|\t|%5d| (Current Process)\n", CurrentProcess->name, CurrentProcess->Id, CurrentProcess->PID);
	while (temp!=CurrentProcess)
	{
		printf("|%9s|\t|%3d|\t|%5d|\n", temp->name, temp->Id, temp->PID);
		temp=temp->next;
	}
}

/* Send SIGKILL to a task determined by the value of its
 * scheduler-specific id.
 */
static int sched_kill_task_by_id(int id){
	ProcessControlBlock *temporary=CurrentProcess;
	while (temporary->Id!=id)
		temporary=temporary->next;
	kill(temporary->PID, SIGTERM);
	return(id);
}


/* Create a new task.  */
static void sched_create_task(char *executable){
	/* Create the process */
	pid_t p=fork();
	if (p<0)
	{
		perror("fork");
		exit(1);
	}
	flag=1;
	/* Child's code */
	if (p==0)
		child(executable);
	
	/* Allocate memory */
	ProcessControlBlock * New = (struct pcb *) malloc(sizeof(struct pcb));
	if (New==NULL)
	{
		printf("No Memory Available! Exiting...\n");
		exit(1);
	}
	New->PID=p;
	New->Id=++nproc;
	strncpy(New->name, executable, TASK_NAME_SZ);
	/* Add to the list after the current process (it will be the next process to run) */
	New->next=CurrentProcess->next;
	CurrentProcess->next=New;
}

/* Process requests by the shell.  */
static int process_request(struct request_struct *rq){
	switch (rq->request_no) {
		case REQ_PRINT_TASKS:
			sched_print_tasks();
			return 0;

		case REQ_KILL_TASK:
			return sched_kill_task_by_id(rq->task_arg);

		case REQ_EXEC_TASK:
			sched_create_task(rq->exec_task_arg);
			return 0;

		default:
			return -ENOSYS;
	}
}

/*
 * SIGALRM handler
 */
static void sigalrm_handler(int signum){
	kill(CurrentProcess->PID, SIGSTOP);
}

/*
 * SIGCHLD handler
 */
static void sigchld_handler(int signum){
	int status;
	pid_t pid;
	for (;;)
	{
		if ((pid=waitpid(-1, &status, WNOHANG | WUNTRACED))<0)
		{
			perror("waitpid");
			exit(1);
		}
		if (pid==0)
			break;
		printf("\n");
		explain_wait_status(pid, status);
		if (WIFSTOPPED(status)) /* A child has received SIGSTOP */
		{
			if (flag)
			{
				flag=0;
				return;
			}
			LastNode=CurrentProcess;
			CurrentProcess=CurrentProcess->next;
			alarm(SCHED_TQ_SEC);
			kill(CurrentProcess->PID, SIGCONT);
		}
		if (WIFEXITED(status) || WIFSIGNALED(status)) /* A child is dead */
		{
			if (CurrentProcess==LastNode) /* All children are now dead */
			{
				free(CurrentProcess);
				printf("No processes left to schedule. Exiting... \n");
				exit(1);
			}
			if (pid==CurrentProcess->PID)
			{
				/* The child that was running died before time quantum
				 * expired */
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

/* Disable delivery of SIGALRM and SIGCHLD. */
static void signals_disable(void){
	sigset_t sigset;

	sigemptyset(&sigset);
	sigaddset(&sigset, SIGALRM);
	sigaddset(&sigset, SIGCHLD);
	if (sigprocmask(SIG_BLOCK, &sigset, NULL) < 0) {
		perror("signals_disable: sigprocmask");
		exit(1);
	}
}

/* Enable delivery of SIGALRM and SIGCHLD.  */
static void signals_enable(void){

	sigset_t sigset;

	sigemptyset(&sigset);
	sigaddset(&sigset, SIGALRM);
	sigaddset(&sigset, SIGCHLD);
	if (sigprocmask(SIG_UNBLOCK, &sigset, NULL) < 0) {
		perror("signals_enable: sigprocmask");
		exit(1);
	}
}


/* Install two signal handlers.
 * One for SIGCHLD, one for SIGALRM.
 * Make sure both signals are masked when one of them is running.
 */
static void install_signal_handlers(void){
	sigset_t BlockSignals;
	/* Signals which will be blocked during handler
	 * execution */
	struct sigaction SignalAction;
	sigemptyset(&BlockSignals);
	sigaddset(&BlockSignals, SIGCHLD); /* Add SIGCHLD and SIGALRM to the set of signals */
	sigaddset(&BlockSignals, SIGALRM); /* which will be blocked */
	SignalAction.sa_flags=SA_RESTART;
	SignalAction.sa_mask=BlockSignals;
	SignalAction.sa_handler=sigchld_handler;
	if (sigaction(SIGCHLD, &SignalAction, NULL)<0)
	{
		perror("sigaction: SIGCHLD");
		exit(1);
	}
	SignalAction.sa_handler=sigalrm_handler;
	if (sigaction(SIGALRM, &SignalAction, NULL)<0)
	{
		perror("sigaction: SIGCHLD");
		exit(1);
	}
	/*
	* Ignore SIGPIPE, so that write()s to pipes
	* with no reader do not result in us being killed,
	* and write() returns EPIPE instead.
	*/
	if (signal(SIGPIPE, SIG_IGN) < 0)
	{
		perror("signal: SIGPIPE");
		exit(1);
	}
}

static void do_shell(char *executable, int wfd, int rfd){
	char arg1[10], arg2[10];
	char *newargv[] = { executable, NULL, NULL, NULL };
	char *newenviron[] = { NULL };

	sprintf(arg1, "%05d", wfd);
	sprintf(arg2, "%05d", rfd);
	newargv[1] = arg1;
	newargv[2] = arg2;

	raise(SIGSTOP);
	execve(executable, newargv, newenviron);

	/* execve() only returns on error */
	perror("scheduler: child: execve");
	exit(1);
}

/* Create a new shell task.
 *
 * The shell gets special treatment:
 * two pipes are created for communication and passed
 * as command-line arguments to the executable.
 */
static pid_t sched_create_shell(char *executable, int *request_fd, int *return_fd){
	pid_t p;
	int pfds_rq[2], pfds_ret[2];

	if (pipe(pfds_rq) < 0 || pipe(pfds_ret) < 0) {
		perror("pipe");
		exit(1);
	}

	p = fork();
	if (p < 0) {
		perror("scheduler: fork");
		exit(1);
	}

	if (p == 0) {
		/* Child */
		close(pfds_rq[0]);
		close(pfds_ret[1]);
		do_shell(executable, pfds_rq[1], pfds_ret[0]);
	}
	/* Parent */
	close(pfds_rq[1]);
	close(pfds_ret[0]);
	*request_fd = pfds_rq[0];
	*return_fd = pfds_ret[1];

	return (p);
}

static void shell_request_loop(int request_fd, int return_fd){
	int ret;
	struct request_struct rq;

	/*
	 * Keep receiving requests from the shell.
	 */
	for (;;) {
		if (read(request_fd, &rq, sizeof(rq)) != sizeof(rq)) {
			perror("scheduler: read from shell");
			fprintf(stderr, "Scheduler: giving up on shell request processing.\n");
			break;
		}

		signals_disable();
		ret = process_request(&rq);
		signals_enable();

		if (write(return_fd, &ret, sizeof(ret)) != sizeof(ret)) {
			perror("scheduler: write to shell");
			fprintf(stderr, "Scheduler: giving up on shell request processing.\n");
			break;
		}
	}
}

int main(int argc, char *argv[]){
	int nproc;
	pid_t p;
	/* Two file descriptors for communication with the shell */
	static int request_fd, return_fd;

	/* Create the shell. */
	p = sched_create_shell(SHELL_EXECUTABLE_NAME, &request_fd, &return_fd);
	/* add the shell to the scheduler's tasks */
	CurrentProcess=(struct pcb *) malloc(sizeof(struct pcb));
	if (CurrentProcess==NULL)
	{
		printf("No Memory Available! Exiting...\n");
		exit(1);
	}
	CurrentProcess->Id=0;
	CurrentProcess->PID=p;
	strncpy(CurrentProcess->name, SHELL_EXECUTABLE_NAME, TASK_NAME_SZ);
	Enqueue();

	/*
	 * For each of argv[1] to argv[argc - 1],
	 * create a new child process, add it to the process list.
	 */
	int i;
	for (i=1; i<=argc-1; i++)
	{
		if ((p=fork())<0)
		{
			perror("fork");
			exit(1);
		}
		else if (p==0)
		{
			child(argv[i]);
		}
		CurrentProcess=(struct pcb *) malloc(sizeof(struct pcb));
		if (CurrentProcess==NULL)
		{
			printf("No Memory Available! Exiting...\n");
			exit(1);
		}
		CurrentProcess->Id=i;
		CurrentProcess->PID=p;
		strncpy(CurrentProcess->name, argv[i], TASK_NAME_SZ);
		Enqueue();
	}
	nproc=i-1; /* number of proccesses goes here */

	/* Wait for all children to raise SIGSTOP before exec()ing. */
	wait_for_ready_children(nproc);

	/* Install SIGALRM and SIGCHLD handlers. */
	install_signal_handlers();

	CurrentProcess=LastNode->next;
	alarm(SCHED_TQ_SEC);
	kill(CurrentProcess->PID, SIGCONT);

	if (nproc == 0) {
		fprintf(stderr, "Scheduler: No tasks. Exiting...\n");
		exit(1);
	}

	shell_request_loop(request_fd, return_fd);

	/* Now that the shell is gone, just loop forever
	 * until we exit from inside a signal handler.
	 */
	while (pause())
		;

	/* Unreachable */
	fprintf(stderr, "Internal error: Reached unreachable point\n");
	return 1;
}
