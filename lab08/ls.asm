
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 0c             	sub    $0xc,%esp
  13:	8b 01                	mov    (%ecx),%eax
  15:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  18:	83 f8 01             	cmp    $0x1,%eax
  1b:	7e 24                	jle    41 <main+0x41>
  1d:	8d 5a 04             	lea    0x4(%edx),%ebx
  20:	8d 34 82             	lea    (%edx,%eax,4),%esi
  23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  27:	90                   	nop
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  28:	83 ec 0c             	sub    $0xc,%esp
  2b:	ff 33                	pushl  (%ebx)
  2d:	83 c3 04             	add    $0x4,%ebx
  30:	e8 db 00 00 00       	call   110 <ls>
  for(i=1; i<argc; i++)
  35:	83 c4 10             	add    $0x10,%esp
  38:	39 f3                	cmp    %esi,%ebx
  3a:	75 ec                	jne    28 <main+0x28>
  exit();
  3c:	e8 60 05 00 00       	call   5a1 <exit>
    ls(".");
  41:	83 ec 0c             	sub    $0xc,%esp
  44:	68 e0 0a 00 00       	push   $0xae0
  49:	e8 c2 00 00 00       	call   110 <ls>
    exit();
  4e:	e8 4e 05 00 00       	call   5a1 <exit>
  53:	66 90                	xchg   %ax,%ax
  55:	66 90                	xchg   %ax,%ax
  57:	66 90                	xchg   %ax,%ax
  59:	66 90                	xchg   %ax,%ax
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <fmtname>:
{
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	56                   	push   %esi
  64:	53                   	push   %ebx
  65:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  68:	83 ec 0c             	sub    $0xc,%esp
  6b:	56                   	push   %esi
  6c:	e8 5f 03 00 00       	call   3d0 <strlen>
  71:	83 c4 10             	add    $0x10,%esp
  74:	01 f0                	add    %esi,%eax
  76:	89 c3                	mov    %eax,%ebx
  78:	0f 82 82 00 00 00    	jb     100 <fmtname+0xa0>
  7e:	80 38 2f             	cmpb   $0x2f,(%eax)
  81:	75 0d                	jne    90 <fmtname+0x30>
  83:	eb 7b                	jmp    100 <fmtname+0xa0>
  85:	8d 76 00             	lea    0x0(%esi),%esi
  88:	80 7b ff 2f          	cmpb   $0x2f,-0x1(%ebx)
  8c:	74 09                	je     97 <fmtname+0x37>
  8e:	89 c3                	mov    %eax,%ebx
  90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  93:	39 c6                	cmp    %eax,%esi
  95:	76 f1                	jbe    88 <fmtname+0x28>
  if(strlen(p) >= DIRSIZ)
  97:	83 ec 0c             	sub    $0xc,%esp
  9a:	53                   	push   %ebx
  9b:	e8 30 03 00 00       	call   3d0 <strlen>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	83 f8 0d             	cmp    $0xd,%eax
  a6:	77 4a                	ja     f2 <fmtname+0x92>
  memmove(buf, p, strlen(p));
  a8:	83 ec 0c             	sub    $0xc,%esp
  ab:	53                   	push   %ebx
  ac:	e8 1f 03 00 00       	call   3d0 <strlen>
  b1:	83 c4 0c             	add    $0xc,%esp
  b4:	50                   	push   %eax
  b5:	53                   	push   %ebx
  b6:	68 18 0e 00 00       	push   $0xe18
  bb:	e8 b0 04 00 00       	call   570 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  c0:	89 1c 24             	mov    %ebx,(%esp)
  c3:	e8 08 03 00 00       	call   3d0 <strlen>
  c8:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
  cb:	bb 18 0e 00 00       	mov    $0xe18,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  d0:	89 c6                	mov    %eax,%esi
  d2:	e8 f9 02 00 00       	call   3d0 <strlen>
  d7:	ba 0e 00 00 00       	mov    $0xe,%edx
  dc:	83 c4 0c             	add    $0xc,%esp
  df:	29 f2                	sub    %esi,%edx
  e1:	05 18 0e 00 00       	add    $0xe18,%eax
  e6:	52                   	push   %edx
  e7:	6a 20                	push   $0x20
  e9:	50                   	push   %eax
  ea:	e8 11 03 00 00       	call   400 <memset>
  return buf;
  ef:	83 c4 10             	add    $0x10,%esp
}
  f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  f5:	89 d8                	mov    %ebx,%eax
  f7:	5b                   	pop    %ebx
  f8:	5e                   	pop    %esi
  f9:	5d                   	pop    %ebp
  fa:	c3                   	ret    
  fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ff:	90                   	nop
 100:	83 c3 01             	add    $0x1,%ebx
 103:	eb 92                	jmp    97 <fmtname+0x37>
 105:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000110 <ls>:
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	56                   	push   %esi
 115:	53                   	push   %ebx
 116:	81 ec 64 02 00 00    	sub    $0x264,%esp
 11c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
 11f:	6a 00                	push   $0x0
 121:	57                   	push   %edi
 122:	e8 ba 04 00 00       	call   5e1 <open>
 127:	83 c4 10             	add    $0x10,%esp
 12a:	85 c0                	test   %eax,%eax
 12c:	0f 88 9e 01 00 00    	js     2d0 <ls+0x1c0>
  if(fstat(fd, &st) < 0){
 132:	83 ec 08             	sub    $0x8,%esp
 135:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 13b:	89 c3                	mov    %eax,%ebx
 13d:	56                   	push   %esi
 13e:	50                   	push   %eax
 13f:	e8 b5 04 00 00       	call   5f9 <fstat>
 144:	83 c4 10             	add    $0x10,%esp
 147:	85 c0                	test   %eax,%eax
 149:	0f 88 c1 01 00 00    	js     310 <ls+0x200>
  switch(st.type){
 14f:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 156:	66 83 f8 01          	cmp    $0x1,%ax
 15a:	74 64                	je     1c0 <ls+0xb0>
 15c:	66 83 f8 02          	cmp    $0x2,%ax
 160:	74 1e                	je     180 <ls+0x70>
  close(fd);
 162:	83 ec 0c             	sub    $0xc,%esp
 165:	53                   	push   %ebx
 166:	e8 5e 04 00 00       	call   5c9 <close>
 16b:	83 c4 10             	add    $0x10,%esp
}
 16e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 171:	5b                   	pop    %ebx
 172:	5e                   	pop    %esi
 173:	5f                   	pop    %edi
 174:	5d                   	pop    %ebp
 175:	c3                   	ret    
 176:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17d:	8d 76 00             	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 180:	83 ec 0c             	sub    $0xc,%esp
 183:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 189:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 18f:	57                   	push   %edi
 190:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 196:	e8 c5 fe ff ff       	call   60 <fmtname>
 19b:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 1a1:	59                   	pop    %ecx
 1a2:	5f                   	pop    %edi
 1a3:	52                   	push   %edx
 1a4:	56                   	push   %esi
 1a5:	6a 02                	push   $0x2
 1a7:	50                   	push   %eax
 1a8:	68 c0 0a 00 00       	push   $0xac0
 1ad:	6a 01                	push   $0x1
 1af:	e8 7c 05 00 00       	call   730 <printf>
    break;
 1b4:	83 c4 20             	add    $0x20,%esp
 1b7:	eb a9                	jmp    162 <ls+0x52>
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1c0:	83 ec 0c             	sub    $0xc,%esp
 1c3:	57                   	push   %edi
 1c4:	e8 07 02 00 00       	call   3d0 <strlen>
 1c9:	83 c4 10             	add    $0x10,%esp
 1cc:	83 c0 10             	add    $0x10,%eax
 1cf:	3d 00 02 00 00       	cmp    $0x200,%eax
 1d4:	0f 87 16 01 00 00    	ja     2f0 <ls+0x1e0>
    strcpy(buf, path);
 1da:	83 ec 08             	sub    $0x8,%esp
 1dd:	57                   	push   %edi
 1de:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1e4:	57                   	push   %edi
 1e5:	e8 66 01 00 00       	call   350 <strcpy>
    p = buf+strlen(buf);
 1ea:	89 3c 24             	mov    %edi,(%esp)
 1ed:	e8 de 01 00 00       	call   3d0 <strlen>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f2:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1f5:	01 f8                	add    %edi,%eax
    *p++ = '/';
 1f7:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 1fa:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 200:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 206:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 210:	83 ec 04             	sub    $0x4,%esp
 213:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 219:	6a 10                	push   $0x10
 21b:	50                   	push   %eax
 21c:	53                   	push   %ebx
 21d:	e8 97 03 00 00       	call   5b9 <read>
 222:	83 c4 10             	add    $0x10,%esp
 225:	83 f8 10             	cmp    $0x10,%eax
 228:	0f 85 34 ff ff ff    	jne    162 <ls+0x52>
      if(de.inum == 0)
 22e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 235:	00 
 236:	74 d8                	je     210 <ls+0x100>
      memmove(p, de.name, DIRSIZ);
 238:	83 ec 04             	sub    $0x4,%esp
 23b:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 241:	6a 0e                	push   $0xe
 243:	50                   	push   %eax
 244:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 24a:	e8 21 03 00 00       	call   570 <memmove>
      p[DIRSIZ] = 0;
 24f:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 255:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 259:	58                   	pop    %eax
 25a:	5a                   	pop    %edx
 25b:	56                   	push   %esi
 25c:	57                   	push   %edi
 25d:	e8 7e 02 00 00       	call   4e0 <stat>
 262:	83 c4 10             	add    $0x10,%esp
 265:	85 c0                	test   %eax,%eax
 267:	0f 88 cb 00 00 00    	js     338 <ls+0x228>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26d:	83 ec 0c             	sub    $0xc,%esp
 270:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 276:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 27c:	57                   	push   %edi
 27d:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 284:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 28a:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 290:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 296:	e8 c5 fd ff ff       	call   60 <fmtname>
 29b:	5a                   	pop    %edx
 29c:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 2a2:	59                   	pop    %ecx
 2a3:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 2a9:	51                   	push   %ecx
 2aa:	52                   	push   %edx
 2ab:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 2b1:	50                   	push   %eax
 2b2:	68 c0 0a 00 00       	push   $0xac0
 2b7:	6a 01                	push   $0x1
 2b9:	e8 72 04 00 00       	call   730 <printf>
 2be:	83 c4 20             	add    $0x20,%esp
 2c1:	e9 4a ff ff ff       	jmp    210 <ls+0x100>
 2c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot open %s\n", path);
 2d0:	83 ec 04             	sub    $0x4,%esp
 2d3:	57                   	push   %edi
 2d4:	68 98 0a 00 00       	push   $0xa98
 2d9:	6a 02                	push   $0x2
 2db:	e8 50 04 00 00       	call   730 <printf>
    return;
 2e0:	83 c4 10             	add    $0x10,%esp
}
 2e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e6:	5b                   	pop    %ebx
 2e7:	5e                   	pop    %esi
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    
 2eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop
      printf(1, "ls: path too long\n");
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	68 cd 0a 00 00       	push   $0xacd
 2f8:	6a 01                	push   $0x1
 2fa:	e8 31 04 00 00       	call   730 <printf>
      break;
 2ff:	83 c4 10             	add    $0x10,%esp
 302:	e9 5b fe ff ff       	jmp    162 <ls+0x52>
 307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30e:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot stat %s\n", path);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	57                   	push   %edi
 314:	68 ac 0a 00 00       	push   $0xaac
 319:	6a 02                	push   $0x2
 31b:	e8 10 04 00 00       	call   730 <printf>
    close(fd);
 320:	89 1c 24             	mov    %ebx,(%esp)
 323:	e8 a1 02 00 00       	call   5c9 <close>
    return;
 328:	83 c4 10             	add    $0x10,%esp
}
 32b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32e:	5b                   	pop    %ebx
 32f:	5e                   	pop    %esi
 330:	5f                   	pop    %edi
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    
 333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 337:	90                   	nop
        printf(1, "ls: cannot stat %s\n", buf);
 338:	83 ec 04             	sub    $0x4,%esp
 33b:	57                   	push   %edi
 33c:	68 ac 0a 00 00       	push   $0xaac
 341:	6a 01                	push   $0x1
 343:	e8 e8 03 00 00       	call   730 <printf>
        continue;
 348:	83 c4 10             	add    $0x10,%esp
 34b:	e9 c0 fe ff ff       	jmp    210 <ls+0x100>

