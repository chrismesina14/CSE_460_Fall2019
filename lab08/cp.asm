
_cp:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fcntl.h"

char buf[512];

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  int fds, fdd, n;

  if(argc != 3)
  14:	83 39 03             	cmpl   $0x3,(%ecx)
{
  17:	8b 79 04             	mov    0x4(%ecx),%edi
  if(argc != 3)
  1a:	74 13                	je     2f <main+0x2f>
  {
    printf(1, "cp SOURCE DEST");
  1c:	56                   	push   %esi
  1d:	56                   	push   %esi
  1e:	68 18 08 00 00       	push   $0x818
  23:	6a 01                	push   $0x1
  25:	e8 86 04 00 00       	call   4b0 <printf>
    exit();
  2a:	e8 f2 02 00 00       	call   321 <exit>
  }
  
  // open source file
  if((fds = open(argv[1], O_RDONLY)) < 0)
  2f:	53                   	push   %ebx
  30:	53                   	push   %ebx
  31:	6a 00                	push   $0x0
  33:	ff 77 04             	pushl  0x4(%edi)
  36:	e8 26 03 00 00       	call   361 <open>
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	89 c3                	mov    %eax,%ebx
  40:	85 c0                	test   %eax,%eax
  42:	78 76                	js     ba <main+0xba>
  {
      printf(1, "cp: cannot open %s\n", argv[1]);
      exit();
  }
  // open destination file
  if((fdd = open(argv[2], O_CREATE|O_RDWR)) < 0)
  44:	52                   	push   %edx
  45:	52                   	push   %edx
  46:	68 02 02 00 00       	push   $0x202
  4b:	ff 77 08             	pushl  0x8(%edi)
  4e:	e8 0e 03 00 00       	call   361 <open>
  53:	83 c4 10             	add    $0x10,%esp
  56:	89 c6                	mov    %eax,%esi
  58:	85 c0                	test   %eax,%eax
  5a:	79 2e                	jns    8a <main+0x8a>
  {
      printf(1, "cp: cannot open %s\n", argv[2]);
  5c:	50                   	push   %eax
  5d:	ff 77 08             	pushl  0x8(%edi)
  60:	68 27 08 00 00       	push   $0x827
  65:	6a 01                	push   $0x1
  67:	e8 44 04 00 00       	call   4b0 <printf>
      exit();
  6c:	e8 b0 02 00 00       	call   321 <exit>
  71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  while ((n = read(fds, buf, sizeof(buf))) > 0 )
  { 
	write(fdd, buf, n);
  78:	83 ec 04             	sub    $0x4,%esp
  7b:	50                   	push   %eax
  7c:	68 20 0b 00 00       	push   $0xb20
  81:	56                   	push   %esi
  82:	e8 ba 02 00 00       	call   341 <write>
  87:	83 c4 10             	add    $0x10,%esp
  while ((n = read(fds, buf, sizeof(buf))) > 0 )
  8a:	83 ec 04             	sub    $0x4,%esp
  8d:	68 00 02 00 00       	push   $0x200
  92:	68 20 0b 00 00       	push   $0xb20
  97:	53                   	push   %ebx
  98:	e8 9c 02 00 00       	call   339 <read>
  9d:	83 c4 10             	add    $0x10,%esp
  a0:	85 c0                	test   %eax,%eax
  a2:	7f d4                	jg     78 <main+0x78>
  }
  close(fds);
  a4:	83 ec 0c             	sub    $0xc,%esp
  a7:	53                   	push   %ebx
  a8:	e8 9c 02 00 00       	call   349 <close>
  close(fdd);
  ad:	89 34 24             	mov    %esi,(%esp)
  b0:	e8 94 02 00 00       	call   349 <close>
  
  exit();
  b5:	e8 67 02 00 00       	call   321 <exit>
      printf(1, "cp: cannot open %s\n", argv[1]);
  ba:	51                   	push   %ecx
  bb:	ff 77 04             	pushl  0x4(%edi)
  be:	68 27 08 00 00       	push   $0x827
  c3:	6a 01                	push   $0x1
  c5:	e8 e6 03 00 00       	call   4b0 <printf>
      exit();
  ca:	e8 52 02 00 00       	call   321 <exit>
  cf:	90                   	nop

000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  d0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d1:	31 d2                	xor    %edx,%edx
{
  d3:	89 e5                	mov    %esp,%ebp
  d5:	53                   	push   %ebx
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  e7:	83 c2 01             	add    $0x1,%edx
  ea:	84 c9                	test   %cl,%cl
  ec:	75 f2                	jne    e0 <strcpy+0x10>
    ;
  return os;
}
  ee:	5b                   	pop    %ebx
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    
  f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff:	90                   	nop

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	56                   	push   %esi
 104:	53                   	push   %ebx
 105:	8b 5d 08             	mov    0x8(%ebp),%ebx
 108:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 10b:	0f b6 13             	movzbl (%ebx),%edx
 10e:	0f b6 0e             	movzbl (%esi),%ecx
 111:	84 d2                	test   %dl,%dl
 113:	74 1e                	je     133 <strcmp+0x33>
 115:	b8 01 00 00 00       	mov    $0x1,%eax
 11a:	38 ca                	cmp    %cl,%dl
 11c:	74 09                	je     127 <strcmp+0x27>
 11e:	eb 20                	jmp    140 <strcmp+0x40>
 120:	83 c0 01             	add    $0x1,%eax
 123:	38 ca                	cmp    %cl,%dl
 125:	75 19                	jne    140 <strcmp+0x40>
 127:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 12b:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 12f:	84 d2                	test   %dl,%dl
 131:	75 ed                	jne    120 <strcmp+0x20>
 133:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 135:	5b                   	pop    %ebx
 136:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 137:	29 c8                	sub    %ecx,%eax
}
 139:	5d                   	pop    %ebp
 13a:	c3                   	ret    
 13b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 13f:	90                   	nop
 140:	0f b6 c2             	movzbl %dl,%eax
 143:	5b                   	pop    %ebx
 144:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 145:	29 c8                	sub    %ecx,%eax
}
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000150 <strlen>:

uint
strlen(char *s)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 156:	80 39 00             	cmpb   $0x0,(%ecx)
 159:	74 15                	je     170 <strlen+0x20>
 15b:	31 d2                	xor    %edx,%edx
 15d:	8d 76 00             	lea    0x0(%esi),%esi
 160:	83 c2 01             	add    $0x1,%edx
 163:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 167:	89 d0                	mov    %edx,%eax
 169:	75 f5                	jne    160 <strlen+0x10>
    ;
  return n;
}
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret    
 16d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 170:	31 c0                	xor    %eax,%eax
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
 174:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop

00000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	57                   	push   %edi
 184:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 187:	8b 4d 10             	mov    0x10(%ebp),%ecx
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	89 d7                	mov    %edx,%edi
 18f:	fc                   	cld    
 190:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 192:	89 d0                	mov    %edx,%eax
 194:	5f                   	pop    %edi
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    
 197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19e:	66 90                	xchg   %ax,%ax

000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 1aa:	0f b6 18             	movzbl (%eax),%ebx
 1ad:	84 db                	test   %bl,%bl
 1af:	74 1d                	je     1ce <strchr+0x2e>
 1b1:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 1b3:	38 d3                	cmp    %dl,%bl
 1b5:	75 0d                	jne    1c4 <strchr+0x24>
 1b7:	eb 17                	jmp    1d0 <strchr+0x30>
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1c0:	38 ca                	cmp    %cl,%dl
 1c2:	74 0c                	je     1d0 <strchr+0x30>
  for(; *s; s++)
 1c4:	83 c0 01             	add    $0x1,%eax
 1c7:	0f b6 10             	movzbl (%eax),%edx
 1ca:	84 d2                	test   %dl,%dl
 1cc:	75 f2                	jne    1c0 <strchr+0x20>
      return (char*)s;
  return 0;
 1ce:	31 c0                	xor    %eax,%eax
}
 1d0:	5b                   	pop    %ebx
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001e0 <gets>:

