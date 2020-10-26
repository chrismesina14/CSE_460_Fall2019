#include <cstdlib>
#include <time.h>
#include "functions.h"


/* FUNCTION: initialize
 * This function should initialize the array 
 * to random values between 1 and 500
 *
 * The arguments are:
 *     array: pointer to an array of integer values
 *     length: size of array
 *
 * It returns:
 *     0: on success
 *     non-zero: on an error
 */
int initialize (int* array, int length)
{
    srand(time(0));
	int i;

    for (i = 0; i < length; i ++)
    {
        array [i] = rand()%100 + 1;
    }
  
    return 0;
}

/* FUNCTION: find_max
 * This function should find the largest element in the array and
 * return it through the argument max.
 *
 * The arguments are:
 *     array: pointer to an array of integer values
 *     length: size of array
 *     max: set to the largest value in array 
 *
 * It returns:
 *     0: on success
 *     non-zero: on an error
 */
int find_max (int* array, int length, int max)
{
    int i;

    max = array [0];
    for (i = 1; i < length; i ++)
    {
        if (max < array [i])
        { 
            max = array [i];
        }
    }

    return max;
}
