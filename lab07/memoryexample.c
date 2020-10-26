#include <stdio.h>
#include <stdlib.h>   //needed for exit()
#include <string.h>
#include <sys/types.h>
#include <unistd.h>

#define SHOW_ADDRESS(ID, I) printf("The id %s \t is at:%8X\n", ID, &I)

extern int etext, edata, end;

char *cptr = "Hello World\n"; // static by placement
char buffer1[25];

int main(void) 
{
    void showit(char *); // function prototype
    int i=0; //automatic variable, display segment adr


    printf("Adr etext: %8X\t Adr edata: %8X\t Adr end: %8X\n\n",
            &etext, &edata, &end);

    // display some addresses
    SHOW_ADDRESS("main", main); 
    SHOW_ADDRESS("showit", showit);
    SHOW_ADDRESS("cptr", cptr);
    SHOW_ADDRESS("buffer1", buffer1);
    SHOW_ADDRESS("i", i);
    strcpy(buffer1, "A demonstration\n");   // library function
    write(1, buffer1, strlen(buffer1) + 1); // system call 
    for (; i<1; ++i)
        showit(cptr); /* function call */

    return 0;
}


void showit(char *p) 
{
    char *buffer2;
    SHOW_ADDRESS("buffer2", buffer2);
    buffer2 = (char *)malloc(strlen(p)+1);
    if (buffer2 != NULL) 
    {
        strcpy(buffer2, p);    // copy the string
        printf("%s", buffer2); // display the string
        free(buffer2);         // release location
    }
    else 
    {
        printf("Allocation error.\n");
        exit(1);
    }
}