00000350 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 350:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 351:	31 d2                	xor    %edx,%edx
{
 353:	89 e5                	mov    %esp,%ebp
 355:	53                   	push   %ebx
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 360:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 364:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 367:	83 c2 01             	add    $0x1,%edx
 36a:	84 c9                	test   %cl,%cl
 36c:	75 f2                	jne    360 <strcpy+0x10>
    ;
  return os;
}
 36e:	5b                   	pop    %ebx
 36f:	5d                   	pop    %ebp
 370:	c3                   	ret    
 371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 37f:	90                   	nop

00000380 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	56                   	push   %esi
 384:	53                   	push   %ebx
 385:	8b 5d 08             	mov    0x8(%ebp),%ebx
 388:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(*p && *p == *q)
 38b:	0f b6 13             	movzbl (%ebx),%edx
 38e:	0f b6 0e             	movzbl (%esi),%ecx
 391:	84 d2                	test   %dl,%dl
 393:	74 1e                	je     3b3 <strcmp+0x33>
 395:	b8 01 00 00 00       	mov    $0x1,%eax
 39a:	38 ca                	cmp    %cl,%dl
 39c:	74 09                	je     3a7 <strcmp+0x27>
 39e:	eb 20                	jmp    3c0 <strcmp+0x40>
 3a0:	83 c0 01             	add    $0x1,%eax
 3a3:	38 ca                	cmp    %cl,%dl
 3a5:	75 19                	jne    3c0 <strcmp+0x40>
 3a7:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 3ab:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
 3af:	84 d2                	test   %dl,%dl
 3b1:	75 ed                	jne    3a0 <strcmp+0x20>
 3b3:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
}
 3b5:	5b                   	pop    %ebx
 3b6:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 3b7:	29 c8                	sub    %ecx,%eax
}
 3b9:	5d                   	pop    %ebp
 3ba:	c3                   	ret    
 3bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3bf:	90                   	nop
 3c0:	0f b6 c2             	movzbl %dl,%eax
 3c3:	5b                   	pop    %ebx
 3c4:	5e                   	pop    %esi
  return (uchar)*p - (uchar)*q;
 3c5:	29 c8                	sub    %ecx,%eax
}
 3c7:	5d                   	pop    %ebp
 3c8:	c3                   	ret    
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003d0 <strlen>:

