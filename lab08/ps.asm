
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
  cps();
   6:	e8 06 03 00 00       	call   311 <cps>
  nps();
   b:	e8 09 03 00 00       	call   319 <nps>

  exit();
  10:	e8 5c 02 00 00       	call   271 <exit>
  15:	66 90                	xchg   %ax,%ax
  17:	66 90                	xchg   %ax,%ax
  19:	66 90                	xchg   %ax,%ax
  1b:	66 90                	xchg   %ax,%ax
  1d:	66 90                	xchg   %ax,%ax
  1f:	90                   	nop

00000020 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  20:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  21:	31 d2                	xor    %edx,%edx
{
  23:	89 e5                	mov    %esp,%ebp
  25:	53                   	push   %ebx
  26:	8b 45 08             	mov    0x8(%ebp),%eax
  29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  37:	83 c2 01             	add    $0x1,%edx
  3a:	84 c9                	test   %cl,%cl
  3c:	75 f2                	jne    30 <strcpy+0x10>
    ;
  return os;
}
  3e:	5b                   	pop    %ebx
  3f:	5d                   	pop    %ebp
  40:	c3                   	ret    
  41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  4f:	90                   	nop

00000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	56                   	push   %esi
  54:	53                   	push   %ebx
  55:	8b 5d 08             	mov    0x8(%ebp),%ebx
  58:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
  5b:	0f b6 13             	movzbl (%ebx),%edx
  5e:	0f b6 0e             	movzbl (%esi),%ecx
  61:	84 d2                	test   %dl,%dl
  63:	74 1e                	je     83 <strcmp+0x33>
  65:	b8 01 00 00 00       	mov    $0x1,%eax
  6a:	38 ca                	cmp    %cl,%dl
  6c:	74 09                	je     77 <strcmp+0x27>
  6e:	eb 20                	jmp    90 <strcmp+0x40>
  70:	83 c0 01             	add    $0x1,%eax
  73:	38 ca                	cmp    %cl,%dl
  75:	75 19                	jne    90 <strcmp+0x40>
  77:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  7b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
  7f:	84 d2                	test   %dl,%dl
  81:	75 ed                	jne    70 <strcmp+0x20>
  83:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
  85:	5b                   	pop    %ebx
  86:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
  87:	29 c8                	sub    %ecx,%eax
}
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    
  8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8f:	90                   	nop
  90:	0f b6 c2             	movzbl %dl,%eax
  93:	5b                   	pop    %ebx
  94:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
  95:	29 c8                	sub    %ecx,%eax
}
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    
  99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000000a0 <strlen>:

uint
strlen(char *s)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a6:	80 39 00             	cmpb   $0x0,(%ecx)
  a9:	74 15                	je     c0 <strlen+0x20>
  ab:	31 d2                	xor    %edx,%edx
  ad:	8d 76 00             	lea    0x0(%esi),%esi
  b0:	83 c2 01             	add    $0x1,%edx
  b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  b7:	89 d0                	mov    %edx,%eax
  b9:	75 f5                	jne    b0 <strlen+0x10>
    ;
  return n;
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    
  bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
  c0:	31 c0                	xor    %eax,%eax
}
  c2:	5d                   	pop    %ebp
  c3:	c3                   	ret    
  c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  cf:	90                   	nop

000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	57                   	push   %edi
  d4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	89 d7                	mov    %edx,%edi
  df:	fc                   	cld    
  e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e2:	89 d0                	mov    %edx,%eax
  e4:	5f                   	pop    %edi
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ee:	66 90                	xchg   %ax,%ax