char*
gets(char *buf, int max)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e5:	31 f6                	xor    %esi,%esi
{
 1e7:	53                   	push   %ebx
 1e8:	89 f3                	mov    %esi,%ebx
 1ea:	83 ec 1c             	sub    $0x1c,%esp
 1ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 1f0:	eb 2f                	jmp    221 <gets+0x41>
 1f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 1f8:	83 ec 04             	sub    $0x4,%esp
 1fb:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1fe:	6a 01                	push   $0x1
 200:	50                   	push   %eax
 201:	6a 00                	push   $0x0
 203:	e8 31 01 00 00       	call   339 <read>
    if(cc < 1)
 208:	83 c4 10             	add    $0x10,%esp
 20b:	85 c0                	test   %eax,%eax
 20d:	7e 1c                	jle    22b <gets+0x4b>
      break;
    buf[i++] = c;
 20f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 213:	83 c7 01             	add    $0x1,%edi
 216:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 219:	3c 0a                	cmp    $0xa,%al
 21b:	74 23                	je     240 <gets+0x60>
 21d:	3c 0d                	cmp    $0xd,%al
 21f:	74 1f                	je     240 <gets+0x60>
  for(i=0; i+1 < max; ){
 221:	83 c3 01             	add    $0x1,%ebx
 224:	89 fe                	mov    %edi,%esi
 226:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 229:	7c cd                	jl     1f8 <gets+0x18>
 22b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 230:	c6 03 00             	movb   $0x0,(%ebx)
}
 233:	8d 65 f4             	lea    -0xc(%ebp),%esp
 236:	5b                   	pop    %ebx
 237:	5e                   	pop    %esi
 238:	5f                   	pop    %edi
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    
 23b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop
 240:	8b 75 08             	mov    0x8(%ebp),%esi
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	01 de                	add    %ebx,%esi
 248:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 24a:	c6 03 00             	movb   $0x0,(%ebx)
}
 24d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 250:	5b                   	pop    %ebx
 251:	5e                   	pop    %esi
 252:	5f                   	pop    %edi
 253:	5d                   	pop    %ebp
 254:	c3                   	ret    
 255:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000260 <stat>:

int
stat(char *n, struct stat *st)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	56                   	push   %esi
 264:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 265:	83 ec 08             	sub    $0x8,%esp
 268:	6a 00                	push   $0x0
 26a:	ff 75 08             	pushl  0x8(%ebp)
 26d:	e8 ef 00 00 00       	call   361 <open>
  if(fd < 0)
 272:	83 c4 10             	add    $0x10,%esp
 275:	85 c0                	test   %eax,%eax
 277:	78 27                	js     2a0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 279:	83 ec 08             	sub    $0x8,%esp
 27c:	ff 75 0c             	pushl  0xc(%ebp)
 27f:	89 c3                	mov    %eax,%ebx
 281:	50                   	push   %eax
 282:	e8 f2 00 00 00       	call   379 <fstat>
  close(fd);
 287:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 28a:	89 c6                	mov    %eax,%esi
  close(fd);
 28c:	e8 b8 00 00 00       	call   349 <close>
  return r;
 291:	83 c4 10             	add    $0x10,%esp
}
 294:	8d 65 f8             	lea    -0x8(%ebp),%esp
 297:	89 f0                	mov    %esi,%eax
 299:	5b                   	pop    %ebx
 29a:	5e                   	pop    %esi
 29b:	5d                   	pop    %ebp
 29c:	c3                   	ret    
 29d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 2a0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2a5:	eb ed                	jmp    294 <stat+0x34>
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax

000002b0 <atoi>:

int
atoi(const char *s)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	53                   	push   %ebx
 2b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b7:	0f be 11             	movsbl (%ecx),%edx
 2ba:	8d 42 d0             	lea    -0x30(%edx),%eax
 2bd:	3c 09                	cmp    $0x9,%al
  n = 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2c4:	77 1f                	ja     2e5 <atoi+0x35>
 2c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 2d0:	83 c1 01             	add    $0x1,%ecx
 2d3:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2d6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2da:	0f be 11             	movsbl (%ecx),%edx
 2dd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2e0:	80 fb 09             	cmp    $0x9,%bl
 2e3:	76 eb                	jbe    2d0 <atoi+0x20>
  return n;
}
 2e5:	5b                   	pop    %ebx
 2e6:	5d                   	pop    %ebp
 2e7:	c3                   	ret    
 2e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop

