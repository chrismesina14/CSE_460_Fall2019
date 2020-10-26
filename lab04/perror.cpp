#include <cstdio>
#include <unistd.h>
#include <cstdlib>
#include <errno.h>      //must use for perror

using namespace std;

//extern int errno;  //in linux, don't seem to need this

int main (int argc, char *argv[])
{
        int n_char=0;
	char buffer[10];

        //Initially n_char is set to 0 -- errno is 0 by default
        printf("n_char = %d \t errno = %d\n", n_char, errno);

        //Display a prompt to stdout
        n_char = write(1, "Enter a word  ", 14);

        //Use the read system call to obtain 10 characters from stdin
        n_char = read(0, buffer, 10);
        printf("\nn_char = %d \t errno = %d\n", n_char, errno);

        //If read has failed
        if (n_char == -1)
        {
                perror(argv[0]);
                exit (1);
        }

        //Display the characters read
        n_char = write(1,buffer,n_char);

        return 0;
}