uint
strlen(char *s)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 3d6:	80 39 00             	cmpb   $0x0,(%ecx)
 3d9:	74 15                	je     3f0 <strlen+0x20>
 3db:	31 d2                	xor    %edx,%edx
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3e7:	89 d0                	mov    %edx,%eax
 3e9:	75 f5                	jne    3e0 <strlen+0x10>
    ;
  return n;
}
 3eb:	5d                   	pop    %ebp
 3ec:	c3                   	ret    
 3ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 3f0:	31 c0                	xor    %eax,%eax
}
 3f2:	5d                   	pop    %ebp
 3f3:	c3                   	ret    
 3f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 407:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	89 d7                	mov    %edx,%edi
 40f:	fc                   	cld    
 410:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 412:	89 d0                	mov    %edx,%eax
 414:	5f                   	pop    %edi
 415:	5d                   	pop    %ebp
 416:	c3                   	ret    
 417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41e:	66 90                	xchg   %ax,%ax

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	53                   	push   %ebx
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 42a:	0f b6 18             	movzbl (%eax),%ebx
 42d:	84 db                	test   %bl,%bl
 42f:	74 1d                	je     44e <strchr+0x2e>
 431:	89 d1                	mov    %edx,%ecx
    if(*s == c)
 433:	38 d3                	cmp    %dl,%bl
 435:	75 0d                	jne    444 <strchr+0x24>
 437:	eb 17                	jmp    450 <strchr+0x30>
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 440:	38 ca                	cmp    %cl,%dl
 442:	74 0c                	je     450 <strchr+0x30>
  for(; *s; s++)
 444:	83 c0 01             	add    $0x1,%eax
 447:	0f b6 10             	movzbl (%eax),%edx
 44a:	84 d2                	test   %dl,%dl
 44c:	75 f2                	jne    440 <strchr+0x20>
      return (char*)s;
  return 0;
 44e:	31 c0                	xor    %eax,%eax
}
 450:	5b                   	pop    %ebx
 451:	5d                   	pop    %ebp
 452:	c3                   	ret    
 453:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 45a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000460 <gets>:

