#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>


void doWrite (int fd, const char *buff, int len)
{
        int wcnt, idx=0;

        do{
                wcnt = write(fd, buff+idx, len-idx);
                if (wcnt == -1) //error
                {
                        perror("write");
                        return;
                }
                idx += wcnt;
        } while (idx<len);
}


void write_file(int fd, const char *infile)
{
        int fd_infile, rcnt;
        char buff[1024];

        fd_infile = open(infile, O_RDONLY);     //open input file only for read
        if (fd_infile == -1)
        {
                perror("open");
                exit(1);
        }
        for (;;)
        {
                rcnt = read(fd_infile, buff, sizeof(buff)-1);
                if (rcnt == 0)  //end-of-file
                        return;
                if (rcnt == -1) //error
                {
                        perror("read");
                        return;
                }
                doWrite(fd, buff, rcnt);
        }
}

int main(int argc, char *argv[])
{
        if (argc < 3)           //Zero or one input files
        {
                fprintf(stdout, "Usage: ./fconc infile1 infile2 [outifle (default:fconc.out)]\n");
                return 0;
        }

        int fd, oflags, mode;

        oflags = O_CREAT | O_WRONLY | O_TRUNC ;
        mode = S_IRUSR | S_IWUSR ;

        if (argc ==3)           //Two input files
        {
                fd = open("fconc.out", oflags, mode); //there is no output file, we create fconc.out
                if (fd == -1)
                {
                        perror("open");
                        exit(1);
                }
                write_file(fd , argv[1]);
                write_file(fd , argv[2]);
        }
        else if (argc == 4)      //Two input files, one output file
        {

                fd = open(argv[3], oflags, mode); //There is already one output file, we just open it
                if (fd == -1)
                {
                        perror("open");
                        exit(1);
                }
                write_file(fd , argv[1]);
                write_file(fd , argv[2]);

        }
        else         //More than three  files
        {
                fprintf(stdout, "Usage: ./fconc infile1 infile2 [outifle (default:fconc.out)]\n");
                return 0;
        }

        close(fd);
        return 0;
}