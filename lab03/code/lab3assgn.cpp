#include<iostream>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

using namespace std;

int main(int argc, char * argv[])
{
    if(argc < 3)
    {
        cout << "error myCat: not enough arguments" << endl;
        return 0;
    }

    int status;
    int fork_return = fork();

    if(fork_return == 0)
    {
        cout << "In the CHILD process Trying to Meow" << endl;
        cout << "Child Process ID: " << getpid() << ", Parent ID: " << getppid() << ", Process Group: " << getpgrp() << endl << endl;
        execl("/bin/cat", "cat", "-n", argv[1], "-", argv[2], NULL);
    }
    else if(fork_return > 0)
    {
        cout << "In the PARENT process" << endl;;
        cout << "Original Process ID: " << getpid() << ", Parent Is: " << getppid() << ", Process Group is: " << getpgrp() << endl << endl;
        wait(&status);
    }
}