000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	53                   	push   %ebx
  f4:	8b 45 08             	mov    0x8(%ebp),%eax
  f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
  fa:	0f b6 18             	movzbl (%eax),%ebx
  fd:	84 db                	test   %bl,%bl
  ff:	74 1d                	je     11e <strchr+0x2e>
 101:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 103:	38 d3                	cmp    %dl,%bl
 105:	75 0d                	jne    114 <strchr+0x24>
 107:	eb 17                	jmp    120 <strchr+0x30>
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 110:	38 ca                	cmp    %cl,%dl
 112:	74 0c                	je     120 <strchr+0x30>
  for(; *s; s++)
 114:	83 c0 01             	add    $0x1,%eax
 117:	0f b6 10             	movzbl (%eax),%edx
 11a:	84 d2                	test   %dl,%dl
 11c:	75 f2                	jne    110 <strchr+0x20>
      return (char*)s;
  return 0;
 11e:	31 c0                	xor    %eax,%eax
}
 120:	5b                   	pop    %ebx
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    
 123:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 135:	31 f6                	xor    %esi,%esi
{
 137:	53                   	push   %ebx
 138:	89 f3                	mov    %esi,%ebx
 13a:	83 ec 1c             	sub    $0x1c,%esp
 13d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 140:	eb 2f                	jmp    171 <gets+0x41>
 142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 148:	83 ec 04             	sub    $0x4,%esp
 14b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 14e:	6a 01                	push   $0x1
 150:	50                   	push   %eax
 151:	6a 00                	push   $0x0
 153:	e8 31 01 00 00       	call   289 <read>
    if(cc < 1)
 158:	83 c4 10             	add    $0x10,%esp
 15b:	85 c0                	test   %eax,%eax
 15d:	7e 1c                	jle    17b <gets+0x4b>
      break;
    buf[i++] = c;
 15f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 163:	83 c7 01             	add    $0x1,%edi
 166:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 169:	3c 0a                	cmp    $0xa,%al
 16b:	74 23                	je     190 <gets+0x60>
 16d:	3c 0d                	cmp    $0xd,%al
 16f:	74 1f                	je     190 <gets+0x60>
  for(i=0; i+1 < max; ){
 171:	83 c3 01             	add    $0x1,%ebx
 174:	89 fe                	mov    %edi,%esi
 176:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 179:	7c cd                	jl     148 <gets+0x18>
 17b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 180:	c6 03 00             	movb   $0x0,(%ebx)
}
 183:	8d 65 f4             	lea    -0xc(%ebp),%esp
 186:	5b                   	pop    %ebx
 187:	5e                   	pop    %esi
 188:	5f                   	pop    %edi
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    
 18b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 18f:	90                   	nop
 190:	8b 75 08             	mov    0x8(%ebp),%esi
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	01 de                	add    %ebx,%esi
 198:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 19a:	c6 03 00             	movb   $0x0,(%ebx)
}
 19d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1a0:	5b                   	pop    %ebx
 1a1:	5e                   	pop    %esi
 1a2:	5f                   	pop    %edi
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    
 1a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001b0 <stat>:

int
stat(char *n, struct stat *st)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	56                   	push   %esi
 1b4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	6a 00                	push   $0x0
 1ba:	ff 75 08             	pushl  0x8(%ebp)
 1bd:	e8 ef 00 00 00       	call   2b1 <open>
  if(fd < 0)
 1c2:	83 c4 10             	add    $0x10,%esp
 1c5:	85 c0                	test   %eax,%eax
 1c7:	78 27                	js     1f0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	ff 75 0c             	pushl  0xc(%ebp)
 1cf:	89 c3                	mov    %eax,%ebx
 1d1:	50                   	push   %eax
 1d2:	e8 f2 00 00 00       	call   2c9 <fstat>
  close(fd);
 1d7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1da:	89 c6                	mov    %eax,%esi
  close(fd);
 1dc:	e8 b8 00 00 00       	call   299 <close>
  return r;
 1e1:	83 c4 10             	add    $0x10,%esp
}
 1e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1e7:	89 f0                	mov    %esi,%eax
 1e9:	5b                   	pop    %ebx
 1ea:	5e                   	pop    %esi
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret    
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 1f0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1f5:	eb ed                	jmp    1e4 <stat+0x34>
 1f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fe:	66 90                	xchg   %ax,%ax

00000200 <atoi>:

