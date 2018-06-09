#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include "pthread.h"
#include "mandel-lib.h"
#include "semaphore.h"

#define MANDEL_MAX_ITERATION 100000

/*
* Output at the terminal is is x_chars wide by y_chars long
*/

int y_chars = 50;
int x_chars = 90;

/*
* The part of the complex plane to be drawn:
* upper left corner is (xmin, ymax), lower right corner is (xmax, ymin)
*/

double xmin = -1.8, xmax = 1.0;
double ymin = -1.0, ymax = 1.0;

/*
* Every character in the final output is
* xstep x ystep units wide on the complex plane.
*/

double xstep;
double ystep;
//construct semaphores

struct thread_struct{
	//POSIX thread id
	pthread_t thid;
	//application's thread id
	sem_t semid;
	int tid;
	int count;
	struct thread_struct *next;
};

//on previous lab we were told atoi was not safe and not to use it
//so we create a function to convert characters to numbers

int conv_num(char *c, int *num){
	long l;
	char *ch;
	l = strtol(c, &ch, 10);
	if(c!=ch && *ch=='\0'){
		*num = l;
		return 0;
	}
	else{
	return -1;
	}
}
//without using this function we got segmentation fault or bus error

int dif_malloc(size_t size){
	void *p;
	if((p = malloc(size)) == NULL){
		fprintf(stderr, "Out of memory\n");
		exit(1);
	}
	return p;
}
/*
* This function computes a line of output
* as an array of x_char color values.
*/

void compute_mandel_line(int line, int color_val[])
{
/*
* x and y traverse the complex plane.
*/
	double x, y;
	int n;
	int val;
	/* Find out the y value corresponding to this line */
	y = ymax - ystep * line;
	/* and iterate for all points on this line */
	for (x = xmin, n = 0; n < x_chars; x+= xstep, n++) {
		/* Compute the point's color value */
		val = mandel_iterations_at_point(x, y, MANDEL_MAX_ITERATION);
		if (val > 255)
			val = 255;
		/* And store it in the color_val[] array */
		val = xterm_color(val);
		color_val[n] = val;
	}
}
/*
* This function outputs an array of x_char color values
* to a 256-color xterm.
*/

void output_mandel_line(int fd, int color_val[])
{
	int i;
	char point ='@';
	char newline='\n';
	for (i = 0; i < x_chars; i++) {
		/* Set the current color, then output the point */
		set_xterm_color(fd, color_val[i]);
		if (write(fd, &point, 1) != 1) {
			perror("compute_and_output_mandel_line: write point");
			exit(1);
		}
	}
/* Now that the line is done, output a newline character */
	if (write(fd, &newline, 1) != 1) {
		perror("compute_and_output_mandel_line: write newline");
		exit(1);
	}
}

void *compute_and_output_mandel_line(void *arg)
{
/*
* A temporary array, used to hold color values for the line being drawn
*/
	int color_val[x_chars], i;
	struct thread_struct *thr = arg;
	for(i=thr->tid; i<y_chars; i+=thr->count){
		compute_mandel_line(i, color_val);
		sem_wait(&thr->semid);
		output_mandel_line(1, color_val);
		sem_post(&thr->next->semid);
		reset_xterm_color(1);
	}
	return 0;
}

int main(int argc, char *argv[]){
	int i, counter, ret;
	struct thread_struct *thr;
	xstep = (xmax - xmin) / x_chars;
	ystep = (ymax - ymin) / y_chars;
	conv_num(argv[1], &counter);
	thr = dif_malloc(counter *sizeof(*thr));
	//we initilize the semaphores
	sem_init(&thr[0].semid, 0, 1);
	for(i=0;i<counter; i++){
		thr[i].tid = i;
		thr[i].count = counter;
		if(i!=(counter-1)){
			thr[i].next = &thr[i+1];
			sem_init(&thr[i+1].semid, 0, 0);
		}
		else{
			thr[i].next = &thr[0];
		}
	}
/*
* draw the Mandelbrot Set, one line at a time.
* Output is sent to file descriptor '1', i.e., standard output.
*/
	for (i = 0; i < counter; i++) {
		ret = pthread_create(&thr[i].thid, NULL,compute_and_output_mandel_line, &thr[i]);
		if(ret){
			printf("pthread create\n");
			exit(1);
		}
	}
	for(i=0;i<counter; i++){
		ret = pthread_join(thr[i].thid, NULL);
		if(ret){
			printf("pthread join\n");
			exit(1);
		}
		sem_destroy(&thr[i].semid);
	}
	reset_xterm_color(1);
	return 0;
}