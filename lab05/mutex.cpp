#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <pthread.h>
#include <sys/types.h>
#include <unistd.h>

using namespace std;

pthread_mutex_t output_lock;

void * say_it( void * );

int main(int argc, char *argv[])
{
   int num_threads;
   pthread_t *thread_ids;
   void  *p_status;

   //Set up an output lock so that threads wait their turn to speak.
   if (pthread_mutex_init(&output_lock, NULL)!=0)
   {
      perror("Could not create mutex for output: ");
      return 1;
   }

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

      //Threads may still be building their return, so lock stdout
      if (pthread_mutex_lock(&output_lock) != 0)
      {
          perror("Could not lock output: ");
          return 4;
      }
      cout << "Thread " << i << ": " << (char *)p_status << endl;
      if (pthread_mutex_unlock(&output_lock) != 0)
      {
          perror("Could not unlock output: ");
          return 5;
      }

      delete [] (char *)p_status;
   }

   return 0;
}

// 
void * say_it(void *num)
{
   int t_num = *(int *)num;
   char *msg = new char[255];

   if (pthread_mutex_lock(&output_lock) != 0)
   {
       perror("Could not lock output: ");
       exit(4); //something horrible happened - exit whole program with error
   }
   cout << "Building message for thread" << t_num << endl;
   if (pthread_mutex_unlock(&output_lock) != 0)
   {
       perror("Could not unlock output: ");
       exit(5); //something horrible happened - exit whole program with error
   }

   snprintf(msg, 255, "My thread id was %X. Goodbye...", pthread_self());
   return msg;
}