int
atoi(const char *s)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	53                   	push   %ebx
 204:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 207:	0f be 11             	movsbl (%ecx),%edx
 20a:	8d 42 d0             	lea    -0x30(%edx),%eax
 20d:	3c 09                	cmp    $0x9,%al
  n = 0;
 20f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 214:	77 1f                	ja     235 <atoi+0x35>
 216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 21d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 220:	83 c1 01             	add    $0x1,%ecx
 223:	8d 04 80             	lea    (%eax,%eax,4),%eax
 226:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 22a:	0f be 11             	movsbl (%ecx),%edx
 22d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 230:	80 fb 09             	cmp    $0x9,%bl
 233:	76 eb                	jbe    220 <atoi+0x20>
  return n;
}
 235:	5b                   	pop    %ebx
 236:	5d                   	pop    %ebp
 237:	c3                   	ret    
 238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop

00000240 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	57                   	push   %edi
 244:	8b 55 10             	mov    0x10(%ebp),%edx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	56                   	push   %esi
 24b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 24e:	85 d2                	test   %edx,%edx
 250:	7e 13                	jle    265 <memmove+0x25>
 252:	01 c2                	add    %eax,%edx
  dst = vdst;
 254:	89 c7                	mov    %eax,%edi
 256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 260:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 261:	39 fa                	cmp    %edi,%edx
 263:	75 fb                	jne    260 <memmove+0x20>
  return vdst;
}
 265:	5e                   	pop    %esi
 266:	5f                   	pop    %edi
 267:	5d                   	pop    %ebp
 268:	c3                   	ret    

00000269 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 269:	b8 01 00 00 00       	mov    $0x1,%eax
 26e:	cd 40                	int    $0x40
 270:	c3                   	ret    

00000271 <exit>:
SYSCALL(exit)
 271:	b8 02 00 00 00       	mov    $0x2,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <wait>:
SYSCALL(wait)
 279:	b8 03 00 00 00       	mov    $0x3,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <pipe>:
SYSCALL(pipe)
 281:	b8 04 00 00 00       	mov    $0x4,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <read>:
SYSCALL(read)
 289:	b8 05 00 00 00       	mov    $0x5,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <write>:
SYSCALL(write)
 291:	b8 10 00 00 00       	mov    $0x10,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <close>:
SYSCALL(close)
 299:	b8 15 00 00 00       	mov    $0x15,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <kill>:
SYSCALL(kill)
 2a1:	b8 06 00 00 00       	mov    $0x6,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <exec>:
SYSCALL(exec)
 2a9:	b8 07 00 00 00       	mov    $0x7,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <open>:
SYSCALL(open)
 2b1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <mknod>:
SYSCALL(mknod)
 2b9:	b8 11 00 00 00       	mov    $0x11,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <unlink>:
SYSCALL(unlink)
 2c1:	b8 12 00 00 00       	mov    $0x12,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <fstat>:
SYSCALL(fstat)
 2c9:	b8 08 00 00 00       	mov    $0x8,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <link>:
SYSCALL(link)
 2d1:	b8 13 00 00 00       	mov    $0x13,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <mkdir>:
SYSCALL(mkdir)
 2d9:	b8 14 00 00 00       	mov    $0x14,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <chdir>:
SYSCALL(chdir)
 2e1:	b8 09 00 00 00       	mov    $0x9,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <dup>:
SYSCALL(dup)
 2e9:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <getpid>:
SYSCALL(getpid)
 2f1:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <sbrk>:
SYSCALL(sbrk)
 2f9:	b8 0c 00 00 00       	mov    $0xc,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <sleep>:
SYSCALL(sleep)
 301:	b8 0d 00 00 00       	mov    $0xd,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <uptime>:
SYSCALL(uptime)
 309:	b8 0e 00 00 00       	mov    $0xe,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <cps>:
SYSCALL(cps)
 311:	b8 16 00 00 00       	mov    $0x16,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <nps>:
SYSCALL(nps)
 319:	b8 17 00 00 00       	mov    $0x17,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <chpr>:
SYSCALL(chpr)
 321:	b8 18 00 00 00       	mov    $0x18,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <pfs>:
SYSCALL(pfs)
 329:	b8 19 00 00 00       	mov    $0x19,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    
 331:	66 90                	xchg   %ax,%ax
 333:	66 90                	xchg   %ax,%ax
 335:	66 90                	xchg   %ax,%ax
 337:	66 90                	xchg   %ax,%ax
 339:	66 90                	xchg   %ax,%ax
 33b:	66 90                	xchg   %ax,%ax
 33d:	66 90                	xchg   %ax,%ax
 33f:	90                   	nop

