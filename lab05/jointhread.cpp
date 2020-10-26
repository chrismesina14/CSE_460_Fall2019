#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <pthread.h>
#include <sys/types.h>
#include <unistd.h>

using namespace std;

//Thread start 
void * say_it( void * );

int main(int argc, char *argv[])
{
   int num_threads;
   pthread_t *thread_ids;
   void  *p_status;

   cout << "How many threads? ";
   cin >> num_threads;
   thread_ids = new pthread_t[num_threads];

   cout << "Displaying" << endl;

   // generate threads 
   for (int i = 0; i < num_threads; i++)
   {
      int *arg = new int;
      *arg = i;
      if( pthread_create(&thread_ids[i],NULL,say_it,arg) > 0)
      {
            perror("creating thread:");
            return 2;
      }
   }

   // join threads and print their return values
   for (int i = 0; i < num_threads; i++)
   {
      if (pthread_join(thread_ids[i], &p_status) != 0)
      {
         perror("trouble joining thread: ");
         return 3;
      }
      cout << "Thread " << i << ": " << (char *)p_status << endl;

      delete [] (char *)p_status;
   }

   delete [] thread_ids;

   return 0;
}

// Build a message and return it at exit
void * say_it(void *num)
{
   int t_num = *(int *)num;
   char *msg = new char[255];
   cout << "Building message for thread" << t_num << endl;
   sleep(1);

   snprintf(msg, 255, "My thread id was %X. Goodbye...", pthread_self());
   return msg;
}
