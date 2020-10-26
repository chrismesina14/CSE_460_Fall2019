/***********************************************************************************************
 * Christian Mesina
 * pc.c
 * 11/05/2019
 * This program is called the Producer-Consumer Problem where the producer generates a data
 * element to be sent to the buffer while the consumer consume a data element from the buffer.
 **********************************************************************************************/
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

#define TRUE 1
#define BUFFER_SIZE 5
#define LOOPS 10

/* The mutex lock */
pthread_mutex_t mutex;

/* the semaphores */
sem_t full, empty;

/* the buffer */
int buffer[BUFFER_SIZE];

/* buffer counter */
int in, out;

pthread_t tid;       //Thread ID
pthread_attr_t attr; //Set of thread attributes

void *producer(void *param); /* the producer thread */
void *consumer(void *param); /* the consumer thread */

void initializeData() {

   /* Create the mutex lock */
   pthread_mutex_init(&mutex, NULL);

   /* Create the full semaphore and initialize to 0 */
   sem_init(&full, 0, 0);

   /* Create the empty semaphore and initialize to BUFFER_SIZE */
   sem_init(&empty, 0, BUFFER_SIZE);

   /* Get the default attributes */
   pthread_attr_init(&attr);

   /* init buffer */
   in = 0;
   out = 0;
}

/* Producer Thread */
void *producer(void *param) {
   int item;
   int i = 0;

   while(i < LOOPS)
   {
      /* generate a random number */
      item = rand()%1000;

      /* acquire the empty lock */
      sem_wait(&empty);
      /* acquire the mutex lock */
      pthread_mutex_lock(&mutex);

      if ((in + 1)%BUFFER_SIZE == out)
      {
      	printf("Error the buffer is full \n");
      }
      else
      { 
      	/* produce an item and add it in the buffer*/	  
      	buffer[in] = item;
      	in = ((in + 1) % BUFFER_SIZE);
      	printf("Producer [%lu] produced %d\n", pthread_self(), item);
      }
      i++;
      /* release the mutex lock */
      pthread_mutex_unlock(&mutex);
      /* signal full */
      sem_post(&full);
   }
}

/* Consumer Thread */
void *consumer(void *param) {
   int item;
   int i = 0;
   
   while(i < LOOPS) 
   {
      /* aquire the full lock */
      sem_wait(&full);
      /* aquire the mutex lock */
      pthread_mutex_lock(&mutex);
      
      if (in == out)
      {
      	printf("Error the buffer is empty \n");
      }
      else
      { 
      	/* consume an item and remove it from the buffer*/
        item = buffer[out];
        out = ((out + 1) % BUFFER_SIZE);
        printf("\tConsumer [%lu] consumed %d\n", pthread_self(), item);
      }
	  i++;      
      /* release the mutex lock */
      pthread_mutex_unlock(&mutex);
      /* signal empty */
      sem_post(&empty);
   }
}

int main(int argc, char *argv[]) {
   /* Loop counter */
   int i;

   /* Verify the correct number of arguments were passed in */
   if(argc != 3) {
      fprintf(stderr, "USAGE:./pc  \n");
   }

   int numProd = atoi(argv[1]); /* Number of producer threads */
   int numCons = atoi(argv[2]); /* Number of consumer threads */

   /* Initialize the app */
   initializeData();

   /* Create the producer threads */
   for(i = 0; i < numProd; i++) {
      /* Create the thread */
      pthread_create(&tid,&attr,producer, NULL);
    }

   /* Create the consumer threads */
   for(i = 0; i < numCons; i++) {
      /* Create the thread */
      pthread_create(&tid,&attr,consumer, NULL);
   }

   /* Sleep for the specified amount of time */
   sleep(1);

   /* Exit the program */
   printf("Exit the program\n");
   exit(0);
}