00000340 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	56                   	push   %esi
 345:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 346:	89 d3                	mov    %edx,%ebx
{
 348:	83 ec 3c             	sub    $0x3c,%esp
 34b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 34e:	85 d2                	test   %edx,%edx
 350:	0f 89 92 00 00 00    	jns    3e8 <printint+0xa8>
 356:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 35a:	0f 84 88 00 00 00    	je     3e8 <printint+0xa8>
    neg = 1;
 360:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 367:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 369:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 370:	8d 75 d7             	lea    -0x29(%ebp),%esi
 373:	eb 08                	jmp    37d <printint+0x3d>
 375:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 378:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 37b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 37d:	89 d8                	mov    %ebx,%eax
 37f:	31 d2                	xor    %edx,%edx
 381:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 384:	f7 f1                	div    %ecx
 386:	83 c7 01             	add    $0x1,%edi
 389:	0f b6 92 70 07 00 00 	movzbl 0x770(%edx),%edx
 390:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 393:	39 d9                	cmp    %ebx,%ecx
 395:	76 e1                	jbe    378 <printint+0x38>
  if(neg)
 397:	8b 45 c0             	mov    -0x40(%ebp),%eax
 39a:	85 c0                	test   %eax,%eax
 39c:	74 0d                	je     3ab <printint+0x6b>
    buf[i++] = '-';
 39e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 3a3:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 3a8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 3ab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 3ae:	8b 7d bc             	mov    -0x44(%ebp),%edi
 3b1:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3b5:	eb 0f                	jmp    3c6 <printint+0x86>
 3b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3be:	66 90                	xchg   %ax,%ax
 3c0:	0f b6 13             	movzbl (%ebx),%edx
 3c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 3c6:	83 ec 04             	sub    $0x4,%esp
 3c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3cc:	6a 01                	push   $0x1
 3ce:	56                   	push   %esi
 3cf:	57                   	push   %edi
 3d0:	e8 bc fe ff ff       	call   291 <write>

  while(--i >= 0)
 3d5:	83 c4 10             	add    $0x10,%esp
 3d8:	39 de                	cmp    %ebx,%esi
 3da:	75 e4                	jne    3c0 <printint+0x80>
    putc(fd, buf[i]);
}
 3dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3df:	5b                   	pop    %ebx
 3e0:	5e                   	pop    %esi
 3e1:	5f                   	pop    %edi
 3e2:	5d                   	pop    %ebp
 3e3:	c3                   	ret    
 3e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3e8:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 3ef:	e9 75 ff ff ff       	jmp    369 <printint+0x29>
 3f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