char*
gets(char *buf, int max)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 465:	31 f6                	xor    %esi,%esi
{
 467:	53                   	push   %ebx
 468:	89 f3                	mov    %esi,%ebx
 46a:	83 ec 1c             	sub    $0x1c,%esp
 46d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 470:	eb 2f                	jmp    4a1 <gets+0x41>
 472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 478:	83 ec 04             	sub    $0x4,%esp
 47b:	8d 45 e7             	lea    -0x19(%ebp),%eax
 47e:	6a 01                	push   $0x1
 480:	50                   	push   %eax
 481:	6a 00                	push   $0x0
 483:	e8 31 01 00 00       	call   5b9 <read>
    if(cc < 1)
 488:	83 c4 10             	add    $0x10,%esp
 48b:	85 c0                	test   %eax,%eax
 48d:	7e 1c                	jle    4ab <gets+0x4b>
      break;
    buf[i++] = c;
 48f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 493:	83 c7 01             	add    $0x1,%edi
 496:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 499:	3c 0a                	cmp    $0xa,%al
 49b:	74 23                	je     4c0 <gets+0x60>
 49d:	3c 0d                	cmp    $0xd,%al
 49f:	74 1f                	je     4c0 <gets+0x60>
  for(i=0; i+1 < max; ){
 4a1:	83 c3 01             	add    $0x1,%ebx
 4a4:	89 fe                	mov    %edi,%esi
 4a6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4a9:	7c cd                	jl     478 <gets+0x18>
 4ab:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4b0:	c6 03 00             	movb   $0x0,(%ebx)
}
 4b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4b6:	5b                   	pop    %ebx
 4b7:	5e                   	pop    %esi
 4b8:	5f                   	pop    %edi
 4b9:	5d                   	pop    %ebp
 4ba:	c3                   	ret    
 4bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop
 4c0:	8b 75 08             	mov    0x8(%ebp),%esi
 4c3:	8b 45 08             	mov    0x8(%ebp),%eax
 4c6:	01 de                	add    %ebx,%esi
 4c8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4ca:	c6 03 00             	movb   $0x0,(%ebx)
}
 4cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d0:	5b                   	pop    %ebx
 4d1:	5e                   	pop    %esi
 4d2:	5f                   	pop    %edi
 4d3:	5d                   	pop    %ebp
 4d4:	c3                   	ret    
 4d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004e0 <stat>:

int
stat(char *n, struct stat *st)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	56                   	push   %esi
 4e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e5:	83 ec 08             	sub    $0x8,%esp
 4e8:	6a 00                	push   $0x0
 4ea:	ff 75 08             	pushl  0x8(%ebp)
 4ed:	e8 ef 00 00 00       	call   5e1 <open>
  if(fd < 0)
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	85 c0                	test   %eax,%eax
 4f7:	78 27                	js     520 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4f9:	83 ec 08             	sub    $0x8,%esp
 4fc:	ff 75 0c             	pushl  0xc(%ebp)
 4ff:	89 c3                	mov    %eax,%ebx
 501:	50                   	push   %eax
 502:	e8 f2 00 00 00       	call   5f9 <fstat>
  close(fd);
 507:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 50a:	89 c6                	mov    %eax,%esi
  close(fd);
 50c:	e8 b8 00 00 00       	call   5c9 <close>
  return r;
 511:	83 c4 10             	add    $0x10,%esp
}
 514:	8d 65 f8             	lea    -0x8(%ebp),%esp
 517:	89 f0                	mov    %esi,%eax
 519:	5b                   	pop    %ebx
 51a:	5e                   	pop    %esi
 51b:	5d                   	pop    %ebp
 51c:	c3                   	ret    
 51d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 520:	be ff ff ff ff       	mov    $0xffffffff,%esi
 525:	eb ed                	jmp    514 <stat+0x34>
 527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52e:	66 90                	xchg   %ax,%ax

00000530 <atoi>:

int
atoi(const char *s)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	53                   	push   %ebx
 534:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 537:	0f be 11             	movsbl (%ecx),%edx
 53a:	8d 42 d0             	lea    -0x30(%edx),%eax
 53d:	3c 09                	cmp    $0x9,%al
  n = 0;
 53f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 544:	77 1f                	ja     565 <atoi+0x35>
 546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 54d:	8d 76 00             	lea    0x0(%esi),%esi
    n = n*10 + *s++ - '0';
 550:	83 c1 01             	add    $0x1,%ecx
 553:	8d 04 80             	lea    (%eax,%eax,4),%eax
 556:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 55a:	0f be 11             	movsbl (%ecx),%edx
 55d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 560:	80 fb 09             	cmp    $0x9,%bl
 563:	76 eb                	jbe    550 <atoi+0x20>
  return n;
}
 565:	5b                   	pop    %ebx
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    
 568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56f:	90                   	nop

