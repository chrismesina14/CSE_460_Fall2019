#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char buf[512];

int main(int argc, char *argv[])
{
  int fds, fdd, n;

  if(argc != 3)
  {
    printf(1, "cp SOURCE DEST");
    exit();
  }
  
  // open source file
  if((fds = open(argv[1], O_RDONLY)) < 0)
  {
      printf(1, "cp: cannot open %s\n", argv[1]);
      exit();
  }
  // open destination file
  if((fdd = open(argv[2], O_CREATE|O_RDWR)) < 0)
  {
      printf(1, "cp: cannot open %s\n", argv[2]);
      exit();
  }

  while ((n = read(fds, buf, sizeof(buf))) > 0 )
  { 
	write(fdd, buf, n);
  }
  close(fds);
  close(fdd);
  
  exit();
}