00000400 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 409:	8b 75 0c             	mov    0xc(%ebp),%esi
 40c:	0f b6 1e             	movzbl (%esi),%ebx
 40f:	84 db                	test   %bl,%bl
 411:	0f 84 b9 00 00 00    	je     4d0 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 417:	8d 45 10             	lea    0x10(%ebp),%eax
 41a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 41d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 420:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 422:	89 45 d0             	mov    %eax,-0x30(%ebp)
 425:	eb 38                	jmp    45f <printf+0x5f>
 427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42e:	66 90                	xchg   %ax,%ax
 430:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 433:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 438:	83 f8 25             	cmp    $0x25,%eax
 43b:	74 17                	je     454 <printf+0x54>
  write(fd, &c, 1);
 43d:	83 ec 04             	sub    $0x4,%esp
 440:	88 5d e7             	mov    %bl,-0x19(%ebp)
 443:	6a 01                	push   $0x1
 445:	57                   	push   %edi
 446:	ff 75 08             	pushl  0x8(%ebp)
 449:	e8 43 fe ff ff       	call   291 <write>
 44e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 451:	83 c4 10             	add    $0x10,%esp
 454:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 457:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 45b:	84 db                	test   %bl,%bl
 45d:	74 71                	je     4d0 <printf+0xd0>
    c = fmt[i] & 0xff;
 45f:	0f be cb             	movsbl %bl,%ecx
 462:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 465:	85 d2                	test   %edx,%edx
 467:	74 c7                	je     430 <printf+0x30>
      }
    } else if(state == '%'){
 469:	83 fa 25             	cmp    $0x25,%edx
 46c:	75 e6                	jne    454 <printf+0x54>
      if(c == 'd'){
 46e:	83 f8 64             	cmp    $0x64,%eax
 471:	0f 84 99 00 00 00    	je     510 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 477:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 47d:	83 f9 70             	cmp    $0x70,%ecx
 480:	74 5e                	je     4e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 482:	83 f8 73             	cmp    $0x73,%eax
 485:	0f 84 d5 00 00 00    	je     560 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 48b:	83 f8 63             	cmp    $0x63,%eax
 48e:	0f 84 8c 00 00 00    	je     520 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 494:	83 f8 25             	cmp    $0x25,%eax
 497:	0f 84 b3 00 00 00    	je     550 <printf+0x150>
  write(fd, &c, 1);
 49d:	83 ec 04             	sub    $0x4,%esp
 4a0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4a4:	6a 01                	push   $0x1
 4a6:	57                   	push   %edi
 4a7:	ff 75 08             	pushl  0x8(%ebp)
 4aa:	e8 e2 fd ff ff       	call   291 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4af:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4b2:	83 c4 0c             	add    $0xc,%esp
 4b5:	6a 01                	push   $0x1
 4b7:	83 c6 01             	add    $0x1,%esi
 4ba:	57                   	push   %edi
 4bb:	ff 75 08             	pushl  0x8(%ebp)
 4be:	e8 ce fd ff ff       	call   291 <write>
  for(i = 0; fmt[i]; i++){
 4c3:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 4c7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4ca:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4cc:	84 db                	test   %bl,%bl
 4ce:	75 8f                	jne    45f <printf+0x5f>
    }
  }
}
 4d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d3:	5b                   	pop    %ebx
 4d4:	5e                   	pop    %esi
 4d5:	5f                   	pop    %edi
 4d6:	5d                   	pop    %ebp
 4d7:	c3                   	ret    
 4d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop
        printint(fd, *ap, 16, 0);
 4e0:	83 ec 0c             	sub    $0xc,%esp
 4e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4e8:	6a 00                	push   $0x0
 4ea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
 4f0:	8b 13                	mov    (%ebx),%edx
 4f2:	e8 49 fe ff ff       	call   340 <printint>
        ap++;
 4f7:	89 d8                	mov    %ebx,%eax
 4f9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4fc:	31 d2                	xor    %edx,%edx
        ap++;
 4fe:	83 c0 04             	add    $0x4,%eax
 501:	89 45 d0             	mov    %eax,-0x30(%ebp)
 504:	e9 4b ff ff ff       	jmp    454 <printf+0x54>
 509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 510:	83 ec 0c             	sub    $0xc,%esp
 513:	b9 0a 00 00 00       	mov    $0xa,%ecx
 518:	6a 01                	push   $0x1
 51a:	eb ce                	jmp    4ea <printf+0xea>
 51c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 520:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 523:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 526:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 528:	6a 01                	push   $0x1
        ap++;
 52a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 52d:	57                   	push   %edi
 52e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 531:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 534:	e8 58 fd ff ff       	call   291 <write>
        ap++;
 539:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 53c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 53f:	31 d2                	xor    %edx,%edx
 541:	e9 0e ff ff ff       	jmp    454 <printf+0x54>
 546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 550:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 553:	83 ec 04             	sub    $0x4,%esp
 556:	e9 5a ff ff ff       	jmp    4b5 <printf+0xb5>
 55b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 55f:	90                   	nop
        s = (char*)*ap;
 560:	8b 45 d0             	mov    -0x30(%ebp),%eax
 563:	8b 18                	mov    (%eax),%ebx
        ap++;
 565:	83 c0 04             	add    $0x4,%eax
 568:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 56b:	85 db                	test   %ebx,%ebx
 56d:	74 17                	je     586 <printf+0x186>
        while(*s != 0){
 56f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 572:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 574:	84 c0                	test   %al,%al
 576:	0f 84 d8 fe ff ff    	je     454 <printf+0x54>
 57c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 57f:	89 de                	mov    %ebx,%esi
 581:	8b 5d 08             	mov    0x8(%ebp),%ebx
 584:	eb 1a                	jmp    5a0 <printf+0x1a0>
          s = "(null)";
 586:	bb 68 07 00 00       	mov    $0x768,%ebx
        while(*s != 0){
 58b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 58e:	b8 28 00 00 00       	mov    $0x28,%eax
 593:	89 de                	mov    %ebx,%esi
 595:	8b 5d 08             	mov    0x8(%ebp),%ebx
 598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59f:	90                   	nop
  write(fd, &c, 1);
 5a0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5a3:	83 c6 01             	add    $0x1,%esi
 5a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5a9:	6a 01                	push   $0x1
 5ab:	57                   	push   %edi
 5ac:	53                   	push   %ebx
 5ad:	e8 df fc ff ff       	call   291 <write>
        while(*s != 0){
 5b2:	0f b6 06             	movzbl (%esi),%eax
 5b5:	83 c4 10             	add    $0x10,%esp
 5b8:	84 c0                	test   %al,%al
 5ba:	75 e4                	jne    5a0 <printf+0x1a0>
 5bc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5bf:	31 d2                	xor    %edx,%edx
 5c1:	e9 8e fe ff ff       	jmp    454 <printf+0x54>
 5c6:	66 90                	xchg   %ax,%ax
 5c8:	66 90                	xchg   %ax,%ax
 5ca:	66 90                	xchg   %ax,%ax
 5cc:	66 90                	xchg   %ax,%ax
 5ce:	66 90                	xchg   %ax,%ax

000005d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 10 0a 00 00       	mov    0xa10,%eax
{
 5d6:	89 e5                	mov    %esp,%ebp
 5d8:	57                   	push   %edi
 5d9:	56                   	push   %esi
 5da:	53                   	push   %ebx
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5de:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 5e0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e3:	39 c8                	cmp    %ecx,%eax
 5e5:	73 19                	jae    600 <free+0x30>
 5e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ee:	66 90                	xchg   %ax,%ax
 5f0:	39 d1                	cmp    %edx,%ecx
 5f2:	72 14                	jb     608 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f4:	39 d0                	cmp    %edx,%eax
 5f6:	73 10                	jae    608 <free+0x38>
{
 5f8:	89 d0                	mov    %edx,%eax
 5fa:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fc:	39 c8                	cmp    %ecx,%eax
 5fe:	72 f0                	jb     5f0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 600:	39 d0                	cmp    %edx,%eax
 602:	72 f4                	jb     5f8 <free+0x28>
 604:	39 d1                	cmp    %edx,%ecx
 606:	73 f0                	jae    5f8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 608:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 60e:	39 fa                	cmp    %edi,%edx
 610:	74 1e                	je     630 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 612:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 615:	8b 50 04             	mov    0x4(%eax),%edx
 618:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61b:	39 f1                	cmp    %esi,%ecx
 61d:	74 28                	je     647 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 61f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 621:	5b                   	pop    %ebx
  freep = p;
 622:	a3 10 0a 00 00       	mov    %eax,0xa10
}
 627:	5e                   	pop    %esi
 628:	5f                   	pop    %edi
 629:	5d                   	pop    %ebp
 62a:	c3                   	ret    
 62b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 62f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 630:	03 72 04             	add    0x4(%edx),%esi
 633:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 636:	8b 10                	mov    (%eax),%edx
 638:	8b 12                	mov    (%edx),%edx
 63a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 63d:	8b 50 04             	mov    0x4(%eax),%edx
 640:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 643:	39 f1                	cmp    %esi,%ecx
 645:	75 d8                	jne    61f <free+0x4f>
    p->s.size += bp->s.size;
 647:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 64a:	a3 10 0a 00 00       	mov    %eax,0xa10
    p->s.size += bp->s.size;
 64f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 652:	8b 53 f8             	mov    -0x8(%ebx),%edx
 655:	89 10                	mov    %edx,(%eax)
}
 657:	5b                   	pop    %ebx
 658:	5e                   	pop    %esi
 659:	5f                   	pop    %edi
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret    
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000660 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 669:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 66c:	8b 3d 10 0a 00 00    	mov    0xa10,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 672:	8d 70 07             	lea    0x7(%eax),%esi
 675:	c1 ee 03             	shr    $0x3,%esi
 678:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 67b:	85 ff                	test   %edi,%edi
 67d:	0f 84 ad 00 00 00    	je     730 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 683:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 685:	8b 4a 04             	mov    0x4(%edx),%ecx
 688:	39 f1                	cmp    %esi,%ecx
 68a:	73 72                	jae    6fe <malloc+0x9e>
 68c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 692:	bb 00 10 00 00       	mov    $0x1000,%ebx
 697:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 69a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6a4:	eb 1b                	jmp    6c1 <malloc+0x61>
 6a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6b2:	8b 48 04             	mov    0x4(%eax),%ecx
 6b5:	39 f1                	cmp    %esi,%ecx
 6b7:	73 4f                	jae    708 <malloc+0xa8>
 6b9:	8b 3d 10 0a 00 00    	mov    0xa10,%edi
 6bf:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6c1:	39 d7                	cmp    %edx,%edi
 6c3:	75 eb                	jne    6b0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 6c5:	83 ec 0c             	sub    $0xc,%esp
 6c8:	ff 75 e4             	pushl  -0x1c(%ebp)
 6cb:	e8 29 fc ff ff       	call   2f9 <sbrk>
  if(p == (char*)-1)
 6d0:	83 c4 10             	add    $0x10,%esp
 6d3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6d6:	74 1c                	je     6f4 <malloc+0x94>
  hp->s.size = nu;
 6d8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6db:	83 ec 0c             	sub    $0xc,%esp
 6de:	83 c0 08             	add    $0x8,%eax
 6e1:	50                   	push   %eax
 6e2:	e8 e9 fe ff ff       	call   5d0 <free>
  return freep;
 6e7:	8b 15 10 0a 00 00    	mov    0xa10,%edx
      if((p = morecore(nunits)) == 0)
 6ed:	83 c4 10             	add    $0x10,%esp
 6f0:	85 d2                	test   %edx,%edx
 6f2:	75 bc                	jne    6b0 <malloc+0x50>
        return 0;
  }
}
 6f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 6f7:	31 c0                	xor    %eax,%eax
}
 6f9:	5b                   	pop    %ebx
 6fa:	5e                   	pop    %esi
 6fb:	5f                   	pop    %edi
 6fc:	5d                   	pop    %ebp
 6fd:	c3                   	ret    
    if(p->s.size >= nunits){
 6fe:	89 d0                	mov    %edx,%eax
 700:	89 fa                	mov    %edi,%edx
 702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 708:	39 ce                	cmp    %ecx,%esi
 70a:	74 54                	je     760 <malloc+0x100>
        p->s.size -= nunits;
 70c:	29 f1                	sub    %esi,%ecx
 70e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 711:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 714:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 717:	89 15 10 0a 00 00    	mov    %edx,0xa10
}
 71d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 720:	83 c0 08             	add    $0x8,%eax
}
 723:	5b                   	pop    %ebx
 724:	5e                   	pop    %esi
 725:	5f                   	pop    %edi
 726:	5d                   	pop    %ebp
 727:	c3                   	ret    
 728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 730:	c7 05 10 0a 00 00 14 	movl   $0xa14,0xa10
 737:	0a 00 00 
    base.s.size = 0;
 73a:	bf 14 0a 00 00       	mov    $0xa14,%edi
    base.s.ptr = freep = prevp = &base;
 73f:	c7 05 14 0a 00 00 14 	movl   $0xa14,0xa14
 746:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 749:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 74b:	c7 05 18 0a 00 00 00 	movl   $0x0,0xa18
 752:	00 00 00 
    if(p->s.size >= nunits){
 755:	e9 32 ff ff ff       	jmp    68c <malloc+0x2c>
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 760:	8b 08                	mov    (%eax),%ecx
 762:	89 0a                	mov    %ecx,(%edx)
 764:	eb b1                	jmp    717 <malloc+0xb7>