00000570 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	57                   	push   %edi
 574:	8b 55 10             	mov    0x10(%ebp),%edx
 577:	8b 45 08             	mov    0x8(%ebp),%eax
 57a:	56                   	push   %esi
 57b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 57e:	85 d2                	test   %edx,%edx
 580:	7e 13                	jle    595 <memmove+0x25>
 582:	01 c2                	add    %eax,%edx
  dst = vdst;
 584:	89 c7                	mov    %eax,%edi
 586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 590:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 591:	39 fa                	cmp    %edi,%edx
 593:	75 fb                	jne    590 <memmove+0x20>
  return vdst;
}
 595:	5e                   	pop    %esi
 596:	5f                   	pop    %edi
 597:	5d                   	pop    %ebp
 598:	c3                   	ret    

00000599 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 599:	b8 01 00 00 00       	mov    $0x1,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <exit>:
SYSCALL(exit)
 5a1:	b8 02 00 00 00       	mov    $0x2,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <wait>:
SYSCALL(wait)
 5a9:	b8 03 00 00 00       	mov    $0x3,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <pipe>:
SYSCALL(pipe)
 5b1:	b8 04 00 00 00       	mov    $0x4,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <read>:
SYSCALL(read)
 5b9:	b8 05 00 00 00       	mov    $0x5,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <write>:
SYSCALL(write)
 5c1:	b8 10 00 00 00       	mov    $0x10,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <close>:
SYSCALL(close)
 5c9:	b8 15 00 00 00       	mov    $0x15,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <kill>:
SYSCALL(kill)
 5d1:	b8 06 00 00 00       	mov    $0x6,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <exec>:
SYSCALL(exec)
 5d9:	b8 07 00 00 00       	mov    $0x7,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <open>:
SYSCALL(open)
 5e1:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <mknod>:
SYSCALL(mknod)
 5e9:	b8 11 00 00 00       	mov    $0x11,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <unlink>:
SYSCALL(unlink)
 5f1:	b8 12 00 00 00       	mov    $0x12,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <fstat>:
SYSCALL(fstat)
 5f9:	b8 08 00 00 00       	mov    $0x8,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <link>:
SYSCALL(link)
 601:	b8 13 00 00 00       	mov    $0x13,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <mkdir>:
SYSCALL(mkdir)
 609:	b8 14 00 00 00       	mov    $0x14,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <chdir>:
SYSCALL(chdir)
 611:	b8 09 00 00 00       	mov    $0x9,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <dup>:
SYSCALL(dup)
 619:	b8 0a 00 00 00       	mov    $0xa,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <getpid>:
SYSCALL(getpid)
 621:	b8 0b 00 00 00       	mov    $0xb,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <sbrk>:
SYSCALL(sbrk)
 629:	b8 0c 00 00 00       	mov    $0xc,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <sleep>:
SYSCALL(sleep)
 631:	b8 0d 00 00 00       	mov    $0xd,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <uptime>:
SYSCALL(uptime)
 639:	b8 0e 00 00 00       	mov    $0xe,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <cps>:
SYSCALL(cps)
 641:	b8 16 00 00 00       	mov    $0x16,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <nps>:
SYSCALL(nps)
 649:	b8 17 00 00 00       	mov    $0x17,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <chpr>:
SYSCALL(chpr)
 651:	b8 18 00 00 00       	mov    $0x18,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <pfs>:
SYSCALL(pfs)
 659:	b8 19 00 00 00       	mov    $0x19,%eax
 65e:	cd 40                	int    $0x40
 660:	c3                   	ret    
 661:	66 90                	xchg   %ax,%ax
 663:	66 90                	xchg   %ax,%ax
 665:	66 90                	xchg   %ax,%ax
 667:	66 90                	xchg   %ax,%ax
 669:	66 90                	xchg   %ax,%ax
 66b:	66 90                	xchg   %ax,%ax
 66d:	66 90                	xchg   %ax,%ax
 66f:	90                   	nop

