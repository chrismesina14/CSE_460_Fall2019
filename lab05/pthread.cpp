#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <pthread.h>
#include <sys/types.h>
#include <unistd.h>

using namespace std;

void * say_it( void * );

int main(int argc, char *argv[])
{
   int num_threads;
   pthread_t *thread_ids;

   cout << "How many threads? ";
   cin >> num_threads;
   thread_ids = new pthread_t[num_threads];

   cout << "Making Threads" << endl;

   // generate threads 
   for (int i = 0; i < num_threads; i++)
   {
      if( pthread_create(&thread_ids[i],NULL,say_it,&thread_ids[i]) > 0)
      {
            cerr << "pthread_create failure" << endl;
            return 2;
      }
   }

   system("bash -c 'read -sn 1 -p \"Press any key to quit...\" ' ");
   delete [] thread_ids;
   return 0;
}

// Print out the thread number twice
void * say_it(void *num)
{
   cout << "I am thread #" << *(unsigned int *)(num) << "." << endl;
   return NULL;
}
