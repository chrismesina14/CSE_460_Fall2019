#include <iostream>
#include "functions.h"

int main ()
{
    int array[100];
    int max = 0;
    int size = 0;

    cout << "How big is the array? ";
    cin >> size;
    if (initialize (array, size) != 0 )
    {
        cout << "initialization error\n";
        return 1;
    }

    max = find_max(array, size, max);

    if (find_max (array, size, max) == 0 )
    {
        cout << "some function error\n";
        return 1;
    }
    cout << "max value in array is: " << max;
	cout << endl;

    return 0;
}

