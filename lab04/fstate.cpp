#include <cstdio>
#include <unistd.h>
#include <cstdlib>
#include <sys/types.h> //needed for open
#include <sys/stat.h>  //needed for open
#include <fcntl.h>     //needed for open

using namespace std;

int main (int argc, char *argv[])
{
	struct stat statBuf;

	int err, FD;
	FD = open("openclose.in", O_WRONLY | O_CREAT, S_IREAD | S_IWRITE);
   
	if(FD == -1) /* open failed? */
		exit(-1);

	err = fstat(FD, &statBuf);

	if(err == -1) /* fstat failed? */
		exit(-1);

	printf("The number of blocks = %d\n", statBuf.st_blocks);
	
    return 0;
}