00000670 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	57                   	push   %edi
 674:	56                   	push   %esi
 675:	53                   	push   %ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 676:	89 d3                	mov    %edx,%ebx
{
 678:	83 ec 3c             	sub    $0x3c,%esp
 67b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  if(sgn && xx < 0){
 67e:	85 d2                	test   %edx,%edx
 680:	0f 89 92 00 00 00    	jns    718 <printint+0xa8>
 686:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 68a:	0f 84 88 00 00 00    	je     718 <printint+0xa8>
    neg = 1;
 690:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
    x = -xx;
 697:	f7 db                	neg    %ebx
  } else {
    x = xx;
  }

  i = 0;
 699:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6a0:	8d 75 d7             	lea    -0x29(%ebp),%esi
 6a3:	eb 08                	jmp    6ad <printint+0x3d>
 6a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6a8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  }while((x /= base) != 0);
 6ab:	89 c3                	mov    %eax,%ebx
    buf[i++] = digits[x % base];
 6ad:	89 d8                	mov    %ebx,%eax
 6af:	31 d2                	xor    %edx,%edx
 6b1:	8b 7d c4             	mov    -0x3c(%ebp),%edi
 6b4:	f7 f1                	div    %ecx
 6b6:	83 c7 01             	add    $0x1,%edi
 6b9:	0f b6 92 ec 0a 00 00 	movzbl 0xaec(%edx),%edx
 6c0:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
 6c3:	39 d9                	cmp    %ebx,%ecx
 6c5:	76 e1                	jbe    6a8 <printint+0x38>
  if(neg)
 6c7:	8b 45 c0             	mov    -0x40(%ebp),%eax
 6ca:	85 c0                	test   %eax,%eax
 6cc:	74 0d                	je     6db <printint+0x6b>
    buf[i++] = '-';
 6ce:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 6d3:	ba 2d 00 00 00       	mov    $0x2d,%edx
    buf[i++] = digits[x % base];
 6d8:	89 7d c4             	mov    %edi,-0x3c(%ebp)
 6db:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 6de:	8b 7d bc             	mov    -0x44(%ebp),%edi
 6e1:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 6e5:	eb 0f                	jmp    6f6 <printint+0x86>
 6e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ee:	66 90                	xchg   %ax,%ax
 6f0:	0f b6 13             	movzbl (%ebx),%edx
 6f3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 6f6:	83 ec 04             	sub    $0x4,%esp
 6f9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 6fc:	6a 01                	push   $0x1
 6fe:	56                   	push   %esi
 6ff:	57                   	push   %edi
 700:	e8 bc fe ff ff       	call   5c1 <write>

  while(--i >= 0)
 705:	83 c4 10             	add    $0x10,%esp
 708:	39 de                	cmp    %ebx,%esi
 70a:	75 e4                	jne    6f0 <printint+0x80>
    putc(fd, buf[i]);
}
 70c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 70f:	5b                   	pop    %ebx
 710:	5e                   	pop    %esi
 711:	5f                   	pop    %edi
 712:	5d                   	pop    %ebp
 713:	c3                   	ret    
 714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 718:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
 71f:	e9 75 ff ff ff       	jmp    699 <printint+0x29>
 724:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 72f:	90                   	nop

