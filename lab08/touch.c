#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
    int n = argc;
    for(int i = 1; i < n; i++)
    {
        open(argv[i], O_CREATE|O_RDWR);
    }
}
