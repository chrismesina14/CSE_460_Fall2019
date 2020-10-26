#include <iostream>
#include <unistd.h>
#include <cstdio>
#include <cstdlib>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <errno.h>

using namespace std;

int main(int argc, char *argv[])
{
    if(argc < 2)    
    {
        cout << "Error. Not enough arguments." << endl;
        return 1;
    }

    int fork_return;
    fork_return = fork();

    if(fork_return < 0)
    {
        cout << "ERROR!" << endl;
        return 1;
    }

    else if(fork_return == 0)       // Child
    {
        int fd;
        fd = open(argv[1], O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);

        int n_char;
        char buffer[100];
         
        n_char = read(0, buffer, sizeof(buffer));
    
        n_char = write(fd, buffer, n_char);
        
        if(n_char == -1)
        {
            perror(argv[0]);
            return 1;
        }
    }
    
    else if(fork_return > 0)        // Parent
    {
        wait(NULL);
        cout << "This is the Parent process" << endl;

        int fd;
        fd = open(argv[1], O_RDONLY, S_IREAD | S_IWRITE);
        
        int n_char;
        char buffer[100];

        n_char = read(fd, buffer, sizeof(buffer));
    
        n_char = write(1, buffer, n_char);

        if(fd == -1)
        {
            perror(argv[0]);
            return 1;
        }
    }
}