00000730 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	53                   	push   %ebx
 736:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 739:	8b 75 0c             	mov    0xc(%ebp),%esi
 73c:	0f b6 1e             	movzbl (%esi),%ebx
 73f:	84 db                	test   %bl,%bl
 741:	0f 84 b9 00 00 00    	je     800 <printf+0xd0>
  ap = (uint*)(void*)&fmt + 1;
 747:	8d 45 10             	lea    0x10(%ebp),%eax
 74a:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 74d:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 750:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 752:	89 45 d0             	mov    %eax,-0x30(%ebp)
 755:	eb 38                	jmp    78f <printf+0x5f>
 757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75e:	66 90                	xchg   %ax,%ax
 760:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 763:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 768:	83 f8 25             	cmp    $0x25,%eax
 76b:	74 17                	je     784 <printf+0x54>
  write(fd, &c, 1);
 76d:	83 ec 04             	sub    $0x4,%esp
 770:	88 5d e7             	mov    %bl,-0x19(%ebp)
 773:	6a 01                	push   $0x1
 775:	57                   	push   %edi
 776:	ff 75 08             	pushl  0x8(%ebp)
 779:	e8 43 fe ff ff       	call   5c1 <write>
 77e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 781:	83 c4 10             	add    $0x10,%esp
 784:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 787:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 78b:	84 db                	test   %bl,%bl
 78d:	74 71                	je     800 <printf+0xd0>
    c = fmt[i] & 0xff;
 78f:	0f be cb             	movsbl %bl,%ecx
 792:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 795:	85 d2                	test   %edx,%edx
 797:	74 c7                	je     760 <printf+0x30>
      }
    } else if(state == '%'){
 799:	83 fa 25             	cmp    $0x25,%edx
 79c:	75 e6                	jne    784 <printf+0x54>
      if(c == 'd'){
 79e:	83 f8 64             	cmp    $0x64,%eax
 7a1:	0f 84 99 00 00 00    	je     840 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7a7:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7ad:	83 f9 70             	cmp    $0x70,%ecx
 7b0:	74 5e                	je     810 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7b2:	83 f8 73             	cmp    $0x73,%eax
 7b5:	0f 84 d5 00 00 00    	je     890 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7bb:	83 f8 63             	cmp    $0x63,%eax
 7be:	0f 84 8c 00 00 00    	je     850 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7c4:	83 f8 25             	cmp    $0x25,%eax
 7c7:	0f 84 b3 00 00 00    	je     880 <printf+0x150>
  write(fd, &c, 1);
 7cd:	83 ec 04             	sub    $0x4,%esp
 7d0:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7d4:	6a 01                	push   $0x1
 7d6:	57                   	push   %edi
 7d7:	ff 75 08             	pushl  0x8(%ebp)
 7da:	e8 e2 fd ff ff       	call   5c1 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7df:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7e2:	83 c4 0c             	add    $0xc,%esp
 7e5:	6a 01                	push   $0x1
 7e7:	83 c6 01             	add    $0x1,%esi
 7ea:	57                   	push   %edi
 7eb:	ff 75 08             	pushl  0x8(%ebp)
 7ee:	e8 ce fd ff ff       	call   5c1 <write>
  for(i = 0; fmt[i]; i++){
 7f3:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 7f7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7fa:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 7fc:	84 db                	test   %bl,%bl
 7fe:	75 8f                	jne    78f <printf+0x5f>
    }
  }
}
 800:	8d 65 f4             	lea    -0xc(%ebp),%esp
 803:	5b                   	pop    %ebx
 804:	5e                   	pop    %esi
 805:	5f                   	pop    %edi
 806:	5d                   	pop    %ebp
 807:	c3                   	ret    
 808:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 80f:	90                   	nop
        printint(fd, *ap, 16, 0);
 810:	83 ec 0c             	sub    $0xc,%esp
 813:	b9 10 00 00 00       	mov    $0x10,%ecx
 818:	6a 00                	push   $0x0
 81a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
 820:	8b 13                	mov    (%ebx),%edx
 822:	e8 49 fe ff ff       	call   670 <printint>
        ap++;
 827:	89 d8                	mov    %ebx,%eax
 829:	83 c4 10             	add    $0x10,%esp
      state = 0;
 82c:	31 d2                	xor    %edx,%edx
        ap++;
 82e:	83 c0 04             	add    $0x4,%eax
 831:	89 45 d0             	mov    %eax,-0x30(%ebp)
 834:	e9 4b ff ff ff       	jmp    784 <printf+0x54>
 839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 840:	83 ec 0c             	sub    $0xc,%esp
 843:	b9 0a 00 00 00       	mov    $0xa,%ecx
 848:	6a 01                	push   $0x1
 84a:	eb ce                	jmp    81a <printf+0xea>
 84c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 850:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 853:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 856:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 858:	6a 01                	push   $0x1
        ap++;
 85a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 85d:	57                   	push   %edi
 85e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 861:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 864:	e8 58 fd ff ff       	call   5c1 <write>
        ap++;
 869:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 86c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 86f:	31 d2                	xor    %edx,%edx
 871:	e9 0e ff ff ff       	jmp    784 <printf+0x54>
 876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 87d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 880:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 883:	83 ec 04             	sub    $0x4,%esp
 886:	e9 5a ff ff ff       	jmp    7e5 <printf+0xb5>
 88b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 88f:	90                   	nop
        s = (char*)*ap;
 890:	8b 45 d0             	mov    -0x30(%ebp),%eax
 893:	8b 18                	mov    (%eax),%ebx
        ap++;
 895:	83 c0 04             	add    $0x4,%eax
 898:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 89b:	85 db                	test   %ebx,%ebx
 89d:	74 17                	je     8b6 <printf+0x186>
        while(*s != 0){
 89f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 8a2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 8a4:	84 c0                	test   %al,%al
 8a6:	0f 84 d8 fe ff ff    	je     784 <printf+0x54>
 8ac:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8af:	89 de                	mov    %ebx,%esi
 8b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8b4:	eb 1a                	jmp    8d0 <printf+0x1a0>
          s = "(null)";
 8b6:	bb e2 0a 00 00       	mov    $0xae2,%ebx
        while(*s != 0){
 8bb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8be:	b8 28 00 00 00       	mov    $0x28,%eax
 8c3:	89 de                	mov    %ebx,%esi
 8c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8cf:	90                   	nop
  write(fd, &c, 1);
 8d0:	83 ec 04             	sub    $0x4,%esp
          s++;
 8d3:	83 c6 01             	add    $0x1,%esi
 8d6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8d9:	6a 01                	push   $0x1
 8db:	57                   	push   %edi
 8dc:	53                   	push   %ebx
 8dd:	e8 df fc ff ff       	call   5c1 <write>
        while(*s != 0){
 8e2:	0f b6 06             	movzbl (%esi),%eax
 8e5:	83 c4 10             	add    $0x10,%esp
 8e8:	84 c0                	test   %al,%al
 8ea:	75 e4                	jne    8d0 <printf+0x1a0>
 8ec:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 8ef:	31 d2                	xor    %edx,%edx
 8f1:	e9 8e fe ff ff       	jmp    784 <printf+0x54>
 8f6:	66 90                	xchg   %ax,%ax
 8f8:	66 90                	xchg   %ax,%ax
 8fa:	66 90                	xchg   %ax,%ax
 8fc:	66 90                	xchg   %ax,%ax
 8fe:	66 90                	xchg   %ax,%ax

00000900 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 900:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 901:	a1 28 0e 00 00       	mov    0xe28,%eax
{
 906:	89 e5                	mov    %esp,%ebp
 908:	57                   	push   %edi
 909:	56                   	push   %esi
 90a:	53                   	push   %ebx
 90b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 90e:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 910:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 913:	39 c8                	cmp    %ecx,%eax
 915:	73 19                	jae    930 <free+0x30>
 917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 91e:	66 90                	xchg   %ax,%ax
 920:	39 d1                	cmp    %edx,%ecx
 922:	72 14                	jb     938 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 924:	39 d0                	cmp    %edx,%eax
 926:	73 10                	jae    938 <free+0x38>
{
 928:	89 d0                	mov    %edx,%eax
 92a:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92c:	39 c8                	cmp    %ecx,%eax
 92e:	72 f0                	jb     920 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 930:	39 d0                	cmp    %edx,%eax
 932:	72 f4                	jb     928 <free+0x28>
 934:	39 d1                	cmp    %edx,%ecx
 936:	73 f0                	jae    928 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 938:	8b 73 fc             	mov    -0x4(%ebx),%esi
 93b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 93e:	39 fa                	cmp    %edi,%edx
 940:	74 1e                	je     960 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 942:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 945:	8b 50 04             	mov    0x4(%eax),%edx
 948:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 94b:	39 f1                	cmp    %esi,%ecx
 94d:	74 28                	je     977 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 94f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 951:	5b                   	pop    %ebx
  freep = p;
 952:	a3 28 0e 00 00       	mov    %eax,0xe28
}
 957:	5e                   	pop    %esi
 958:	5f                   	pop    %edi
 959:	5d                   	pop    %ebp
 95a:	c3                   	ret    
 95b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 95f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 960:	03 72 04             	add    0x4(%edx),%esi
 963:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 966:	8b 10                	mov    (%eax),%edx
 968:	8b 12                	mov    (%edx),%edx
 96a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 96d:	8b 50 04             	mov    0x4(%eax),%edx
 970:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 973:	39 f1                	cmp    %esi,%ecx
 975:	75 d8                	jne    94f <free+0x4f>
    p->s.size += bp->s.size;
 977:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 97a:	a3 28 0e 00 00       	mov    %eax,0xe28
    p->s.size += bp->s.size;
 97f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 982:	8b 53 f8             	mov    -0x8(%ebx),%edx
 985:	89 10                	mov    %edx,(%eax)
}
 987:	5b                   	pop    %ebx
 988:	5e                   	pop    %esi
 989:	5f                   	pop    %edi
 98a:	5d                   	pop    %ebp
 98b:	c3                   	ret    
 98c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000990 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	57                   	push   %edi
 994:	56                   	push   %esi
 995:	53                   	push   %ebx
 996:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 999:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 99c:	8b 3d 28 0e 00 00    	mov    0xe28,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a2:	8d 70 07             	lea    0x7(%eax),%esi
 9a5:	c1 ee 03             	shr    $0x3,%esi
 9a8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 9ab:	85 ff                	test   %edi,%edi
 9ad:	0f 84 ad 00 00 00    	je     a60 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 9b5:	8b 4a 04             	mov    0x4(%edx),%ecx
 9b8:	39 f1                	cmp    %esi,%ecx
 9ba:	73 72                	jae    a2e <malloc+0x9e>
 9bc:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 9c2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9c7:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 9ca:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 9d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 9d4:	eb 1b                	jmp    9f1 <malloc+0x61>
 9d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9e2:	8b 48 04             	mov    0x4(%eax),%ecx
 9e5:	39 f1                	cmp    %esi,%ecx
 9e7:	73 4f                	jae    a38 <malloc+0xa8>
 9e9:	8b 3d 28 0e 00 00    	mov    0xe28,%edi
 9ef:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9f1:	39 d7                	cmp    %edx,%edi
 9f3:	75 eb                	jne    9e0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 9f5:	83 ec 0c             	sub    $0xc,%esp
 9f8:	ff 75 e4             	pushl  -0x1c(%ebp)
 9fb:	e8 29 fc ff ff       	call   629 <sbrk>
  if(p == (char*)-1)
 a00:	83 c4 10             	add    $0x10,%esp
 a03:	83 f8 ff             	cmp    $0xffffffff,%eax
 a06:	74 1c                	je     a24 <malloc+0x94>
  hp->s.size = nu;
 a08:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a0b:	83 ec 0c             	sub    $0xc,%esp
 a0e:	83 c0 08             	add    $0x8,%eax
 a11:	50                   	push   %eax
 a12:	e8 e9 fe ff ff       	call   900 <free>
  return freep;
 a17:	8b 15 28 0e 00 00    	mov    0xe28,%edx
      if((p = morecore(nunits)) == 0)
 a1d:	83 c4 10             	add    $0x10,%esp
 a20:	85 d2                	test   %edx,%edx
 a22:	75 bc                	jne    9e0 <malloc+0x50>
        return 0;
  }
}
 a24:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a27:	31 c0                	xor    %eax,%eax
}
 a29:	5b                   	pop    %ebx
 a2a:	5e                   	pop    %esi
 a2b:	5f                   	pop    %edi
 a2c:	5d                   	pop    %ebp
 a2d:	c3                   	ret    
    if(p->s.size >= nunits){
 a2e:	89 d0                	mov    %edx,%eax
 a30:	89 fa                	mov    %edi,%edx
 a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a38:	39 ce                	cmp    %ecx,%esi
 a3a:	74 54                	je     a90 <malloc+0x100>
        p->s.size -= nunits;
 a3c:	29 f1                	sub    %esi,%ecx
 a3e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a41:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a44:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 a47:	89 15 28 0e 00 00    	mov    %edx,0xe28
}
 a4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a50:	83 c0 08             	add    $0x8,%eax
}
 a53:	5b                   	pop    %ebx
 a54:	5e                   	pop    %esi
 a55:	5f                   	pop    %edi
 a56:	5d                   	pop    %ebp
 a57:	c3                   	ret    
 a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a5f:	90                   	nop
    base.s.ptr = freep = prevp = &base;
 a60:	c7 05 28 0e 00 00 2c 	movl   $0xe2c,0xe28
 a67:	0e 00 00 
    base.s.size = 0;
 a6a:	bf 2c 0e 00 00       	mov    $0xe2c,%edi
    base.s.ptr = freep = prevp = &base;
 a6f:	c7 05 2c 0e 00 00 2c 	movl   $0xe2c,0xe2c
 a76:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a79:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 a7b:	c7 05 30 0e 00 00 00 	movl   $0x0,0xe30
 a82:	00 00 00 
    if(p->s.size >= nunits){
 a85:	e9 32 ff ff ff       	jmp    9bc <malloc+0x2c>
 a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a90:	8b 08                	mov    (%eax),%ecx
 a92:	89 0a                	mov    %ecx,(%edx)
 a94:	eb b1                	jmp    a47 <malloc+0xb7>