000002f0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	57                   	push   %edi
 2f4:	8b 55 10             	mov    0x10(%ebp),%edx
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	56                   	push   %esi
 2fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2fe:	85 d2                	test   %edx,%edx
 300:	7e 13                	jle    315 <memmove+0x25>
 302:	01 c2                	add    %eax,%edx
  dst = vdst;
 304:	89 c7                	mov    %eax,%edi
 306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 310:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 311:	39 fa                	cmp    %edi,%edx
 313:	75 fb                	jne    310 <memmove+0x20>
  return vdst;
}
 315:	5e                   	pop    %esi
 316:	5f                   	pop    %edi
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    

00000319 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 319:	b8 01 00 00 00       	mov    $0x1,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <exit>:
SYSCALL(exit)
 321:	b8 02 00 00 00       	mov    $0x2,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <wait>:
SYSCALL(wait)
 329:	b8 03 00 00 00       	mov    $0x3,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <pipe>:
SYSCALL(pipe)
 331:	b8 04 00 00 00       	mov    $0x4,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <read>:
SYSCALL(read)
 339:	b8 05 00 00 00       	mov    $0x5,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <write>:
SYSCALL(write)
 341:	b8 10 00 00 00       	mov    $0x10,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <close>:
SYSCALL(close)
 349:	b8 15 00 00 00       	mov    $0x15,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <kill>:
SYSCALL(kill)
 351:	b8 06 00 00 00       	mov    $0x6,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <exec>:
SYSCALL(exec)
 359:	b8 07 00 00 00       	mov    $0x7,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <open>:
SYSCALL(open)
 361:	b8 0f 00 00 00       	mov    $0xf,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <mknod>:
SYSCALL(mknod)
 369:	b8 11 00 00 00       	mov    $0x11,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <unlink>:
SYSCALL(unlink)
 371:	b8 12 00 00 00       	mov    $0x12,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <fstat>:
SYSCALL(fstat)
 379:	b8 08 00 00 00       	mov    $0x8,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <link>:
SYSCALL(link)
 381:	b8 13 00 00 00       	mov    $0x13,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <mkdir>:
SYSCALL(mkdir)
 389:	b8 14 00 00 00       	mov    $0x14,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <chdir>:
SYSCALL(chdir)
 391:	b8 09 00 00 00       	mov    $0x9,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <dup>:
SYSCALL(dup)
 399:	b8 0a 00 00 00       	mov    $0xa,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <getpid>:
SYSCALL(getpid)
 3a1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <sbrk>:
SYSCALL(sbrk)
 3a9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <sleep>:
SYSCALL(sleep)
 3b1:	b8 0d 00 00 00       	mov    $0xd,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <uptime>:
SYSCALL(uptime)
 3b9:	b8 0e 00 00 00       	mov    $0xe,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <cps>:
SYSCALL(cps)
 3c1:	b8 16 00 00 00       	mov    $0x16,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <nps>:
SYSCALL(nps)
 3c9:	b8 17 00 00 00       	mov    $0x17,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <chpr>:
SYSCALL(chpr)
 3d1:	b8 18 00 00 00       	mov    $0x18,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <pfs>:
SYSCALL(pfs)
 3d9:	b8 19 00 00 00       	mov    $0x19,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    
 3e1:	66 90                	xchg   %ax,%ax
 3e3:	66 90                	xchg   %ax,%ax
 3e5:	66 90                	xchg   %ax,%ax
 3e7:	66 90                	xchg   %ax,%ax
 3e9:	66 90                	xchg   %ax,%ax
 3eb:	66 90                	xchg   %ax,%ax
 3ed:	66 90                	xchg   %ax,%ax
 3ef:	90                   	nop

