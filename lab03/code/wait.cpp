#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <iostream>
using namespace std;
int main()
{
int status; 
pid_t fork_return; 

fork_return = fork(); 

if (fork_return == 0) /* child process */ 
{ 
  cout << "I'm the child!" << endl; 
  return 0; 
} 
else if (fork_return > 0) /* parent process */ 
{ 
  wait(&status); 
  cout << "I'm the parent!" << endl; 
  if (WIFEXITED(status))
      cout << "Child returned: " << WEXITSTATUS(status) << endl;
} 

}