000003f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3f6:	89 d3                	mov    %edx,%ebx
{
 3f8:	83 ec 3c             	sub    $0x3c,%esp
 3fb:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 3fe:	85 d2                	test   %edx,%edx
 400:	0f 89 92 00 00 00    	jns    498 <printint+0xa8>
 406:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 40a:	0f 84 88 00 00 00    	je     498 <printint+0xa8>
    neg = 1;
 410:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 417:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 419:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 420:	8d 75 d7             	lea    -0x29(%ebp),%esi
 423:	eb 08                	jmp    42d <printint+0x3d>
 425:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 428:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 42b:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 42d:	89 d8                	mov    %ebx,%eax
 42f:	31 d2                	xor    %edx,%edx
 431:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 434:	f7 f1                	div    %ecx
 436:	83 c7 01             	add    $0x1,%edi
 439:	0f b6 92 44 08 00 00 	movzbl 0x844(%edx),%edx
 440:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 443:	39 d9                	cmp    %ebx,%ecx
 445:	76 e1                	jbe    428 <printint+0x38>
  if(neg)
 447:	8b 45 c0             	mov    -0x40(%ebp),%eax
 44a:	85 c0                	test   %eax,%eax
 44c:	74 0d                	je     45b <printint+0x6b>
    buf[i++] = '-';
 44e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 453:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 458:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 45b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 45e:	8b 7d bc             	mov    -0x44(%ebp),%edi
 461:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 465:	eb 0f                	jmp    476 <printint+0x86>
 467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 46e:	66 90                	xchg   %ax,%ax
 470:	0f b6 13             	movzbl (%ebx),%edx
 473:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 476:	83 ec 04             	sub    $0x4,%esp
 479:	88 55 d7             	mov    %dl,-0x29(%ebp)
 47c:	6a 01                	push   $0x1
 47e:	56                   	push   %esi
 47f:	57                   	push   %edi
 480:	e8 bc fe ff ff       	call   341 <write>

  while(--i >= 0)
 485:	83 c4 10             	add    $0x10,%esp
 488:	39 de                	cmp    %ebx,%esi
 48a:	75 e4                	jne    470 <printint+0x80>
    putc(fd, buf[i]);
}
 48c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48f:	5b                   	pop    %ebx
 490:	5e                   	pop    %esi
 491:	5f                   	pop    %edi
 492:	5d                   	pop    %ebp
 493:	c3                   	ret    
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 498:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 49f:	e9 75 ff ff ff       	jmp    419 <printint+0x29>
 4a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop

000004b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b9:	8b 75 0c             	mov    0xc(%ebp),%esi
 4bc:	0f b6 1e             	movzbl (%esi),%ebx
 4bf:	84 db                	test   %bl,%bl
 4c1:	0f 84 b9 00 00 00    	je     580 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 4c7:	8d 45 10             	lea    0x10(%ebp),%eax
 4ca:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 4cd:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4d0:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 4d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4d5:	eb 38                	jmp    50f <printf+0x5f>
 4d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4de:	66 90                	xchg   %ax,%ax
 4e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4e3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 4e8:	83 f8 25             	cmp    $0x25,%eax
 4eb:	74 17                	je     504 <printf+0x54>
  write(fd, &c, 1);
 4ed:	83 ec 04             	sub    $0x4,%esp
 4f0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 4f3:	6a 01                	push   $0x1
 4f5:	57                   	push   %edi
 4f6:	ff 75 08             	pushl  0x8(%ebp)
 4f9:	e8 43 fe ff ff       	call   341 <write>
 4fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 501:	83 c4 10             	add    $0x10,%esp
 504:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 507:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 50b:	84 db                	test   %bl,%bl
 50d:	74 71                	je     580 <printf+0xd0>
    c = fmt[i] & 0xff;
 50f:	0f be cb             	movsbl %bl,%ecx
 512:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 515:	85 d2                	test   %edx,%edx
 517:	74 c7                	je     4e0 <printf+0x30>
      }
    } else if(state == '%'){
 519:	83 fa 25             	cmp    $0x25,%edx
 51c:	75 e6                	jne    504 <printf+0x54>
      if(c == 'd'){
 51e:	83 f8 64             	cmp    $0x64,%eax
 521:	0f 84 99 00 00 00    	je     5c0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 527:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 52d:	83 f9 70             	cmp    $0x70,%ecx
 530:	74 5e                	je     590 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 532:	83 f8 73             	cmp    $0x73,%eax
 535:	0f 84 d5 00 00 00    	je     610 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53b:	83 f8 63             	cmp    $0x63,%eax
 53e:	0f 84 8c 00 00 00    	je     5d0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 544:	83 f8 25             	cmp    $0x25,%eax
 547:	0f 84 b3 00 00 00    	je     600 <printf+0x150>
  write(fd, &c, 1);
 54d:	83 ec 04             	sub    $0x4,%esp
 550:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 554:	6a 01                	push   $0x1
 556:	57                   	push   %edi
 557:	ff 75 08             	pushl  0x8(%ebp)
 55a:	e8 e2 fd ff ff       	call   341 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 55f:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 562:	83 c4 0c             	add    $0xc,%esp
 565:	6a 01                	push   $0x1
 567:	83 c6 01             	add    $0x1,%esi
 56a:	57                   	push   %edi
 56b:	ff 75 08             	pushl  0x8(%ebp)
 56e:	e8 ce fd ff ff       	call   341 <write>
  for(i = 0; fmt[i]; i++){
 573:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 577:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 57a:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 57c:	84 db                	test   %bl,%bl
 57e:	75 8f                	jne    50f <printf+0x5f>
    }
  }
}
 580:	8d 65 f4             	lea    -0xc(%ebp),%esp
 583:	5b                   	pop    %ebx
 584:	5e                   	pop    %esi
 585:	5f                   	pop    %edi
 586:	5d                   	pop    %ebp
 587:	c3                   	ret    
 588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop
        printint(fd, *ap, 16, 0);
 590:	83 ec 0c             	sub    $0xc,%esp
 593:	b9 10 00 00 00       	mov    $0x10,%ecx
 598:	6a 00                	push   $0x0
 59a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	8b 13                	mov    (%ebx),%edx
 5a2:	e8 49 fe ff ff       	call   3f0 <printint>
        ap++;
 5a7:	89 d8                	mov    %ebx,%eax
 5a9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ac:	31 d2                	xor    %edx,%edx
        ap++;
 5ae:	83 c0 04             	add    $0x4,%eax
 5b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5b4:	e9 4b ff ff ff       	jmp    504 <printf+0x54>
 5b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 5c0:	83 ec 0c             	sub    $0xc,%esp
 5c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5c8:	6a 01                	push   $0x1
 5ca:	eb ce                	jmp    59a <printf+0xea>
 5cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 5d0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 5d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5d6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 5d8:	6a 01                	push   $0x1
        ap++;
 5da:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 5dd:	57                   	push   %edi
 5de:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 5e1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5e4:	e8 58 fd ff ff       	call   341 <write>
        ap++;
 5e9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 5ec:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5ef:	31 d2                	xor    %edx,%edx
 5f1:	e9 0e ff ff ff       	jmp    504 <printf+0x54>
 5f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 600:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 603:	83 ec 04             	sub    $0x4,%esp
 606:	e9 5a ff ff ff       	jmp    565 <printf+0xb5>
 60b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop
        s = (char*)*ap;
 610:	8b 45 d0             	mov    -0x30(%ebp),%eax
 613:	8b 18                	mov    (%eax),%ebx
        ap++;
 615:	83 c0 04             	add    $0x4,%eax
 618:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 61b:	85 db                	test   %ebx,%ebx
 61d:	74 17                	je     636 <printf+0x186>
        while(*s != 0){
 61f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 622:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 624:	84 c0                	test   %al,%al
 626:	0f 84 d8 fe ff ff    	je     504 <printf+0x54>
 62c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 62f:	89 de                	mov    %ebx,%esi
 631:	8b 5d 08             	mov    0x8(%ebp),%ebx
 634:	eb 1a                	jmp    650 <printf+0x1a0>
          s = "(null)";
 636:	bb 3b 08 00 00       	mov    $0x83b,%ebx
        while(*s != 0){
 63b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 63e:	b8 28 00 00 00       	mov    $0x28,%eax
 643:	89 de                	mov    %ebx,%esi
 645:	8b 5d 08             	mov    0x8(%ebp),%ebx
 648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64f:	90                   	nop
  write(fd, &c, 1);
 650:	83 ec 04             	sub    $0x4,%esp
          s++;
 653:	83 c6 01             	add    $0x1,%esi
 656:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 659:	6a 01                	push   $0x1
 65b:	57                   	push   %edi
 65c:	53                   	push   %ebx
 65d:	e8 df fc ff ff       	call   341 <write>
        while(*s != 0){
 662:	0f b6 06             	movzbl (%esi),%eax
 665:	83 c4 10             	add    $0x10,%esp
 668:	84 c0                	test   %al,%al
 66a:	75 e4                	jne    650 <printf+0x1a0>
 66c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 66f:	31 d2                	xor    %edx,%edx
 671:	e9 8e fe ff ff       	jmp    504 <printf+0x54>
 676:	66 90                	xchg   %ax,%ax
 678:	66 90                	xchg   %ax,%ax
 67a:	66 90                	xchg   %ax,%ax
 67c:	66 90                	xchg   %ax,%ax
 67e:	66 90                	xchg   %ax,%ax

00000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	a1 00 0b 00 00       	mov    0xb00,%eax
{
 686:	89 e5                	mov    %esp,%ebp
 688:	57                   	push   %edi
 689:	56                   	push   %esi
 68a:	53                   	push   %ebx
 68b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 68e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 690:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 693:	39 c8                	cmp    %ecx,%eax
 695:	73 19                	jae    6b0 <free+0x30>
 697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 69e:	66 90                	xchg   %ax,%ax
 6a0:	39 d1                	cmp    %edx,%ecx
 6a2:	72 14                	jb     6b8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a4:	39 d0                	cmp    %edx,%eax
 6a6:	73 10                	jae    6b8 <free+0x38>
{
 6a8:	89 d0                	mov    %edx,%eax
 6aa:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ac:	39 c8                	cmp    %ecx,%eax
 6ae:	72 f0                	jb     6a0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b0:	39 d0                	cmp    %edx,%eax
 6b2:	72 f4                	jb     6a8 <free+0x28>
 6b4:	39 d1                	cmp    %edx,%ecx
 6b6:	73 f0                	jae    6a8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6be:	39 fa                	cmp    %edi,%edx
 6c0:	74 1e                	je     6e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6c2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6c5:	8b 50 04             	mov    0x4(%eax),%edx
 6c8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6cb:	39 f1                	cmp    %esi,%ecx
 6cd:	74 28                	je     6f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6cf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 6d1:	5b                   	pop    %ebx
  freep = p;
 6d2:	a3 00 0b 00 00       	mov    %eax,0xb00
}
 6d7:	5e                   	pop    %esi
 6d8:	5f                   	pop    %edi
 6d9:	5d                   	pop    %ebp
 6da:	c3                   	ret    
 6db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6df:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 6e0:	03 72 04             	add    0x4(%edx),%esi
 6e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	8b 10                	mov    (%eax),%edx
 6e8:	8b 12                	mov    (%edx),%edx
 6ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ed:	8b 50 04             	mov    0x4(%eax),%edx
 6f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6f3:	39 f1                	cmp    %esi,%ecx
 6f5:	75 d8                	jne    6cf <free+0x4f>
    p->s.size += bp->s.size;
 6f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 6fa:	a3 00 0b 00 00       	mov    %eax,0xb00
    p->s.size += bp->s.size;
 6ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 702:	8b 53 f8             	mov    -0x8(%ebx),%edx
 705:	89 10                	mov    %edx,(%eax)
}
 707:	5b                   	pop    %ebx
 708:	5e                   	pop    %esi
 709:	5f                   	pop    %edi
 70a:	5d                   	pop    %ebp
 70b:	c3                   	ret    
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000710 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 71c:	8b 3d 00 0b 00 00    	mov    0xb00,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 722:	8d 70 07             	lea    0x7(%eax),%esi
 725:	c1 ee 03             	shr    $0x3,%esi
 728:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 72b:	85 ff                	test   %edi,%edi
 72d:	0f 84 ad 00 00 00    	je     7e0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 733:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 735:	8b 4a 04             	mov    0x4(%edx),%ecx
 738:	39 f1                	cmp    %esi,%ecx
 73a:	73 72                	jae    7ae <malloc+0x9e>
 73c:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 742:	bb 00 10 00 00       	mov    $0x1000,%ebx
 747:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 74a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 751:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 754:	eb 1b                	jmp    771 <malloc+0x61>
 756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 760:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 762:	8b 48 04             	mov    0x4(%eax),%ecx
 765:	39 f1                	cmp    %esi,%ecx
 767:	73 4f                	jae    7b8 <malloc+0xa8>
 769:	8b 3d 00 0b 00 00    	mov    0xb00,%edi
 76f:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 771:	39 d7                	cmp    %edx,%edi
 773:	75 eb                	jne    760 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 775:	83 ec 0c             	sub    $0xc,%esp
 778:	ff 75 e4             	pushl  -0x1c(%ebp)
 77b:	e8 29 fc ff ff       	call   3a9 <sbrk>
  if(p == (char*)-1)
 780:	83 c4 10             	add    $0x10,%esp
 783:	83 f8 ff             	cmp    $0xffffffff,%eax
 786:	74 1c                	je     7a4 <malloc+0x94>
  hp->s.size = nu;
 788:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 78b:	83 ec 0c             	sub    $0xc,%esp
 78e:	83 c0 08             	add    $0x8,%eax
 791:	50                   	push   %eax
 792:	e8 e9 fe ff ff       	call   680 <free>
  return freep;
 797:	8b 15 00 0b 00 00    	mov    0xb00,%edx
      if((p = morecore(nunits)) == 0)
 79d:	83 c4 10             	add    $0x10,%esp
 7a0:	85 d2                	test   %edx,%edx
 7a2:	75 bc                	jne    760 <malloc+0x50>
        return 0;
  }
}
 7a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7a7:	31 c0                	xor    %eax,%eax
}
 7a9:	5b                   	pop    %ebx
 7aa:	5e                   	pop    %esi
 7ab:	5f                   	pop    %edi
 7ac:	5d                   	pop    %ebp
 7ad:	c3                   	ret    
    if(p->s.size >= nunits){
 7ae:	89 d0                	mov    %edx,%eax
 7b0:	89 fa                	mov    %edi,%edx
 7b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7b8:	39 ce                	cmp    %ecx,%esi
 7ba:	74 54                	je     810 <malloc+0x100>
        p->s.size -= nunits;
 7bc:	29 f1                	sub    %esi,%ecx
 7be:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7c1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7c4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7c7:	89 15 00 0b 00 00    	mov    %edx,0xb00
}
 7cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7d0:	83 c0 08             	add    $0x8,%eax
}
 7d3:	5b                   	pop    %ebx
 7d4:	5e                   	pop    %esi
 7d5:	5f                   	pop    %edi
 7d6:	5d                   	pop    %ebp
 7d7:	c3                   	ret    
 7d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7df:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 7e0:	c7 05 00 0b 00 00 04 	movl   $0xb04,0xb00
 7e7:	0b 00 00 
    base.s.size = 0;
 7ea:	bf 04 0b 00 00       	mov    $0xb04,%edi
    base.s.ptr = freep = prevp = &base;
 7ef:	c7 05 04 0b 00 00 04 	movl   $0xb04,0xb04
 7f6:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7fb:	c7 05 08 0b 00 00 00 	movl   $0x0,0xb08
 802:	00 00 00 
    if(p->s.size >= nunits){
 805:	e9 32 ff ff ff       	jmp    73c <malloc+0x2c>
 80a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 810:	8b 08                	mov    (%eax),%ecx
 812:	89 0a                	mov    %ecx,(%edx)
 814:	eb b1                	jmp    7c7 <malloc+0xb7>
