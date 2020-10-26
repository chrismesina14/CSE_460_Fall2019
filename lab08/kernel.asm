
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 31 10 80       	mov    $0x801031f0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 73 10 80       	push   $0x801073c0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 85 46 00 00       	call   801046e0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100063:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	83 ec 08             	sub    $0x8,%esp
80100085:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 73 10 80       	push   $0x801073c7
80100097:	50                   	push   %eax
80100098:	e8 33 45 00 00       	call   801045d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a2:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a4:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 f7 46 00 00       	call   801047e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 99 47 00 00       	call   80104900 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 44 00 00       	call   80104610 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 af 22 00 00       	call   80102440 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ce 73 10 80       	push   $0x801073ce
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ed 44 00 00       	call   801046b0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 67 22 00 00       	jmp    80102440 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 73 10 80       	push   $0x801073df
801001e1:	e8 aa 01 00 00       	call   80100390 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 44 00 00       	call   801046b0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 5c 44 00 00       	call   80104670 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021b:	e8 c0 45 00 00       	call   801047e0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 8f 46 00 00       	jmp    80104900 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 73 10 80       	push   $0x801073e6
80100279:	e8 12 01 00 00       	call   80100390 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010028f:	e8 7c 15 00 00       	call   80101810 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029b:	e8 40 45 00 00       	call   801047e0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002a8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002aa:	85 f6                	test   %esi,%esi
801002ac:	0f 8e a0 00 00 00    	jle    80100352 <consoleread+0xd2>
801002b2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002b4:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002ba:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d5:	e8 16 3e 00 00       	call   801040f0 <sleep>
    while(input.r == input.w){
801002da:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 40 38 00 00       	call   80103b30 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 20 a5 10 80       	push   $0x8010a520
801002ff:	e8 fc 45 00 00       	call   80104900 <release>
        ilock(ip);
80100304:	5a                   	pop    %edx
80100305:	ff 75 08             	pushl  0x8(%ebp)
80100308:	e8 23 14 00 00       	call   80101730 <ilock>
        return -1;
8010030d:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100310:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100318:	5b                   	pop    %ebx
80100319:	5e                   	pop    %esi
8010031a:	5f                   	pop    %edi
8010031b:	5d                   	pop    %ebp
8010031c:	c3                   	ret    
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 42 01             	lea    0x1(%edx),%eax
80100323:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100334:	83 f8 04             	cmp    $0x4,%eax
80100337:	74 46                	je     8010037f <consoleread+0xff>
    *dst++ = c;
80100339:	89 da                	mov    %ebx,%edx
    --n;
8010033b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033e:	f7 da                	neg    %edx
80100340:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100343:	83 f8 0a             	cmp    $0xa,%eax
80100346:	74 31                	je     80100379 <consoleread+0xf9>
  while(n > 0){
80100348:	85 db                	test   %ebx,%ebx
8010034a:	0f 85 64 ff ff ff    	jne    801002b4 <consoleread+0x34>
80100350:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100352:	83 ec 0c             	sub    $0xc,%esp
80100355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100358:	68 20 a5 10 80       	push   $0x8010a520
8010035d:	e8 9e 45 00 00       	call   80104900 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 c5 13 00 00       	call   80101730 <ilock>
  return target - n;
8010036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010036e:	83 c4 10             	add    $0x10,%esp
}
80100371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
80100379:	89 f0                	mov    %esi,%eax
8010037b:	29 d8                	sub    %ebx,%eax
8010037d:	eb d3                	jmp    80100352 <consoleread+0xd2>
      if(n < target){
8010037f:	89 f0                	mov    %esi,%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	39 f3                	cmp    %esi,%ebx
80100385:	73 cb                	jae    80100352 <consoleread+0xd2>
        input.r--;
80100387:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 c2 26 00 00       	call   80102a70 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 73 10 80       	push   $0x801073ed
801003b7:	e8 f4 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 eb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 c7 7e 10 80 	movl   $0x80107ec7,(%esp)
801003cc:	e8 df 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	8d 45 08             	lea    0x8(%ebp),%eax
801003d4:	5a                   	pop    %edx
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 23 43 00 00       	call   80104700 <getcallerpcs>
  for(i=0; i<10; i++)
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 74 10 80       	push   $0x80107401
801003ed:	e8 be 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
    ;
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010040c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 c1 5b 00 00       	call   80105ff0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004ec:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 d6 5a 00 00       	call   80105ff0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ca 5a 00 00       	call   80105ff0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 be 5a 00 00       	call   80105ff0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	68 60 0e 00 00       	push   $0xe60
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100550:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 8a 44 00 00       	call   801049f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 d5 43 00 00       	call   80104950 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 05 74 10 80       	push   $0x80107405
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 68                	js     8010061c <printint+0x7c>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	31 db                	xor    %ebx,%ebx
801005ba:	eb 04                	jmp    801005c0 <printint+0x20>
  }while((x /= base) != 0);
801005bc:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005be:	89 fb                	mov    %edi,%ebx
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	8d 7b 01             	lea    0x1(%ebx),%edi
801005c7:	f7 75 d4             	divl   -0x2c(%ebp)
801005ca:	0f b6 92 30 74 10 80 	movzbl -0x7fef8bd0(%edx),%edx
801005d1:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005d5:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
801005d8:	76 e2                	jbe    801005bc <printint+0x1c>
  if(sign)
801005da:	85 f6                	test   %esi,%esi
801005dc:	75 32                	jne    80100610 <printint+0x70>
801005de:	0f be c2             	movsbl %dl,%eax
801005e1:	89 df                	mov    %ebx,%edi
  if(panicked){
801005e3:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801005e9:	85 c9                	test   %ecx,%ecx
801005eb:	75 20                	jne    8010060d <printint+0x6d>
801005ed:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005f1:	e8 1a fe ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
801005f6:	8d 45 d7             	lea    -0x29(%ebp),%eax
801005f9:	39 d8                	cmp    %ebx,%eax
801005fb:	74 27                	je     80100624 <printint+0x84>
  if(panicked){
801005fd:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i]);
80100603:	0f be 03             	movsbl (%ebx),%eax
  if(panicked){
80100606:	83 eb 01             	sub    $0x1,%ebx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 e4                	je     801005f1 <printint+0x51>
  asm volatile("cli");
8010060d:	fa                   	cli    
      ;
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
    buf[i++] = '-';
80100610:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100615:	b8 2d 00 00 00       	mov    $0x2d,%eax
8010061a:	eb c7                	jmp    801005e3 <printint+0x43>
    x = -xx;
8010061c:	f7 d8                	neg    %eax
8010061e:	89 ce                	mov    %ecx,%esi
80100620:	89 c1                	mov    %eax,%ecx
80100622:	eb 94                	jmp    801005b8 <printint+0x18>
}
80100624:	83 c4 2c             	add    $0x2c,%esp
80100627:	5b                   	pop    %ebx
80100628:	5e                   	pop    %esi
80100629:	5f                   	pop    %edi
8010062a:	5d                   	pop    %ebp
8010062b:	c3                   	ret    
8010062c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
80100639:	8b 7d 10             	mov    0x10(%ebp),%edi
8010063c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;

  iunlock(ip);
8010063f:	ff 75 08             	pushl  0x8(%ebp)
80100642:	e8 c9 11 00 00       	call   80101810 <iunlock>
  acquire(&cons.lock);
80100647:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064e:	e8 8d 41 00 00       	call   801047e0 <acquire>
  for(i = 0; i < n; i++)
80100653:	83 c4 10             	add    $0x10,%esp
80100656:	85 ff                	test   %edi,%edi
80100658:	7e 36                	jle    80100690 <consolewrite+0x60>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	75 21                	jne    80100685 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
80100664:	0f b6 03             	movzbl (%ebx),%eax
80100667:	8d 73 01             	lea    0x1(%ebx),%esi
8010066a:	01 fb                	add    %edi,%ebx
8010066c:	e8 9f fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
80100671:	39 de                	cmp    %ebx,%esi
80100673:	74 1b                	je     80100690 <consolewrite+0x60>
  if(panicked){
80100675:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i] & 0xff);
8010067b:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
8010067e:	83 c6 01             	add    $0x1,%esi
80100681:	85 d2                	test   %edx,%edx
80100683:	74 e7                	je     8010066c <consolewrite+0x3c>
80100685:	fa                   	cli    
      ;
80100686:	eb fe                	jmp    80100686 <consolewrite+0x56>
80100688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010068f:	90                   	nop
  release(&cons.lock);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	68 20 a5 10 80       	push   $0x8010a520
80100698:	e8 63 42 00 00       	call   80104900 <release>
  ilock(ip);
8010069d:	58                   	pop    %eax
8010069e:	ff 75 08             	pushl  0x8(%ebp)
801006a1:	e8 8a 10 00 00       	call   80101730 <ilock>

  return n;
}
801006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a9:	89 f8                	mov    %edi,%eax
801006ab:	5b                   	pop    %ebx
801006ac:	5e                   	pop    %esi
801006ad:	5f                   	pop    %edi
801006ae:	5d                   	pop    %ebp
801006af:	c3                   	ret    

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c1:	85 c0                	test   %eax,%eax
801006c3:	0f 85 df 00 00 00    	jne    801007a8 <cprintf+0xf8>
  if (fmt == 0)
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cf:	85 c0                	test   %eax,%eax
801006d1:	0f 84 5e 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d7:	0f b6 00             	movzbl (%eax),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	74 32                	je     80100710 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006de:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	74 40                	je     80100728 <cprintf+0x78>
  if(panicked){
801006e8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006ee:	85 c9                	test   %ecx,%ecx
801006f0:	74 0b                	je     801006fd <cprintf+0x4d>
801006f2:	fa                   	cli    
      ;
801006f3:	eb fe                	jmp    801006f3 <cprintf+0x43>
801006f5:	8d 76 00             	lea    0x0(%esi),%esi
801006f8:	b8 25 00 00 00       	mov    $0x25,%eax
801006fd:	e8 0e fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100705:	83 c6 01             	add    $0x1,%esi
80100708:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
8010070c:	85 c0                	test   %eax,%eax
8010070e:	75 d3                	jne    801006e3 <cprintf+0x33>
  if(locking)
80100710:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100713:	85 db                	test   %ebx,%ebx
80100715:	0f 85 05 01 00 00    	jne    80100820 <cprintf+0x170>
}
8010071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071e:	5b                   	pop    %ebx
8010071f:	5e                   	pop    %esi
80100720:	5f                   	pop    %edi
80100721:	5d                   	pop    %ebp
80100722:	c3                   	ret    
80100723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100727:	90                   	nop
    c = fmt[++i] & 0xff;
80100728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072b:	83 c6 01             	add    $0x1,%esi
8010072e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100732:	85 ff                	test   %edi,%edi
80100734:	74 da                	je     80100710 <cprintf+0x60>
    switch(c){
80100736:	83 ff 70             	cmp    $0x70,%edi
80100739:	0f 84 7e 00 00 00    	je     801007bd <cprintf+0x10d>
8010073f:	7f 26                	jg     80100767 <cprintf+0xb7>
80100741:	83 ff 25             	cmp    $0x25,%edi
80100744:	0f 84 be 00 00 00    	je     80100808 <cprintf+0x158>
8010074a:	83 ff 64             	cmp    $0x64,%edi
8010074d:	75 46                	jne    80100795 <cprintf+0xe5>
      printint(*argp++, 10, 1);
8010074f:	8b 03                	mov    (%ebx),%eax
80100751:	8d 7b 04             	lea    0x4(%ebx),%edi
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 fb                	mov    %edi,%ebx
80100760:	e8 3b fe ff ff       	call   801005a0 <printint>
      break;
80100765:	eb 9b                	jmp    80100702 <cprintf+0x52>
    switch(c){
80100767:	83 ff 73             	cmp    $0x73,%edi
8010076a:	75 24                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010076c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010076f:	8b 1b                	mov    (%ebx),%ebx
80100771:	85 db                	test   %ebx,%ebx
80100773:	75 68                	jne    801007dd <cprintf+0x12d>
80100775:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
8010077a:	bb 18 74 10 80       	mov    $0x80107418,%ebx
  if(panicked){
8010077f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100785:	85 d2                	test   %edx,%edx
80100787:	74 4c                	je     801007d5 <cprintf+0x125>
80100789:	fa                   	cli    
      ;
8010078a:	eb fe                	jmp    8010078a <cprintf+0xda>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 ff 78             	cmp    $0x78,%edi
80100793:	74 28                	je     801007bd <cprintf+0x10d>
  if(panicked){
80100795:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010079b:	85 d2                	test   %edx,%edx
8010079d:	74 4c                	je     801007eb <cprintf+0x13b>
8010079f:	fa                   	cli    
      ;
801007a0:	eb fe                	jmp    801007a0 <cprintf+0xf0>
801007a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	68 20 a5 10 80       	push   $0x8010a520
801007b0:	e8 2b 40 00 00       	call   801047e0 <acquire>
801007b5:	83 c4 10             	add    $0x10,%esp
801007b8:	e9 0c ff ff ff       	jmp    801006c9 <cprintf+0x19>
      printint(*argp++, 16, 0);
801007bd:	8b 03                	mov    (%ebx),%eax
801007bf:	8d 7b 04             	lea    0x4(%ebx),%edi
801007c2:	31 c9                	xor    %ecx,%ecx
801007c4:	ba 10 00 00 00       	mov    $0x10,%edx
801007c9:	89 fb                	mov    %edi,%ebx
801007cb:	e8 d0 fd ff ff       	call   801005a0 <printint>
      break;
801007d0:	e9 2d ff ff ff       	jmp    80100702 <cprintf+0x52>
801007d5:	e8 36 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007da:	83 c3 01             	add    $0x1,%ebx
801007dd:	0f be 03             	movsbl (%ebx),%eax
801007e0:	84 c0                	test   %al,%al
801007e2:	75 9b                	jne    8010077f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007e4:	89 fb                	mov    %edi,%ebx
801007e6:	e9 17 ff ff ff       	jmp    80100702 <cprintf+0x52>
801007eb:	b8 25 00 00 00       	mov    $0x25,%eax
801007f0:	e8 1b fc ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
801007f5:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801007fa:	85 c0                	test   %eax,%eax
801007fc:	74 4a                	je     80100848 <cprintf+0x198>
801007fe:	fa                   	cli    
      ;
801007ff:	eb fe                	jmp    801007ff <cprintf+0x14f>
80100801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100808:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	0f 84 e2 fe ff ff    	je     801006f8 <cprintf+0x48>
80100816:	fa                   	cli    
      ;
80100817:	eb fe                	jmp    80100817 <cprintf+0x167>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 d3 40 00 00       	call   80104900 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 e6 fe ff ff       	jmp    8010071b <cprintf+0x6b>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 1f 74 10 80       	push   $0x8010741f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 ae fe ff ff       	jmp    80100702 <cprintf+0x52>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	56                   	push   %esi
  int c, doprocdump = 0;
80100865:	31 f6                	xor    %esi,%esi
{
80100867:	53                   	push   %ebx
80100868:	83 ec 18             	sub    $0x18,%esp
8010086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010086e:	68 20 a5 10 80       	push   $0x8010a520
80100873:	e8 68 3f 00 00       	call   801047e0 <acquire>
  while((c = getc()) >= 0){
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	ff d7                	call   *%edi
8010087d:	89 c3                	mov    %eax,%ebx
8010087f:	85 c0                	test   %eax,%eax
80100881:	0f 88 38 01 00 00    	js     801009bf <consoleintr+0x15f>
    switch(c){
80100887:	83 fb 10             	cmp    $0x10,%ebx
8010088a:	0f 84 f0 00 00 00    	je     80100980 <consoleintr+0x120>
80100890:	0f 8e ba 00 00 00    	jle    80100950 <consoleintr+0xf0>
80100896:	83 fb 15             	cmp    $0x15,%ebx
80100899:	75 35                	jne    801008d0 <consoleintr+0x70>
      while(input.e != input.w &&
8010089b:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008a0:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008a6:	74 d3                	je     8010087b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008a8:	83 e8 01             	sub    $0x1,%eax
801008ab:	89 c2                	mov    %eax,%edx
801008ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008b0:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
801008b7:	74 c2                	je     8010087b <consoleintr+0x1b>
  if(panicked){
801008b9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
801008bf:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008c4:	85 d2                	test   %edx,%edx
801008c6:	0f 84 be 00 00 00    	je     8010098a <consoleintr+0x12a>
801008cc:	fa                   	cli    
      ;
801008cd:	eb fe                	jmp    801008cd <consoleintr+0x6d>
801008cf:	90                   	nop
    switch(c){
801008d0:	83 fb 7f             	cmp    $0x7f,%ebx
801008d3:	0f 84 7c 00 00 00    	je     80100955 <consoleintr+0xf5>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d9:	85 db                	test   %ebx,%ebx
801008db:	74 9e                	je     8010087b <consoleintr+0x1b>
801008dd:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008e2:	89 c2                	mov    %eax,%edx
801008e4:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008ea:	83 fa 7f             	cmp    $0x7f,%edx
801008ed:	77 8c                	ja     8010087b <consoleintr+0x1b>
        c = (c == '\r') ? '\n' : c;
801008ef:	8d 48 01             	lea    0x1(%eax),%ecx
801008f2:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008f8:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008fb:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100901:	83 fb 0d             	cmp    $0xd,%ebx
80100904:	0f 84 d1 00 00 00    	je     801009db <consoleintr+0x17b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010090a:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
80100910:	85 d2                	test   %edx,%edx
80100912:	0f 85 ce 00 00 00    	jne    801009e6 <consoleintr+0x186>
80100918:	89 d8                	mov    %ebx,%eax
8010091a:	e8 f1 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010091f:	83 fb 0a             	cmp    $0xa,%ebx
80100922:	0f 84 d2 00 00 00    	je     801009fa <consoleintr+0x19a>
80100928:	83 fb 04             	cmp    $0x4,%ebx
8010092b:	0f 84 c9 00 00 00    	je     801009fa <consoleintr+0x19a>
80100931:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100936:	83 e8 80             	sub    $0xffffff80,%eax
80100939:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
8010093f:	0f 85 36 ff ff ff    	jne    8010087b <consoleintr+0x1b>
80100945:	e9 b5 00 00 00       	jmp    801009ff <consoleintr+0x19f>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100950:	83 fb 08             	cmp    $0x8,%ebx
80100953:	75 84                	jne    801008d9 <consoleintr+0x79>
      if(input.e != input.w){
80100955:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095a:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100960:	0f 84 15 ff ff ff    	je     8010087b <consoleintr+0x1b>
        input.e--;
80100966:	83 e8 01             	sub    $0x1,%eax
80100969:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
8010096e:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100973:	85 c0                	test   %eax,%eax
80100975:	74 39                	je     801009b0 <consoleintr+0x150>
80100977:	fa                   	cli    
      ;
80100978:	eb fe                	jmp    80100978 <consoleintr+0x118>
8010097a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      doprocdump = 1;
80100980:	be 01 00 00 00       	mov    $0x1,%esi
80100985:	e9 f1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
8010098a:	b8 00 01 00 00       	mov    $0x100,%eax
8010098f:	e8 7c fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100994:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100999:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010099f:	0f 85 03 ff ff ff    	jne    801008a8 <consoleintr+0x48>
801009a5:	e9 d1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 56 fa ff ff       	call   80100410 <consputc.part.0>
801009ba:	e9 bc fe ff ff       	jmp    8010087b <consoleintr+0x1b>
  release(&cons.lock);
801009bf:	83 ec 0c             	sub    $0xc,%esp
801009c2:	68 20 a5 10 80       	push   $0x8010a520
801009c7:	e8 34 3f 00 00       	call   80104900 <release>
  if(doprocdump) {
801009cc:	83 c4 10             	add    $0x10,%esp
801009cf:	85 f6                	test   %esi,%esi
801009d1:	75 46                	jne    80100a19 <consoleintr+0x1b9>
}
801009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009d6:	5b                   	pop    %ebx
801009d7:	5e                   	pop    %esi
801009d8:	5f                   	pop    %edi
801009d9:	5d                   	pop    %ebp
801009da:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009db:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009e2:	85 d2                	test   %edx,%edx
801009e4:	74 0a                	je     801009f0 <consoleintr+0x190>
801009e6:	fa                   	cli    
      ;
801009e7:	eb fe                	jmp    801009e7 <consoleintr+0x187>
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f0:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f5:	e8 16 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fa:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
801009ff:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a02:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a07:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a0c:	e8 8f 38 00 00       	call   801042a0 <wakeup>
80100a11:	83 c4 10             	add    $0x10,%esp
80100a14:	e9 62 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
}
80100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1c:	5b                   	pop    %ebx
80100a1d:	5e                   	pop    %esi
80100a1e:	5f                   	pop    %edi
80100a1f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a20:	e9 5b 39 00 00       	jmp    80104380 <procdump>
80100a25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a36:	68 28 74 10 80       	push   $0x80107428
80100a3b:	68 20 a5 10 80       	push   $0x8010a520
80100a40:	e8 9b 3c 00 00       	call   801046e0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a45:	58                   	pop    %eax
80100a46:	5a                   	pop    %edx
80100a47:	6a 00                	push   $0x0
80100a49:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4b:	c7 05 6c 09 11 80 30 	movl   $0x80100630,0x8011096c
80100a52:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a55:	c7 05 68 09 11 80 80 	movl   $0x80100280,0x80110968
80100a5c:	02 10 80 
  cons.locking = 1;
80100a5f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a66:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a69:	e8 82 1b 00 00       	call   801025f0 <ioapicenable>
}
80100a6e:	83 c4 10             	add    $0x10,%esp
80100a71:	c9                   	leave  
80100a72:	c3                   	ret    
80100a73:	66 90                	xchg   %ax,%ax
80100a75:	66 90                	xchg   %ax,%ax
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	57                   	push   %edi
80100a84:	56                   	push   %esi
80100a85:	53                   	push   %ebx
80100a86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a8c:	e8 9f 30 00 00       	call   80103b30 <myproc>
80100a91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a97:	e8 44 24 00 00       	call   80102ee0 <begin_op>

  if((ip = namei(path)) == 0){
80100a9c:	83 ec 0c             	sub    $0xc,%esp
80100a9f:	ff 75 08             	pushl  0x8(%ebp)
80100aa2:	e8 29 15 00 00       	call   80101fd0 <namei>
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	85 c0                	test   %eax,%eax
80100aac:	0f 84 09 03 00 00    	je     80100dbb <exec+0x33b>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	89 c3                	mov    %eax,%ebx
80100ab7:	50                   	push   %eax
80100ab8:	e8 73 0c 00 00       	call   80101730 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100abd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac3:	6a 34                	push   $0x34
80100ac5:	6a 00                	push   $0x0
80100ac7:	50                   	push   %eax
80100ac8:	53                   	push   %ebx
80100ac9:	e8 42 0f 00 00       	call   80101a10 <readi>
80100ace:	83 c4 20             	add    $0x20,%esp
80100ad1:	83 f8 34             	cmp    $0x34,%eax
80100ad4:	74 22                	je     80100af8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	53                   	push   %ebx
80100ada:	e8 e1 0e 00 00       	call   801019c0 <iunlockput>
    end_op();
80100adf:	e8 6c 24 00 00       	call   80102f50 <end_op>
80100ae4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aef:	5b                   	pop    %ebx
80100af0:	5e                   	pop    %esi
80100af1:	5f                   	pop    %edi
80100af2:	5d                   	pop    %ebp
80100af3:	c3                   	ret    
80100af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aff:	45 4c 46 
80100b02:	75 d2                	jne    80100ad6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b04:	e8 37 66 00 00       	call   80107140 <setupkvm>
80100b09:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b0f:	85 c0                	test   %eax,%eax
80100b11:	74 c3                	je     80100ad6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b13:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b1a:	00 
80100b1b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b21:	0f 84 b3 02 00 00    	je     80100dda <exec+0x35a>
  sz = 0;
80100b27:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b2e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b31:	31 ff                	xor    %edi,%edi
80100b33:	e9 8e 00 00 00       	jmp    80100bc6 <exec+0x146>
80100b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b3f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 e8 63 00 00       	call   80106f60 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 f2 62 00 00       	call   80106ea0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 3a 0e 00 00       	call   80101a10 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 d0 64 00 00       	call   801070c0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 de fe ff ff       	jmp    80100ad6 <exec+0x56>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 9f 0d 00 00       	call   801019c0 <iunlockput>
  end_op();
80100c21:	e8 2a 23 00 00       	call   80102f50 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 29 63 00 00       	call   80106f60 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 88 65 00 00       	call   801071e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 b8 3e 00 00       	call   80104b60 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 a5 3e 00 00       	call   80104b60 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 64 66 00 00       	call   80107330 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 da 63 00 00       	call   801070c0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 f9 fd ff ff       	jmp    80100aec <exec+0x6c>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 f8 65 00 00       	call   80107330 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 aa 3d 00 00       	call   80104b20 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->priority = 2;        // Added statement at line 102
80100d9a:	c7 41 7c 02 00 00 00 	movl   $0x2,0x7c(%ecx)
  switchuvm(curproc);
80100da1:	89 0c 24             	mov    %ecx,(%esp)
80100da4:	e8 67 5f 00 00       	call   80106d10 <switchuvm>
  freevm(oldpgdir);
80100da9:	89 3c 24             	mov    %edi,(%esp)
80100dac:	e8 0f 63 00 00       	call   801070c0 <freevm>
  return 0;
80100db1:	83 c4 10             	add    $0x10,%esp
80100db4:	31 c0                	xor    %eax,%eax
80100db6:	e9 31 fd ff ff       	jmp    80100aec <exec+0x6c>
    end_op();
80100dbb:	e8 90 21 00 00       	call   80102f50 <end_op>
    cprintf("exec: fail\n");
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 41 74 10 80       	push   $0x80107441
80100dc8:	e8 e3 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dd5:	e9 12 fd ff ff       	jmp    80100aec <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dda:	31 ff                	xor    %edi,%edi
80100ddc:	be 00 20 00 00       	mov    $0x2000,%esi
80100de1:	e9 32 fe ff ff       	jmp    80100c18 <exec+0x198>
80100de6:	66 90                	xchg   %ax,%ax
80100de8:	66 90                	xchg   %ax,%ax
80100dea:	66 90                	xchg   %ax,%ax
80100dec:	66 90                	xchg   %ax,%ax
80100dee:	66 90                	xchg   %ax,%ax

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100df6:	68 4d 74 10 80       	push   $0x8010744d
80100dfb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e00:	e8 db 38 00 00       	call   801046e0 <initlock>
}
80100e05:	83 c4 10             	add    $0x10,%esp
80100e08:	c9                   	leave  
80100e09:	c3                   	ret    
80100e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e14:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e1c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e21:	e8 ba 39 00 00       	call   801047e0 <acquire>
80100e26:	83 c4 10             	add    $0x10,%esp
80100e29:	eb 10                	jmp    80100e3b <filealloc+0x2b>
80100e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 aa 3a 00 00       	call   80104900 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e6a:	e8 91 3a 00 00       	call   80104900 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	53                   	push   %ebx
80100e84:	83 ec 10             	sub    $0x10,%esp
80100e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e8f:	e8 4c 39 00 00       	call   801047e0 <acquire>
  if(f->ref < 1)
80100e94:	8b 43 04             	mov    0x4(%ebx),%eax
80100e97:	83 c4 10             	add    $0x10,%esp
80100e9a:	85 c0                	test   %eax,%eax
80100e9c:	7e 1a                	jle    80100eb8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e9e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ea7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100eac:	e8 4f 3a 00 00       	call   80104900 <release>
  return f;
}
80100eb1:	89 d8                	mov    %ebx,%eax
80100eb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb6:	c9                   	leave  
80100eb7:	c3                   	ret    
    panic("filedup");
80100eb8:	83 ec 0c             	sub    $0xc,%esp
80100ebb:	68 54 74 10 80       	push   $0x80107454
80100ec0:	e8 cb f4 ff ff       	call   80100390 <panic>
80100ec5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	57                   	push   %edi
80100ed4:	56                   	push   %esi
80100ed5:	53                   	push   %ebx
80100ed6:	83 ec 28             	sub    $0x28,%esp
80100ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100edc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ee1:	e8 fa 38 00 00       	call   801047e0 <acquire>
  if(f->ref < 1)
80100ee6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ee9:	83 c4 10             	add    $0x10,%esp
80100eec:	85 c0                	test   %eax,%eax
80100eee:	0f 8e a3 00 00 00    	jle    80100f97 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80100ef4:	83 e8 01             	sub    $0x1,%eax
80100ef7:	89 43 04             	mov    %eax,0x4(%ebx)
80100efa:	75 44                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100efc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f00:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f03:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f05:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f0e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f14:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f19:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f1c:	e8 df 39 00 00       	call   80104900 <release>

  if(ff.type == FD_PIPE)
80100f21:	83 c4 10             	add    $0x10,%esp
80100f24:	83 ff 01             	cmp    $0x1,%edi
80100f27:	74 2f                	je     80100f58 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f29:	83 ff 02             	cmp    $0x2,%edi
80100f2c:	74 4a                	je     80100f78 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f31:	5b                   	pop    %ebx
80100f32:	5e                   	pop    %esi
80100f33:	5f                   	pop    %edi
80100f34:	5d                   	pop    %ebp
80100f35:	c3                   	ret    
80100f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f3d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 ad 39 00 00       	jmp    80104900 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100f58:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f5c:	83 ec 08             	sub    $0x8,%esp
80100f5f:	53                   	push   %ebx
80100f60:	56                   	push   %esi
80100f61:	e8 2a 27 00 00       	call   80103690 <pipeclose>
80100f66:	83 c4 10             	add    $0x10,%esp
}
80100f69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6c:	5b                   	pop    %ebx
80100f6d:	5e                   	pop    %esi
80100f6e:	5f                   	pop    %edi
80100f6f:	5d                   	pop    %ebp
80100f70:	c3                   	ret    
80100f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f78:	e8 63 1f 00 00       	call   80102ee0 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	pushl  -0x20(%ebp)
80100f83:	e8 d8 08 00 00       	call   80101860 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 b9 1f 00 00       	jmp    80102f50 <end_op>
    panic("fileclose");
80100f97:	83 ec 0c             	sub    $0xc,%esp
80100f9a:	68 5c 74 10 80       	push   $0x8010745c
80100f9f:	e8 ec f3 ff ff       	call   80100390 <panic>
80100fa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100faf:	90                   	nop

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	53                   	push   %ebx
80100fb4:	83 ec 04             	sub    $0x4,%esp
80100fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fba:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fbd:	75 31                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	ff 73 10             	pushl  0x10(%ebx)
80100fc5:	e8 66 07 00 00       	call   80101730 <ilock>
    stati(f->ip, st);
80100fca:	58                   	pop    %eax
80100fcb:	5a                   	pop    %edx
80100fcc:	ff 75 0c             	pushl  0xc(%ebp)
80100fcf:	ff 73 10             	pushl  0x10(%ebx)
80100fd2:	e8 09 0a 00 00       	call   801019e0 <stati>
    iunlock(f->ip);
80100fd7:	59                   	pop    %ecx
80100fd8:	ff 73 10             	pushl  0x10(%ebx)
80100fdb:	e8 30 08 00 00       	call   80101810 <iunlock>
    return 0;
80100fe0:	83 c4 10             	add    $0x10,%esp
80100fe3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	57                   	push   %edi
80101004:	56                   	push   %esi
80101005:	53                   	push   %ebx
80101006:	83 ec 0c             	sub    $0xc,%esp
80101009:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010100c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010100f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101012:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101016:	74 60                	je     80101078 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101018:	8b 03                	mov    (%ebx),%eax
8010101a:	83 f8 01             	cmp    $0x1,%eax
8010101d:	74 41                	je     80101060 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101f:	83 f8 02             	cmp    $0x2,%eax
80101022:	75 5b                	jne    8010107f <fileread+0x7f>
    ilock(f->ip);
80101024:	83 ec 0c             	sub    $0xc,%esp
80101027:	ff 73 10             	pushl  0x10(%ebx)
8010102a:	e8 01 07 00 00       	call   80101730 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010102f:	57                   	push   %edi
80101030:	ff 73 14             	pushl  0x14(%ebx)
80101033:	56                   	push   %esi
80101034:	ff 73 10             	pushl  0x10(%ebx)
80101037:	e8 d4 09 00 00       	call   80101a10 <readi>
8010103c:	83 c4 20             	add    $0x20,%esp
8010103f:	89 c6                	mov    %eax,%esi
80101041:	85 c0                	test   %eax,%eax
80101043:	7e 03                	jle    80101048 <fileread+0x48>
      f->off += r;
80101045:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101048:	83 ec 0c             	sub    $0xc,%esp
8010104b:	ff 73 10             	pushl  0x10(%ebx)
8010104e:	e8 bd 07 00 00       	call   80101810 <iunlock>
    return r;
80101053:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	89 f0                	mov    %esi,%eax
8010105b:	5b                   	pop    %ebx
8010105c:	5e                   	pop    %esi
8010105d:	5f                   	pop    %edi
8010105e:	5d                   	pop    %ebp
8010105f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101060:	8b 43 0c             	mov    0xc(%ebx),%eax
80101063:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101069:	5b                   	pop    %ebx
8010106a:	5e                   	pop    %esi
8010106b:	5f                   	pop    %edi
8010106c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010106d:	e9 ce 27 00 00       	jmp    80103840 <piperead>
80101072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101078:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010107d:	eb d7                	jmp    80101056 <fileread+0x56>
  panic("fileread");
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	68 66 74 10 80       	push   $0x80107466
80101087:	e8 04 f3 ff ff       	call   80100390 <panic>
8010108c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	57                   	push   %edi
80101094:	56                   	push   %esi
80101095:	53                   	push   %ebx
80101096:	83 ec 1c             	sub    $0x1c,%esp
80101099:	8b 45 0c             	mov    0xc(%ebp),%eax
8010109c:	8b 75 08             	mov    0x8(%ebp),%esi
8010109f:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ac:	0f 84 bb 00 00 00    	je     8010116d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010b2:	8b 06                	mov    (%esi),%eax
801010b4:	83 f8 01             	cmp    $0x1,%eax
801010b7:	0f 84 bf 00 00 00    	je     8010117c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010bd:	83 f8 02             	cmp    $0x2,%eax
801010c0:	0f 85 c8 00 00 00    	jne    8010118e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010c9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 30                	jg     801010ff <filewrite+0x6f>
801010cf:	e9 94 00 00 00       	jmp    80101168 <filewrite+0xd8>
801010d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010d8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010db:	83 ec 0c             	sub    $0xc,%esp
801010de:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010e4:	e8 27 07 00 00       	call   80101810 <iunlock>
      end_op();
801010e9:	e8 62 1e 00 00       	call   80102f50 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f1:	83 c4 10             	add    $0x10,%esp
801010f4:	39 c3                	cmp    %eax,%ebx
801010f6:	75 60                	jne    80101158 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010f8:	01 df                	add    %ebx,%edi
    while(i < n){
801010fa:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010fd:	7e 69                	jle    80101168 <filewrite+0xd8>
      int n1 = n - i;
801010ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101102:	b8 00 06 00 00       	mov    $0x600,%eax
80101107:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101109:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010110f:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101112:	e8 c9 1d 00 00       	call   80102ee0 <begin_op>
      ilock(f->ip);
80101117:	83 ec 0c             	sub    $0xc,%esp
8010111a:	ff 76 10             	pushl  0x10(%esi)
8010111d:	e8 0e 06 00 00       	call   80101730 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101122:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101125:	53                   	push   %ebx
80101126:	ff 76 14             	pushl  0x14(%esi)
80101129:	01 f8                	add    %edi,%eax
8010112b:	50                   	push   %eax
8010112c:	ff 76 10             	pushl  0x10(%esi)
8010112f:	e8 dc 09 00 00       	call   80101b10 <writei>
80101134:	83 c4 20             	add    $0x20,%esp
80101137:	85 c0                	test   %eax,%eax
80101139:	7f 9d                	jg     801010d8 <filewrite+0x48>
      iunlock(f->ip);
8010113b:	83 ec 0c             	sub    $0xc,%esp
8010113e:	ff 76 10             	pushl  0x10(%esi)
80101141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101144:	e8 c7 06 00 00       	call   80101810 <iunlock>
      end_op();
80101149:	e8 02 1e 00 00       	call   80102f50 <end_op>
      if(r < 0)
8010114e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101151:	83 c4 10             	add    $0x10,%esp
80101154:	85 c0                	test   %eax,%eax
80101156:	75 15                	jne    8010116d <filewrite+0xdd>
        panic("short filewrite");
80101158:	83 ec 0c             	sub    $0xc,%esp
8010115b:	68 6f 74 10 80       	push   $0x8010746f
80101160:	e8 2b f2 ff ff       	call   80100390 <panic>
80101165:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101168:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010116b:	74 05                	je     80101172 <filewrite+0xe2>
    return -1;
8010116d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
80101172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101175:	89 f8                	mov    %edi,%eax
80101177:	5b                   	pop    %ebx
80101178:	5e                   	pop    %esi
80101179:	5f                   	pop    %edi
8010117a:	5d                   	pop    %ebp
8010117b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010117c:	8b 46 0c             	mov    0xc(%esi),%eax
8010117f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101182:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101185:	5b                   	pop    %ebx
80101186:	5e                   	pop    %esi
80101187:	5f                   	pop    %edi
80101188:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101189:	e9 a2 25 00 00       	jmp    80103730 <pipewrite>
  panic("filewrite");
8010118e:	83 ec 0c             	sub    $0xc,%esp
80101191:	68 75 74 10 80       	push   $0x80107475
80101196:	e8 f5 f1 ff ff       	call   80100390 <panic>
8010119b:	66 90                	xchg   %ax,%ax
8010119d:	66 90                	xchg   %ax,%ax
8010119f:	90                   	nop

801011a0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	57                   	push   %edi
801011a4:	56                   	push   %esi
801011a5:	53                   	push   %ebx
801011a6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011a9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
801011af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011b2:	85 c9                	test   %ecx,%ecx
801011b4:	0f 84 87 00 00 00    	je     80101241 <balloc+0xa1>
801011ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	89 f0                	mov    %esi,%eax
801011c9:	c1 f8 0c             	sar    $0xc,%eax
801011cc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011d2:	50                   	push   %eax
801011d3:	ff 75 d8             	pushl  -0x28(%ebp)
801011d6:	e8 f5 ee ff ff       	call   801000d0 <bread>
801011db:	83 c4 10             	add    $0x10,%esp
801011de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011e1:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011e9:	31 c0                	xor    %eax,%eax
801011eb:	eb 2f                	jmp    8010121c <balloc+0x7c>
801011ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011f0:	89 c1                	mov    %eax,%ecx
801011f2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011fa:	83 e1 07             	and    $0x7,%ecx
801011fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ff:	89 c1                	mov    %eax,%ecx
80101201:	c1 f9 03             	sar    $0x3,%ecx
80101204:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101209:	89 fa                	mov    %edi,%edx
8010120b:	85 df                	test   %ebx,%edi
8010120d:	74 41                	je     80101250 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010120f:	83 c0 01             	add    $0x1,%eax
80101212:	83 c6 01             	add    $0x1,%esi
80101215:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010121a:	74 05                	je     80101221 <balloc+0x81>
8010121c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010121f:	77 cf                	ja     801011f0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	ff 75 e4             	pushl  -0x1c(%ebp)
80101227:	e8 c4 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010122c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101233:	83 c4 10             	add    $0x10,%esp
80101236:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101239:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010123f:	77 80                	ja     801011c1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	68 7f 74 10 80       	push   $0x8010747f
80101249:	e8 42 f1 ff ff       	call   80100390 <panic>
8010124e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101250:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101253:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101256:	09 da                	or     %ebx,%edx
80101258:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010125c:	57                   	push   %edi
8010125d:	e8 5e 1e 00 00       	call   801030c0 <log_write>
        brelse(bp);
80101262:	89 3c 24             	mov    %edi,(%esp)
80101265:	e8 86 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010126a:	58                   	pop    %eax
8010126b:	5a                   	pop    %edx
8010126c:	56                   	push   %esi
8010126d:	ff 75 d8             	pushl  -0x28(%ebp)
80101270:	e8 5b ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101275:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101278:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010127a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010127d:	68 00 02 00 00       	push   $0x200
80101282:	6a 00                	push   $0x0
80101284:	50                   	push   %eax
80101285:	e8 c6 36 00 00       	call   80104950 <memset>
  log_write(bp);
8010128a:	89 1c 24             	mov    %ebx,(%esp)
8010128d:	e8 2e 1e 00 00       	call   801030c0 <log_write>
  brelse(bp);
80101292:	89 1c 24             	mov    %ebx,(%esp)
80101295:	e8 56 ef ff ff       	call   801001f0 <brelse>
}
8010129a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010129d:	89 f0                	mov    %esi,%eax
8010129f:	5b                   	pop    %ebx
801012a0:	5e                   	pop    %esi
801012a1:	5f                   	pop    %edi
801012a2:	5d                   	pop    %ebp
801012a3:	c3                   	ret    
801012a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012af:	90                   	nop

801012b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	89 c7                	mov    %eax,%edi
801012b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012b7:	31 f6                	xor    %esi,%esi
{
801012b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ba:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012bf:	83 ec 28             	sub    $0x28,%esp
801012c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012c5:	68 e0 09 11 80       	push   $0x801109e0
801012ca:	e8 11 35 00 00       	call   801047e0 <acquire>
801012cf:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012d5:	eb 1b                	jmp    801012f2 <iget+0x42>
801012d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012de:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012e0:	39 3b                	cmp    %edi,(%ebx)
801012e2:	74 6c                	je     80101350 <iget+0xa0>
801012e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ea:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012f0:	73 26                	jae    80101318 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012f5:	85 c9                	test   %ecx,%ecx
801012f7:	7f e7                	jg     801012e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f9:	85 f6                	test   %esi,%esi
801012fb:	75 e7                	jne    801012e4 <iget+0x34>
801012fd:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80101303:	85 c9                	test   %ecx,%ecx
80101305:	75 70                	jne    80101377 <iget+0xc7>
80101307:	89 de                	mov    %ebx,%esi
80101309:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101311:	72 df                	jb     801012f2 <iget+0x42>
80101313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101317:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101318:	85 f6                	test   %esi,%esi
8010131a:	74 74                	je     80101390 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010131c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010131f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101321:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101324:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010132b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101332:	68 e0 09 11 80       	push   $0x801109e0
80101337:	e8 c4 35 00 00       	call   80104900 <release>

  return ip;
8010133c:	83 c4 10             	add    $0x10,%esp
}
8010133f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101342:	89 f0                	mov    %esi,%eax
80101344:	5b                   	pop    %ebx
80101345:	5e                   	pop    %esi
80101346:	5f                   	pop    %edi
80101347:	5d                   	pop    %ebp
80101348:	c3                   	ret    
80101349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101350:	39 53 04             	cmp    %edx,0x4(%ebx)
80101353:	75 8f                	jne    801012e4 <iget+0x34>
      release(&icache.lock);
80101355:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101358:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010135b:	89 de                	mov    %ebx,%esi
      ip->ref++;
8010135d:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101360:	68 e0 09 11 80       	push   $0x801109e0
80101365:	e8 96 35 00 00       	call   80104900 <release>
      return ip;
8010136a:	83 c4 10             	add    $0x10,%esp
}
8010136d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101370:	89 f0                	mov    %esi,%eax
80101372:	5b                   	pop    %ebx
80101373:	5e                   	pop    %esi
80101374:	5f                   	pop    %edi
80101375:	5d                   	pop    %ebp
80101376:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101377:	3d 34 26 11 80       	cmp    $0x80112634,%eax
8010137c:	73 12                	jae    80101390 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010137e:	8b 48 08             	mov    0x8(%eax),%ecx
80101381:	89 c3                	mov    %eax,%ebx
80101383:	85 c9                	test   %ecx,%ecx
80101385:	0f 8f 55 ff ff ff    	jg     801012e0 <iget+0x30>
8010138b:	e9 6d ff ff ff       	jmp    801012fd <iget+0x4d>
    panic("iget: no inodes");
80101390:	83 ec 0c             	sub    $0xc,%esp
80101393:	68 95 74 10 80       	push   $0x80107495
80101398:	e8 f3 ef ff ff       	call   80100390 <panic>
8010139d:	8d 76 00             	lea    0x0(%esi),%esi

801013a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	89 c6                	mov    %eax,%esi
801013a7:	53                   	push   %ebx
801013a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013ab:	83 fa 0b             	cmp    $0xb,%edx
801013ae:	0f 86 84 00 00 00    	jbe    80101438 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013b7:	83 fb 7f             	cmp    $0x7f,%ebx
801013ba:	0f 87 98 00 00 00    	ja     80101458 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013c0:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013c6:	8b 00                	mov    (%eax),%eax
801013c8:	85 d2                	test   %edx,%edx
801013ca:	74 54                	je     80101420 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013cc:	83 ec 08             	sub    $0x8,%esp
801013cf:	52                   	push   %edx
801013d0:	50                   	push   %eax
801013d1:	e8 fa ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013d6:	83 c4 10             	add    $0x10,%esp
801013d9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801013dd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013df:	8b 1a                	mov    (%edx),%ebx
801013e1:	85 db                	test   %ebx,%ebx
801013e3:	74 1b                	je     80101400 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013e5:	83 ec 0c             	sub    $0xc,%esp
801013e8:	57                   	push   %edi
801013e9:	e8 02 ee ff ff       	call   801001f0 <brelse>
    return addr;
801013ee:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801013f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f4:	89 d8                	mov    %ebx,%eax
801013f6:	5b                   	pop    %ebx
801013f7:	5e                   	pop    %esi
801013f8:	5f                   	pop    %edi
801013f9:	5d                   	pop    %ebp
801013fa:	c3                   	ret    
801013fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013ff:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101400:	8b 06                	mov    (%esi),%eax
80101402:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101405:	e8 96 fd ff ff       	call   801011a0 <balloc>
8010140a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010140d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101410:	89 c3                	mov    %eax,%ebx
80101412:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101414:	57                   	push   %edi
80101415:	e8 a6 1c 00 00       	call   801030c0 <log_write>
8010141a:	83 c4 10             	add    $0x10,%esp
8010141d:	eb c6                	jmp    801013e5 <bmap+0x45>
8010141f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101420:	e8 7b fd ff ff       	call   801011a0 <balloc>
80101425:	89 c2                	mov    %eax,%edx
80101427:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010142d:	8b 06                	mov    (%esi),%eax
8010142f:	eb 9b                	jmp    801013cc <bmap+0x2c>
80101431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101438:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010143b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010143e:	85 db                	test   %ebx,%ebx
80101440:	75 af                	jne    801013f1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101442:	8b 00                	mov    (%eax),%eax
80101444:	e8 57 fd ff ff       	call   801011a0 <balloc>
80101449:	89 47 5c             	mov    %eax,0x5c(%edi)
8010144c:	89 c3                	mov    %eax,%ebx
}
8010144e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101451:	89 d8                	mov    %ebx,%eax
80101453:	5b                   	pop    %ebx
80101454:	5e                   	pop    %esi
80101455:	5f                   	pop    %edi
80101456:	5d                   	pop    %ebp
80101457:	c3                   	ret    
  panic("bmap: out of range");
80101458:	83 ec 0c             	sub    $0xc,%esp
8010145b:	68 a5 74 10 80       	push   $0x801074a5
80101460:	e8 2b ef ff ff       	call   80100390 <panic>
80101465:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101470 <readsb>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	56                   	push   %esi
80101474:	53                   	push   %ebx
80101475:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101478:	83 ec 08             	sub    $0x8,%esp
8010147b:	6a 01                	push   $0x1
8010147d:	ff 75 08             	pushl  0x8(%ebp)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101485:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101488:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010148a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010148d:	6a 1c                	push   $0x1c
8010148f:	50                   	push   %eax
80101490:	56                   	push   %esi
80101491:	e8 5a 35 00 00       	call   801049f0 <memmove>
  brelse(bp);
80101496:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101499:	83 c4 10             	add    $0x10,%esp
}
8010149c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010149f:	5b                   	pop    %ebx
801014a0:	5e                   	pop    %esi
801014a1:	5d                   	pop    %ebp
  brelse(bp);
801014a2:	e9 49 ed ff ff       	jmp    801001f0 <brelse>
801014a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ae:	66 90                	xchg   %ax,%ax

801014b0 <bfree>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	56                   	push   %esi
801014b4:	89 c6                	mov    %eax,%esi
801014b6:	53                   	push   %ebx
801014b7:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
801014b9:	83 ec 08             	sub    $0x8,%esp
801014bc:	68 c0 09 11 80       	push   $0x801109c0
801014c1:	50                   	push   %eax
801014c2:	e8 a9 ff ff ff       	call   80101470 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014c7:	58                   	pop    %eax
801014c8:	5a                   	pop    %edx
801014c9:	89 da                	mov    %ebx,%edx
801014cb:	c1 ea 0c             	shr    $0xc,%edx
801014ce:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801014d4:	52                   	push   %edx
801014d5:	56                   	push   %esi
801014d6:	e8 f5 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014db:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014dd:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014e0:	ba 01 00 00 00       	mov    $0x1,%edx
801014e5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014e8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014ee:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014f1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014f3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014f8:	85 d1                	test   %edx,%ecx
801014fa:	74 25                	je     80101521 <bfree+0x71>
  bp->data[bi/8] &= ~m;
801014fc:	f7 d2                	not    %edx
801014fe:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101500:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101503:	21 ca                	and    %ecx,%edx
80101505:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101509:	56                   	push   %esi
8010150a:	e8 b1 1b 00 00       	call   801030c0 <log_write>
  brelse(bp);
8010150f:	89 34 24             	mov    %esi,(%esp)
80101512:	e8 d9 ec ff ff       	call   801001f0 <brelse>
}
80101517:	83 c4 10             	add    $0x10,%esp
8010151a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010151d:	5b                   	pop    %ebx
8010151e:	5e                   	pop    %esi
8010151f:	5d                   	pop    %ebp
80101520:	c3                   	ret    
    panic("freeing free block");
80101521:	83 ec 0c             	sub    $0xc,%esp
80101524:	68 b8 74 10 80       	push   $0x801074b8
80101529:	e8 62 ee ff ff       	call   80100390 <panic>
8010152e:	66 90                	xchg   %ax,%ax

80101530 <iinit>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	53                   	push   %ebx
80101534:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101539:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010153c:	68 cb 74 10 80       	push   $0x801074cb
80101541:	68 e0 09 11 80       	push   $0x801109e0
80101546:	e8 95 31 00 00       	call   801046e0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010154b:	83 c4 10             	add    $0x10,%esp
8010154e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101550:	83 ec 08             	sub    $0x8,%esp
80101553:	68 d2 74 10 80       	push   $0x801074d2
80101558:	53                   	push   %ebx
80101559:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010155f:	e8 6c 30 00 00       	call   801045d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101564:	83 c4 10             	add    $0x10,%esp
80101567:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010156d:	75 e1                	jne    80101550 <iinit+0x20>
  readsb(dev, &sb);
8010156f:	83 ec 08             	sub    $0x8,%esp
80101572:	68 c0 09 11 80       	push   $0x801109c0
80101577:	ff 75 08             	pushl  0x8(%ebp)
8010157a:	e8 f1 fe ff ff       	call   80101470 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010157f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101585:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010158b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101591:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101597:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010159d:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015a3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015a9:	68 98 75 10 80       	push   $0x80107598
801015ae:	e8 fd f0 ff ff       	call   801006b0 <cprintf>
}
801015b3:	83 c4 30             	add    $0x30,%esp
801015b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015b9:	c9                   	leave  
801015ba:	c3                   	ret    
801015bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015bf:	90                   	nop

801015c0 <ialloc>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	57                   	push   %edi
801015c4:	56                   	push   %esi
801015c5:	53                   	push   %ebx
801015c6:	83 ec 1c             	sub    $0x1c,%esp
801015c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015cc:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015d3:	8b 75 08             	mov    0x8(%ebp),%esi
801015d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015d9:	0f 86 91 00 00 00    	jbe    80101670 <ialloc+0xb0>
801015df:	bb 01 00 00 00       	mov    $0x1,%ebx
801015e4:	eb 21                	jmp    80101607 <ialloc+0x47>
801015e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ed:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801015f0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015f3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015f6:	57                   	push   %edi
801015f7:	e8 f4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015fc:	83 c4 10             	add    $0x10,%esp
801015ff:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101605:	73 69                	jae    80101670 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101607:	89 d8                	mov    %ebx,%eax
80101609:	83 ec 08             	sub    $0x8,%esp
8010160c:	c1 e8 03             	shr    $0x3,%eax
8010160f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101615:	50                   	push   %eax
80101616:	56                   	push   %esi
80101617:	e8 b4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010161c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010161f:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101621:	89 d8                	mov    %ebx,%eax
80101623:	83 e0 07             	and    $0x7,%eax
80101626:	c1 e0 06             	shl    $0x6,%eax
80101629:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010162d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101631:	75 bd                	jne    801015f0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101633:	83 ec 04             	sub    $0x4,%esp
80101636:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101639:	6a 40                	push   $0x40
8010163b:	6a 00                	push   $0x0
8010163d:	51                   	push   %ecx
8010163e:	e8 0d 33 00 00       	call   80104950 <memset>
      dip->type = type;
80101643:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101647:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010164a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010164d:	89 3c 24             	mov    %edi,(%esp)
80101650:	e8 6b 1a 00 00       	call   801030c0 <log_write>
      brelse(bp);
80101655:	89 3c 24             	mov    %edi,(%esp)
80101658:	e8 93 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010165d:	83 c4 10             	add    $0x10,%esp
}
80101660:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101663:	89 da                	mov    %ebx,%edx
80101665:	89 f0                	mov    %esi,%eax
}
80101667:	5b                   	pop    %ebx
80101668:	5e                   	pop    %esi
80101669:	5f                   	pop    %edi
8010166a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010166b:	e9 40 fc ff ff       	jmp    801012b0 <iget>
  panic("ialloc: no inodes");
80101670:	83 ec 0c             	sub    $0xc,%esp
80101673:	68 d8 74 10 80       	push   $0x801074d8
80101678:	e8 13 ed ff ff       	call   80100390 <panic>
8010167d:	8d 76 00             	lea    0x0(%esi),%esi

80101680 <iupdate>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	56                   	push   %esi
80101684:	53                   	push   %ebx
80101685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101688:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010168b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010168e:	83 ec 08             	sub    $0x8,%esp
80101691:	c1 e8 03             	shr    $0x3,%eax
80101694:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010169a:	50                   	push   %eax
8010169b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010169e:	e8 2d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016a3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016aa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ac:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016af:	83 e0 07             	and    $0x7,%eax
801016b2:	c1 e0 06             	shl    $0x6,%eax
801016b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016b9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016bc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016c0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016c3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016c7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016cb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016cf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016d3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016d7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016da:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016dd:	6a 34                	push   $0x34
801016df:	53                   	push   %ebx
801016e0:	50                   	push   %eax
801016e1:	e8 0a 33 00 00       	call   801049f0 <memmove>
  log_write(bp);
801016e6:	89 34 24             	mov    %esi,(%esp)
801016e9:	e8 d2 19 00 00       	call   801030c0 <log_write>
  brelse(bp);
801016ee:	89 75 08             	mov    %esi,0x8(%ebp)
801016f1:	83 c4 10             	add    $0x10,%esp
}
801016f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f7:	5b                   	pop    %ebx
801016f8:	5e                   	pop    %esi
801016f9:	5d                   	pop    %ebp
  brelse(bp);
801016fa:	e9 f1 ea ff ff       	jmp    801001f0 <brelse>
801016ff:	90                   	nop

80101700 <idup>:
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	53                   	push   %ebx
80101704:	83 ec 10             	sub    $0x10,%esp
80101707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010170a:	68 e0 09 11 80       	push   $0x801109e0
8010170f:	e8 cc 30 00 00       	call   801047e0 <acquire>
  ip->ref++;
80101714:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101718:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010171f:	e8 dc 31 00 00       	call   80104900 <release>
}
80101724:	89 d8                	mov    %ebx,%eax
80101726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101729:	c9                   	leave  
8010172a:	c3                   	ret    
8010172b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010172f:	90                   	nop

80101730 <ilock>:
{
80101730:	55                   	push   %ebp
80101731:	89 e5                	mov    %esp,%ebp
80101733:	56                   	push   %esi
80101734:	53                   	push   %ebx
80101735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101738:	85 db                	test   %ebx,%ebx
8010173a:	0f 84 b7 00 00 00    	je     801017f7 <ilock+0xc7>
80101740:	8b 53 08             	mov    0x8(%ebx),%edx
80101743:	85 d2                	test   %edx,%edx
80101745:	0f 8e ac 00 00 00    	jle    801017f7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010174b:	83 ec 0c             	sub    $0xc,%esp
8010174e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101751:	50                   	push   %eax
80101752:	e8 b9 2e 00 00       	call   80104610 <acquiresleep>
  if(ip->valid == 0){
80101757:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010175a:	83 c4 10             	add    $0x10,%esp
8010175d:	85 c0                	test   %eax,%eax
8010175f:	74 0f                	je     80101770 <ilock+0x40>
}
80101761:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101764:	5b                   	pop    %ebx
80101765:	5e                   	pop    %esi
80101766:	5d                   	pop    %ebp
80101767:	c3                   	ret    
80101768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101770:	8b 43 04             	mov    0x4(%ebx),%eax
80101773:	83 ec 08             	sub    $0x8,%esp
80101776:	c1 e8 03             	shr    $0x3,%eax
80101779:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010177f:	50                   	push   %eax
80101780:	ff 33                	pushl  (%ebx)
80101782:	e8 49 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101787:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010178a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010178c:	8b 43 04             	mov    0x4(%ebx),%eax
8010178f:	83 e0 07             	and    $0x7,%eax
80101792:	c1 e0 06             	shl    $0x6,%eax
80101795:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101799:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010179c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010179f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017a3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017a7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017ab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017af:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017b3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017b7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017bb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017be:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c1:	6a 34                	push   $0x34
801017c3:	50                   	push   %eax
801017c4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017c7:	50                   	push   %eax
801017c8:	e8 23 32 00 00       	call   801049f0 <memmove>
    brelse(bp);
801017cd:	89 34 24             	mov    %esi,(%esp)
801017d0:	e8 1b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017d5:	83 c4 10             	add    $0x10,%esp
801017d8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017dd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017e4:	0f 85 77 ff ff ff    	jne    80101761 <ilock+0x31>
      panic("ilock: no type");
801017ea:	83 ec 0c             	sub    $0xc,%esp
801017ed:	68 f0 74 10 80       	push   $0x801074f0
801017f2:	e8 99 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017f7:	83 ec 0c             	sub    $0xc,%esp
801017fa:	68 ea 74 10 80       	push   $0x801074ea
801017ff:	e8 8c eb ff ff       	call   80100390 <panic>
80101804:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010180b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010180f:	90                   	nop

80101810 <iunlock>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101818:	85 db                	test   %ebx,%ebx
8010181a:	74 28                	je     80101844 <iunlock+0x34>
8010181c:	83 ec 0c             	sub    $0xc,%esp
8010181f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101822:	56                   	push   %esi
80101823:	e8 88 2e 00 00       	call   801046b0 <holdingsleep>
80101828:	83 c4 10             	add    $0x10,%esp
8010182b:	85 c0                	test   %eax,%eax
8010182d:	74 15                	je     80101844 <iunlock+0x34>
8010182f:	8b 43 08             	mov    0x8(%ebx),%eax
80101832:	85 c0                	test   %eax,%eax
80101834:	7e 0e                	jle    80101844 <iunlock+0x34>
  releasesleep(&ip->lock);
80101836:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101839:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010183f:	e9 2c 2e 00 00       	jmp    80104670 <releasesleep>
    panic("iunlock");
80101844:	83 ec 0c             	sub    $0xc,%esp
80101847:	68 ff 74 10 80       	push   $0x801074ff
8010184c:	e8 3f eb ff ff       	call   80100390 <panic>
80101851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iput>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	57                   	push   %edi
80101864:	56                   	push   %esi
80101865:	53                   	push   %ebx
80101866:	83 ec 28             	sub    $0x28,%esp
80101869:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010186c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010186f:	57                   	push   %edi
80101870:	e8 9b 2d 00 00       	call   80104610 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101875:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 d2                	test   %edx,%edx
8010187d:	74 07                	je     80101886 <iput+0x26>
8010187f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101884:	74 32                	je     801018b8 <iput+0x58>
  releasesleep(&ip->lock);
80101886:	83 ec 0c             	sub    $0xc,%esp
80101889:	57                   	push   %edi
8010188a:	e8 e1 2d 00 00       	call   80104670 <releasesleep>
  acquire(&icache.lock);
8010188f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101896:	e8 45 2f 00 00       	call   801047e0 <acquire>
  ip->ref--;
8010189b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010189f:	83 c4 10             	add    $0x10,%esp
801018a2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5f                   	pop    %edi
801018af:	5d                   	pop    %ebp
  release(&icache.lock);
801018b0:	e9 4b 30 00 00       	jmp    80104900 <release>
801018b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018b8:	83 ec 0c             	sub    $0xc,%esp
801018bb:	68 e0 09 11 80       	push   $0x801109e0
801018c0:	e8 1b 2f 00 00       	call   801047e0 <acquire>
    int r = ip->ref;
801018c5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018c8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018cf:	e8 2c 30 00 00       	call   80104900 <release>
    if(r == 1){
801018d4:	83 c4 10             	add    $0x10,%esp
801018d7:	83 fe 01             	cmp    $0x1,%esi
801018da:	75 aa                	jne    80101886 <iput+0x26>
801018dc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018e8:	89 cf                	mov    %ecx,%edi
801018ea:	eb 0b                	jmp    801018f7 <iput+0x97>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018f0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018f3:	39 fe                	cmp    %edi,%esi
801018f5:	74 19                	je     80101910 <iput+0xb0>
    if(ip->addrs[i]){
801018f7:	8b 16                	mov    (%esi),%edx
801018f9:	85 d2                	test   %edx,%edx
801018fb:	74 f3                	je     801018f0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018fd:	8b 03                	mov    (%ebx),%eax
801018ff:	e8 ac fb ff ff       	call   801014b0 <bfree>
      ip->addrs[i] = 0;
80101904:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010190a:	eb e4                	jmp    801018f0 <iput+0x90>
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101910:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101916:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101919:	85 c0                	test   %eax,%eax
8010191b:	75 33                	jne    80101950 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010191d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101920:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101927:	53                   	push   %ebx
80101928:	e8 53 fd ff ff       	call   80101680 <iupdate>
      ip->type = 0;
8010192d:	31 c0                	xor    %eax,%eax
8010192f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101933:	89 1c 24             	mov    %ebx,(%esp)
80101936:	e8 45 fd ff ff       	call   80101680 <iupdate>
      ip->valid = 0;
8010193b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101942:	83 c4 10             	add    $0x10,%esp
80101945:	e9 3c ff ff ff       	jmp    80101886 <iput+0x26>
8010194a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101950:	83 ec 08             	sub    $0x8,%esp
80101953:	50                   	push   %eax
80101954:	ff 33                	pushl  (%ebx)
80101956:	e8 75 e7 ff ff       	call   801000d0 <bread>
8010195b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010195e:	83 c4 10             	add    $0x10,%esp
80101961:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010196a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010196d:	89 cf                	mov    %ecx,%edi
8010196f:	eb 0e                	jmp    8010197f <iput+0x11f>
80101971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101978:	83 c6 04             	add    $0x4,%esi
8010197b:	39 f7                	cmp    %esi,%edi
8010197d:	74 11                	je     80101990 <iput+0x130>
      if(a[j])
8010197f:	8b 16                	mov    (%esi),%edx
80101981:	85 d2                	test   %edx,%edx
80101983:	74 f3                	je     80101978 <iput+0x118>
        bfree(ip->dev, a[j]);
80101985:	8b 03                	mov    (%ebx),%eax
80101987:	e8 24 fb ff ff       	call   801014b0 <bfree>
8010198c:	eb ea                	jmp    80101978 <iput+0x118>
8010198e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101990:	83 ec 0c             	sub    $0xc,%esp
80101993:	ff 75 e4             	pushl  -0x1c(%ebp)
80101996:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101999:	e8 52 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010199e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019a4:	8b 03                	mov    (%ebx),%eax
801019a6:	e8 05 fb ff ff       	call   801014b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019ab:	83 c4 10             	add    $0x10,%esp
801019ae:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019b5:	00 00 00 
801019b8:	e9 60 ff ff ff       	jmp    8010191d <iput+0xbd>
801019bd:	8d 76 00             	lea    0x0(%esi),%esi

801019c0 <iunlockput>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	53                   	push   %ebx
801019c4:	83 ec 10             	sub    $0x10,%esp
801019c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ca:	53                   	push   %ebx
801019cb:	e8 40 fe ff ff       	call   80101810 <iunlock>
  iput(ip);
801019d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019d3:	83 c4 10             	add    $0x10,%esp
}
801019d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019d9:	c9                   	leave  
  iput(ip);
801019da:	e9 81 fe ff ff       	jmp    80101860 <iput>
801019df:	90                   	nop

801019e0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	8b 55 08             	mov    0x8(%ebp),%edx
801019e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019e9:	8b 0a                	mov    (%edx),%ecx
801019eb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ee:	8b 4a 04             	mov    0x4(%edx),%ecx
801019f1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019f4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019f8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019fb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019ff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a03:	8b 52 58             	mov    0x58(%edx),%edx
80101a06:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a09:	5d                   	pop    %ebp
80101a0a:	c3                   	ret    
80101a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a0f:	90                   	nop

80101a10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	57                   	push   %edi
80101a14:	56                   	push   %esi
80101a15:	53                   	push   %ebx
80101a16:	83 ec 1c             	sub    $0x1c,%esp
80101a19:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1f:	8b 75 10             	mov    0x10(%ebp),%esi
80101a22:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a25:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a28:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a33:	0f 84 a7 00 00 00    	je     80101ae0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a3c:	8b 40 58             	mov    0x58(%eax),%eax
80101a3f:	39 c6                	cmp    %eax,%esi
80101a41:	0f 87 ba 00 00 00    	ja     80101b01 <readi+0xf1>
80101a47:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a4a:	31 c9                	xor    %ecx,%ecx
80101a4c:	89 da                	mov    %ebx,%edx
80101a4e:	01 f2                	add    %esi,%edx
80101a50:	0f 92 c1             	setb   %cl
80101a53:	89 cf                	mov    %ecx,%edi
80101a55:	0f 82 a6 00 00 00    	jb     80101b01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a5b:	89 c1                	mov    %eax,%ecx
80101a5d:	29 f1                	sub    %esi,%ecx
80101a5f:	39 d0                	cmp    %edx,%eax
80101a61:	0f 43 cb             	cmovae %ebx,%ecx
80101a64:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a67:	85 c9                	test   %ecx,%ecx
80101a69:	74 67                	je     80101ad2 <readi+0xc2>
80101a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a73:	89 f2                	mov    %esi,%edx
80101a75:	c1 ea 09             	shr    $0x9,%edx
80101a78:	89 d8                	mov    %ebx,%eax
80101a7a:	e8 21 f9 ff ff       	call   801013a0 <bmap>
80101a7f:	83 ec 08             	sub    $0x8,%esp
80101a82:	50                   	push   %eax
80101a83:	ff 33                	pushl  (%ebx)
80101a85:	e8 46 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a8d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a92:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a95:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a97:	89 f0                	mov    %esi,%eax
80101a99:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a9e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101aa0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101aa5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa9:	39 d9                	cmp    %ebx,%ecx
80101aab:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101aae:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aaf:	01 df                	add    %ebx,%edi
80101ab1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ab3:	50                   	push   %eax
80101ab4:	ff 75 e0             	pushl  -0x20(%ebp)
80101ab7:	e8 34 2f 00 00       	call   801049f0 <memmove>
    brelse(bp);
80101abc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101abf:	89 14 24             	mov    %edx,(%esp)
80101ac2:	e8 29 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ac7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aca:	83 c4 10             	add    $0x10,%esp
80101acd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ad0:	77 9e                	ja     80101a70 <readi+0x60>
  }
  return n;
80101ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ad5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ad8:	5b                   	pop    %ebx
80101ad9:	5e                   	pop    %esi
80101ada:	5f                   	pop    %edi
80101adb:	5d                   	pop    %ebp
80101adc:	c3                   	ret    
80101add:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ae0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ae4:	66 83 f8 09          	cmp    $0x9,%ax
80101ae8:	77 17                	ja     80101b01 <readi+0xf1>
80101aea:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101af1:	85 c0                	test   %eax,%eax
80101af3:	74 0c                	je     80101b01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101af5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101af8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101afb:	5b                   	pop    %ebx
80101afc:	5e                   	pop    %esi
80101afd:	5f                   	pop    %edi
80101afe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aff:	ff e0                	jmp    *%eax
      return -1;
80101b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b06:	eb cd                	jmp    80101ad5 <readi+0xc5>
80101b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b0f:	90                   	nop

80101b10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 1c             	sub    $0x1c,%esp
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b30:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b33:	0f 84 b7 00 00 00    	je     80101bf0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3f:	0f 82 e7 00 00 00    	jb     80101c2c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b48:	89 f8                	mov    %edi,%eax
80101b4a:	01 f0                	add    %esi,%eax
80101b4c:	0f 82 da 00 00 00    	jb     80101c2c <writei+0x11c>
80101b52:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b57:	0f 87 cf 00 00 00    	ja     80101c2c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b5d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b64:	85 ff                	test   %edi,%edi
80101b66:	74 79                	je     80101be1 <writei+0xd1>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b73:	89 f2                	mov    %esi,%edx
80101b75:	c1 ea 09             	shr    $0x9,%edx
80101b78:	89 f8                	mov    %edi,%eax
80101b7a:	e8 21 f8 ff ff       	call   801013a0 <bmap>
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	50                   	push   %eax
80101b83:	ff 37                	pushl  (%edi)
80101b85:	e8 46 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b8f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b92:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b95:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b97:	89 f0                	mov    %esi,%eax
80101b99:	83 c4 0c             	add    $0xc,%esp
80101b9c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ba1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ba3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba7:	39 d9                	cmp    %ebx,%ecx
80101ba9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bac:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bad:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101baf:	ff 75 dc             	pushl  -0x24(%ebp)
80101bb2:	50                   	push   %eax
80101bb3:	e8 38 2e 00 00       	call   801049f0 <memmove>
    log_write(bp);
80101bb8:	89 3c 24             	mov    %edi,(%esp)
80101bbb:	e8 00 15 00 00       	call   801030c0 <log_write>
    brelse(bp);
80101bc0:	89 3c 24             	mov    %edi,(%esp)
80101bc3:	e8 28 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bcb:	83 c4 10             	add    $0x10,%esp
80101bce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bd1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bd4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bd7:	77 97                	ja     80101b70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bdf:	77 37                	ja     80101c18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101be7:	5b                   	pop    %ebx
80101be8:	5e                   	pop    %esi
80101be9:	5f                   	pop    %edi
80101bea:	5d                   	pop    %ebp
80101beb:	c3                   	ret    
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bf4:	66 83 f8 09          	cmp    $0x9,%ax
80101bf8:	77 32                	ja     80101c2c <writei+0x11c>
80101bfa:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c01:	85 c0                	test   %eax,%eax
80101c03:	74 27                	je     80101c2c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c0f:	ff e0                	jmp    *%eax
80101c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c1b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c21:	50                   	push   %eax
80101c22:	e8 59 fa ff ff       	call   80101680 <iupdate>
80101c27:	83 c4 10             	add    $0x10,%esp
80101c2a:	eb b5                	jmp    80101be1 <writei+0xd1>
      return -1;
80101c2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c31:	eb b1                	jmp    80101be4 <writei+0xd4>
80101c33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c46:	6a 0e                	push   $0xe
80101c48:	ff 75 0c             	pushl  0xc(%ebp)
80101c4b:	ff 75 08             	pushl  0x8(%ebp)
80101c4e:	e8 0d 2e 00 00       	call   80104a60 <strncmp>
}
80101c53:	c9                   	leave  
80101c54:	c3                   	ret    
80101c55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	83 ec 1c             	sub    $0x1c,%esp
80101c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c71:	0f 85 85 00 00 00    	jne    80101cfc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c77:	8b 53 58             	mov    0x58(%ebx),%edx
80101c7a:	31 ff                	xor    %edi,%edi
80101c7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c7f:	85 d2                	test   %edx,%edx
80101c81:	74 3e                	je     80101cc1 <dirlookup+0x61>
80101c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c87:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c88:	6a 10                	push   $0x10
80101c8a:	57                   	push   %edi
80101c8b:	56                   	push   %esi
80101c8c:	53                   	push   %ebx
80101c8d:	e8 7e fd ff ff       	call   80101a10 <readi>
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	83 f8 10             	cmp    $0x10,%eax
80101c98:	75 55                	jne    80101cef <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c9f:	74 18                	je     80101cb9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101ca1:	83 ec 04             	sub    $0x4,%esp
80101ca4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ca7:	6a 0e                	push   $0xe
80101ca9:	50                   	push   %eax
80101caa:	ff 75 0c             	pushl  0xc(%ebp)
80101cad:	e8 ae 2d 00 00       	call   80104a60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101cb2:	83 c4 10             	add    $0x10,%esp
80101cb5:	85 c0                	test   %eax,%eax
80101cb7:	74 17                	je     80101cd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cb9:	83 c7 10             	add    $0x10,%edi
80101cbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101cbf:	72 c7                	jb     80101c88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cc4:	31 c0                	xor    %eax,%eax
}
80101cc6:	5b                   	pop    %ebx
80101cc7:	5e                   	pop    %esi
80101cc8:	5f                   	pop    %edi
80101cc9:	5d                   	pop    %ebp
80101cca:	c3                   	ret    
80101ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ccf:	90                   	nop
      if(poff)
80101cd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cd3:	85 c0                	test   %eax,%eax
80101cd5:	74 05                	je     80101cdc <dirlookup+0x7c>
        *poff = off;
80101cd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cdc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ce0:	8b 03                	mov    (%ebx),%eax
80101ce2:	e8 c9 f5 ff ff       	call   801012b0 <iget>
}
80101ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cea:	5b                   	pop    %ebx
80101ceb:	5e                   	pop    %esi
80101cec:	5f                   	pop    %edi
80101ced:	5d                   	pop    %ebp
80101cee:	c3                   	ret    
      panic("dirlookup read");
80101cef:	83 ec 0c             	sub    $0xc,%esp
80101cf2:	68 19 75 10 80       	push   $0x80107519
80101cf7:	e8 94 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cfc:	83 ec 0c             	sub    $0xc,%esp
80101cff:	68 07 75 10 80       	push   $0x80107507
80101d04:	e8 87 e6 ff ff       	call   80100390 <panic>
80101d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	57                   	push   %edi
80101d14:	56                   	push   %esi
80101d15:	53                   	push   %ebx
80101d16:	89 c3                	mov    %eax,%ebx
80101d18:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d1b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d1e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d24:	0f 84 86 01 00 00    	je     80101eb0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d2a:	e8 01 1e 00 00       	call   80103b30 <myproc>
  acquire(&icache.lock);
80101d2f:	83 ec 0c             	sub    $0xc,%esp
80101d32:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d34:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d37:	68 e0 09 11 80       	push   $0x801109e0
80101d3c:	e8 9f 2a 00 00       	call   801047e0 <acquire>
  ip->ref++;
80101d41:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d45:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d4c:	e8 af 2b 00 00       	call   80104900 <release>
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	eb 0d                	jmp    80101d63 <namex+0x53>
80101d56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d5d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101d60:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d63:	0f b6 07             	movzbl (%edi),%eax
80101d66:	3c 2f                	cmp    $0x2f,%al
80101d68:	74 f6                	je     80101d60 <namex+0x50>
  if(*path == 0)
80101d6a:	84 c0                	test   %al,%al
80101d6c:	0f 84 ee 00 00 00    	je     80101e60 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d72:	0f b6 07             	movzbl (%edi),%eax
80101d75:	84 c0                	test   %al,%al
80101d77:	0f 84 fb 00 00 00    	je     80101e78 <namex+0x168>
80101d7d:	89 fb                	mov    %edi,%ebx
80101d7f:	3c 2f                	cmp    $0x2f,%al
80101d81:	0f 84 f1 00 00 00    	je     80101e78 <namex+0x168>
80101d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8e:	66 90                	xchg   %ax,%ax
    path++;
80101d90:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d93:	0f b6 03             	movzbl (%ebx),%eax
80101d96:	3c 2f                	cmp    $0x2f,%al
80101d98:	74 04                	je     80101d9e <namex+0x8e>
80101d9a:	84 c0                	test   %al,%al
80101d9c:	75 f2                	jne    80101d90 <namex+0x80>
  len = path - s;
80101d9e:	89 d8                	mov    %ebx,%eax
80101da0:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101da2:	83 f8 0d             	cmp    $0xd,%eax
80101da5:	0f 8e 85 00 00 00    	jle    80101e30 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101dab:	83 ec 04             	sub    $0x4,%esp
80101dae:	6a 0e                	push   $0xe
80101db0:	57                   	push   %edi
    path++;
80101db1:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101db3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101db6:	e8 35 2c 00 00       	call   801049f0 <memmove>
80101dbb:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101dbe:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101dc1:	75 0d                	jne    80101dd0 <namex+0xc0>
80101dc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dc7:	90                   	nop
    path++;
80101dc8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dcb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dce:	74 f8                	je     80101dc8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 57 f9 ff ff       	call   80101730 <ilock>
    if(ip->type != T_DIR){
80101dd9:	83 c4 10             	add    $0x10,%esp
80101ddc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101de1:	0f 85 a1 00 00 00    	jne    80101e88 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101de7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dea:	85 d2                	test   %edx,%edx
80101dec:	74 09                	je     80101df7 <namex+0xe7>
80101dee:	80 3f 00             	cmpb   $0x0,(%edi)
80101df1:	0f 84 d9 00 00 00    	je     80101ed0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101df7:	83 ec 04             	sub    $0x4,%esp
80101dfa:	6a 00                	push   $0x0
80101dfc:	ff 75 e4             	pushl  -0x1c(%ebp)
80101dff:	56                   	push   %esi
80101e00:	e8 5b fe ff ff       	call   80101c60 <dirlookup>
80101e05:	83 c4 10             	add    $0x10,%esp
80101e08:	89 c3                	mov    %eax,%ebx
80101e0a:	85 c0                	test   %eax,%eax
80101e0c:	74 7a                	je     80101e88 <namex+0x178>
  iunlock(ip);
80101e0e:	83 ec 0c             	sub    $0xc,%esp
80101e11:	56                   	push   %esi
80101e12:	e8 f9 f9 ff ff       	call   80101810 <iunlock>
  iput(ip);
80101e17:	89 34 24             	mov    %esi,(%esp)
80101e1a:	89 de                	mov    %ebx,%esi
80101e1c:	e8 3f fa ff ff       	call   80101860 <iput>
  while(*path == '/')
80101e21:	83 c4 10             	add    $0x10,%esp
80101e24:	e9 3a ff ff ff       	jmp    80101d63 <namex+0x53>
80101e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e33:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e36:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e39:	83 ec 04             	sub    $0x4,%esp
80101e3c:	50                   	push   %eax
80101e3d:	57                   	push   %edi
    name[len] = 0;
80101e3e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e40:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e43:	e8 a8 2b 00 00       	call   801049f0 <memmove>
    name[len] = 0;
80101e48:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e4b:	83 c4 10             	add    $0x10,%esp
80101e4e:	c6 00 00             	movb   $0x0,(%eax)
80101e51:	e9 68 ff ff ff       	jmp    80101dbe <namex+0xae>
80101e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e5d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e60:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e63:	85 c0                	test   %eax,%eax
80101e65:	0f 85 85 00 00 00    	jne    80101ef0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e6e:	89 f0                	mov    %esi,%eax
80101e70:	5b                   	pop    %ebx
80101e71:	5e                   	pop    %esi
80101e72:	5f                   	pop    %edi
80101e73:	5d                   	pop    %ebp
80101e74:	c3                   	ret    
80101e75:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e7b:	89 fb                	mov    %edi,%ebx
80101e7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e80:	31 c0                	xor    %eax,%eax
80101e82:	eb b5                	jmp    80101e39 <namex+0x129>
80101e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e88:	83 ec 0c             	sub    $0xc,%esp
80101e8b:	56                   	push   %esi
80101e8c:	e8 7f f9 ff ff       	call   80101810 <iunlock>
  iput(ip);
80101e91:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e94:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e96:	e8 c5 f9 ff ff       	call   80101860 <iput>
      return 0;
80101e9b:	83 c4 10             	add    $0x10,%esp
}
80101e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ea1:	89 f0                	mov    %esi,%eax
80101ea3:	5b                   	pop    %ebx
80101ea4:	5e                   	pop    %esi
80101ea5:	5f                   	pop    %edi
80101ea6:	5d                   	pop    %ebp
80101ea7:	c3                   	ret    
80101ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eaf:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101eb0:	ba 01 00 00 00       	mov    $0x1,%edx
80101eb5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eba:	89 df                	mov    %ebx,%edi
80101ebc:	e8 ef f3 ff ff       	call   801012b0 <iget>
80101ec1:	89 c6                	mov    %eax,%esi
80101ec3:	e9 9b fe ff ff       	jmp    80101d63 <namex+0x53>
80101ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecf:	90                   	nop
      iunlock(ip);
80101ed0:	83 ec 0c             	sub    $0xc,%esp
80101ed3:	56                   	push   %esi
80101ed4:	e8 37 f9 ff ff       	call   80101810 <iunlock>
      return ip;
80101ed9:	83 c4 10             	add    $0x10,%esp
}
80101edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101edf:	89 f0                	mov    %esi,%eax
80101ee1:	5b                   	pop    %ebx
80101ee2:	5e                   	pop    %esi
80101ee3:	5f                   	pop    %edi
80101ee4:	5d                   	pop    %ebp
80101ee5:	c3                   	ret    
80101ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eed:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101ef0:	83 ec 0c             	sub    $0xc,%esp
80101ef3:	56                   	push   %esi
    return 0;
80101ef4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ef6:	e8 65 f9 ff ff       	call   80101860 <iput>
    return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
80101efe:	e9 68 ff ff ff       	jmp    80101e6b <namex+0x15b>
80101f03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f10 <dirlink>:
{
80101f10:	55                   	push   %ebp
80101f11:	89 e5                	mov    %esp,%ebp
80101f13:	57                   	push   %edi
80101f14:	56                   	push   %esi
80101f15:	53                   	push   %ebx
80101f16:	83 ec 20             	sub    $0x20,%esp
80101f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f1c:	6a 00                	push   $0x0
80101f1e:	ff 75 0c             	pushl  0xc(%ebp)
80101f21:	53                   	push   %ebx
80101f22:	e8 39 fd ff ff       	call   80101c60 <dirlookup>
80101f27:	83 c4 10             	add    $0x10,%esp
80101f2a:	85 c0                	test   %eax,%eax
80101f2c:	75 67                	jne    80101f95 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f2e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f31:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f34:	85 ff                	test   %edi,%edi
80101f36:	74 29                	je     80101f61 <dirlink+0x51>
80101f38:	31 ff                	xor    %edi,%edi
80101f3a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f3d:	eb 09                	jmp    80101f48 <dirlink+0x38>
80101f3f:	90                   	nop
80101f40:	83 c7 10             	add    $0x10,%edi
80101f43:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f46:	73 19                	jae    80101f61 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f48:	6a 10                	push   $0x10
80101f4a:	57                   	push   %edi
80101f4b:	56                   	push   %esi
80101f4c:	53                   	push   %ebx
80101f4d:	e8 be fa ff ff       	call   80101a10 <readi>
80101f52:	83 c4 10             	add    $0x10,%esp
80101f55:	83 f8 10             	cmp    $0x10,%eax
80101f58:	75 4e                	jne    80101fa8 <dirlink+0x98>
    if(de.inum == 0)
80101f5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f5f:	75 df                	jne    80101f40 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f61:	83 ec 04             	sub    $0x4,%esp
80101f64:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f67:	6a 0e                	push   $0xe
80101f69:	ff 75 0c             	pushl  0xc(%ebp)
80101f6c:	50                   	push   %eax
80101f6d:	e8 4e 2b 00 00       	call   80104ac0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f72:	6a 10                	push   $0x10
  de.inum = inum;
80101f74:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
  de.inum = inum;
80101f7a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f7e:	e8 8d fb ff ff       	call   80101b10 <writei>
80101f83:	83 c4 20             	add    $0x20,%esp
80101f86:	83 f8 10             	cmp    $0x10,%eax
80101f89:	75 2a                	jne    80101fb5 <dirlink+0xa5>
  return 0;
80101f8b:	31 c0                	xor    %eax,%eax
}
80101f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f90:	5b                   	pop    %ebx
80101f91:	5e                   	pop    %esi
80101f92:	5f                   	pop    %edi
80101f93:	5d                   	pop    %ebp
80101f94:	c3                   	ret    
    iput(ip);
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	50                   	push   %eax
80101f99:	e8 c2 f8 ff ff       	call   80101860 <iput>
    return -1;
80101f9e:	83 c4 10             	add    $0x10,%esp
80101fa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fa6:	eb e5                	jmp    80101f8d <dirlink+0x7d>
      panic("dirlink read");
80101fa8:	83 ec 0c             	sub    $0xc,%esp
80101fab:	68 28 75 10 80       	push   $0x80107528
80101fb0:	e8 db e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101fb5:	83 ec 0c             	sub    $0xc,%esp
80101fb8:	68 ae 7c 10 80       	push   $0x80107cae
80101fbd:	e8 ce e3 ff ff       	call   80100390 <panic>
80101fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <namei>:

struct inode*
namei(char *path)
{
80101fd0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fd1:	31 d2                	xor    %edx,%edx
{
80101fd3:	89 e5                	mov    %esp,%ebp
80101fd5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fdb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fde:	e8 2d fd ff ff       	call   80101d10 <namex>
}
80101fe3:	c9                   	leave  
80101fe4:	c3                   	ret    
80101fe5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ff0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ff0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ff1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101ff6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ff8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ffe:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fff:	e9 0c fd ff ff       	jmp    80101d10 <namex>
80102004:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010200b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010200f:	90                   	nop

80102010 <pfs>:

int
pfs()
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	57                   	push   %edi
80102014:	56                   	push   %esi
80102015:	53                   	push   %ebx
80102016:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;
  int countt = 0, countf = 0, counta = 0, bn = 0, nb=0;;
  bp = 0;
  cprintf("\nFree blocks:\n");
80102019:	68 35 75 10 80       	push   $0x80107535
8010201e:	e8 8d e6 ff ff       	call   801006b0 <cprintf>
  for(b = 0; b < sb.size; b += BPB){
80102023:	8b 1d c0 09 11 80    	mov    0x801109c0,%ebx
80102029:	83 c4 10             	add    $0x10,%esp
8010202c:	85 db                	test   %ebx,%ebx
8010202e:	0f 84 f7 01 00 00    	je     8010222b <pfs+0x21b>
  int countt = 0, countf = 0, counta = 0, bn = 0, nb=0;;
80102034:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010203b:	31 ff                	xor    %edi,%edi
  for(b = 0; b < sb.size; b += BPB){
8010203d:	31 f6                	xor    %esi,%esi
8010203f:	90                   	nop
    nb++;
    bp = bread(1, BBLOCK(b, sb));
80102040:	89 f8                	mov    %edi,%eax
80102042:	83 ec 08             	sub    $0x8,%esp
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102045:	31 db                	xor    %ebx,%ebx
    bp = bread(1, BBLOCK(b, sb));
80102047:	c1 f8 0c             	sar    $0xc,%eax
8010204a:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80102050:	50                   	push   %eax
80102051:	6a 01                	push   $0x1
80102053:	e8 78 e0 ff ff       	call   801000d0 <bread>
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010205e:	eb 23                	jmp    80102083 <pfs+0x73>
      m = 1 << (bi % 8);
      ++countt;
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        if ( (countf % 16) == 0 ) cprintf("\n");
        cprintf("%d  ", bn );
80102060:	83 ec 08             	sub    $0x8,%esp
80102063:	56                   	push   %esi
80102064:	68 44 75 10 80       	push   $0x80107544
80102069:	e8 42 e6 ff ff       	call   801006b0 <cprintf>
        ++countf;
8010206e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80102072:	83 c4 10             	add    $0x10,%esp
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102075:	83 c3 01             	add    $0x1,%ebx
      }
      bn++;
80102078:	83 c6 01             	add    $0x1,%esi
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010207b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
80102081:	74 45                	je     801020c8 <pfs+0xb8>
80102083:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
80102086:	39 15 c0 09 11 80    	cmp    %edx,0x801109c0
8010208c:	76 3a                	jbe    801020c8 <pfs+0xb8>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010208e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102091:	89 da                	mov    %ebx,%edx
      m = 1 << (bi % 8);
80102093:	89 d9                	mov    %ebx,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80102095:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
80102098:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010209b:	0f b6 54 10 5c       	movzbl 0x5c(%eax,%edx,1),%edx
      m = 1 << (bi % 8);
801020a0:	b8 01 00 00 00       	mov    $0x1,%eax
801020a5:	d3 e0                	shl    %cl,%eax
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801020a7:	85 c2                	test   %eax,%edx
801020a9:	75 ca                	jne    80102075 <pfs+0x65>
        if ( (countf % 16) == 0 ) cprintf("\n");
801020ab:	f6 45 e0 0f          	testb  $0xf,-0x20(%ebp)
801020af:	75 af                	jne    80102060 <pfs+0x50>
801020b1:	83 ec 0c             	sub    $0xc,%esp
801020b4:	68 c7 7e 10 80       	push   $0x80107ec7
801020b9:	e8 f2 e5 ff ff       	call   801006b0 <cprintf>
801020be:	83 c4 10             	add    $0x10,%esp
801020c1:	eb 9d                	jmp    80102060 <pfs+0x50>
801020c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020c7:	90                   	nop
    }
    brelse(bp);
801020c8:	83 ec 0c             	sub    $0xc,%esp
801020cb:	ff 75 e4             	pushl  -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801020ce:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801020d4:	e8 17 e1 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801020d9:	83 c4 10             	add    $0x10,%esp
801020dc:	39 3d c0 09 11 80    	cmp    %edi,0x801109c0
801020e2:	0f 87 58 ff ff ff    	ja     80102040 <pfs+0x30>
  }
  cprintf("\nTotal free blocks = %d", countf );
801020e8:	83 ec 08             	sub    $0x8,%esp
801020eb:	ff 75 e0             	pushl  -0x20(%ebp)
801020ee:	68 49 75 10 80       	push   $0x80107549
801020f3:	e8 b8 e5 ff ff       	call   801006b0 <cprintf>

  cprintf("\nAlocated blocks:\n");
801020f8:	c7 04 24 61 75 10 80 	movl   $0x80107561,(%esp)
801020ff:	e8 ac e5 ff ff       	call   801006b0 <cprintf>
  bn = 0;

  for(b = 0; b < sb.size; b += BPB){
80102104:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
8010210a:	83 c4 10             	add    $0x10,%esp
8010210d:	85 c9                	test   %ecx,%ecx
8010210f:	0f 84 22 01 00 00    	je     80102237 <pfs+0x227>
  int countt = 0, countf = 0, counta = 0, bn = 0, nb=0;;
80102115:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  bn = 0;
8010211c:	31 ff                	xor    %edi,%edi
  for(b = 0; b < sb.size; b += BPB){
8010211e:	31 f6                	xor    %esi,%esi
    nb++;
    bp = bread(1, BBLOCK(b, sb));
80102120:	89 f8                	mov    %edi,%eax
80102122:	83 ec 08             	sub    $0x8,%esp
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102125:	31 db                	xor    %ebx,%ebx
    bp = bread(1, BBLOCK(b, sb));
80102127:	c1 f8 0c             	sar    $0xc,%eax
8010212a:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80102130:	50                   	push   %eax
80102131:	6a 01                	push   $0x1
80102133:	e8 98 df ff ff       	call   801000d0 <bread>
80102138:	83 c4 10             	add    $0x10,%esp
8010213b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010213e:	eb 23                	jmp    80102163 <pfs+0x153>
      m = 1 << (bi % 8);
      ++countt;
      if((bp->data[bi/8] & m) != 0){ // Is block allocated?
        if ( (counta % 16) == 0 ) cprintf("\n");
        cprintf("%d ", bn );
80102140:	83 ec 08             	sub    $0x8,%esp
80102143:	56                   	push   %esi
80102144:	68 74 75 10 80       	push   $0x80107574
80102149:	e8 62 e5 ff ff       	call   801006b0 <cprintf>
        ++counta;
8010214e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
80102152:	83 c4 10             	add    $0x10,%esp
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80102155:	83 c3 01             	add    $0x1,%ebx
      }
      bn++;
80102158:	83 c6 01             	add    $0x1,%esi
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010215b:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
80102161:	74 45                	je     801021a8 <pfs+0x198>
80102163:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80102166:	39 15 c0 09 11 80    	cmp    %edx,0x801109c0
8010216c:	76 3a                	jbe    801021a8 <pfs+0x198>
      if((bp->data[bi/8] & m) != 0){ // Is block allocated?
8010216e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102171:	89 da                	mov    %ebx,%edx
      m = 1 << (bi % 8);
80102173:	89 d9                	mov    %ebx,%ecx
      if((bp->data[bi/8] & m) != 0){ // Is block allocated?
80102175:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
80102178:	83 e1 07             	and    $0x7,%ecx
      if((bp->data[bi/8] & m) != 0){ // Is block allocated?
8010217b:	0f b6 54 10 5c       	movzbl 0x5c(%eax,%edx,1),%edx
      m = 1 << (bi % 8);
80102180:	b8 01 00 00 00       	mov    $0x1,%eax
80102185:	d3 e0                	shl    %cl,%eax
      if((bp->data[bi/8] & m) != 0){ // Is block allocated?
80102187:	85 c2                	test   %eax,%edx
80102189:	74 ca                	je     80102155 <pfs+0x145>
        if ( (counta % 16) == 0 ) cprintf("\n");
8010218b:	f6 45 e0 0f          	testb  $0xf,-0x20(%ebp)
8010218f:	75 af                	jne    80102140 <pfs+0x130>
80102191:	83 ec 0c             	sub    $0xc,%esp
80102194:	68 c7 7e 10 80       	push   $0x80107ec7
80102199:	e8 12 e5 ff ff       	call   801006b0 <cprintf>
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	eb 9d                	jmp    80102140 <pfs+0x130>
801021a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021a7:	90                   	nop
    }
    brelse(bp);
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801021ae:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801021b4:	e8 37 e0 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801021b9:	83 c4 10             	add    $0x10,%esp
801021bc:	39 3d c0 09 11 80    	cmp    %edi,0x801109c0
801021c2:	0f 87 58 ff ff ff    	ja     80102120 <pfs+0x110>
  }
  cprintf("\nTotal allocated blocks = %d\n", counta );
801021c8:	83 ec 08             	sub    $0x8,%esp
801021cb:	ff 75 e0             	pushl  -0x20(%ebp)
801021ce:	68 78 75 10 80       	push   $0x80107578
801021d3:	e8 d8 e4 ff ff       	call   801006b0 <cprintf>

  cprintf("sb: size nblocks ninodes nlog logstart inodestart bmap-start Inodes-per-block Bitmap-bits-per-block\n");
801021d8:	c7 04 24 ec 75 10 80 	movl   $0x801075ec,(%esp)
801021df:	e8 cc e4 ff ff       	call   801006b0 <cprintf>
  cprintf(" %d\t %d\t %d %d %d \t %d \t %d \t %d \t\t %d\n", 
801021e4:	58                   	pop    %eax
801021e5:	5a                   	pop    %edx
801021e6:	68 00 10 00 00       	push   $0x1000
801021eb:	6a 08                	push   $0x8
801021ed:	ff 35 d8 09 11 80    	pushl  0x801109d8
801021f3:	ff 35 d4 09 11 80    	pushl  0x801109d4
801021f9:	ff 35 d0 09 11 80    	pushl  0x801109d0
801021ff:	ff 35 cc 09 11 80    	pushl  0x801109cc
80102205:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010220b:	ff 35 c4 09 11 80    	pushl  0x801109c4
80102211:	ff 35 c0 09 11 80    	pushl  0x801109c0
80102217:	68 54 76 10 80       	push   $0x80107654
8010221c:	e8 8f e4 ff ff       	call   801006b0 <cprintf>
     sb.size, sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart, IPB, BPB);
  return 0;
}
80102221:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102224:	31 c0                	xor    %eax,%eax
80102226:	5b                   	pop    %ebx
80102227:	5e                   	pop    %esi
80102228:	5f                   	pop    %edi
80102229:	5d                   	pop    %ebp
8010222a:	c3                   	ret    
  int countt = 0, countf = 0, counta = 0, bn = 0, nb=0;;
8010222b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80102232:	e9 b1 fe ff ff       	jmp    801020e8 <pfs+0xd8>
80102237:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010223e:	eb 88                	jmp    801021c8 <pfs+0x1b8>

80102240 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102249:	85 c0                	test   %eax,%eax
8010224b:	0f 84 b4 00 00 00    	je     80102305 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102251:	8b 70 08             	mov    0x8(%eax),%esi
80102254:	89 c3                	mov    %eax,%ebx
80102256:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010225c:	0f 87 96 00 00 00    	ja     801022f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010226e:	66 90                	xchg   %ax,%ax
80102270:	89 ca                	mov    %ecx,%edx
80102272:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102273:	83 e0 c0             	and    $0xffffffc0,%eax
80102276:	3c 40                	cmp    $0x40,%al
80102278:	75 f6                	jne    80102270 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010227a:	31 ff                	xor    %edi,%edi
8010227c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102281:	89 f8                	mov    %edi,%eax
80102283:	ee                   	out    %al,(%dx)
80102284:	b8 01 00 00 00       	mov    $0x1,%eax
80102289:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010228e:	ee                   	out    %al,(%dx)
8010228f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102294:	89 f0                	mov    %esi,%eax
80102296:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102297:	89 f0                	mov    %esi,%eax
80102299:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010229e:	c1 f8 08             	sar    $0x8,%eax
801022a1:	ee                   	out    %al,(%dx)
801022a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022a7:	89 f8                	mov    %edi,%eax
801022a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801022aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801022ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022b3:	c1 e0 04             	shl    $0x4,%eax
801022b6:	83 e0 10             	and    $0x10,%eax
801022b9:	83 c8 e0             	or     $0xffffffe0,%eax
801022bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801022bd:	f6 03 04             	testb  $0x4,(%ebx)
801022c0:	75 16                	jne    801022d8 <idestart+0x98>
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	89 ca                	mov    %ecx,%edx
801022c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801022ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022cd:	5b                   	pop    %ebx
801022ce:	5e                   	pop    %esi
801022cf:	5f                   	pop    %edi
801022d0:	5d                   	pop    %ebp
801022d1:	c3                   	ret    
801022d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022d8:	b8 30 00 00 00       	mov    $0x30,%eax
801022dd:	89 ca                	mov    %ecx,%edx
801022df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801022e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801022e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801022e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ed:	fc                   	cld    
801022ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022f3:	5b                   	pop    %ebx
801022f4:	5e                   	pop    %esi
801022f5:	5f                   	pop    %edi
801022f6:	5d                   	pop    %ebp
801022f7:	c3                   	ret    
    panic("incorrect blockno");
801022f8:	83 ec 0c             	sub    $0xc,%esp
801022fb:	68 85 76 10 80       	push   $0x80107685
80102300:	e8 8b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102305:	83 ec 0c             	sub    $0xc,%esp
80102308:	68 7c 76 10 80       	push   $0x8010767c
8010230d:	e8 7e e0 ff ff       	call   80100390 <panic>
80102312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102320 <ideinit>:
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102326:	68 97 76 10 80       	push   $0x80107697
8010232b:	68 80 a5 10 80       	push   $0x8010a580
80102330:	e8 ab 23 00 00       	call   801046e0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102335:	58                   	pop    %eax
80102336:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010233b:	5a                   	pop    %edx
8010233c:	83 e8 01             	sub    $0x1,%eax
8010233f:	50                   	push   %eax
80102340:	6a 0e                	push   $0xe
80102342:	e8 a9 02 00 00       	call   801025f0 <ioapicenable>
80102347:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010234a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010234f:	90                   	nop
80102350:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102351:	83 e0 c0             	and    $0xffffffc0,%eax
80102354:	3c 40                	cmp    $0x40,%al
80102356:	75 f8                	jne    80102350 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102358:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010235d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102362:	ee                   	out    %al,(%dx)
80102363:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102368:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010236d:	eb 06                	jmp    80102375 <ideinit+0x55>
8010236f:	90                   	nop
  for(i=0; i<1000; i++){
80102370:	83 e9 01             	sub    $0x1,%ecx
80102373:	74 0f                	je     80102384 <ideinit+0x64>
80102375:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102376:	84 c0                	test   %al,%al
80102378:	74 f6                	je     80102370 <ideinit+0x50>
      havedisk1 = 1;
8010237a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102381:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102384:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102389:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010238e:	ee                   	out    %al,(%dx)
}
8010238f:	c9                   	leave  
80102390:	c3                   	ret    
80102391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop

801023a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	57                   	push   %edi
801023a4:	56                   	push   %esi
801023a5:	53                   	push   %ebx
801023a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023a9:	68 80 a5 10 80       	push   $0x8010a580
801023ae:	e8 2d 24 00 00       	call   801047e0 <acquire>

  if((b = idequeue) == 0){
801023b3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801023b9:	83 c4 10             	add    $0x10,%esp
801023bc:	85 db                	test   %ebx,%ebx
801023be:	74 63                	je     80102423 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801023c0:	8b 43 58             	mov    0x58(%ebx),%eax
801023c3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801023c8:	8b 33                	mov    (%ebx),%esi
801023ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801023d0:	75 2f                	jne    80102401 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023de:	66 90                	xchg   %ax,%ax
801023e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023e1:	89 c1                	mov    %eax,%ecx
801023e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801023e6:	80 f9 40             	cmp    $0x40,%cl
801023e9:	75 f5                	jne    801023e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801023eb:	a8 21                	test   $0x21,%al
801023ed:	75 12                	jne    80102401 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801023ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801023f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023fc:	fc                   	cld    
801023fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801023ff:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102401:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102404:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102407:	83 ce 02             	or     $0x2,%esi
8010240a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010240c:	53                   	push   %ebx
8010240d:	e8 8e 1e 00 00       	call   801042a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102412:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102417:	83 c4 10             	add    $0x10,%esp
8010241a:	85 c0                	test   %eax,%eax
8010241c:	74 05                	je     80102423 <ideintr+0x83>
    idestart(idequeue);
8010241e:	e8 1d fe ff ff       	call   80102240 <idestart>
    release(&idelock);
80102423:	83 ec 0c             	sub    $0xc,%esp
80102426:	68 80 a5 10 80       	push   $0x8010a580
8010242b:	e8 d0 24 00 00       	call   80104900 <release>

  release(&idelock);
}
80102430:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102433:	5b                   	pop    %ebx
80102434:	5e                   	pop    %esi
80102435:	5f                   	pop    %edi
80102436:	5d                   	pop    %ebp
80102437:	c3                   	ret    
80102438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243f:	90                   	nop

80102440 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	53                   	push   %ebx
80102444:	83 ec 10             	sub    $0x10,%esp
80102447:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010244a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010244d:	50                   	push   %eax
8010244e:	e8 5d 22 00 00       	call   801046b0 <holdingsleep>
80102453:	83 c4 10             	add    $0x10,%esp
80102456:	85 c0                	test   %eax,%eax
80102458:	0f 84 d3 00 00 00    	je     80102531 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010245e:	8b 03                	mov    (%ebx),%eax
80102460:	83 e0 06             	and    $0x6,%eax
80102463:	83 f8 02             	cmp    $0x2,%eax
80102466:	0f 84 b8 00 00 00    	je     80102524 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010246c:	8b 53 04             	mov    0x4(%ebx),%edx
8010246f:	85 d2                	test   %edx,%edx
80102471:	74 0d                	je     80102480 <iderw+0x40>
80102473:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102478:	85 c0                	test   %eax,%eax
8010247a:	0f 84 97 00 00 00    	je     80102517 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102480:	83 ec 0c             	sub    $0xc,%esp
80102483:	68 80 a5 10 80       	push   $0x8010a580
80102488:	e8 53 23 00 00       	call   801047e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010248d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
  b->qnext = 0;
80102493:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010249a:	83 c4 10             	add    $0x10,%esp
8010249d:	85 d2                	test   %edx,%edx
8010249f:	75 09                	jne    801024aa <iderw+0x6a>
801024a1:	eb 6d                	jmp    80102510 <iderw+0xd0>
801024a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024a7:	90                   	nop
801024a8:	89 c2                	mov    %eax,%edx
801024aa:	8b 42 58             	mov    0x58(%edx),%eax
801024ad:	85 c0                	test   %eax,%eax
801024af:	75 f7                	jne    801024a8 <iderw+0x68>
801024b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801024b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801024b6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801024bc:	74 42                	je     80102500 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024be:	8b 03                	mov    (%ebx),%eax
801024c0:	83 e0 06             	and    $0x6,%eax
801024c3:	83 f8 02             	cmp    $0x2,%eax
801024c6:	74 23                	je     801024eb <iderw+0xab>
801024c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024cf:	90                   	nop
    sleep(b, &idelock);
801024d0:	83 ec 08             	sub    $0x8,%esp
801024d3:	68 80 a5 10 80       	push   $0x8010a580
801024d8:	53                   	push   %ebx
801024d9:	e8 12 1c 00 00       	call   801040f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801024de:	8b 03                	mov    (%ebx),%eax
801024e0:	83 c4 10             	add    $0x10,%esp
801024e3:	83 e0 06             	and    $0x6,%eax
801024e6:	83 f8 02             	cmp    $0x2,%eax
801024e9:	75 e5                	jne    801024d0 <iderw+0x90>
  }


  release(&idelock);
801024eb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801024f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024f5:	c9                   	leave  
  release(&idelock);
801024f6:	e9 05 24 00 00       	jmp    80104900 <release>
801024fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024ff:	90                   	nop
    idestart(b);
80102500:	89 d8                	mov    %ebx,%eax
80102502:	e8 39 fd ff ff       	call   80102240 <idestart>
80102507:	eb b5                	jmp    801024be <iderw+0x7e>
80102509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102510:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102515:	eb 9d                	jmp    801024b4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102517:	83 ec 0c             	sub    $0xc,%esp
8010251a:	68 c6 76 10 80       	push   $0x801076c6
8010251f:	e8 6c de ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102524:	83 ec 0c             	sub    $0xc,%esp
80102527:	68 b1 76 10 80       	push   $0x801076b1
8010252c:	e8 5f de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102531:	83 ec 0c             	sub    $0xc,%esp
80102534:	68 9b 76 10 80       	push   $0x8010769b
80102539:	e8 52 de ff ff       	call   80100390 <panic>
8010253e:	66 90                	xchg   %ax,%ax

80102540 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102540:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102541:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102548:	00 c0 fe 
{
8010254b:	89 e5                	mov    %esp,%ebp
8010254d:	56                   	push   %esi
8010254e:	53                   	push   %ebx
  ioapic->reg = reg;
8010254f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102556:	00 00 00 
  return ioapic->data;
80102559:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010255f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102562:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102568:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010256e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102575:	c1 ee 10             	shr    $0x10,%esi
80102578:	89 f0                	mov    %esi,%eax
8010257a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010257d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102580:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102583:	39 c2                	cmp    %eax,%edx
80102585:	74 16                	je     8010259d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102587:	83 ec 0c             	sub    $0xc,%esp
8010258a:	68 e4 76 10 80       	push   $0x801076e4
8010258f:	e8 1c e1 ff ff       	call   801006b0 <cprintf>
80102594:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010259a:	83 c4 10             	add    $0x10,%esp
8010259d:	83 c6 21             	add    $0x21,%esi
{
801025a0:	ba 10 00 00 00       	mov    $0x10,%edx
801025a5:	b8 20 00 00 00       	mov    $0x20,%eax
801025aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801025b0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025b2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801025b4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801025ba:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801025bd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801025c3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801025c6:	8d 5a 01             	lea    0x1(%edx),%ebx
801025c9:	83 c2 02             	add    $0x2,%edx
801025cc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801025ce:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801025d4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801025db:	39 f0                	cmp    %esi,%eax
801025dd:	75 d1                	jne    801025b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801025df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e2:	5b                   	pop    %ebx
801025e3:	5e                   	pop    %esi
801025e4:	5d                   	pop    %ebp
801025e5:	c3                   	ret    
801025e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ed:	8d 76 00             	lea    0x0(%esi),%esi

801025f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801025f0:	55                   	push   %ebp
  ioapic->reg = reg;
801025f1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801025f7:	89 e5                	mov    %esp,%ebp
801025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801025fc:	8d 50 20             	lea    0x20(%eax),%edx
801025ff:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102603:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102605:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010260b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010260e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102611:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102614:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102616:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010261b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010261e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102621:	5d                   	pop    %ebp
80102622:	c3                   	ret    
80102623:	66 90                	xchg   %ax,%ax
80102625:	66 90                	xchg   %ax,%ax
80102627:	66 90                	xchg   %ax,%ax
80102629:	66 90                	xchg   %ax,%ax
8010262b:	66 90                	xchg   %ax,%ax
8010262d:	66 90                	xchg   %ax,%ax
8010262f:	90                   	nop

80102630 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	53                   	push   %ebx
80102634:	83 ec 04             	sub    $0x4,%esp
80102637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010263a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102640:	75 76                	jne    801026b8 <kfree+0x88>
80102642:	81 fb a8 55 11 80    	cmp    $0x801155a8,%ebx
80102648:	72 6e                	jb     801026b8 <kfree+0x88>
8010264a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102650:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102655:	77 61                	ja     801026b8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102657:	83 ec 04             	sub    $0x4,%esp
8010265a:	68 00 10 00 00       	push   $0x1000
8010265f:	6a 01                	push   $0x1
80102661:	53                   	push   %ebx
80102662:	e8 e9 22 00 00       	call   80104950 <memset>

  if(kmem.use_lock)
80102667:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	85 d2                	test   %edx,%edx
80102672:	75 1c                	jne    80102690 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102674:	a1 78 26 11 80       	mov    0x80112678,%eax
80102679:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010267b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102680:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102686:	85 c0                	test   %eax,%eax
80102688:	75 1e                	jne    801026a8 <kfree+0x78>
    release(&kmem.lock);
}
8010268a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010268d:	c9                   	leave  
8010268e:	c3                   	ret    
8010268f:	90                   	nop
    acquire(&kmem.lock);
80102690:	83 ec 0c             	sub    $0xc,%esp
80102693:	68 40 26 11 80       	push   $0x80112640
80102698:	e8 43 21 00 00       	call   801047e0 <acquire>
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	eb d2                	jmp    80102674 <kfree+0x44>
801026a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801026a8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801026af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026b2:	c9                   	leave  
    release(&kmem.lock);
801026b3:	e9 48 22 00 00       	jmp    80104900 <release>
    panic("kfree");
801026b8:	83 ec 0c             	sub    $0xc,%esp
801026bb:	68 16 77 10 80       	push   $0x80107716
801026c0:	e8 cb dc ff ff       	call   80100390 <panic>
801026c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026d0 <freerange>:
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026d4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026d7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026da:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ed:	39 de                	cmp    %ebx,%esi
801026ef:	72 23                	jb     80102714 <freerange+0x44>
801026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026f8:	83 ec 0c             	sub    $0xc,%esp
801026fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102701:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102707:	50                   	push   %eax
80102708:	e8 23 ff ff ff       	call   80102630 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010270d:	83 c4 10             	add    $0x10,%esp
80102710:	39 f3                	cmp    %esi,%ebx
80102712:	76 e4                	jbe    801026f8 <freerange+0x28>
}
80102714:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102717:	5b                   	pop    %ebx
80102718:	5e                   	pop    %esi
80102719:	5d                   	pop    %ebp
8010271a:	c3                   	ret    
8010271b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010271f:	90                   	nop

80102720 <kinit1>:
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
80102725:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	68 1c 77 10 80       	push   $0x8010771c
80102730:	68 40 26 11 80       	push   $0x80112640
80102735:	e8 a6 1f 00 00       	call   801046e0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010273a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102740:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102747:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010274a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102750:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102756:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275c:	39 de                	cmp    %ebx,%esi
8010275e:	72 1c                	jb     8010277c <kinit1+0x5c>
    kfree(p);
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102769:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010276f:	50                   	push   %eax
80102770:	e8 bb fe ff ff       	call   80102630 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102775:	83 c4 10             	add    $0x10,%esp
80102778:	39 de                	cmp    %ebx,%esi
8010277a:	73 e4                	jae    80102760 <kinit1+0x40>
}
8010277c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010277f:	5b                   	pop    %ebx
80102780:	5e                   	pop    %esi
80102781:	5d                   	pop    %ebp
80102782:	c3                   	ret    
80102783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102790 <kinit2>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102794:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102797:	8b 75 0c             	mov    0xc(%ebp),%esi
8010279a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010279b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027ad:	39 de                	cmp    %ebx,%esi
801027af:	72 23                	jb     801027d4 <kinit2+0x44>
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027b8:	83 ec 0c             	sub    $0xc,%esp
801027bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027c7:	50                   	push   %eax
801027c8:	e8 63 fe ff ff       	call   80102630 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027cd:	83 c4 10             	add    $0x10,%esp
801027d0:	39 de                	cmp    %ebx,%esi
801027d2:	73 e4                	jae    801027b8 <kinit2+0x28>
  kmem.use_lock = 1;
801027d4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801027db:	00 00 00 
}
801027de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e1:	5b                   	pop    %ebx
801027e2:	5e                   	pop    %esi
801027e3:	5d                   	pop    %ebp
801027e4:	c3                   	ret    
801027e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	53                   	push   %ebx
801027f4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801027f7:	a1 74 26 11 80       	mov    0x80112674,%eax
801027fc:	85 c0                	test   %eax,%eax
801027fe:	75 20                	jne    80102820 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102800:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102806:	85 db                	test   %ebx,%ebx
80102808:	74 07                	je     80102811 <kalloc+0x21>
    kmem.freelist = r->next;
8010280a:	8b 03                	mov    (%ebx),%eax
8010280c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102811:	89 d8                	mov    %ebx,%eax
80102813:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102816:	c9                   	leave  
80102817:	c3                   	ret    
80102818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010281f:	90                   	nop
    acquire(&kmem.lock);
80102820:	83 ec 0c             	sub    $0xc,%esp
80102823:	68 40 26 11 80       	push   $0x80112640
80102828:	e8 b3 1f 00 00       	call   801047e0 <acquire>
  r = kmem.freelist;
8010282d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102833:	83 c4 10             	add    $0x10,%esp
80102836:	a1 74 26 11 80       	mov    0x80112674,%eax
8010283b:	85 db                	test   %ebx,%ebx
8010283d:	74 08                	je     80102847 <kalloc+0x57>
    kmem.freelist = r->next;
8010283f:	8b 13                	mov    (%ebx),%edx
80102841:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102847:	85 c0                	test   %eax,%eax
80102849:	74 c6                	je     80102811 <kalloc+0x21>
    release(&kmem.lock);
8010284b:	83 ec 0c             	sub    $0xc,%esp
8010284e:	68 40 26 11 80       	push   $0x80112640
80102853:	e8 a8 20 00 00       	call   80104900 <release>
}
80102858:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010285a:	83 c4 10             	add    $0x10,%esp
}
8010285d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102860:	c9                   	leave  
80102861:	c3                   	ret    
80102862:	66 90                	xchg   %ax,%ax
80102864:	66 90                	xchg   %ax,%ax
80102866:	66 90                	xchg   %ax,%ax
80102868:	66 90                	xchg   %ax,%ax
8010286a:	66 90                	xchg   %ax,%ax
8010286c:	66 90                	xchg   %ax,%ax
8010286e:	66 90                	xchg   %ax,%ax

80102870 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102870:	ba 64 00 00 00       	mov    $0x64,%edx
80102875:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102876:	a8 01                	test   $0x1,%al
80102878:	0f 84 c2 00 00 00    	je     80102940 <kbdgetc+0xd0>
{
8010287e:	55                   	push   %ebp
8010287f:	ba 60 00 00 00       	mov    $0x60,%edx
80102884:	89 e5                	mov    %esp,%ebp
80102886:	53                   	push   %ebx
80102887:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102888:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010288b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102891:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102897:	74 57                	je     801028f0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102899:	89 d9                	mov    %ebx,%ecx
8010289b:	83 e1 40             	and    $0x40,%ecx
8010289e:	84 c0                	test   %al,%al
801028a0:	78 5e                	js     80102900 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801028a2:	85 c9                	test   %ecx,%ecx
801028a4:	74 09                	je     801028af <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801028a6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801028a9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801028ac:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801028af:	0f b6 8a 60 78 10 80 	movzbl -0x7fef87a0(%edx),%ecx
  shift ^= togglecode[data];
801028b6:	0f b6 82 60 77 10 80 	movzbl -0x7fef88a0(%edx),%eax
  shift |= shiftcode[data];
801028bd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801028bf:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801028c1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801028c3:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801028c9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801028cc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801028cf:	8b 04 85 40 77 10 80 	mov    -0x7fef88c0(,%eax,4),%eax
801028d6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801028da:	74 0b                	je     801028e7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801028dc:	8d 50 9f             	lea    -0x61(%eax),%edx
801028df:	83 fa 19             	cmp    $0x19,%edx
801028e2:	77 44                	ja     80102928 <kbdgetc+0xb8>
      c += 'A' - 'a';
801028e4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801028e7:	5b                   	pop    %ebx
801028e8:	5d                   	pop    %ebp
801028e9:	c3                   	ret    
801028ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801028f0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801028f3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801028f5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801028fb:	5b                   	pop    %ebx
801028fc:	5d                   	pop    %ebp
801028fd:	c3                   	ret    
801028fe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102900:	83 e0 7f             	and    $0x7f,%eax
80102903:	85 c9                	test   %ecx,%ecx
80102905:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102908:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010290a:	0f b6 8a 60 78 10 80 	movzbl -0x7fef87a0(%edx),%ecx
80102911:	83 c9 40             	or     $0x40,%ecx
80102914:	0f b6 c9             	movzbl %cl,%ecx
80102917:	f7 d1                	not    %ecx
80102919:	21 d9                	and    %ebx,%ecx
}
8010291b:	5b                   	pop    %ebx
8010291c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010291d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102923:	c3                   	ret    
80102924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102928:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010292b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010292e:	5b                   	pop    %ebx
8010292f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102930:	83 f9 1a             	cmp    $0x1a,%ecx
80102933:	0f 42 c2             	cmovb  %edx,%eax
}
80102936:	c3                   	ret    
80102937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293e:	66 90                	xchg   %ax,%ax
    return -1;
80102940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102945:	c3                   	ret    
80102946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294d:	8d 76 00             	lea    0x0(%esi),%esi

80102950 <kbdintr>:

void
kbdintr(void)
{
80102950:	55                   	push   %ebp
80102951:	89 e5                	mov    %esp,%ebp
80102953:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102956:	68 70 28 10 80       	push   $0x80102870
8010295b:	e8 00 df ff ff       	call   80100860 <consoleintr>
}
80102960:	83 c4 10             	add    $0x10,%esp
80102963:	c9                   	leave  
80102964:	c3                   	ret    
80102965:	66 90                	xchg   %ax,%ax
80102967:	66 90                	xchg   %ax,%ax
80102969:	66 90                	xchg   %ax,%ax
8010296b:	66 90                	xchg   %ax,%ax
8010296d:	66 90                	xchg   %ax,%ax
8010296f:	90                   	nop

80102970 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102970:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102975:	85 c0                	test   %eax,%eax
80102977:	0f 84 cb 00 00 00    	je     80102a48 <lapicinit+0xd8>
  lapic[index] = value;
8010297d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102984:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102987:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010298a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102991:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102994:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102997:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010299e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801029a1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029a4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801029ab:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801029ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801029b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029be:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801029c5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801029cb:	8b 50 30             	mov    0x30(%eax),%edx
801029ce:	c1 ea 10             	shr    $0x10,%edx
801029d1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801029d7:	75 77                	jne    80102a50 <lapicinit+0xe0>
  lapic[index] = value;
801029d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801029e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801029fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a00:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a07:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a0a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a0d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a14:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a1a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a21:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a24:	8b 50 20             	mov    0x20(%eax),%edx
80102a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a2e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a30:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a36:	80 e6 10             	and    $0x10,%dh
80102a39:	75 f5                	jne    80102a30 <lapicinit+0xc0>
  lapic[index] = value;
80102a3b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102a42:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a45:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102a48:	c3                   	ret    
80102a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102a50:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102a57:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5a:	8b 50 20             	mov    0x20(%eax),%edx
80102a5d:	e9 77 ff ff ff       	jmp    801029d9 <lapicinit+0x69>
80102a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a70 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a70:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102a75:	85 c0                	test   %eax,%eax
80102a77:	74 07                	je     80102a80 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a79:	8b 40 20             	mov    0x20(%eax),%eax
80102a7c:	c1 e8 18             	shr    $0x18,%eax
80102a7f:	c3                   	ret    
    return 0;
80102a80:	31 c0                	xor    %eax,%eax
}
80102a82:	c3                   	ret    
80102a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a90 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a90:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102a95:	85 c0                	test   %eax,%eax
80102a97:	74 0d                	je     80102aa6 <lapiceoi+0x16>
  lapic[index] = value;
80102a99:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102aa0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102aa6:	c3                   	ret    
80102aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aae:	66 90                	xchg   %ax,%ax

80102ab0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102ab0:	c3                   	ret    
80102ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102abf:	90                   	nop

80102ac0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ac0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102ac6:	ba 70 00 00 00       	mov    $0x70,%edx
80102acb:	89 e5                	mov    %esp,%ebp
80102acd:	53                   	push   %ebx
80102ace:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102ad1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ad4:	ee                   	out    %al,(%dx)
80102ad5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ada:	ba 71 00 00 00       	mov    $0x71,%edx
80102adf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ae0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ae2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ae5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102aeb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102aed:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102af0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102af2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102af5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102af8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102afe:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102b03:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b09:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b0c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b13:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b16:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b19:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b20:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b23:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b26:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b2c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b2f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b35:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b38:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b41:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102b47:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102b48:	8b 40 20             	mov    0x20(%eax),%eax
}
80102b4b:	5d                   	pop    %ebp
80102b4c:	c3                   	ret    
80102b4d:	8d 76 00             	lea    0x0(%esi),%esi

80102b50 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102b50:	55                   	push   %ebp
80102b51:	b8 0b 00 00 00       	mov    $0xb,%eax
80102b56:	ba 70 00 00 00       	mov    $0x70,%edx
80102b5b:	89 e5                	mov    %esp,%ebp
80102b5d:	57                   	push   %edi
80102b5e:	56                   	push   %esi
80102b5f:	53                   	push   %ebx
80102b60:	83 ec 4c             	sub    $0x4c,%esp
80102b63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b64:	ba 71 00 00 00       	mov    $0x71,%edx
80102b69:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102b6a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b72:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b75:	8d 76 00             	lea    0x0(%esi),%esi
80102b78:	31 c0                	xor    %eax,%eax
80102b7a:	89 da                	mov    %ebx,%edx
80102b7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b82:	89 ca                	mov    %ecx,%edx
80102b84:	ec                   	in     (%dx),%al
80102b85:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b88:	89 da                	mov    %ebx,%edx
80102b8a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b90:	89 ca                	mov    %ecx,%edx
80102b92:	ec                   	in     (%dx),%al
80102b93:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b96:	89 da                	mov    %ebx,%edx
80102b98:	b8 04 00 00 00       	mov    $0x4,%eax
80102b9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9e:	89 ca                	mov    %ecx,%edx
80102ba0:	ec                   	in     (%dx),%al
80102ba1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba4:	89 da                	mov    %ebx,%edx
80102ba6:	b8 07 00 00 00       	mov    $0x7,%eax
80102bab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bac:	89 ca                	mov    %ecx,%edx
80102bae:	ec                   	in     (%dx),%al
80102baf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb2:	89 da                	mov    %ebx,%edx
80102bb4:	b8 08 00 00 00       	mov    $0x8,%eax
80102bb9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bba:	89 ca                	mov    %ecx,%edx
80102bbc:	ec                   	in     (%dx),%al
80102bbd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bbf:	89 da                	mov    %ebx,%edx
80102bc1:	b8 09 00 00 00       	mov    $0x9,%eax
80102bc6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc7:	89 ca                	mov    %ecx,%edx
80102bc9:	ec                   	in     (%dx),%al
80102bca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bcc:	89 da                	mov    %ebx,%edx
80102bce:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bd3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bd4:	89 ca                	mov    %ecx,%edx
80102bd6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102bd7:	84 c0                	test   %al,%al
80102bd9:	78 9d                	js     80102b78 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102bdb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102bdf:	89 fa                	mov    %edi,%edx
80102be1:	0f b6 fa             	movzbl %dl,%edi
80102be4:	89 f2                	mov    %esi,%edx
80102be6:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102be9:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102bed:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf0:	89 da                	mov    %ebx,%edx
80102bf2:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102bf5:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102bf8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102bfc:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102bff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c02:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c06:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c09:	31 c0                	xor    %eax,%eax
80102c0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0c:	89 ca                	mov    %ecx,%edx
80102c0e:	ec                   	in     (%dx),%al
80102c0f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c12:	89 da                	mov    %ebx,%edx
80102c14:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c17:	b8 02 00 00 00       	mov    $0x2,%eax
80102c1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1d:	89 ca                	mov    %ecx,%edx
80102c1f:	ec                   	in     (%dx),%al
80102c20:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c23:	89 da                	mov    %ebx,%edx
80102c25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c28:	b8 04 00 00 00       	mov    $0x4,%eax
80102c2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c2e:	89 ca                	mov    %ecx,%edx
80102c30:	ec                   	in     (%dx),%al
80102c31:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c34:	89 da                	mov    %ebx,%edx
80102c36:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c39:	b8 07 00 00 00       	mov    $0x7,%eax
80102c3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3f:	89 ca                	mov    %ecx,%edx
80102c41:	ec                   	in     (%dx),%al
80102c42:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c45:	89 da                	mov    %ebx,%edx
80102c47:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102c4a:	b8 08 00 00 00       	mov    $0x8,%eax
80102c4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c50:	89 ca                	mov    %ecx,%edx
80102c52:	ec                   	in     (%dx),%al
80102c53:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c56:	89 da                	mov    %ebx,%edx
80102c58:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c5b:	b8 09 00 00 00       	mov    $0x9,%eax
80102c60:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c61:	89 ca                	mov    %ecx,%edx
80102c63:	ec                   	in     (%dx),%al
80102c64:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c67:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102c6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102c6d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c70:	6a 18                	push   $0x18
80102c72:	50                   	push   %eax
80102c73:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c76:	50                   	push   %eax
80102c77:	e8 24 1d 00 00       	call   801049a0 <memcmp>
80102c7c:	83 c4 10             	add    $0x10,%esp
80102c7f:	85 c0                	test   %eax,%eax
80102c81:	0f 85 f1 fe ff ff    	jne    80102b78 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c87:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c8b:	75 78                	jne    80102d05 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c90:	89 c2                	mov    %eax,%edx
80102c92:	83 e0 0f             	and    $0xf,%eax
80102c95:	c1 ea 04             	shr    $0x4,%edx
80102c98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c9e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ca1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ca4:	89 c2                	mov    %eax,%edx
80102ca6:	83 e0 0f             	and    $0xf,%eax
80102ca9:	c1 ea 04             	shr    $0x4,%edx
80102cac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102caf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cb2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102cb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102cb8:	89 c2                	mov    %eax,%edx
80102cba:	83 e0 0f             	and    $0xf,%eax
80102cbd:	c1 ea 04             	shr    $0x4,%edx
80102cc0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cc3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cc6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102cc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ccc:	89 c2                	mov    %eax,%edx
80102cce:	83 e0 0f             	and    $0xf,%eax
80102cd1:	c1 ea 04             	shr    $0x4,%edx
80102cd4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cd7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cda:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102cdd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ce0:	89 c2                	mov    %eax,%edx
80102ce2:	83 e0 0f             	and    $0xf,%eax
80102ce5:	c1 ea 04             	shr    $0x4,%edx
80102ce8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ceb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102cf1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cf4:	89 c2                	mov    %eax,%edx
80102cf6:	83 e0 0f             	and    $0xf,%eax
80102cf9:	c1 ea 04             	shr    $0x4,%edx
80102cfc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d05:	8b 75 08             	mov    0x8(%ebp),%esi
80102d08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d0b:	89 06                	mov    %eax,(%esi)
80102d0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d10:	89 46 04             	mov    %eax,0x4(%esi)
80102d13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d16:	89 46 08             	mov    %eax,0x8(%esi)
80102d19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d22:	89 46 10             	mov    %eax,0x10(%esi)
80102d25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d28:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d35:	5b                   	pop    %ebx
80102d36:	5e                   	pop    %esi
80102d37:	5f                   	pop    %edi
80102d38:	5d                   	pop    %ebp
80102d39:	c3                   	ret    
80102d3a:	66 90                	xchg   %ax,%ax
80102d3c:	66 90                	xchg   %ax,%ax
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d40:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d46:	85 c9                	test   %ecx,%ecx
80102d48:	0f 8e 8a 00 00 00    	jle    80102dd8 <install_trans+0x98>
{
80102d4e:	55                   	push   %ebp
80102d4f:	89 e5                	mov    %esp,%ebp
80102d51:	57                   	push   %edi
80102d52:	56                   	push   %esi
80102d53:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102d54:	31 db                	xor    %ebx,%ebx
{
80102d56:	83 ec 0c             	sub    $0xc,%esp
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102d60:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d65:	83 ec 08             	sub    $0x8,%esp
80102d68:	01 d8                	add    %ebx,%eax
80102d6a:	83 c0 01             	add    $0x1,%eax
80102d6d:	50                   	push   %eax
80102d6e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d74:	e8 57 d3 ff ff       	call   801000d0 <bread>
80102d79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d7b:	58                   	pop    %eax
80102d7c:	5a                   	pop    %edx
80102d7d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102d84:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d8d:	e8 3e d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d92:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d95:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d97:	8d 47 5c             	lea    0x5c(%edi),%eax
80102d9a:	68 00 02 00 00       	push   $0x200
80102d9f:	50                   	push   %eax
80102da0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102da3:	50                   	push   %eax
80102da4:	e8 47 1c 00 00       	call   801049f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102da9:	89 34 24             	mov    %esi,(%esp)
80102dac:	e8 ff d3 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102db1:	89 3c 24             	mov    %edi,(%esp)
80102db4:	e8 37 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102db9:	89 34 24             	mov    %esi,(%esp)
80102dbc:	e8 2f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102dca:	7f 94                	jg     80102d60 <install_trans+0x20>
  }
}
80102dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dcf:	5b                   	pop    %ebx
80102dd0:	5e                   	pop    %esi
80102dd1:	5f                   	pop    %edi
80102dd2:	5d                   	pop    %ebp
80102dd3:	c3                   	ret    
80102dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dd8:	c3                   	ret    
80102dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102de0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102de7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102ded:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102df3:	e8 d8 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102df8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102dfb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102dfd:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102e02:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102e05:	85 c0                	test   %eax,%eax
80102e07:	7e 19                	jle    80102e22 <write_head+0x42>
80102e09:	31 d2                	xor    %edx,%edx
80102e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e0f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102e10:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102e17:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102e1b:	83 c2 01             	add    $0x1,%edx
80102e1e:	39 d0                	cmp    %edx,%eax
80102e20:	75 ee                	jne    80102e10 <write_head+0x30>
  }
  bwrite(buf);
80102e22:	83 ec 0c             	sub    $0xc,%esp
80102e25:	53                   	push   %ebx
80102e26:	e8 85 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102e2b:	89 1c 24             	mov    %ebx,(%esp)
80102e2e:	e8 bd d3 ff ff       	call   801001f0 <brelse>
}
80102e33:	83 c4 10             	add    $0x10,%esp
80102e36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e39:	c9                   	leave  
80102e3a:	c3                   	ret    
80102e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e3f:	90                   	nop

80102e40 <initlog>:
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 2c             	sub    $0x2c,%esp
80102e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102e4a:	68 60 79 10 80       	push   $0x80107960
80102e4f:	68 80 26 11 80       	push   $0x80112680
80102e54:	e8 87 18 00 00       	call   801046e0 <initlock>
  readsb(dev, &sb);
80102e59:	58                   	pop    %eax
80102e5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102e5d:	5a                   	pop    %edx
80102e5e:	50                   	push   %eax
80102e5f:	53                   	push   %ebx
80102e60:	e8 0b e6 ff ff       	call   80101470 <readsb>
  log.start = sb.logstart;
80102e65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102e68:	59                   	pop    %ecx
  log.dev = dev;
80102e69:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102e6f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e72:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102e77:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102e7d:	5a                   	pop    %edx
80102e7e:	50                   	push   %eax
80102e7f:	53                   	push   %ebx
80102e80:	e8 4b d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e85:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e88:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102e8b:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102e91:	85 c9                	test   %ecx,%ecx
80102e93:	7e 1d                	jle    80102eb2 <initlog+0x72>
80102e95:	31 d2                	xor    %edx,%edx
80102e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e9e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ea0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102ea4:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102eab:	83 c2 01             	add    $0x1,%edx
80102eae:	39 d1                	cmp    %edx,%ecx
80102eb0:	75 ee                	jne    80102ea0 <initlog+0x60>
  brelse(buf);
80102eb2:	83 ec 0c             	sub    $0xc,%esp
80102eb5:	50                   	push   %eax
80102eb6:	e8 35 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ebb:	e8 80 fe ff ff       	call   80102d40 <install_trans>
  log.lh.n = 0;
80102ec0:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102ec7:	00 00 00 
  write_head(); // clear the log
80102eca:	e8 11 ff ff ff       	call   80102de0 <write_head>
}
80102ecf:	83 c4 10             	add    $0x10,%esp
80102ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ed5:	c9                   	leave  
80102ed6:	c3                   	ret    
80102ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102ee6:	68 80 26 11 80       	push   $0x80112680
80102eeb:	e8 f0 18 00 00       	call   801047e0 <acquire>
80102ef0:	83 c4 10             	add    $0x10,%esp
80102ef3:	eb 18                	jmp    80102f0d <begin_op+0x2d>
80102ef5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ef8:	83 ec 08             	sub    $0x8,%esp
80102efb:	68 80 26 11 80       	push   $0x80112680
80102f00:	68 80 26 11 80       	push   $0x80112680
80102f05:	e8 e6 11 00 00       	call   801040f0 <sleep>
80102f0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f0d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102f12:	85 c0                	test   %eax,%eax
80102f14:	75 e2                	jne    80102ef8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f16:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f1b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f21:	83 c0 01             	add    $0x1,%eax
80102f24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f2a:	83 fa 1e             	cmp    $0x1e,%edx
80102f2d:	7f c9                	jg     80102ef8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f32:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102f37:	68 80 26 11 80       	push   $0x80112680
80102f3c:	e8 bf 19 00 00       	call   80104900 <release>
      break;
    }
  }
}
80102f41:	83 c4 10             	add    $0x10,%esp
80102f44:	c9                   	leave  
80102f45:	c3                   	ret    
80102f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f4d:	8d 76 00             	lea    0x0(%esi),%esi

80102f50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	57                   	push   %edi
80102f54:	56                   	push   %esi
80102f55:	53                   	push   %ebx
80102f56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102f59:	68 80 26 11 80       	push   $0x80112680
80102f5e:	e8 7d 18 00 00       	call   801047e0 <acquire>
  log.outstanding -= 1;
80102f63:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102f68:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102f6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f71:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f74:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102f7a:	85 f6                	test   %esi,%esi
80102f7c:	0f 85 22 01 00 00    	jne    801030a4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f82:	85 db                	test   %ebx,%ebx
80102f84:	0f 85 f6 00 00 00    	jne    80103080 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f8a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102f91:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f94:	83 ec 0c             	sub    $0xc,%esp
80102f97:	68 80 26 11 80       	push   $0x80112680
80102f9c:	e8 5f 19 00 00       	call   80104900 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102fa1:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102fa7:	83 c4 10             	add    $0x10,%esp
80102faa:	85 c9                	test   %ecx,%ecx
80102fac:	7f 42                	jg     80102ff0 <end_op+0xa0>
    acquire(&log.lock);
80102fae:	83 ec 0c             	sub    $0xc,%esp
80102fb1:	68 80 26 11 80       	push   $0x80112680
80102fb6:	e8 25 18 00 00       	call   801047e0 <acquire>
    wakeup(&log);
80102fbb:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102fc2:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102fc9:	00 00 00 
    wakeup(&log);
80102fcc:	e8 cf 12 00 00       	call   801042a0 <wakeup>
    release(&log.lock);
80102fd1:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102fd8:	e8 23 19 00 00       	call   80104900 <release>
80102fdd:	83 c4 10             	add    $0x10,%esp
}
80102fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fe3:	5b                   	pop    %ebx
80102fe4:	5e                   	pop    %esi
80102fe5:	5f                   	pop    %edi
80102fe6:	5d                   	pop    %ebp
80102fe7:	c3                   	ret    
80102fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fef:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ff0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ff5:	83 ec 08             	sub    $0x8,%esp
80102ff8:	01 d8                	add    %ebx,%eax
80102ffa:	83 c0 01             	add    $0x1,%eax
80102ffd:	50                   	push   %eax
80102ffe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80103004:	e8 c7 d0 ff ff       	call   801000d0 <bread>
80103009:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010300b:	58                   	pop    %eax
8010300c:	5a                   	pop    %edx
8010300d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80103014:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010301a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010301d:	e8 ae d0 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103022:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103025:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103027:	8d 40 5c             	lea    0x5c(%eax),%eax
8010302a:	68 00 02 00 00       	push   $0x200
8010302f:	50                   	push   %eax
80103030:	8d 46 5c             	lea    0x5c(%esi),%eax
80103033:	50                   	push   %eax
80103034:	e8 b7 19 00 00       	call   801049f0 <memmove>
    bwrite(to);  // write the log
80103039:	89 34 24             	mov    %esi,(%esp)
8010303c:	e8 6f d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103041:	89 3c 24             	mov    %edi,(%esp)
80103044:	e8 a7 d1 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103049:	89 34 24             	mov    %esi,(%esp)
8010304c:	e8 9f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103051:	83 c4 10             	add    $0x10,%esp
80103054:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
8010305a:	7c 94                	jl     80102ff0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010305c:	e8 7f fd ff ff       	call   80102de0 <write_head>
    install_trans(); // Now install writes to home locations
80103061:	e8 da fc ff ff       	call   80102d40 <install_trans>
    log.lh.n = 0;
80103066:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010306d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103070:	e8 6b fd ff ff       	call   80102de0 <write_head>
80103075:	e9 34 ff ff ff       	jmp    80102fae <end_op+0x5e>
8010307a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103080:	83 ec 0c             	sub    $0xc,%esp
80103083:	68 80 26 11 80       	push   $0x80112680
80103088:	e8 13 12 00 00       	call   801042a0 <wakeup>
  release(&log.lock);
8010308d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80103094:	e8 67 18 00 00       	call   80104900 <release>
80103099:	83 c4 10             	add    $0x10,%esp
}
8010309c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309f:	5b                   	pop    %ebx
801030a0:	5e                   	pop    %esi
801030a1:	5f                   	pop    %edi
801030a2:	5d                   	pop    %ebp
801030a3:	c3                   	ret    
    panic("log.committing");
801030a4:	83 ec 0c             	sub    $0xc,%esp
801030a7:	68 64 79 10 80       	push   $0x80107964
801030ac:	e8 df d2 ff ff       	call   80100390 <panic>
801030b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030bf:	90                   	nop

801030c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	53                   	push   %ebx
801030c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030c7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
801030cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801030d0:	83 fa 1d             	cmp    $0x1d,%edx
801030d3:	0f 8f 94 00 00 00    	jg     8010316d <log_write+0xad>
801030d9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
801030de:	83 e8 01             	sub    $0x1,%eax
801030e1:	39 c2                	cmp    %eax,%edx
801030e3:	0f 8d 84 00 00 00    	jge    8010316d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
801030e9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
801030ee:	85 c0                	test   %eax,%eax
801030f0:	0f 8e 84 00 00 00    	jle    8010317a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
801030f6:	83 ec 0c             	sub    $0xc,%esp
801030f9:	68 80 26 11 80       	push   $0x80112680
801030fe:	e8 dd 16 00 00       	call   801047e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103103:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80103109:	83 c4 10             	add    $0x10,%esp
8010310c:	85 d2                	test   %edx,%edx
8010310e:	7e 51                	jle    80103161 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103110:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103113:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103115:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
8010311b:	75 0c                	jne    80103129 <log_write+0x69>
8010311d:	eb 39                	jmp    80103158 <log_write+0x98>
8010311f:	90                   	nop
80103120:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80103127:	74 2f                	je     80103158 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103129:	83 c0 01             	add    $0x1,%eax
8010312c:	39 c2                	cmp    %eax,%edx
8010312e:	75 f0                	jne    80103120 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103130:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103137:	83 c2 01             	add    $0x1,%edx
8010313a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80103140:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80103143:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103146:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
8010314d:	c9                   	leave  
  release(&log.lock);
8010314e:	e9 ad 17 00 00       	jmp    80104900 <release>
80103153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103157:	90                   	nop
  log.lh.block[i] = b->blockno;
80103158:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
8010315f:	eb df                	jmp    80103140 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80103161:	8b 43 08             	mov    0x8(%ebx),%eax
80103164:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80103169:	75 d5                	jne    80103140 <log_write+0x80>
8010316b:	eb ca                	jmp    80103137 <log_write+0x77>
    panic("too big a transaction");
8010316d:	83 ec 0c             	sub    $0xc,%esp
80103170:	68 73 79 10 80       	push   $0x80107973
80103175:	e8 16 d2 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010317a:	83 ec 0c             	sub    $0xc,%esp
8010317d:	68 89 79 10 80       	push   $0x80107989
80103182:	e8 09 d2 ff ff       	call   80100390 <panic>
80103187:	66 90                	xchg   %ax,%ax
80103189:	66 90                	xchg   %ax,%ax
8010318b:	66 90                	xchg   %ax,%ax
8010318d:	66 90                	xchg   %ax,%ax
8010318f:	90                   	nop

80103190 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	53                   	push   %ebx
80103194:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103197:	e8 74 09 00 00       	call   80103b10 <cpuid>
8010319c:	89 c3                	mov    %eax,%ebx
8010319e:	e8 6d 09 00 00       	call   80103b10 <cpuid>
801031a3:	83 ec 04             	sub    $0x4,%esp
801031a6:	53                   	push   %ebx
801031a7:	50                   	push   %eax
801031a8:	68 a4 79 10 80       	push   $0x801079a4
801031ad:	e8 fe d4 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801031b2:	e8 49 2a 00 00       	call   80105c00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801031b7:	e8 d4 08 00 00       	call   80103a90 <mycpu>
801031bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801031be:	b8 01 00 00 00       	mov    $0x1,%eax
801031c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801031ca:	e8 21 0c 00 00       	call   80103df0 <scheduler>
801031cf:	90                   	nop

801031d0 <mpenter>:
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801031d6:	e8 25 3b 00 00       	call   80106d00 <switchkvm>
  seginit();
801031db:	e8 90 3a 00 00       	call   80106c70 <seginit>
  lapicinit();
801031e0:	e8 8b f7 ff ff       	call   80102970 <lapicinit>
  mpmain();
801031e5:	e8 a6 ff ff ff       	call   80103190 <mpmain>
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <main>:
{
801031f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801031f4:	83 e4 f0             	and    $0xfffffff0,%esp
801031f7:	ff 71 fc             	pushl  -0x4(%ecx)
801031fa:	55                   	push   %ebp
801031fb:	89 e5                	mov    %esp,%ebp
801031fd:	53                   	push   %ebx
801031fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801031ff:	83 ec 08             	sub    $0x8,%esp
80103202:	68 00 00 40 80       	push   $0x80400000
80103207:	68 a8 55 11 80       	push   $0x801155a8
8010320c:	e8 0f f5 ff ff       	call   80102720 <kinit1>
  kvmalloc();      // kernel page table
80103211:	e8 aa 3f 00 00       	call   801071c0 <kvmalloc>
  mpinit();        // detect other processors
80103216:	e8 85 01 00 00       	call   801033a0 <mpinit>
  lapicinit();     // interrupt controller
8010321b:	e8 50 f7 ff ff       	call   80102970 <lapicinit>
  seginit();       // segment descriptors
80103220:	e8 4b 3a 00 00       	call   80106c70 <seginit>
  picinit();       // disable pic
80103225:	e8 46 03 00 00       	call   80103570 <picinit>
  ioapicinit();    // another interrupt controller
8010322a:	e8 11 f3 ff ff       	call   80102540 <ioapicinit>
  consoleinit();   // console hardware
8010322f:	e8 fc d7 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103234:	e8 f7 2c 00 00       	call   80105f30 <uartinit>
  pinit();         // process table
80103239:	e8 32 08 00 00       	call   80103a70 <pinit>
  tvinit();        // trap vectors
8010323e:	e8 3d 29 00 00       	call   80105b80 <tvinit>
  binit();         // buffer cache
80103243:	e8 f8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103248:	e8 a3 db ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
8010324d:	e8 ce f0 ff ff       	call   80102320 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103252:	83 c4 0c             	add    $0xc,%esp
80103255:	68 8a 00 00 00       	push   $0x8a
8010325a:	68 8c a4 10 80       	push   $0x8010a48c
8010325f:	68 00 70 00 80       	push   $0x80007000
80103264:	e8 87 17 00 00       	call   801049f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103269:	83 c4 10             	add    $0x10,%esp
8010326c:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103273:	00 00 00 
80103276:	05 80 27 11 80       	add    $0x80112780,%eax
8010327b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103280:	76 7e                	jbe    80103300 <main+0x110>
80103282:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103287:	eb 20                	jmp    801032a9 <main+0xb9>
80103289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103290:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103297:	00 00 00 
8010329a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801032a0:	05 80 27 11 80       	add    $0x80112780,%eax
801032a5:	39 c3                	cmp    %eax,%ebx
801032a7:	73 57                	jae    80103300 <main+0x110>
    if(c == mycpu())  // We've started already.
801032a9:	e8 e2 07 00 00       	call   80103a90 <mycpu>
801032ae:	39 d8                	cmp    %ebx,%eax
801032b0:	74 de                	je     80103290 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032b2:	e8 39 f5 ff ff       	call   801027f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801032b7:	83 ec 08             	sub    $0x8,%esp
    *(void**)(code-8) = mpenter;
801032ba:	c7 05 f8 6f 00 80 d0 	movl   $0x801031d0,0x80006ff8
801032c1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032c4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801032cb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ce:	05 00 10 00 00       	add    $0x1000,%eax
801032d3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801032d8:	0f b6 03             	movzbl (%ebx),%eax
801032db:	68 00 70 00 00       	push   $0x7000
801032e0:	50                   	push   %eax
801032e1:	e8 da f7 ff ff       	call   80102ac0 <lapicstartap>
801032e6:	83 c4 10             	add    $0x10,%esp
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801032f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801032f6:	85 c0                	test   %eax,%eax
801032f8:	74 f6                	je     801032f0 <main+0x100>
801032fa:	eb 94                	jmp    80103290 <main+0xa0>
801032fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103300:	83 ec 08             	sub    $0x8,%esp
80103303:	68 00 00 00 8e       	push   $0x8e000000
80103308:	68 00 00 40 80       	push   $0x80400000
8010330d:	e8 7e f4 ff ff       	call   80102790 <kinit2>
  userinit();      // first user process
80103312:	e8 49 08 00 00       	call   80103b60 <userinit>
  mpmain();        // finish this processor's setup
80103317:	e8 74 fe ff ff       	call   80103190 <mpmain>
8010331c:	66 90                	xchg   %ax,%ax
8010331e:	66 90                	xchg   %ax,%ax

80103320 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103325:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010332b:	53                   	push   %ebx
  e = addr+len;
8010332c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010332f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103332:	39 de                	cmp    %ebx,%esi
80103334:	72 10                	jb     80103346 <mpsearch1+0x26>
80103336:	eb 50                	jmp    80103388 <mpsearch1+0x68>
80103338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop
80103340:	89 fe                	mov    %edi,%esi
80103342:	39 fb                	cmp    %edi,%ebx
80103344:	76 42                	jbe    80103388 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103346:	83 ec 04             	sub    $0x4,%esp
80103349:	8d 7e 10             	lea    0x10(%esi),%edi
8010334c:	6a 04                	push   $0x4
8010334e:	68 b8 79 10 80       	push   $0x801079b8
80103353:	56                   	push   %esi
80103354:	e8 47 16 00 00       	call   801049a0 <memcmp>
80103359:	83 c4 10             	add    $0x10,%esp
8010335c:	85 c0                	test   %eax,%eax
8010335e:	75 e0                	jne    80103340 <mpsearch1+0x20>
80103360:	89 f1                	mov    %esi,%ecx
80103362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103368:	0f b6 11             	movzbl (%ecx),%edx
8010336b:	83 c1 01             	add    $0x1,%ecx
8010336e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103370:	39 f9                	cmp    %edi,%ecx
80103372:	75 f4                	jne    80103368 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103374:	84 c0                	test   %al,%al
80103376:	75 c8                	jne    80103340 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103378:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010337b:	89 f0                	mov    %esi,%eax
8010337d:	5b                   	pop    %ebx
8010337e:	5e                   	pop    %esi
8010337f:	5f                   	pop    %edi
80103380:	5d                   	pop    %ebp
80103381:	c3                   	ret    
80103382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103388:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010338b:	31 f6                	xor    %esi,%esi
}
8010338d:	5b                   	pop    %ebx
8010338e:	89 f0                	mov    %esi,%eax
80103390:	5e                   	pop    %esi
80103391:	5f                   	pop    %edi
80103392:	5d                   	pop    %ebp
80103393:	c3                   	ret    
80103394:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010339b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010339f:	90                   	nop

801033a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	57                   	push   %edi
801033a4:	56                   	push   %esi
801033a5:	53                   	push   %ebx
801033a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033b7:	c1 e0 08             	shl    $0x8,%eax
801033ba:	09 d0                	or     %edx,%eax
801033bc:	c1 e0 04             	shl    $0x4,%eax
801033bf:	75 1b                	jne    801033dc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801033c1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801033c8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801033cf:	c1 e0 08             	shl    $0x8,%eax
801033d2:	09 d0                	or     %edx,%eax
801033d4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801033d7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801033dc:	ba 00 04 00 00       	mov    $0x400,%edx
801033e1:	e8 3a ff ff ff       	call   80103320 <mpsearch1>
801033e6:	89 c7                	mov    %eax,%edi
801033e8:	85 c0                	test   %eax,%eax
801033ea:	0f 84 c0 00 00 00    	je     801034b0 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033f0:	8b 5f 04             	mov    0x4(%edi),%ebx
801033f3:	85 db                	test   %ebx,%ebx
801033f5:	0f 84 d5 00 00 00    	je     801034d0 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
801033fb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801033fe:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103404:	6a 04                	push   $0x4
80103406:	68 d5 79 10 80       	push   $0x801079d5
8010340b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010340c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010340f:	e8 8c 15 00 00       	call   801049a0 <memcmp>
80103414:	83 c4 10             	add    $0x10,%esp
80103417:	85 c0                	test   %eax,%eax
80103419:	0f 85 b1 00 00 00    	jne    801034d0 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
8010341f:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103426:	3c 01                	cmp    $0x1,%al
80103428:	0f 95 c2             	setne  %dl
8010342b:	3c 04                	cmp    $0x4,%al
8010342d:	0f 95 c0             	setne  %al
80103430:	20 c2                	and    %al,%dl
80103432:	0f 85 98 00 00 00    	jne    801034d0 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
80103438:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
8010343f:	66 85 c9             	test   %cx,%cx
80103442:	74 21                	je     80103465 <mpinit+0xc5>
80103444:	89 d8                	mov    %ebx,%eax
80103446:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
80103449:	31 d2                	xor    %edx,%edx
8010344b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010344f:	90                   	nop
    sum += addr[i];
80103450:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103457:	83 c0 01             	add    $0x1,%eax
8010345a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010345c:	39 c6                	cmp    %eax,%esi
8010345e:	75 f0                	jne    80103450 <mpinit+0xb0>
80103460:	84 d2                	test   %dl,%dl
80103462:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103465:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103468:	85 c9                	test   %ecx,%ecx
8010346a:	74 64                	je     801034d0 <mpinit+0x130>
8010346c:	84 d2                	test   %dl,%dl
8010346e:	75 60                	jne    801034d0 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103470:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103476:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010347b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103482:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103488:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010348d:	01 d1                	add    %edx,%ecx
8010348f:	89 ce                	mov    %ecx,%esi
80103491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103498:	39 c6                	cmp    %eax,%esi
8010349a:	76 4b                	jbe    801034e7 <mpinit+0x147>
    switch(*p){
8010349c:	0f b6 10             	movzbl (%eax),%edx
8010349f:	80 fa 04             	cmp    $0x4,%dl
801034a2:	0f 87 bf 00 00 00    	ja     80103567 <mpinit+0x1c7>
801034a8:	ff 24 95 fc 79 10 80 	jmp    *-0x7fef8604(,%edx,4)
801034af:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
801034b0:	ba 00 00 01 00       	mov    $0x10000,%edx
801034b5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801034ba:	e8 61 fe ff ff       	call   80103320 <mpsearch1>
801034bf:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034c1:	85 c0                	test   %eax,%eax
801034c3:	0f 85 27 ff ff ff    	jne    801033f0 <mpinit+0x50>
801034c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	68 bd 79 10 80       	push   $0x801079bd
801034d8:	e8 b3 ce ff ff       	call   80100390 <panic>
801034dd:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034e0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034e3:	39 c6                	cmp    %eax,%esi
801034e5:	77 b5                	ja     8010349c <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034e7:	85 db                	test   %ebx,%ebx
801034e9:	74 6f                	je     8010355a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034eb:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801034ef:	74 15                	je     80103506 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034f1:	b8 70 00 00 00       	mov    $0x70,%eax
801034f6:	ba 22 00 00 00       	mov    $0x22,%edx
801034fb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034fc:	ba 23 00 00 00       	mov    $0x23,%edx
80103501:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103502:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103505:	ee                   	out    %al,(%dx)
  }
}
80103506:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103509:	5b                   	pop    %ebx
8010350a:	5e                   	pop    %esi
8010350b:	5f                   	pop    %edi
8010350c:	5d                   	pop    %ebp
8010350d:	c3                   	ret    
8010350e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103510:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80103516:	83 fa 07             	cmp    $0x7,%edx
80103519:	7f 1f                	jg     8010353a <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010351b:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103521:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103524:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103528:	88 91 80 27 11 80    	mov    %dl,-0x7feed880(%ecx)
        ncpu++;
8010352e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103531:	83 c2 01             	add    $0x1,%edx
80103534:	89 15 00 2d 11 80    	mov    %edx,0x80112d00
      p += sizeof(struct mpproc);
8010353a:	83 c0 14             	add    $0x14,%eax
      continue;
8010353d:	e9 56 ff ff ff       	jmp    80103498 <mpinit+0xf8>
80103542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
80103548:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010354c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010354f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103555:	e9 3e ff ff ff       	jmp    80103498 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010355a:	83 ec 0c             	sub    $0xc,%esp
8010355d:	68 dc 79 10 80       	push   $0x801079dc
80103562:	e8 29 ce ff ff       	call   80100390 <panic>
      ismp = 0;
80103567:	31 db                	xor    %ebx,%ebx
80103569:	e9 31 ff ff ff       	jmp    8010349f <mpinit+0xff>
8010356e:	66 90                	xchg   %ax,%ax

80103570 <picinit>:
80103570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103575:	ba 21 00 00 00       	mov    $0x21,%edx
8010357a:	ee                   	out    %al,(%dx)
8010357b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103580:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103581:	c3                   	ret    
80103582:	66 90                	xchg   %ax,%ax
80103584:	66 90                	xchg   %ax,%ax
80103586:	66 90                	xchg   %ax,%ax
80103588:	66 90                	xchg   %ax,%ax
8010358a:	66 90                	xchg   %ax,%ax
8010358c:	66 90                	xchg   %ax,%ax
8010358e:	66 90                	xchg   %ax,%ax

80103590 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	57                   	push   %edi
80103594:	56                   	push   %esi
80103595:	53                   	push   %ebx
80103596:	83 ec 0c             	sub    $0xc,%esp
80103599:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010359c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010359f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035ab:	e8 60 d8 ff ff       	call   80100e10 <filealloc>
801035b0:	89 03                	mov    %eax,(%ebx)
801035b2:	85 c0                	test   %eax,%eax
801035b4:	0f 84 a8 00 00 00    	je     80103662 <pipealloc+0xd2>
801035ba:	e8 51 d8 ff ff       	call   80100e10 <filealloc>
801035bf:	89 06                	mov    %eax,(%esi)
801035c1:	85 c0                	test   %eax,%eax
801035c3:	0f 84 87 00 00 00    	je     80103650 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801035c9:	e8 22 f2 ff ff       	call   801027f0 <kalloc>
801035ce:	89 c7                	mov    %eax,%edi
801035d0:	85 c0                	test   %eax,%eax
801035d2:	0f 84 b0 00 00 00    	je     80103688 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
801035d8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801035df:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801035e2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801035e5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801035ec:	00 00 00 
  p->nwrite = 0;
801035ef:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035f6:	00 00 00 
  p->nread = 0;
801035f9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103600:	00 00 00 
  initlock(&p->lock, "pipe");
80103603:	68 10 7a 10 80       	push   $0x80107a10
80103608:	50                   	push   %eax
80103609:	e8 d2 10 00 00       	call   801046e0 <initlock>
  (*f0)->type = FD_PIPE;
8010360e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103610:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103613:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103619:	8b 03                	mov    (%ebx),%eax
8010361b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010361f:	8b 03                	mov    (%ebx),%eax
80103621:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103625:	8b 03                	mov    (%ebx),%eax
80103627:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010362a:	8b 06                	mov    (%esi),%eax
8010362c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103632:	8b 06                	mov    (%esi),%eax
80103634:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103638:	8b 06                	mov    (%esi),%eax
8010363a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010363e:	8b 06                	mov    (%esi),%eax
80103640:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103643:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103646:	31 c0                	xor    %eax,%eax
}
80103648:	5b                   	pop    %ebx
80103649:	5e                   	pop    %esi
8010364a:	5f                   	pop    %edi
8010364b:	5d                   	pop    %ebp
8010364c:	c3                   	ret    
8010364d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103650:	8b 03                	mov    (%ebx),%eax
80103652:	85 c0                	test   %eax,%eax
80103654:	74 1e                	je     80103674 <pipealloc+0xe4>
    fileclose(*f0);
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	50                   	push   %eax
8010365a:	e8 71 d8 ff ff       	call   80100ed0 <fileclose>
8010365f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103662:	8b 06                	mov    (%esi),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	74 0c                	je     80103674 <pipealloc+0xe4>
    fileclose(*f1);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	50                   	push   %eax
8010366c:	e8 5f d8 ff ff       	call   80100ed0 <fileclose>
80103671:	83 c4 10             	add    $0x10,%esp
}
80103674:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103688:	8b 03                	mov    (%ebx),%eax
8010368a:	85 c0                	test   %eax,%eax
8010368c:	75 c8                	jne    80103656 <pipealloc+0xc6>
8010368e:	eb d2                	jmp    80103662 <pipealloc+0xd2>

80103690 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	56                   	push   %esi
80103694:	53                   	push   %ebx
80103695:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103698:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010369b:	83 ec 0c             	sub    $0xc,%esp
8010369e:	53                   	push   %ebx
8010369f:	e8 3c 11 00 00       	call   801047e0 <acquire>
  if(writable){
801036a4:	83 c4 10             	add    $0x10,%esp
801036a7:	85 f6                	test   %esi,%esi
801036a9:	74 65                	je     80103710 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801036ab:	83 ec 0c             	sub    $0xc,%esp
801036ae:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801036b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801036bb:	00 00 00 
    wakeup(&p->nread);
801036be:	50                   	push   %eax
801036bf:	e8 dc 0b 00 00       	call   801042a0 <wakeup>
801036c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801036c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801036cd:	85 d2                	test   %edx,%edx
801036cf:	75 0a                	jne    801036db <pipeclose+0x4b>
801036d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801036d7:	85 c0                	test   %eax,%eax
801036d9:	74 15                	je     801036f0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801036db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801036de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036e1:	5b                   	pop    %ebx
801036e2:	5e                   	pop    %esi
801036e3:	5d                   	pop    %ebp
    release(&p->lock);
801036e4:	e9 17 12 00 00       	jmp    80104900 <release>
801036e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036f0:	83 ec 0c             	sub    $0xc,%esp
801036f3:	53                   	push   %ebx
801036f4:	e8 07 12 00 00       	call   80104900 <release>
    kfree((char*)p);
801036f9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036fc:	83 c4 10             	add    $0x10,%esp
}
801036ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103702:	5b                   	pop    %ebx
80103703:	5e                   	pop    %esi
80103704:	5d                   	pop    %ebp
    kfree((char*)p);
80103705:	e9 26 ef ff ff       	jmp    80102630 <kfree>
8010370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103710:	83 ec 0c             	sub    $0xc,%esp
80103713:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103719:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103720:	00 00 00 
    wakeup(&p->nwrite);
80103723:	50                   	push   %eax
80103724:	e8 77 0b 00 00       	call   801042a0 <wakeup>
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	eb 99                	jmp    801036c7 <pipeclose+0x37>
8010372e:	66 90                	xchg   %ax,%ax

80103730 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 28             	sub    $0x28,%esp
80103739:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010373c:	53                   	push   %ebx
8010373d:	e8 9e 10 00 00       	call   801047e0 <acquire>
  for(i = 0; i < n; i++){
80103742:	8b 45 10             	mov    0x10(%ebp),%eax
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	85 c0                	test   %eax,%eax
8010374a:	0f 8e c8 00 00 00    	jle    80103818 <pipewrite+0xe8>
80103750:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103753:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103759:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010375f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103762:	03 4d 10             	add    0x10(%ebp),%ecx
80103765:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103768:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010376e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103774:	39 d0                	cmp    %edx,%eax
80103776:	75 71                	jne    801037e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103778:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010377e:	85 c0                	test   %eax,%eax
80103780:	74 4e                	je     801037d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103782:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103788:	eb 3a                	jmp    801037c4 <pipewrite+0x94>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103790:	83 ec 0c             	sub    $0xc,%esp
80103793:	57                   	push   %edi
80103794:	e8 07 0b 00 00       	call   801042a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103799:	5a                   	pop    %edx
8010379a:	59                   	pop    %ecx
8010379b:	53                   	push   %ebx
8010379c:	56                   	push   %esi
8010379d:	e8 4e 09 00 00       	call   801040f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801037ae:	83 c4 10             	add    $0x10,%esp
801037b1:	05 00 02 00 00       	add    $0x200,%eax
801037b6:	39 c2                	cmp    %eax,%edx
801037b8:	75 36                	jne    801037f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801037ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037c0:	85 c0                	test   %eax,%eax
801037c2:	74 0c                	je     801037d0 <pipewrite+0xa0>
801037c4:	e8 67 03 00 00       	call   80103b30 <myproc>
801037c9:	8b 40 24             	mov    0x24(%eax),%eax
801037cc:	85 c0                	test   %eax,%eax
801037ce:	74 c0                	je     80103790 <pipewrite+0x60>
        release(&p->lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	53                   	push   %ebx
801037d4:	e8 27 11 00 00       	call   80104900 <release>
        return -1;
801037d9:	83 c4 10             	add    $0x10,%esp
801037dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801037e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e4:	5b                   	pop    %ebx
801037e5:	5e                   	pop    %esi
801037e6:	5f                   	pop    %edi
801037e7:	5d                   	pop    %ebp
801037e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037e9:	89 c2                	mov    %eax,%edx
801037eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ef:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801037f3:	8d 42 01             	lea    0x1(%edx),%eax
801037f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103802:	0f b6 0e             	movzbl (%esi),%ecx
80103805:	83 c6 01             	add    $0x1,%esi
80103808:	89 75 e4             	mov    %esi,-0x1c(%ebp)
8010380b:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
8010380f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103812:	0f 85 50 ff ff ff    	jne    80103768 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103818:	83 ec 0c             	sub    $0xc,%esp
8010381b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103821:	50                   	push   %eax
80103822:	e8 79 0a 00 00       	call   801042a0 <wakeup>
  release(&p->lock);
80103827:	89 1c 24             	mov    %ebx,(%esp)
8010382a:	e8 d1 10 00 00       	call   80104900 <release>
  return n;
8010382f:	83 c4 10             	add    $0x10,%esp
80103832:	8b 45 10             	mov    0x10(%ebp),%eax
80103835:	eb aa                	jmp    801037e1 <pipewrite+0xb1>
80103837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010383e:	66 90                	xchg   %ax,%ax

80103840 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	57                   	push   %edi
80103844:	56                   	push   %esi
80103845:	53                   	push   %ebx
80103846:	83 ec 18             	sub    $0x18,%esp
80103849:	8b 75 08             	mov    0x8(%ebp),%esi
8010384c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010384f:	56                   	push   %esi
80103850:	e8 8b 0f 00 00       	call   801047e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103855:	83 c4 10             	add    $0x10,%esp
80103858:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010385e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103864:	75 6a                	jne    801038d0 <piperead+0x90>
80103866:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010386c:	85 db                	test   %ebx,%ebx
8010386e:	0f 84 c4 00 00 00    	je     80103938 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103874:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010387a:	eb 2d                	jmp    801038a9 <piperead+0x69>
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103880:	83 ec 08             	sub    $0x8,%esp
80103883:	56                   	push   %esi
80103884:	53                   	push   %ebx
80103885:	e8 66 08 00 00       	call   801040f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010388a:	83 c4 10             	add    $0x10,%esp
8010388d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103893:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103899:	75 35                	jne    801038d0 <piperead+0x90>
8010389b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801038a1:	85 d2                	test   %edx,%edx
801038a3:	0f 84 8f 00 00 00    	je     80103938 <piperead+0xf8>
    if(myproc()->killed){
801038a9:	e8 82 02 00 00       	call   80103b30 <myproc>
801038ae:	8b 48 24             	mov    0x24(%eax),%ecx
801038b1:	85 c9                	test   %ecx,%ecx
801038b3:	74 cb                	je     80103880 <piperead+0x40>
      release(&p->lock);
801038b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038bd:	56                   	push   %esi
801038be:	e8 3d 10 00 00       	call   80104900 <release>
      return -1;
801038c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801038c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038c9:	89 d8                	mov    %ebx,%eax
801038cb:	5b                   	pop    %ebx
801038cc:	5e                   	pop    %esi
801038cd:	5f                   	pop    %edi
801038ce:	5d                   	pop    %ebp
801038cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801038d0:	8b 45 10             	mov    0x10(%ebp),%eax
801038d3:	85 c0                	test   %eax,%eax
801038d5:	7e 61                	jle    80103938 <piperead+0xf8>
    if(p->nread == p->nwrite)
801038d7:	31 db                	xor    %ebx,%ebx
801038d9:	eb 13                	jmp    801038ee <piperead+0xae>
801038db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038df:	90                   	nop
801038e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038ec:	74 1f                	je     8010390d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801038ee:	8d 41 01             	lea    0x1(%ecx),%eax
801038f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801038f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801038fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103902:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103905:	83 c3 01             	add    $0x1,%ebx
80103908:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010390b:	75 d3                	jne    801038e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010390d:	83 ec 0c             	sub    $0xc,%esp
80103910:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103916:	50                   	push   %eax
80103917:	e8 84 09 00 00       	call   801042a0 <wakeup>
  release(&p->lock);
8010391c:	89 34 24             	mov    %esi,(%esp)
8010391f:	e8 dc 0f 00 00       	call   80104900 <release>
  return i;
80103924:	83 c4 10             	add    $0x10,%esp
}
80103927:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010392a:	89 d8                	mov    %ebx,%eax
8010392c:	5b                   	pop    %ebx
8010392d:	5e                   	pop    %esi
8010392e:	5f                   	pop    %edi
8010392f:	5d                   	pop    %ebp
80103930:	c3                   	ret    
80103931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
80103938:	31 db                	xor    %ebx,%ebx
8010393a:	eb d1                	jmp    8010390d <piperead+0xcd>
8010393c:	66 90                	xchg   %ax,%ax
8010393e:	66 90                	xchg   %ax,%ax

80103940 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103944:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103949:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010394c:	68 20 2d 11 80       	push   $0x80112d20
80103951:	e8 8a 0e 00 00       	call   801047e0 <acquire>
80103956:	83 c4 10             	add    $0x10,%esp
80103959:	eb 14                	jmp    8010396f <allocproc+0x2f>
8010395b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010395f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103960:	83 eb 80             	sub    $0xffffff80,%ebx
80103963:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103969:	0f 84 81 00 00 00    	je     801039f0 <allocproc+0xb0>
    if(p->state == UNUSED)
8010396f:	8b 43 0c             	mov    0xc(%ebx),%eax
80103972:	85 c0                	test   %eax,%eax
80103974:	75 ea                	jne    80103960 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103976:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->priority = 10;     // default priority
  release(&ptable.lock);
8010397b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010397e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 10;     // default priority
80103985:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  p->pid = nextpid++;
8010398c:	89 43 10             	mov    %eax,0x10(%ebx)
8010398f:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103992:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
80103997:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
8010399d:	e8 5e 0f 00 00       	call   80104900 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039a2:	e8 49 ee ff ff       	call   801027f0 <kalloc>
801039a7:	83 c4 10             	add    $0x10,%esp
801039aa:	89 43 08             	mov    %eax,0x8(%ebx)
801039ad:	85 c0                	test   %eax,%eax
801039af:	74 58                	je     80103a09 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801039b1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801039b7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801039ba:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801039bf:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801039c2:	c7 40 14 6d 5b 10 80 	movl   $0x80105b6d,0x14(%eax)
  p->context = (struct context*)sp;
801039c9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801039cc:	6a 14                	push   $0x14
801039ce:	6a 00                	push   $0x0
801039d0:	50                   	push   %eax
801039d1:	e8 7a 0f 00 00       	call   80104950 <memset>
  p->context->eip = (uint)forkret;
801039d6:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801039d9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801039dc:	c7 40 10 20 3a 10 80 	movl   $0x80103a20,0x10(%eax)
}
801039e3:	89 d8                	mov    %ebx,%eax
801039e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039e8:	c9                   	leave  
801039e9:	c3                   	ret    
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801039f0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801039f3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801039f5:	68 20 2d 11 80       	push   $0x80112d20
801039fa:	e8 01 0f 00 00       	call   80104900 <release>
}
801039ff:	89 d8                	mov    %ebx,%eax
  return 0;
80103a01:	83 c4 10             	add    $0x10,%esp
}
80103a04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a07:	c9                   	leave  
80103a08:	c3                   	ret    
    p->state = UNUSED;
80103a09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a10:	31 db                	xor    %ebx,%ebx
}
80103a12:	89 d8                	mov    %ebx,%eax
80103a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a17:	c9                   	leave  
80103a18:	c3                   	ret    
80103a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a26:	68 20 2d 11 80       	push   $0x80112d20
80103a2b:	e8 d0 0e 00 00       	call   80104900 <release>

  if (first) {
80103a30:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a35:	83 c4 10             	add    $0x10,%esp
80103a38:	85 c0                	test   %eax,%eax
80103a3a:	75 04                	jne    80103a40 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a3c:	c9                   	leave  
80103a3d:	c3                   	ret    
80103a3e:	66 90                	xchg   %ax,%ax
    first = 0;
80103a40:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a47:	00 00 00 
    iinit(ROOTDEV);
80103a4a:	83 ec 0c             	sub    $0xc,%esp
80103a4d:	6a 01                	push   $0x1
80103a4f:	e8 dc da ff ff       	call   80101530 <iinit>
    initlog(ROOTDEV);
80103a54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103a5b:	e8 e0 f3 ff ff       	call   80102e40 <initlog>
80103a60:	83 c4 10             	add    $0x10,%esp
}
80103a63:	c9                   	leave  
80103a64:	c3                   	ret    
80103a65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a70 <pinit>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a76:	68 15 7a 10 80       	push   $0x80107a15
80103a7b:	68 20 2d 11 80       	push   $0x80112d20
80103a80:	e8 5b 0c 00 00       	call   801046e0 <initlock>
}
80103a85:	83 c4 10             	add    $0x10,%esp
80103a88:	c9                   	leave  
80103a89:	c3                   	ret    
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a90 <mycpu>:
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	56                   	push   %esi
80103a94:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a95:	9c                   	pushf  
80103a96:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a97:	f6 c4 02             	test   $0x2,%ah
80103a9a:	75 5d                	jne    80103af9 <mycpu+0x69>
  apicid = lapicid();
80103a9c:	e8 cf ef ff ff       	call   80102a70 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103aa1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103aa7:	85 f6                	test   %esi,%esi
80103aa9:	7e 41                	jle    80103aec <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103aab:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103ab2:	39 d0                	cmp    %edx,%eax
80103ab4:	74 2f                	je     80103ae5 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
80103ab6:	31 d2                	xor    %edx,%edx
80103ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103abf:	90                   	nop
80103ac0:	83 c2 01             	add    $0x1,%edx
80103ac3:	39 f2                	cmp    %esi,%edx
80103ac5:	74 25                	je     80103aec <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103ac7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103acd:	0f b6 99 80 27 11 80 	movzbl -0x7feed880(%ecx),%ebx
80103ad4:	39 c3                	cmp    %eax,%ebx
80103ad6:	75 e8                	jne    80103ac0 <mycpu+0x30>
80103ad8:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
80103ade:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae1:	5b                   	pop    %ebx
80103ae2:	5e                   	pop    %esi
80103ae3:	5d                   	pop    %ebp
80103ae4:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103ae5:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
80103aea:	eb f2                	jmp    80103ade <mycpu+0x4e>
  panic("unknown apicid\n");
80103aec:	83 ec 0c             	sub    $0xc,%esp
80103aef:	68 1c 7a 10 80       	push   $0x80107a1c
80103af4:	e8 97 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103af9:	83 ec 0c             	sub    $0xc,%esp
80103afc:	68 48 7b 10 80       	push   $0x80107b48
80103b01:	e8 8a c8 ff ff       	call   80100390 <panic>
80103b06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi

80103b10 <cpuid>:
cpuid() {
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b16:	e8 75 ff ff ff       	call   80103a90 <mycpu>
}
80103b1b:	c9                   	leave  
  return mycpu()-cpus;
80103b1c:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103b21:	c1 f8 04             	sar    $0x4,%eax
80103b24:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b2a:	c3                   	ret    
80103b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <myproc>:
myproc(void) {
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	53                   	push   %ebx
80103b34:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b37:	e8 54 0c 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103b3c:	e8 4f ff ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80103b41:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b47:	e8 54 0d 00 00       	call   801048a0 <popcli>
}
80103b4c:	83 c4 04             	add    $0x4,%esp
80103b4f:	89 d8                	mov    %ebx,%eax
80103b51:	5b                   	pop    %ebx
80103b52:	5d                   	pop    %ebp
80103b53:	c3                   	ret    
80103b54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <userinit>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	53                   	push   %ebx
80103b64:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b67:	e8 d4 fd ff ff       	call   80103940 <allocproc>
80103b6c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b6e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103b73:	e8 c8 35 00 00       	call   80107140 <setupkvm>
80103b78:	89 43 04             	mov    %eax,0x4(%ebx)
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	0f 84 bd 00 00 00    	je     80103c40 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b83:	83 ec 04             	sub    $0x4,%esp
80103b86:	68 2c 00 00 00       	push   $0x2c
80103b8b:	68 60 a4 10 80       	push   $0x8010a460
80103b90:	50                   	push   %eax
80103b91:	e8 8a 32 00 00       	call   80106e20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b96:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b99:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b9f:	6a 4c                	push   $0x4c
80103ba1:	6a 00                	push   $0x0
80103ba3:	ff 73 18             	pushl  0x18(%ebx)
80103ba6:	e8 a5 0d 00 00       	call   80104950 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bab:	8b 43 18             	mov    0x18(%ebx),%eax
80103bae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bb3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bb6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bbb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103bbf:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103bc6:	8b 43 18             	mov    0x18(%ebx),%eax
80103bc9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bcd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103bd1:	8b 43 18             	mov    0x18(%ebx),%eax
80103bd4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103bd8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103bdc:	8b 43 18             	mov    0x18(%ebx),%eax
80103bdf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103be6:	8b 43 18             	mov    0x18(%ebx),%eax
80103be9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103bf0:	8b 43 18             	mov    0x18(%ebx),%eax
80103bf3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103bfa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	68 45 7a 10 80       	push   $0x80107a45
80103c04:	50                   	push   %eax
80103c05:	e8 16 0f 00 00       	call   80104b20 <safestrcpy>
  p->cwd = namei("/");
80103c0a:	c7 04 24 4e 7a 10 80 	movl   $0x80107a4e,(%esp)
80103c11:	e8 ba e3 ff ff       	call   80101fd0 <namei>
80103c16:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c19:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c20:	e8 bb 0b 00 00       	call   801047e0 <acquire>
  p->state = RUNNABLE;
80103c25:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c2c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c33:	e8 c8 0c 00 00       	call   80104900 <release>
}
80103c38:	83 c4 10             	add    $0x10,%esp
80103c3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c3e:	c9                   	leave  
80103c3f:	c3                   	ret    
    panic("userinit: out of memory?");
80103c40:	83 ec 0c             	sub    $0xc,%esp
80103c43:	68 2c 7a 10 80       	push   $0x80107a2c
80103c48:	e8 43 c7 ff ff       	call   80100390 <panic>
80103c4d:	8d 76 00             	lea    0x0(%esi),%esi

80103c50 <growproc>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
80103c55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c58:	e8 33 0b 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103c5d:	e8 2e fe ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80103c62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c68:	e8 33 0c 00 00       	call   801048a0 <popcli>
  sz = curproc->sz;
80103c6d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c6f:	85 f6                	test   %esi,%esi
80103c71:	7f 1d                	jg     80103c90 <growproc+0x40>
  } else if(n < 0){
80103c73:	75 3b                	jne    80103cb0 <growproc+0x60>
  switchuvm(curproc);
80103c75:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c78:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c7a:	53                   	push   %ebx
80103c7b:	e8 90 30 00 00       	call   80106d10 <switchuvm>
  return 0;
80103c80:	83 c4 10             	add    $0x10,%esp
80103c83:	31 c0                	xor    %eax,%eax
}
80103c85:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c88:	5b                   	pop    %ebx
80103c89:	5e                   	pop    %esi
80103c8a:	5d                   	pop    %ebp
80103c8b:	c3                   	ret    
80103c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c90:	83 ec 04             	sub    $0x4,%esp
80103c93:	01 c6                	add    %eax,%esi
80103c95:	56                   	push   %esi
80103c96:	50                   	push   %eax
80103c97:	ff 73 04             	pushl  0x4(%ebx)
80103c9a:	e8 c1 32 00 00       	call   80106f60 <allocuvm>
80103c9f:	83 c4 10             	add    $0x10,%esp
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	75 cf                	jne    80103c75 <growproc+0x25>
      return -1;
80103ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103cab:	eb d8                	jmp    80103c85 <growproc+0x35>
80103cad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103cb0:	83 ec 04             	sub    $0x4,%esp
80103cb3:	01 c6                	add    %eax,%esi
80103cb5:	56                   	push   %esi
80103cb6:	50                   	push   %eax
80103cb7:	ff 73 04             	pushl  0x4(%ebx)
80103cba:	e8 d1 33 00 00       	call   80107090 <deallocuvm>
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	85 c0                	test   %eax,%eax
80103cc4:	75 af                	jne    80103c75 <growproc+0x25>
80103cc6:	eb de                	jmp    80103ca6 <growproc+0x56>
80103cc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ccf:	90                   	nop

80103cd0 <fork>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cd9:	e8 b2 0a 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103cde:	e8 ad fd ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80103ce3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ce9:	e8 b2 0b 00 00       	call   801048a0 <popcli>
  if((np = allocproc()) == 0){
80103cee:	e8 4d fc ff ff       	call   80103940 <allocproc>
80103cf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cf6:	85 c0                	test   %eax,%eax
80103cf8:	0f 84 b7 00 00 00    	je     80103db5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103cfe:	83 ec 08             	sub    $0x8,%esp
80103d01:	ff 33                	pushl  (%ebx)
80103d03:	89 c7                	mov    %eax,%edi
80103d05:	ff 73 04             	pushl  0x4(%ebx)
80103d08:	e8 03 35 00 00       	call   80107210 <copyuvm>
80103d0d:	83 c4 10             	add    $0x10,%esp
80103d10:	89 47 04             	mov    %eax,0x4(%edi)
80103d13:	85 c0                	test   %eax,%eax
80103d15:	0f 84 a1 00 00 00    	je     80103dbc <fork+0xec>
  np->sz = curproc->sz;
80103d1b:	8b 03                	mov    (%ebx),%eax
80103d1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d20:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103d22:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103d25:	89 c8                	mov    %ecx,%eax
80103d27:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103d2a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d2f:	8b 73 18             	mov    0x18(%ebx),%esi
80103d32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d34:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d36:	8b 40 18             	mov    0x18(%eax),%eax
80103d39:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d44:	85 c0                	test   %eax,%eax
80103d46:	74 13                	je     80103d5b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d48:	83 ec 0c             	sub    $0xc,%esp
80103d4b:	50                   	push   %eax
80103d4c:	e8 2f d1 ff ff       	call   80100e80 <filedup>
80103d51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d54:	83 c4 10             	add    $0x10,%esp
80103d57:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d5b:	83 c6 01             	add    $0x1,%esi
80103d5e:	83 fe 10             	cmp    $0x10,%esi
80103d61:	75 dd                	jne    80103d40 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103d63:	83 ec 0c             	sub    $0xc,%esp
80103d66:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d69:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d6c:	e8 8f d9 ff ff       	call   80101700 <idup>
80103d71:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d74:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d77:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d7a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d7d:	6a 10                	push   $0x10
80103d7f:	53                   	push   %ebx
80103d80:	50                   	push   %eax
80103d81:	e8 9a 0d 00 00       	call   80104b20 <safestrcpy>
  pid = np->pid;
80103d86:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d89:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d90:	e8 4b 0a 00 00       	call   801047e0 <acquire>
  np->state = RUNNABLE;
80103d95:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d9c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103da3:	e8 58 0b 00 00       	call   80104900 <release>
  return pid;
80103da8:	83 c4 10             	add    $0x10,%esp
}
80103dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dae:	89 d8                	mov    %ebx,%eax
80103db0:	5b                   	pop    %ebx
80103db1:	5e                   	pop    %esi
80103db2:	5f                   	pop    %edi
80103db3:	5d                   	pop    %ebp
80103db4:	c3                   	ret    
    return -1;
80103db5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dba:	eb ef                	jmp    80103dab <fork+0xdb>
    kfree(np->kstack);
80103dbc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103dbf:	83 ec 0c             	sub    $0xc,%esp
80103dc2:	ff 73 08             	pushl  0x8(%ebx)
80103dc5:	e8 66 e8 ff ff       	call   80102630 <kfree>
    np->kstack = 0;
80103dca:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103dd1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103dd4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ddb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103de0:	eb c9                	jmp    80103dab <fork+0xdb>
80103de2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103df0 <scheduler>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103df9:	e8 92 fc ff ff       	call   80103a90 <mycpu>
  c->proc = 0;
80103dfe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e05:	00 00 00 
  struct cpu *c = mycpu();
80103e08:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103e0a:	8d 70 04             	lea    0x4(%eax),%esi
80103e0d:	eb 1c                	jmp    80103e2b <scheduler+0x3b>
80103e0f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e10:	83 ef 80             	sub    $0xffffff80,%edi
80103e13:	81 ff 54 4d 11 80    	cmp    $0x80114d54,%edi
80103e19:	72 26                	jb     80103e41 <scheduler+0x51>
    release(&ptable.lock);
80103e1b:	83 ec 0c             	sub    $0xc,%esp
80103e1e:	68 20 2d 11 80       	push   $0x80112d20
80103e23:	e8 d8 0a 00 00       	call   80104900 <release>
  for(;;){
80103e28:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103e2b:	fb                   	sti    
    acquire(&ptable.lock);
80103e2c:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e2f:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
    acquire(&ptable.lock);
80103e34:	68 20 2d 11 80       	push   $0x80112d20
80103e39:	e8 a2 09 00 00       	call   801047e0 <acquire>
80103e3e:	83 c4 10             	add    $0x10,%esp
      if(p->state != RUNNABLE)
80103e41:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103e45:	75 c9                	jne    80103e10 <scheduler+0x20>
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103e47:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if(p1->state != RUNNABLE)
80103e50:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e54:	75 09                	jne    80103e5f <scheduler+0x6f>
        if ( highP->priority > p1->priority )   // larger value, lower priority 
80103e56:	8b 50 7c             	mov    0x7c(%eax),%edx
80103e59:	39 57 7c             	cmp    %edx,0x7c(%edi)
80103e5c:	0f 4f f8             	cmovg  %eax,%edi
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103e5f:	83 e8 80             	sub    $0xffffff80,%eax
80103e62:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103e67:	75 e7                	jne    80103e50 <scheduler+0x60>
      switchuvm(p);
80103e69:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e6c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103e72:	57                   	push   %edi
80103e73:	e8 98 2e 00 00       	call   80106d10 <switchuvm>
      p->state = RUNNING;
80103e78:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
80103e7f:	58                   	pop    %eax
80103e80:	5a                   	pop    %edx
80103e81:	ff 77 1c             	pushl  0x1c(%edi)
80103e84:	56                   	push   %esi
80103e85:	e8 f1 0c 00 00       	call   80104b7b <swtch>
      switchkvm();
80103e8a:	e8 71 2e 00 00       	call   80106d00 <switchkvm>
      c->proc = 0;
80103e8f:	83 c4 10             	add    $0x10,%esp
80103e92:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103e99:	00 00 00 
80103e9c:	e9 6f ff ff ff       	jmp    80103e10 <scheduler+0x20>
80103ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eaf:	90                   	nop

80103eb0 <sched>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	56                   	push   %esi
80103eb4:	53                   	push   %ebx
  pushcli();
80103eb5:	e8 d6 08 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103eba:	e8 d1 fb ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80103ebf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ec5:	e8 d6 09 00 00       	call   801048a0 <popcli>
  if(!holding(&ptable.lock))
80103eca:	83 ec 0c             	sub    $0xc,%esp
80103ecd:	68 20 2d 11 80       	push   $0x80112d20
80103ed2:	e8 79 08 00 00       	call   80104750 <holding>
80103ed7:	83 c4 10             	add    $0x10,%esp
80103eda:	85 c0                	test   %eax,%eax
80103edc:	74 4f                	je     80103f2d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103ede:	e8 ad fb ff ff       	call   80103a90 <mycpu>
80103ee3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eea:	75 68                	jne    80103f54 <sched+0xa4>
  if(p->state == RUNNING)
80103eec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ef0:	74 55                	je     80103f47 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ef2:	9c                   	pushf  
80103ef3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ef4:	f6 c4 02             	test   $0x2,%ah
80103ef7:	75 41                	jne    80103f3a <sched+0x8a>
  intena = mycpu()->intena;
80103ef9:	e8 92 fb ff ff       	call   80103a90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103efe:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f07:	e8 84 fb ff ff       	call   80103a90 <mycpu>
80103f0c:	83 ec 08             	sub    $0x8,%esp
80103f0f:	ff 70 04             	pushl  0x4(%eax)
80103f12:	53                   	push   %ebx
80103f13:	e8 63 0c 00 00       	call   80104b7b <swtch>
  mycpu()->intena = intena;
80103f18:	e8 73 fb ff ff       	call   80103a90 <mycpu>
}
80103f1d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f29:	5b                   	pop    %ebx
80103f2a:	5e                   	pop    %esi
80103f2b:	5d                   	pop    %ebp
80103f2c:	c3                   	ret    
    panic("sched ptable.lock");
80103f2d:	83 ec 0c             	sub    $0xc,%esp
80103f30:	68 50 7a 10 80       	push   $0x80107a50
80103f35:	e8 56 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f3a:	83 ec 0c             	sub    $0xc,%esp
80103f3d:	68 7c 7a 10 80       	push   $0x80107a7c
80103f42:	e8 49 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f47:	83 ec 0c             	sub    $0xc,%esp
80103f4a:	68 6e 7a 10 80       	push   $0x80107a6e
80103f4f:	e8 3c c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f54:	83 ec 0c             	sub    $0xc,%esp
80103f57:	68 62 7a 10 80       	push   $0x80107a62
80103f5c:	e8 2f c4 ff ff       	call   80100390 <panic>
80103f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6f:	90                   	nop

80103f70 <exit>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f79:	e8 12 08 00 00       	call   80104790 <pushcli>
  c = mycpu();
80103f7e:	e8 0d fb ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80103f83:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f89:	e8 12 09 00 00       	call   801048a0 <popcli>
  if(curproc == initproc)
80103f8e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f91:	8d 7e 68             	lea    0x68(%esi),%edi
80103f94:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103f9a:	0f 84 e7 00 00 00    	je     80104087 <exit+0x117>
    if(curproc->ofile[fd]){
80103fa0:	8b 03                	mov    (%ebx),%eax
80103fa2:	85 c0                	test   %eax,%eax
80103fa4:	74 12                	je     80103fb8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103fa6:	83 ec 0c             	sub    $0xc,%esp
80103fa9:	50                   	push   %eax
80103faa:	e8 21 cf ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
80103faf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103fb5:	83 c4 10             	add    $0x10,%esp
80103fb8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103fbb:	39 fb                	cmp    %edi,%ebx
80103fbd:	75 e1                	jne    80103fa0 <exit+0x30>
  begin_op();
80103fbf:	e8 1c ef ff ff       	call   80102ee0 <begin_op>
  iput(curproc->cwd);
80103fc4:	83 ec 0c             	sub    $0xc,%esp
80103fc7:	ff 76 68             	pushl  0x68(%esi)
80103fca:	e8 91 d8 ff ff       	call   80101860 <iput>
  end_op();
80103fcf:	e8 7c ef ff ff       	call   80102f50 <end_op>
  curproc->cwd = 0;
80103fd4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103fdb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fe2:	e8 f9 07 00 00       	call   801047e0 <acquire>
  wakeup1(curproc->parent);
80103fe7:	8b 56 14             	mov    0x14(%esi),%edx
80103fea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fed:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ff2:	eb 0e                	jmp    80104002 <exit+0x92>
80103ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff8:	83 e8 80             	sub    $0xffffff80,%eax
80103ffb:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104000:	74 1c                	je     8010401e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80104002:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104006:	75 f0                	jne    80103ff8 <exit+0x88>
80104008:	3b 50 20             	cmp    0x20(%eax),%edx
8010400b:	75 eb                	jne    80103ff8 <exit+0x88>
      p->state = RUNNABLE;
8010400d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104014:	83 e8 80             	sub    $0xffffff80,%eax
80104017:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
8010401c:	75 e4                	jne    80104002 <exit+0x92>
      p->parent = initproc;
8010401e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104024:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80104029:	eb 10                	jmp    8010403b <exit+0xcb>
8010402b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010402f:	90                   	nop
80104030:	83 ea 80             	sub    $0xffffff80,%edx
80104033:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80104039:	74 33                	je     8010406e <exit+0xfe>
    if(p->parent == curproc){
8010403b:	39 72 14             	cmp    %esi,0x14(%edx)
8010403e:	75 f0                	jne    80104030 <exit+0xc0>
      if(p->state == ZOMBIE)
80104040:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104044:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104047:	75 e7                	jne    80104030 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104049:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010404e:	eb 0a                	jmp    8010405a <exit+0xea>
80104050:	83 e8 80             	sub    $0xffffff80,%eax
80104053:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104058:	74 d6                	je     80104030 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010405a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010405e:	75 f0                	jne    80104050 <exit+0xe0>
80104060:	3b 48 20             	cmp    0x20(%eax),%ecx
80104063:	75 eb                	jne    80104050 <exit+0xe0>
      p->state = RUNNABLE;
80104065:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010406c:	eb e2                	jmp    80104050 <exit+0xe0>
  curproc->state = ZOMBIE;
8010406e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104075:	e8 36 fe ff ff       	call   80103eb0 <sched>
  panic("zombie exit");
8010407a:	83 ec 0c             	sub    $0xc,%esp
8010407d:	68 9d 7a 10 80       	push   $0x80107a9d
80104082:	e8 09 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104087:	83 ec 0c             	sub    $0xc,%esp
8010408a:	68 90 7a 10 80       	push   $0x80107a90
8010408f:	e8 fc c2 ff ff       	call   80100390 <panic>
80104094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010409b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010409f:	90                   	nop

801040a0 <yield>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040a7:	68 20 2d 11 80       	push   $0x80112d20
801040ac:	e8 2f 07 00 00       	call   801047e0 <acquire>
  pushcli();
801040b1:	e8 da 06 00 00       	call   80104790 <pushcli>
  c = mycpu();
801040b6:	e8 d5 f9 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
801040bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040c1:	e8 da 07 00 00       	call   801048a0 <popcli>
  myproc()->state = RUNNABLE;
801040c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040cd:	e8 de fd ff ff       	call   80103eb0 <sched>
  release(&ptable.lock);
801040d2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040d9:	e8 22 08 00 00       	call   80104900 <release>
}
801040de:	83 c4 10             	add    $0x10,%esp
801040e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e4:	c9                   	leave  
801040e5:	c3                   	ret    
801040e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040ed:	8d 76 00             	lea    0x0(%esi),%esi

801040f0 <sleep>:
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	57                   	push   %edi
801040f4:	56                   	push   %esi
801040f5:	53                   	push   %ebx
801040f6:	83 ec 0c             	sub    $0xc,%esp
801040f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801040fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040ff:	e8 8c 06 00 00       	call   80104790 <pushcli>
  c = mycpu();
80104104:	e8 87 f9 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
80104109:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010410f:	e8 8c 07 00 00       	call   801048a0 <popcli>
  if(p == 0)
80104114:	85 db                	test   %ebx,%ebx
80104116:	0f 84 87 00 00 00    	je     801041a3 <sleep+0xb3>
  if(lk == 0)
8010411c:	85 f6                	test   %esi,%esi
8010411e:	74 76                	je     80104196 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104120:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104126:	74 50                	je     80104178 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104128:	83 ec 0c             	sub    $0xc,%esp
8010412b:	68 20 2d 11 80       	push   $0x80112d20
80104130:	e8 ab 06 00 00       	call   801047e0 <acquire>
    release(lk);
80104135:	89 34 24             	mov    %esi,(%esp)
80104138:	e8 c3 07 00 00       	call   80104900 <release>
  p->chan = chan;
8010413d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104140:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104147:	e8 64 fd ff ff       	call   80103eb0 <sched>
  p->chan = 0;
8010414c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104153:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010415a:	e8 a1 07 00 00       	call   80104900 <release>
    acquire(lk);
8010415f:	89 75 08             	mov    %esi,0x8(%ebp)
80104162:	83 c4 10             	add    $0x10,%esp
}
80104165:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104168:	5b                   	pop    %ebx
80104169:	5e                   	pop    %esi
8010416a:	5f                   	pop    %edi
8010416b:	5d                   	pop    %ebp
    acquire(lk);
8010416c:	e9 6f 06 00 00       	jmp    801047e0 <acquire>
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104178:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010417b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104182:	e8 29 fd ff ff       	call   80103eb0 <sched>
  p->chan = 0;
80104187:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010418e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104191:	5b                   	pop    %ebx
80104192:	5e                   	pop    %esi
80104193:	5f                   	pop    %edi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret    
    panic("sleep without lk");
80104196:	83 ec 0c             	sub    $0xc,%esp
80104199:	68 af 7a 10 80       	push   $0x80107aaf
8010419e:	e8 ed c1 ff ff       	call   80100390 <panic>
    panic("sleep");
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 a9 7a 10 80       	push   $0x80107aa9
801041ab:	e8 e0 c1 ff ff       	call   80100390 <panic>

801041b0 <wait>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
  pushcli();
801041b5:	e8 d6 05 00 00       	call   80104790 <pushcli>
  c = mycpu();
801041ba:	e8 d1 f8 ff ff       	call   80103a90 <mycpu>
  p = c->proc;
801041bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041c5:	e8 d6 06 00 00       	call   801048a0 <popcli>
  acquire(&ptable.lock);
801041ca:	83 ec 0c             	sub    $0xc,%esp
801041cd:	68 20 2d 11 80       	push   $0x80112d20
801041d2:	e8 09 06 00 00       	call   801047e0 <acquire>
801041d7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041da:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041dc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801041e1:	eb 10                	jmp    801041f3 <wait+0x43>
801041e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e7:	90                   	nop
801041e8:	83 eb 80             	sub    $0xffffff80,%ebx
801041eb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801041f1:	74 1b                	je     8010420e <wait+0x5e>
      if(p->parent != curproc)
801041f3:	39 73 14             	cmp    %esi,0x14(%ebx)
801041f6:	75 f0                	jne    801041e8 <wait+0x38>
      if(p->state == ZOMBIE){
801041f8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041fc:	74 32                	je     80104230 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041fe:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104201:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104206:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
8010420c:	75 e5                	jne    801041f3 <wait+0x43>
    if(!havekids || curproc->killed){
8010420e:	85 c0                	test   %eax,%eax
80104210:	74 74                	je     80104286 <wait+0xd6>
80104212:	8b 46 24             	mov    0x24(%esi),%eax
80104215:	85 c0                	test   %eax,%eax
80104217:	75 6d                	jne    80104286 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104219:	83 ec 08             	sub    $0x8,%esp
8010421c:	68 20 2d 11 80       	push   $0x80112d20
80104221:	56                   	push   %esi
80104222:	e8 c9 fe ff ff       	call   801040f0 <sleep>
    havekids = 0;
80104227:	83 c4 10             	add    $0x10,%esp
8010422a:	eb ae                	jmp    801041da <wait+0x2a>
8010422c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104236:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104239:	e8 f2 e3 ff ff       	call   80102630 <kfree>
        freevm(p->pgdir);
8010423e:	5a                   	pop    %edx
8010423f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104242:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104249:	e8 72 2e 00 00       	call   801070c0 <freevm>
        release(&ptable.lock);
8010424e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104255:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010425c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104263:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104267:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010426e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104275:	e8 86 06 00 00       	call   80104900 <release>
        return pid;
8010427a:	83 c4 10             	add    $0x10,%esp
}
8010427d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104280:	89 f0                	mov    %esi,%eax
80104282:	5b                   	pop    %ebx
80104283:	5e                   	pop    %esi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret    
      release(&ptable.lock);
80104286:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104289:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010428e:	68 20 2d 11 80       	push   $0x80112d20
80104293:	e8 68 06 00 00       	call   80104900 <release>
      return -1;
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	eb e0                	jmp    8010427d <wait+0xcd>
8010429d:	8d 76 00             	lea    0x0(%esi),%esi

801042a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042aa:	68 20 2d 11 80       	push   $0x80112d20
801042af:	e8 2c 05 00 00       	call   801047e0 <acquire>
801042b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801042bc:	eb 0c                	jmp    801042ca <wakeup+0x2a>
801042be:	66 90                	xchg   %ax,%ax
801042c0:	83 e8 80             	sub    $0xffffff80,%eax
801042c3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801042c8:	74 1c                	je     801042e6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801042ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042ce:	75 f0                	jne    801042c0 <wakeup+0x20>
801042d0:	3b 58 20             	cmp    0x20(%eax),%ebx
801042d3:	75 eb                	jne    801042c0 <wakeup+0x20>
      p->state = RUNNABLE;
801042d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042dc:	83 e8 80             	sub    $0xffffff80,%eax
801042df:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
801042e4:	75 e4                	jne    801042ca <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801042e6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801042ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f0:	c9                   	leave  
  release(&ptable.lock);
801042f1:	e9 0a 06 00 00       	jmp    80104900 <release>
801042f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fd:	8d 76 00             	lea    0x0(%esi),%esi

80104300 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 10             	sub    $0x10,%esp
80104307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010430a:	68 20 2d 11 80       	push   $0x80112d20
8010430f:	e8 cc 04 00 00       	call   801047e0 <acquire>
80104314:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104317:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010431c:	eb 0c                	jmp    8010432a <kill+0x2a>
8010431e:	66 90                	xchg   %ax,%ax
80104320:	83 e8 80             	sub    $0xffffff80,%eax
80104323:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104328:	74 36                	je     80104360 <kill+0x60>
    if(p->pid == pid){
8010432a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010432d:	75 f1                	jne    80104320 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010432f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104333:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010433a:	75 07                	jne    80104343 <kill+0x43>
        p->state = RUNNABLE;
8010433c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104343:	83 ec 0c             	sub    $0xc,%esp
80104346:	68 20 2d 11 80       	push   $0x80112d20
8010434b:	e8 b0 05 00 00       	call   80104900 <release>
      return 0;
80104350:	83 c4 10             	add    $0x10,%esp
80104353:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104358:	c9                   	leave  
80104359:	c3                   	ret    
8010435a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104360:	83 ec 0c             	sub    $0xc,%esp
80104363:	68 20 2d 11 80       	push   $0x80112d20
80104368:	e8 93 05 00 00       	call   80104900 <release>
  return -1;
8010436d:	83 c4 10             	add    $0x10,%esp
80104370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104375:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104378:	c9                   	leave  
80104379:	c3                   	ret    
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104380 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	56                   	push   %esi
80104385:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104388:	53                   	push   %ebx
80104389:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010438e:	83 ec 3c             	sub    $0x3c,%esp
80104391:	eb 24                	jmp    801043b7 <procdump+0x37>
80104393:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104397:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104398:	83 ec 0c             	sub    $0xc,%esp
8010439b:	68 c7 7e 10 80       	push   $0x80107ec7
801043a0:	e8 0b c3 ff ff       	call   801006b0 <cprintf>
801043a5:	83 c4 10             	add    $0x10,%esp
801043a8:	83 eb 80             	sub    $0xffffff80,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ab:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
801043b1:	0f 84 81 00 00 00    	je     80104438 <procdump+0xb8>
    if(p->state == UNUSED)
801043b7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043ba:	85 c0                	test   %eax,%eax
801043bc:	74 ea                	je     801043a8 <procdump+0x28>
      state = "???";
801043be:	ba c0 7a 10 80       	mov    $0x80107ac0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043c3:	83 f8 05             	cmp    $0x5,%eax
801043c6:	77 11                	ja     801043d9 <procdump+0x59>
801043c8:	8b 14 85 b0 7b 10 80 	mov    -0x7fef8450(,%eax,4),%edx
      state = "???";
801043cf:	b8 c0 7a 10 80       	mov    $0x80107ac0,%eax
801043d4:	85 d2                	test   %edx,%edx
801043d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801043d9:	53                   	push   %ebx
801043da:	52                   	push   %edx
801043db:	ff 73 a4             	pushl  -0x5c(%ebx)
801043de:	68 c4 7a 10 80       	push   $0x80107ac4
801043e3:	e8 c8 c2 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801043e8:	83 c4 10             	add    $0x10,%esp
801043eb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801043ef:	75 a7                	jne    80104398 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043f1:	83 ec 08             	sub    $0x8,%esp
801043f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043f7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801043fa:	50                   	push   %eax
801043fb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801043fe:	8b 40 0c             	mov    0xc(%eax),%eax
80104401:	83 c0 08             	add    $0x8,%eax
80104404:	50                   	push   %eax
80104405:	e8 f6 02 00 00       	call   80104700 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010440a:	83 c4 10             	add    $0x10,%esp
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
80104410:	8b 17                	mov    (%edi),%edx
80104412:	85 d2                	test   %edx,%edx
80104414:	74 82                	je     80104398 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104416:	83 ec 08             	sub    $0x8,%esp
80104419:	83 c7 04             	add    $0x4,%edi
8010441c:	52                   	push   %edx
8010441d:	68 01 74 10 80       	push   $0x80107401
80104422:	e8 89 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104427:	83 c4 10             	add    $0x10,%esp
8010442a:	39 fe                	cmp    %edi,%esi
8010442c:	75 e2                	jne    80104410 <procdump+0x90>
8010442e:	e9 65 ff ff ff       	jmp    80104398 <procdump+0x18>
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
  }
}
80104438:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010443b:	5b                   	pop    %ebx
8010443c:	5e                   	pop    %esi
8010443d:	5f                   	pop    %edi
8010443e:	5d                   	pop    %ebp
8010443f:	c3                   	ret    

80104440 <cps>:

//current process status
int
cps()
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	53                   	push   %ebx
80104444:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
80104447:	fb                   	sti    

  // Enable interrupts on this processor.
  sti();

  // Loop over process table looking for process with pid.
  acquire(&ptable.lock);
80104448:	68 20 2d 11 80       	push   $0x80112d20
  cprintf("name \t pid \t state \t priority \n");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010444d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  acquire(&ptable.lock);
80104452:	e8 89 03 00 00       	call   801047e0 <acquire>
  cprintf("name \t pid \t state \t priority \n");
80104457:	c7 04 24 70 7b 10 80 	movl   $0x80107b70,(%esp)
8010445e:	e8 4d c2 ff ff       	call   801006b0 <cprintf>
80104463:	83 c4 10             	add    $0x10,%esp
80104466:	eb 1d                	jmp    80104485 <cps+0x45>
80104468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446f:	90                   	nop
      if ( p->state == SLEEPING ){
        cprintf("%s \t %d  \t SLEEPING \t %d\n ", p->name, p->pid, p->priority );
      }
      else if ( p->state == RUNNING ){
80104470:	83 f8 04             	cmp    $0x4,%eax
80104473:	74 5b                	je     801044d0 <cps+0x90>
       cprintf("%s \t %d  \t RUNNING \t %d\n ", p->name, p->pid, p->priority );
      }
      else if (p->state == RUNNABLE){
80104475:	83 f8 03             	cmp    $0x3,%eax
80104478:	74 76                	je     801044f0 <cps+0xb0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010447a:	83 eb 80             	sub    $0xffffff80,%ebx
8010447d:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80104483:	74 2a                	je     801044af <cps+0x6f>
      if ( p->state == SLEEPING ){
80104485:	8b 43 0c             	mov    0xc(%ebx),%eax
80104488:	83 f8 02             	cmp    $0x2,%eax
8010448b:	75 e3                	jne    80104470 <cps+0x30>
        cprintf("%s \t %d  \t SLEEPING \t %d\n ", p->name, p->pid, p->priority );
8010448d:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104490:	ff 73 7c             	pushl  0x7c(%ebx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104493:	83 eb 80             	sub    $0xffffff80,%ebx
        cprintf("%s \t %d  \t SLEEPING \t %d\n ", p->name, p->pid, p->priority );
80104496:	ff 73 90             	pushl  -0x70(%ebx)
80104499:	50                   	push   %eax
8010449a:	68 cd 7a 10 80       	push   $0x80107acd
8010449f:	e8 0c c2 ff ff       	call   801006b0 <cprintf>
801044a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044a7:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801044ad:	75 d6                	jne    80104485 <cps+0x45>
       cprintf("%s \t %d  \t RUNNABLE \t %d\n ", p->name, p->pid, p->priority );
      }
  }

  release(&ptable.lock);
801044af:	83 ec 0c             	sub    $0xc,%esp
801044b2:	68 20 2d 11 80       	push   $0x80112d20
801044b7:	e8 44 04 00 00       	call   80104900 <release>

  return 22;
}
801044bc:	b8 16 00 00 00       	mov    $0x16,%eax
801044c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c4:	c9                   	leave  
801044c5:	c3                   	ret    
801044c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
       cprintf("%s \t %d  \t RUNNING \t %d\n ", p->name, p->pid, p->priority );
801044d0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044d3:	ff 73 7c             	pushl  0x7c(%ebx)
801044d6:	ff 73 10             	pushl  0x10(%ebx)
801044d9:	50                   	push   %eax
801044da:	68 e8 7a 10 80       	push   $0x80107ae8
801044df:	e8 cc c1 ff ff       	call   801006b0 <cprintf>
801044e4:	83 c4 10             	add    $0x10,%esp
801044e7:	eb 91                	jmp    8010447a <cps+0x3a>
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
       cprintf("%s \t %d  \t RUNNABLE \t %d\n ", p->name, p->pid, p->priority );
801044f0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044f3:	ff 73 7c             	pushl  0x7c(%ebx)
801044f6:	ff 73 10             	pushl  0x10(%ebx)
801044f9:	50                   	push   %eax
801044fa:	68 02 7b 10 80       	push   $0x80107b02
801044ff:	e8 ac c1 ff ff       	call   801006b0 <cprintf>
80104504:	83 c4 10             	add    $0x10,%esp
80104507:	e9 6e ff ff ff       	jmp    8010447a <cps+0x3a>
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104510 <nps>:

int
nps()
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	83 ec 14             	sub    $0x14,%esp
80104516:	fb                   	sti    
  // Enable interrupts on this processor.
  sti();

  int i = 0;

  acquire(&ptable.lock);
80104517:	68 20 2d 11 80       	push   $0x80112d20
8010451c:	e8 bf 02 00 00       	call   801047e0 <acquire>
80104521:	83 c4 10             	add    $0x10,%esp
  int i = 0;
80104524:	31 c9                	xor    %ecx,%ecx
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104526:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010452b:	eb 18                	jmp    80104545 <nps+0x35>
8010452d:	8d 76 00             	lea    0x0(%esi),%esi
      if ( p->state == SLEEPING )
        i = i + 1;
      else if ( p->state == RUNNING )
        i = i + 1;
80104530:	83 fa 04             	cmp    $0x4,%edx
80104533:	0f 94 c2             	sete   %dl
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104536:	83 e8 80             	sub    $0xffffff80,%eax
        i = i + 1;
80104539:	0f b6 d2             	movzbl %dl,%edx
8010453c:	01 d1                	add    %edx,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010453e:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104543:	74 15                	je     8010455a <nps+0x4a>
      if ( p->state == SLEEPING )
80104545:	8b 50 0c             	mov    0xc(%eax),%edx
80104548:	83 fa 02             	cmp    $0x2,%edx
8010454b:	75 e3                	jne    80104530 <nps+0x20>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010454d:	83 e8 80             	sub    $0xffffff80,%eax
        i = i + 1;
80104550:	83 c1 01             	add    $0x1,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104553:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104558:	75 eb                	jne    80104545 <nps+0x35>
  }

  cprintf("Total number of processes: %d \n", i);
8010455a:	83 ec 08             	sub    $0x8,%esp
8010455d:	51                   	push   %ecx
8010455e:	68 90 7b 10 80       	push   $0x80107b90
80104563:	e8 48 c1 ff ff       	call   801006b0 <cprintf>

  release(&ptable.lock);
80104568:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010456f:	e8 8c 03 00 00       	call   80104900 <release>
  
  return 23;
}
80104574:	b8 17 00 00 00       	mov    $0x17,%eax
80104579:	c9                   	leave  
8010457a:	c3                   	ret    
8010457b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010457f:	90                   	nop

80104580 <chpr>:

//change priority
int
chpr( int pid, int priority )
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 10             	sub    $0x10,%esp
80104587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010458a:	68 20 2d 11 80       	push   $0x80112d20
8010458f:	e8 4c 02 00 00       	call   801047e0 <acquire>
80104594:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104597:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010459c:	eb 0d                	jmp    801045ab <chpr+0x2b>
8010459e:	66 90                	xchg   %ax,%ax
801045a0:	83 ea 80             	sub    $0xffffff80,%edx
801045a3:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
801045a9:	74 0b                	je     801045b6 <chpr+0x36>
    if(p->pid == pid ) {
801045ab:	39 5a 10             	cmp    %ebx,0x10(%edx)
801045ae:	75 f0                	jne    801045a0 <chpr+0x20>
        p->priority = priority;
801045b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801045b3:	89 42 7c             	mov    %eax,0x7c(%edx)
        break;
    }
  }
  release(&ptable.lock);
801045b6:	83 ec 0c             	sub    $0xc,%esp
801045b9:	68 20 2d 11 80       	push   $0x80112d20
801045be:	e8 3d 03 00 00       	call   80104900 <release>

  return pid;
}
801045c3:	89 d8                	mov    %ebx,%eax
801045c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045c8:	c9                   	leave  
801045c9:	c3                   	ret    
801045ca:	66 90                	xchg   %ax,%ax
801045cc:	66 90                	xchg   %ax,%ax
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 0c             	sub    $0xc,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801045da:	68 c8 7b 10 80       	push   $0x80107bc8
801045df:	8d 43 04             	lea    0x4(%ebx),%eax
801045e2:	50                   	push   %eax
801045e3:	e8 f8 00 00 00       	call   801046e0 <initlock>
  lk->name = name;
801045e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801045eb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045f1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045f4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045fb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104601:	c9                   	leave  
80104602:	c3                   	ret    
80104603:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104610 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104618:	8d 73 04             	lea    0x4(%ebx),%esi
8010461b:	83 ec 0c             	sub    $0xc,%esp
8010461e:	56                   	push   %esi
8010461f:	e8 bc 01 00 00       	call   801047e0 <acquire>
  while (lk->locked) {
80104624:	8b 13                	mov    (%ebx),%edx
80104626:	83 c4 10             	add    $0x10,%esp
80104629:	85 d2                	test   %edx,%edx
8010462b:	74 16                	je     80104643 <acquiresleep+0x33>
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104630:	83 ec 08             	sub    $0x8,%esp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	e8 b6 fa ff ff       	call   801040f0 <sleep>
  while (lk->locked) {
8010463a:	8b 03                	mov    (%ebx),%eax
8010463c:	83 c4 10             	add    $0x10,%esp
8010463f:	85 c0                	test   %eax,%eax
80104641:	75 ed                	jne    80104630 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104643:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104649:	e8 e2 f4 ff ff       	call   80103b30 <myproc>
8010464e:	8b 40 10             	mov    0x10(%eax),%eax
80104651:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104654:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104657:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010465a:	5b                   	pop    %ebx
8010465b:	5e                   	pop    %esi
8010465c:	5d                   	pop    %ebp
  release(&lk->lk);
8010465d:	e9 9e 02 00 00       	jmp    80104900 <release>
80104662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104670 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104678:	8d 73 04             	lea    0x4(%ebx),%esi
8010467b:	83 ec 0c             	sub    $0xc,%esp
8010467e:	56                   	push   %esi
8010467f:	e8 5c 01 00 00       	call   801047e0 <acquire>
  lk->locked = 0;
80104684:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010468a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104691:	89 1c 24             	mov    %ebx,(%esp)
80104694:	e8 07 fc ff ff       	call   801042a0 <wakeup>
  release(&lk->lk);
80104699:	89 75 08             	mov    %esi,0x8(%ebp)
8010469c:	83 c4 10             	add    $0x10,%esp
}
8010469f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046a2:	5b                   	pop    %ebx
801046a3:	5e                   	pop    %esi
801046a4:	5d                   	pop    %ebp
  release(&lk->lk);
801046a5:	e9 56 02 00 00       	jmp    80104900 <release>
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801046b8:	8d 5e 04             	lea    0x4(%esi),%ebx
801046bb:	83 ec 0c             	sub    $0xc,%esp
801046be:	53                   	push   %ebx
801046bf:	e8 1c 01 00 00       	call   801047e0 <acquire>
  r = lk->locked;
801046c4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801046c6:	89 1c 24             	mov    %ebx,(%esp)
801046c9:	e8 32 02 00 00       	call   80104900 <release>
  return r;
}
801046ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046d1:	89 f0                	mov    %esi,%eax
801046d3:	5b                   	pop    %ebx
801046d4:	5e                   	pop    %esi
801046d5:	5d                   	pop    %ebp
801046d6:	c3                   	ret    
801046d7:	66 90                	xchg   %ax,%ax
801046d9:	66 90                	xchg   %ax,%ax
801046db:	66 90                	xchg   %ax,%ax
801046dd:	66 90                	xchg   %ax,%ax
801046df:	90                   	nop

801046e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046f9:	5d                   	pop    %ebp
801046fa:	c3                   	ret    
801046fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046ff:	90                   	nop

80104700 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104700:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104701:	31 d2                	xor    %edx,%edx
{
80104703:	89 e5                	mov    %esp,%ebp
80104705:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104706:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104709:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010470c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010470f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104710:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104716:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010471c:	77 1a                	ja     80104738 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010471e:	8b 58 04             	mov    0x4(%eax),%ebx
80104721:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104724:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104727:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104729:	83 fa 0a             	cmp    $0xa,%edx
8010472c:	75 e2                	jne    80104710 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010472e:	5b                   	pop    %ebx
8010472f:	5d                   	pop    %ebp
80104730:	c3                   	ret    
80104731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104738:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010473b:	8d 51 28             	lea    0x28(%ecx),%edx
8010473e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104746:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104749:	39 c2                	cmp    %eax,%edx
8010474b:	75 f3                	jne    80104740 <getcallerpcs+0x40>
}
8010474d:	5b                   	pop    %ebx
8010474e:	5d                   	pop    %ebp
8010474f:	c3                   	ret    

80104750 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 04             	sub    $0x4,%esp
80104757:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010475a:	8b 02                	mov    (%edx),%eax
8010475c:	85 c0                	test   %eax,%eax
8010475e:	75 10                	jne    80104770 <holding+0x20>
}
80104760:	83 c4 04             	add    $0x4,%esp
80104763:	31 c0                	xor    %eax,%eax
80104765:	5b                   	pop    %ebx
80104766:	5d                   	pop    %ebp
80104767:	c3                   	ret    
80104768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104770:	8b 5a 08             	mov    0x8(%edx),%ebx
80104773:	e8 18 f3 ff ff       	call   80103a90 <mycpu>
80104778:	39 c3                	cmp    %eax,%ebx
8010477a:	0f 94 c0             	sete   %al
}
8010477d:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104780:	0f b6 c0             	movzbl %al,%eax
}
80104783:	5b                   	pop    %ebx
80104784:	5d                   	pop    %ebp
80104785:	c3                   	ret    
80104786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010478d:	8d 76 00             	lea    0x0(%esi),%esi

80104790 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104797:	9c                   	pushf  
80104798:	5b                   	pop    %ebx
  asm volatile("cli");
80104799:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010479a:	e8 f1 f2 ff ff       	call   80103a90 <mycpu>
8010479f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047a5:	85 c0                	test   %eax,%eax
801047a7:	74 17                	je     801047c0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801047a9:	e8 e2 f2 ff ff       	call   80103a90 <mycpu>
801047ae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047b5:	83 c4 04             	add    $0x4,%esp
801047b8:	5b                   	pop    %ebx
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret    
801047bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047bf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801047c0:	e8 cb f2 ff ff       	call   80103a90 <mycpu>
801047c5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047cb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801047d1:	eb d6                	jmp    801047a9 <pushcli+0x19>
801047d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047e0 <acquire>:
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801047e5:	e8 a6 ff ff ff       	call   80104790 <pushcli>
  if(holding(lk))
801047ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
801047ed:	8b 03                	mov    (%ebx),%eax
801047ef:	85 c0                	test   %eax,%eax
801047f1:	0f 85 81 00 00 00    	jne    80104878 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
801047f7:	ba 01 00 00 00       	mov    $0x1,%edx
801047fc:	eb 05                	jmp    80104803 <acquire+0x23>
801047fe:	66 90                	xchg   %ax,%ax
80104800:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104803:	89 d0                	mov    %edx,%eax
80104805:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104808:	85 c0                	test   %eax,%eax
8010480a:	75 f4                	jne    80104800 <acquire+0x20>
  __sync_synchronize();
8010480c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104811:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104814:	e8 77 f2 ff ff       	call   80103a90 <mycpu>
  ebp = (uint*)v - 2;
80104819:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
8010481b:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
8010481e:	31 c0                	xor    %eax,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104820:	8d 8a 00 00 00 80    	lea    -0x80000000(%edx),%ecx
80104826:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
8010482c:	77 22                	ja     80104850 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
8010482e:	8b 4a 04             	mov    0x4(%edx),%ecx
80104831:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
  for(i = 0; i < 10; i++){
80104835:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104838:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010483a:	83 f8 0a             	cmp    $0xa,%eax
8010483d:	75 e1                	jne    80104820 <acquire+0x40>
}
8010483f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104842:	5b                   	pop    %ebx
80104843:	5e                   	pop    %esi
80104844:	5d                   	pop    %ebp
80104845:	c3                   	ret    
80104846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484d:	8d 76 00             	lea    0x0(%esi),%esi
80104850:	8d 44 83 0c          	lea    0xc(%ebx,%eax,4),%eax
80104854:	83 c3 34             	add    $0x34,%ebx
80104857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104860:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104866:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104869:	39 c3                	cmp    %eax,%ebx
8010486b:	75 f3                	jne    80104860 <acquire+0x80>
}
8010486d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104870:	5b                   	pop    %ebx
80104871:	5e                   	pop    %esi
80104872:	5d                   	pop    %ebp
80104873:	c3                   	ret    
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
80104878:	8b 73 08             	mov    0x8(%ebx),%esi
8010487b:	e8 10 f2 ff ff       	call   80103a90 <mycpu>
80104880:	39 c6                	cmp    %eax,%esi
80104882:	0f 85 6f ff ff ff    	jne    801047f7 <acquire+0x17>
    panic("acquire");
80104888:	83 ec 0c             	sub    $0xc,%esp
8010488b:	68 d3 7b 10 80       	push   $0x80107bd3
80104890:	e8 fb ba ff ff       	call   80100390 <panic>
80104895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <popcli>:

void
popcli(void)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048a6:	9c                   	pushf  
801048a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048a8:	f6 c4 02             	test   $0x2,%ah
801048ab:	75 35                	jne    801048e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048ad:	e8 de f1 ff ff       	call   80103a90 <mycpu>
801048b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801048b9:	78 34                	js     801048ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048bb:	e8 d0 f1 ff ff       	call   80103a90 <mycpu>
801048c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048c6:	85 d2                	test   %edx,%edx
801048c8:	74 06                	je     801048d0 <popcli+0x30>
    sti();
}
801048ca:	c9                   	leave  
801048cb:	c3                   	ret    
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048d0:	e8 bb f1 ff ff       	call   80103a90 <mycpu>
801048d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801048db:	85 c0                	test   %eax,%eax
801048dd:	74 eb                	je     801048ca <popcli+0x2a>
  asm volatile("sti");
801048df:	fb                   	sti    
}
801048e0:	c9                   	leave  
801048e1:	c3                   	ret    
    panic("popcli - interruptible");
801048e2:	83 ec 0c             	sub    $0xc,%esp
801048e5:	68 db 7b 10 80       	push   $0x80107bdb
801048ea:	e8 a1 ba ff ff       	call   80100390 <panic>
    panic("popcli");
801048ef:	83 ec 0c             	sub    $0xc,%esp
801048f2:	68 f2 7b 10 80       	push   $0x80107bf2
801048f7:	e8 94 ba ff ff       	call   80100390 <panic>
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104900 <release>:
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104908:	8b 03                	mov    (%ebx),%eax
8010490a:	85 c0                	test   %eax,%eax
8010490c:	75 12                	jne    80104920 <release+0x20>
    panic("release");
8010490e:	83 ec 0c             	sub    $0xc,%esp
80104911:	68 f9 7b 10 80       	push   $0x80107bf9
80104916:	e8 75 ba ff ff       	call   80100390 <panic>
8010491b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010491f:	90                   	nop
  return lock->locked && lock->cpu == mycpu();
80104920:	8b 73 08             	mov    0x8(%ebx),%esi
80104923:	e8 68 f1 ff ff       	call   80103a90 <mycpu>
80104928:	39 c6                	cmp    %eax,%esi
8010492a:	75 e2                	jne    8010490e <release+0xe>
  lk->pcs[0] = 0;
8010492c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104933:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010493a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010493f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104945:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104948:	5b                   	pop    %ebx
80104949:	5e                   	pop    %esi
8010494a:	5d                   	pop    %ebp
  popcli();
8010494b:	e9 50 ff ff ff       	jmp    801048a0 <popcli>

80104950 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	8b 55 08             	mov    0x8(%ebp),%edx
80104957:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010495a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010495b:	89 d0                	mov    %edx,%eax
8010495d:	09 c8                	or     %ecx,%eax
8010495f:	a8 03                	test   $0x3,%al
80104961:	75 2d                	jne    80104990 <memset+0x40>
    c &= 0xFF;
80104963:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104967:	c1 e9 02             	shr    $0x2,%ecx
8010496a:	89 f8                	mov    %edi,%eax
8010496c:	89 fb                	mov    %edi,%ebx
8010496e:	c1 e0 18             	shl    $0x18,%eax
80104971:	c1 e3 10             	shl    $0x10,%ebx
80104974:	09 d8                	or     %ebx,%eax
80104976:	09 f8                	or     %edi,%eax
80104978:	c1 e7 08             	shl    $0x8,%edi
8010497b:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010497d:	89 d7                	mov    %edx,%edi
8010497f:	fc                   	cld    
80104980:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104982:	5b                   	pop    %ebx
80104983:	89 d0                	mov    %edx,%eax
80104985:	5f                   	pop    %edi
80104986:	5d                   	pop    %ebp
80104987:	c3                   	ret    
80104988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498f:	90                   	nop
  asm volatile("cld; rep stosb" :
80104990:	89 d7                	mov    %edx,%edi
80104992:	8b 45 0c             	mov    0xc(%ebp),%eax
80104995:	fc                   	cld    
80104996:	f3 aa                	rep stos %al,%es:(%edi)
80104998:	5b                   	pop    %ebx
80104999:	89 d0                	mov    %edx,%eax
8010499b:	5f                   	pop    %edi
8010499c:	5d                   	pop    %ebp
8010499d:	c3                   	ret    
8010499e:	66 90                	xchg   %ax,%ax

801049a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	56                   	push   %esi
801049a4:	8b 75 10             	mov    0x10(%ebp),%esi
801049a7:	8b 45 08             	mov    0x8(%ebp),%eax
801049aa:	53                   	push   %ebx
801049ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801049ae:	85 f6                	test   %esi,%esi
801049b0:	74 22                	je     801049d4 <memcmp+0x34>
    if(*s1 != *s2)
801049b2:	0f b6 08             	movzbl (%eax),%ecx
801049b5:	0f b6 1a             	movzbl (%edx),%ebx
801049b8:	01 c6                	add    %eax,%esi
801049ba:	38 cb                	cmp    %cl,%bl
801049bc:	74 0c                	je     801049ca <memcmp+0x2a>
801049be:	eb 20                	jmp    801049e0 <memcmp+0x40>
801049c0:	0f b6 08             	movzbl (%eax),%ecx
801049c3:	0f b6 1a             	movzbl (%edx),%ebx
801049c6:	38 d9                	cmp    %bl,%cl
801049c8:	75 16                	jne    801049e0 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
801049ca:	83 c0 01             	add    $0x1,%eax
801049cd:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049d0:	39 c6                	cmp    %eax,%esi
801049d2:	75 ec                	jne    801049c0 <memcmp+0x20>
  }

  return 0;
}
801049d4:	5b                   	pop    %ebx
  return 0;
801049d5:	31 c0                	xor    %eax,%eax
}
801049d7:	5e                   	pop    %esi
801049d8:	5d                   	pop    %ebp
801049d9:	c3                   	ret    
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
801049e0:	0f b6 c1             	movzbl %cl,%eax
801049e3:	29 d8                	sub    %ebx,%eax
}
801049e5:	5b                   	pop    %ebx
801049e6:	5e                   	pop    %esi
801049e7:	5d                   	pop    %ebp
801049e8:	c3                   	ret    
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	8b 45 08             	mov    0x8(%ebp),%eax
801049f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049fa:	56                   	push   %esi
801049fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049fe:	39 c6                	cmp    %eax,%esi
80104a00:	73 26                	jae    80104a28 <memmove+0x38>
80104a02:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a05:	39 f8                	cmp    %edi,%eax
80104a07:	73 1f                	jae    80104a28 <memmove+0x38>
80104a09:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
80104a0c:	85 c9                	test   %ecx,%ecx
80104a0e:	74 0f                	je     80104a1f <memmove+0x2f>
      *--d = *--s;
80104a10:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104a14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104a17:	83 ea 01             	sub    $0x1,%edx
80104a1a:	83 fa ff             	cmp    $0xffffffff,%edx
80104a1d:	75 f1                	jne    80104a10 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a1f:	5e                   	pop    %esi
80104a20:	5f                   	pop    %edi
80104a21:	5d                   	pop    %ebp
80104a22:	c3                   	ret    
80104a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a27:	90                   	nop
80104a28:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
    while(n-- > 0)
80104a2b:	89 c7                	mov    %eax,%edi
80104a2d:	85 c9                	test   %ecx,%ecx
80104a2f:	74 ee                	je     80104a1f <memmove+0x2f>
80104a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a38:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a39:	39 d6                	cmp    %edx,%esi
80104a3b:	75 fb                	jne    80104a38 <memmove+0x48>
}
80104a3d:	5e                   	pop    %esi
80104a3e:	5f                   	pop    %edi
80104a3f:	5d                   	pop    %ebp
80104a40:	c3                   	ret    
80104a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a4f:	90                   	nop

80104a50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a50:	eb 9e                	jmp    801049f0 <memmove>
80104a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	8b 7d 10             	mov    0x10(%ebp),%edi
80104a67:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a6a:	56                   	push   %esi
80104a6b:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a6e:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
80104a6f:	85 ff                	test   %edi,%edi
80104a71:	74 2f                	je     80104aa2 <strncmp+0x42>
80104a73:	0f b6 11             	movzbl (%ecx),%edx
80104a76:	0f b6 1e             	movzbl (%esi),%ebx
80104a79:	84 d2                	test   %dl,%dl
80104a7b:	74 37                	je     80104ab4 <strncmp+0x54>
80104a7d:	38 da                	cmp    %bl,%dl
80104a7f:	75 33                	jne    80104ab4 <strncmp+0x54>
80104a81:	01 f7                	add    %esi,%edi
80104a83:	eb 13                	jmp    80104a98 <strncmp+0x38>
80104a85:	8d 76 00             	lea    0x0(%esi),%esi
80104a88:	0f b6 11             	movzbl (%ecx),%edx
80104a8b:	84 d2                	test   %dl,%dl
80104a8d:	74 21                	je     80104ab0 <strncmp+0x50>
80104a8f:	0f b6 18             	movzbl (%eax),%ebx
80104a92:	89 c6                	mov    %eax,%esi
80104a94:	38 da                	cmp    %bl,%dl
80104a96:	75 1c                	jne    80104ab4 <strncmp+0x54>
    n--, p++, q++;
80104a98:	8d 46 01             	lea    0x1(%esi),%eax
80104a9b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a9e:	39 f8                	cmp    %edi,%eax
80104aa0:	75 e6                	jne    80104a88 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104aa2:	5b                   	pop    %ebx
    return 0;
80104aa3:	31 c0                	xor    %eax,%eax
}
80104aa5:	5e                   	pop    %esi
80104aa6:	5f                   	pop    %edi
80104aa7:	5d                   	pop    %ebp
80104aa8:	c3                   	ret    
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104ab4:	0f b6 c2             	movzbl %dl,%eax
80104ab7:	29 d8                	sub    %ebx,%eax
}
80104ab9:	5b                   	pop    %ebx
80104aba:	5e                   	pop    %esi
80104abb:	5f                   	pop    %edi
80104abc:	5d                   	pop    %ebp
80104abd:	c3                   	ret    
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ac7:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
80104aca:	56                   	push   %esi
80104acb:	53                   	push   %ebx
80104acc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
80104acf:	eb 1a                	jmp    80104aeb <strncpy+0x2b>
80104ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad8:	83 c2 01             	add    $0x1,%edx
80104adb:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
80104adf:	83 c1 01             	add    $0x1,%ecx
80104ae2:	88 41 ff             	mov    %al,-0x1(%ecx)
80104ae5:	84 c0                	test   %al,%al
80104ae7:	74 09                	je     80104af2 <strncpy+0x32>
80104ae9:	89 fb                	mov    %edi,%ebx
80104aeb:	8d 7b ff             	lea    -0x1(%ebx),%edi
80104aee:	85 db                	test   %ebx,%ebx
80104af0:	7f e6                	jg     80104ad8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104af2:	89 ce                	mov    %ecx,%esi
80104af4:	85 ff                	test   %edi,%edi
80104af6:	7e 1b                	jle    80104b13 <strncpy+0x53>
80104af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop
    *s++ = 0;
80104b00:	83 c6 01             	add    $0x1,%esi
80104b03:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
80104b07:	89 f2                	mov    %esi,%edx
80104b09:	f7 d2                	not    %edx
80104b0b:	01 ca                	add    %ecx,%edx
80104b0d:	01 da                	add    %ebx,%edx
  while(n-- > 0)
80104b0f:	85 d2                	test   %edx,%edx
80104b11:	7f ed                	jg     80104b00 <strncpy+0x40>
  return os;
}
80104b13:	5b                   	pop    %ebx
80104b14:	8b 45 08             	mov    0x8(%ebp),%eax
80104b17:	5e                   	pop    %esi
80104b18:	5f                   	pop    %edi
80104b19:	5d                   	pop    %ebp
80104b1a:	c3                   	ret    
80104b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b1f:	90                   	nop

80104b20 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104b27:	8b 45 08             	mov    0x8(%ebp),%eax
80104b2a:	53                   	push   %ebx
80104b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104b2e:	85 c9                	test   %ecx,%ecx
80104b30:	7e 26                	jle    80104b58 <safestrcpy+0x38>
80104b32:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104b36:	89 c1                	mov    %eax,%ecx
80104b38:	eb 17                	jmp    80104b51 <safestrcpy+0x31>
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b40:	83 c2 01             	add    $0x1,%edx
80104b43:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104b47:	83 c1 01             	add    $0x1,%ecx
80104b4a:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104b4d:	84 db                	test   %bl,%bl
80104b4f:	74 04                	je     80104b55 <safestrcpy+0x35>
80104b51:	39 f2                	cmp    %esi,%edx
80104b53:	75 eb                	jne    80104b40 <safestrcpy+0x20>
    ;
  *s = 0;
80104b55:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104b58:	5b                   	pop    %ebx
80104b59:	5e                   	pop    %esi
80104b5a:	5d                   	pop    %ebp
80104b5b:	c3                   	ret    
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <strlen>:

int
strlen(const char *s)
{
80104b60:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b61:	31 c0                	xor    %eax,%eax
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b68:	80 3a 00             	cmpb   $0x0,(%edx)
80104b6b:	74 0c                	je     80104b79 <strlen+0x19>
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
80104b70:	83 c0 01             	add    $0x1,%eax
80104b73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b77:	75 f7                	jne    80104b70 <strlen+0x10>
    ;
  return n;
}
80104b79:	5d                   	pop    %ebp
80104b7a:	c3                   	ret    

80104b7b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b7b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b7f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104b83:	55                   	push   %ebp
  pushl %ebx
80104b84:	53                   	push   %ebx
  pushl %esi
80104b85:	56                   	push   %esi
  pushl %edi
80104b86:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b87:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b89:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104b8b:	5f                   	pop    %edi
  popl %esi
80104b8c:	5e                   	pop    %esi
  popl %ebx
80104b8d:	5b                   	pop    %ebx
  popl %ebp
80104b8e:	5d                   	pop    %ebp
  ret
80104b8f:	c3                   	ret    

80104b90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	83 ec 04             	sub    $0x4,%esp
80104b97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b9a:	e8 91 ef ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b9f:	8b 00                	mov    (%eax),%eax
80104ba1:	39 d8                	cmp    %ebx,%eax
80104ba3:	76 1b                	jbe    80104bc0 <fetchint+0x30>
80104ba5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ba8:	39 d0                	cmp    %edx,%eax
80104baa:	72 14                	jb     80104bc0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80104baf:	8b 13                	mov    (%ebx),%edx
80104bb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104bb3:	31 c0                	xor    %eax,%eax
}
80104bb5:	83 c4 04             	add    $0x4,%esp
80104bb8:	5b                   	pop    %ebx
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret    
80104bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bbf:	90                   	nop
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc5:	eb ee                	jmp    80104bb5 <fetchint+0x25>
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 04             	sub    $0x4,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bda:	e8 51 ef ff ff       	call   80103b30 <myproc>

  if(addr >= curproc->sz)
80104bdf:	39 18                	cmp    %ebx,(%eax)
80104be1:	76 29                	jbe    80104c0c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104be3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104be6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104be8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bea:	39 d3                	cmp    %edx,%ebx
80104bec:	73 1e                	jae    80104c0c <fetchstr+0x3c>
    if(*s == 0)
80104bee:	80 3b 00             	cmpb   $0x0,(%ebx)
80104bf1:	74 35                	je     80104c28 <fetchstr+0x58>
80104bf3:	89 d8                	mov    %ebx,%eax
80104bf5:	eb 0e                	jmp    80104c05 <fetchstr+0x35>
80104bf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfe:	66 90                	xchg   %ax,%ax
80104c00:	80 38 00             	cmpb   $0x0,(%eax)
80104c03:	74 1b                	je     80104c20 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104c05:	83 c0 01             	add    $0x1,%eax
80104c08:	39 c2                	cmp    %eax,%edx
80104c0a:	77 f4                	ja     80104c00 <fetchstr+0x30>
    return -1;
80104c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104c11:	83 c4 04             	add    $0x4,%esp
80104c14:	5b                   	pop    %ebx
80104c15:	5d                   	pop    %ebp
80104c16:	c3                   	ret    
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax
80104c20:	83 c4 04             	add    $0x4,%esp
80104c23:	29 d8                	sub    %ebx,%eax
80104c25:	5b                   	pop    %ebx
80104c26:	5d                   	pop    %ebp
80104c27:	c3                   	ret    
    if(*s == 0)
80104c28:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104c2a:	eb e5                	jmp    80104c11 <fetchstr+0x41>
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	56                   	push   %esi
80104c34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c35:	e8 f6 ee ff ff       	call   80103b30 <myproc>
80104c3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c3d:	8b 40 18             	mov    0x18(%eax),%eax
80104c40:	8b 40 44             	mov    0x44(%eax),%eax
80104c43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c46:	e8 e5 ee ff ff       	call   80103b30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c4e:	8b 00                	mov    (%eax),%eax
80104c50:	39 c6                	cmp    %eax,%esi
80104c52:	73 1c                	jae    80104c70 <argint+0x40>
80104c54:	8d 53 08             	lea    0x8(%ebx),%edx
80104c57:	39 d0                	cmp    %edx,%eax
80104c59:	72 15                	jb     80104c70 <argint+0x40>
  *ip = *(int*)(addr);
80104c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c61:	89 10                	mov    %edx,(%eax)
  return 0;
80104c63:	31 c0                	xor    %eax,%eax
}
80104c65:	5b                   	pop    %ebx
80104c66:	5e                   	pop    %esi
80104c67:	5d                   	pop    %ebp
80104c68:	c3                   	ret    
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c75:	eb ee                	jmp    80104c65 <argint+0x35>
80104c77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7e:	66 90                	xchg   %ax,%ax

80104c80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
80104c85:	83 ec 10             	sub    $0x10,%esp
80104c88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c8b:	e8 a0 ee ff ff       	call   80103b30 <myproc>
 
  if(argint(n, &i) < 0)
80104c90:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104c93:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104c95:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c98:	50                   	push   %eax
80104c99:	ff 75 08             	pushl  0x8(%ebp)
80104c9c:	e8 8f ff ff ff       	call   80104c30 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ca1:	83 c4 10             	add    $0x10,%esp
80104ca4:	85 c0                	test   %eax,%eax
80104ca6:	78 28                	js     80104cd0 <argptr+0x50>
80104ca8:	85 db                	test   %ebx,%ebx
80104caa:	78 24                	js     80104cd0 <argptr+0x50>
80104cac:	8b 16                	mov    (%esi),%edx
80104cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb1:	39 c2                	cmp    %eax,%edx
80104cb3:	76 1b                	jbe    80104cd0 <argptr+0x50>
80104cb5:	01 c3                	add    %eax,%ebx
80104cb7:	39 da                	cmp    %ebx,%edx
80104cb9:	72 15                	jb     80104cd0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cbe:	89 02                	mov    %eax,(%edx)
  return 0;
80104cc0:	31 c0                	xor    %eax,%eax
}
80104cc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc5:	5b                   	pop    %ebx
80104cc6:	5e                   	pop    %esi
80104cc7:	5d                   	pop    %ebp
80104cc8:	c3                   	ret    
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd5:	eb eb                	jmp    80104cc2 <argptr+0x42>
80104cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce9:	50                   	push   %eax
80104cea:	ff 75 08             	pushl  0x8(%ebp)
80104ced:	e8 3e ff ff ff       	call   80104c30 <argint>
80104cf2:	83 c4 10             	add    $0x10,%esp
80104cf5:	85 c0                	test   %eax,%eax
80104cf7:	78 17                	js     80104d10 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104cf9:	83 ec 08             	sub    $0x8,%esp
80104cfc:	ff 75 0c             	pushl  0xc(%ebp)
80104cff:	ff 75 f4             	pushl  -0xc(%ebp)
80104d02:	e8 c9 fe ff ff       	call   80104bd0 <fetchstr>
80104d07:	83 c4 10             	add    $0x10,%esp
}
80104d0a:	c9                   	leave  
80104d0b:	c3                   	ret    
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d10:	c9                   	leave  
    return -1;
80104d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d16:	c3                   	ret    
80104d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <syscall>:
[SYS_pfs]     sys_pfs,
};

void
syscall(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d27:	e8 04 ee ff ff       	call   80103b30 <myproc>
80104d2c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104d2e:	8b 40 18             	mov    0x18(%eax),%eax
80104d31:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d34:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d37:	83 fa 18             	cmp    $0x18,%edx
80104d3a:	77 1c                	ja     80104d58 <syscall+0x38>
80104d3c:	8b 14 85 20 7c 10 80 	mov    -0x7fef83e0(,%eax,4),%edx
80104d43:	85 d2                	test   %edx,%edx
80104d45:	74 11                	je     80104d58 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104d47:	ff d2                	call   *%edx
80104d49:	8b 53 18             	mov    0x18(%ebx),%edx
80104d4c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d52:	c9                   	leave  
80104d53:	c3                   	ret    
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104d58:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d59:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d5c:	50                   	push   %eax
80104d5d:	ff 73 10             	pushl  0x10(%ebx)
80104d60:	68 01 7c 10 80       	push   $0x80107c01
80104d65:	e8 46 b9 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104d6a:	8b 43 18             	mov    0x18(%ebx),%eax
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d7a:	c9                   	leave  
80104d7b:	c3                   	ret    
80104d7c:	66 90                	xchg   %ax,%ax
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	57                   	push   %edi
80104d84:	56                   	push   %esi
80104d85:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104d86:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
80104d89:	83 ec 44             	sub    $0x44,%esp
80104d8c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104d92:	53                   	push   %ebx
80104d93:	50                   	push   %eax
{
80104d94:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104d97:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104d9a:	e8 51 d2 ff ff       	call   80101ff0 <nameiparent>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	0f 84 46 01 00 00    	je     80104ef0 <create+0x170>
    return 0;
  ilock(dp);
80104daa:	83 ec 0c             	sub    $0xc,%esp
80104dad:	89 c6                	mov    %eax,%esi
80104daf:	50                   	push   %eax
80104db0:	e8 7b c9 ff ff       	call   80101730 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104db5:	83 c4 0c             	add    $0xc,%esp
80104db8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104dbb:	50                   	push   %eax
80104dbc:	53                   	push   %ebx
80104dbd:	56                   	push   %esi
80104dbe:	e8 9d ce ff ff       	call   80101c60 <dirlookup>
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	89 c7                	mov    %eax,%edi
80104dc8:	85 c0                	test   %eax,%eax
80104dca:	74 54                	je     80104e20 <create+0xa0>
    iunlockput(dp);
80104dcc:	83 ec 0c             	sub    $0xc,%esp
80104dcf:	56                   	push   %esi
80104dd0:	e8 eb cb ff ff       	call   801019c0 <iunlockput>
    ilock(ip);
80104dd5:	89 3c 24             	mov    %edi,(%esp)
80104dd8:	e8 53 c9 ff ff       	call   80101730 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104de5:	75 19                	jne    80104e00 <create+0x80>
80104de7:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104dec:	75 12                	jne    80104e00 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104df1:	89 f8                	mov    %edi,%eax
80104df3:	5b                   	pop    %ebx
80104df4:	5e                   	pop    %esi
80104df5:	5f                   	pop    %edi
80104df6:	5d                   	pop    %ebp
80104df7:	c3                   	ret    
80104df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dff:	90                   	nop
    iunlockput(ip);
80104e00:	83 ec 0c             	sub    $0xc,%esp
80104e03:	57                   	push   %edi
    return 0;
80104e04:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104e06:	e8 b5 cb ff ff       	call   801019c0 <iunlockput>
    return 0;
80104e0b:	83 c4 10             	add    $0x10,%esp
}
80104e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e11:	89 f8                	mov    %edi,%eax
80104e13:	5b                   	pop    %ebx
80104e14:	5e                   	pop    %esi
80104e15:	5f                   	pop    %edi
80104e16:	5d                   	pop    %ebp
80104e17:	c3                   	ret    
80104e18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e20:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104e24:	83 ec 08             	sub    $0x8,%esp
80104e27:	50                   	push   %eax
80104e28:	ff 36                	pushl  (%esi)
80104e2a:	e8 91 c7 ff ff       	call   801015c0 <ialloc>
80104e2f:	83 c4 10             	add    $0x10,%esp
80104e32:	89 c7                	mov    %eax,%edi
80104e34:	85 c0                	test   %eax,%eax
80104e36:	0f 84 cd 00 00 00    	je     80104f09 <create+0x189>
  ilock(ip);
80104e3c:	83 ec 0c             	sub    $0xc,%esp
80104e3f:	50                   	push   %eax
80104e40:	e8 eb c8 ff ff       	call   80101730 <ilock>
  ip->major = major;
80104e45:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104e49:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104e4d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104e51:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104e55:	b8 01 00 00 00       	mov    $0x1,%eax
80104e5a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104e5e:	89 3c 24             	mov    %edi,(%esp)
80104e61:	e8 1a c8 ff ff       	call   80101680 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104e66:	83 c4 10             	add    $0x10,%esp
80104e69:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104e6e:	74 30                	je     80104ea0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104e70:	83 ec 04             	sub    $0x4,%esp
80104e73:	ff 77 04             	pushl  0x4(%edi)
80104e76:	53                   	push   %ebx
80104e77:	56                   	push   %esi
80104e78:	e8 93 d0 ff ff       	call   80101f10 <dirlink>
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 78                	js     80104efc <create+0x17c>
  iunlockput(dp);
80104e84:	83 ec 0c             	sub    $0xc,%esp
80104e87:	56                   	push   %esi
80104e88:	e8 33 cb ff ff       	call   801019c0 <iunlockput>
  return ip;
80104e8d:	83 c4 10             	add    $0x10,%esp
}
80104e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e93:	89 f8                	mov    %edi,%eax
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5f                   	pop    %edi
80104e98:	5d                   	pop    %ebp
80104e99:	c3                   	ret    
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ea0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ea3:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104ea8:	56                   	push   %esi
80104ea9:	e8 d2 c7 ff ff       	call   80101680 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eae:	83 c4 0c             	add    $0xc,%esp
80104eb1:	ff 77 04             	pushl  0x4(%edi)
80104eb4:	68 a4 7c 10 80       	push   $0x80107ca4
80104eb9:	57                   	push   %edi
80104eba:	e8 51 d0 ff ff       	call   80101f10 <dirlink>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	78 18                	js     80104ede <create+0x15e>
80104ec6:	83 ec 04             	sub    $0x4,%esp
80104ec9:	ff 76 04             	pushl  0x4(%esi)
80104ecc:	68 a3 7c 10 80       	push   $0x80107ca3
80104ed1:	57                   	push   %edi
80104ed2:	e8 39 d0 ff ff       	call   80101f10 <dirlink>
80104ed7:	83 c4 10             	add    $0x10,%esp
80104eda:	85 c0                	test   %eax,%eax
80104edc:	79 92                	jns    80104e70 <create+0xf0>
      panic("create dots");
80104ede:	83 ec 0c             	sub    $0xc,%esp
80104ee1:	68 97 7c 10 80       	push   $0x80107c97
80104ee6:	e8 a5 b4 ff ff       	call   80100390 <panic>
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop
}
80104ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104ef3:	31 ff                	xor    %edi,%edi
}
80104ef5:	5b                   	pop    %ebx
80104ef6:	89 f8                	mov    %edi,%eax
80104ef8:	5e                   	pop    %esi
80104ef9:	5f                   	pop    %edi
80104efa:	5d                   	pop    %ebp
80104efb:	c3                   	ret    
    panic("create: dirlink");
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	68 a6 7c 10 80       	push   $0x80107ca6
80104f04:	e8 87 b4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104f09:	83 ec 0c             	sub    $0xc,%esp
80104f0c:	68 88 7c 10 80       	push   $0x80107c88
80104f11:	e8 7a b4 ff ff       	call   80100390 <panic>
80104f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi

80104f20 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	89 d6                	mov    %edx,%esi
80104f26:	53                   	push   %ebx
80104f27:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104f29:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104f2c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f2f:	50                   	push   %eax
80104f30:	6a 00                	push   $0x0
80104f32:	e8 f9 fc ff ff       	call   80104c30 <argint>
80104f37:	83 c4 10             	add    $0x10,%esp
80104f3a:	85 c0                	test   %eax,%eax
80104f3c:	78 2a                	js     80104f68 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f3e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f42:	77 24                	ja     80104f68 <argfd.constprop.0+0x48>
80104f44:	e8 e7 eb ff ff       	call   80103b30 <myproc>
80104f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f4c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104f50:	85 c0                	test   %eax,%eax
80104f52:	74 14                	je     80104f68 <argfd.constprop.0+0x48>
  if(pfd)
80104f54:	85 db                	test   %ebx,%ebx
80104f56:	74 02                	je     80104f5a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f58:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104f5a:	89 06                	mov    %eax,(%esi)
  return 0;
80104f5c:	31 c0                	xor    %eax,%eax
}
80104f5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f61:	5b                   	pop    %ebx
80104f62:	5e                   	pop    %esi
80104f63:	5d                   	pop    %ebp
80104f64:	c3                   	ret    
80104f65:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f6d:	eb ef                	jmp    80104f5e <argfd.constprop.0+0x3e>
80104f6f:	90                   	nop

80104f70 <sys_dup>:
{
80104f70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104f71:	31 c0                	xor    %eax,%eax
{
80104f73:	89 e5                	mov    %esp,%ebp
80104f75:	56                   	push   %esi
80104f76:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104f77:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104f7a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104f7d:	e8 9e ff ff ff       	call   80104f20 <argfd.constprop.0>
80104f82:	85 c0                	test   %eax,%eax
80104f84:	78 1a                	js     80104fa0 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104f86:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f89:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104f8b:	e8 a0 eb ff ff       	call   80103b30 <myproc>
    if(curproc->ofile[fd] == 0){
80104f90:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f94:	85 d2                	test   %edx,%edx
80104f96:	74 18                	je     80104fb0 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104f98:	83 c3 01             	add    $0x1,%ebx
80104f9b:	83 fb 10             	cmp    $0x10,%ebx
80104f9e:	75 f0                	jne    80104f90 <sys_dup+0x20>
}
80104fa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fa3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fa8:	89 d8                	mov    %ebx,%eax
80104faa:	5b                   	pop    %ebx
80104fab:	5e                   	pop    %esi
80104fac:	5d                   	pop    %ebp
80104fad:	c3                   	ret    
80104fae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104fb0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fb4:	83 ec 0c             	sub    $0xc,%esp
80104fb7:	ff 75 f4             	pushl  -0xc(%ebp)
80104fba:	e8 c1 be ff ff       	call   80100e80 <filedup>
  return fd;
80104fbf:	83 c4 10             	add    $0x10,%esp
}
80104fc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fc5:	89 d8                	mov    %ebx,%eax
80104fc7:	5b                   	pop    %ebx
80104fc8:	5e                   	pop    %esi
80104fc9:	5d                   	pop    %ebp
80104fca:	c3                   	ret    
80104fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fcf:	90                   	nop

80104fd0 <sys_read>:
{
80104fd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd1:	31 c0                	xor    %eax,%eax
{
80104fd3:	89 e5                	mov    %esp,%ebp
80104fd5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fd8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104fdb:	e8 40 ff ff ff       	call   80104f20 <argfd.constprop.0>
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	78 4c                	js     80105030 <sys_read+0x60>
80104fe4:	83 ec 08             	sub    $0x8,%esp
80104fe7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fea:	50                   	push   %eax
80104feb:	6a 02                	push   $0x2
80104fed:	e8 3e fc ff ff       	call   80104c30 <argint>
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	85 c0                	test   %eax,%eax
80104ff7:	78 37                	js     80105030 <sys_read+0x60>
80104ff9:	83 ec 04             	sub    $0x4,%esp
80104ffc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fff:	ff 75 f0             	pushl  -0x10(%ebp)
80105002:	50                   	push   %eax
80105003:	6a 01                	push   $0x1
80105005:	e8 76 fc ff ff       	call   80104c80 <argptr>
8010500a:	83 c4 10             	add    $0x10,%esp
8010500d:	85 c0                	test   %eax,%eax
8010500f:	78 1f                	js     80105030 <sys_read+0x60>
  return fileread(f, p, n);
80105011:	83 ec 04             	sub    $0x4,%esp
80105014:	ff 75 f0             	pushl  -0x10(%ebp)
80105017:	ff 75 f4             	pushl  -0xc(%ebp)
8010501a:	ff 75 ec             	pushl  -0x14(%ebp)
8010501d:	e8 de bf ff ff       	call   80101000 <fileread>
80105022:	83 c4 10             	add    $0x10,%esp
}
80105025:	c9                   	leave  
80105026:	c3                   	ret    
80105027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502e:	66 90                	xchg   %ax,%ax
80105030:	c9                   	leave  
    return -1;
80105031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105036:	c3                   	ret    
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax

80105040 <sys_write>:
{
80105040:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105041:	31 c0                	xor    %eax,%eax
{
80105043:	89 e5                	mov    %esp,%ebp
80105045:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105048:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010504b:	e8 d0 fe ff ff       	call   80104f20 <argfd.constprop.0>
80105050:	85 c0                	test   %eax,%eax
80105052:	78 4c                	js     801050a0 <sys_write+0x60>
80105054:	83 ec 08             	sub    $0x8,%esp
80105057:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010505a:	50                   	push   %eax
8010505b:	6a 02                	push   $0x2
8010505d:	e8 ce fb ff ff       	call   80104c30 <argint>
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	85 c0                	test   %eax,%eax
80105067:	78 37                	js     801050a0 <sys_write+0x60>
80105069:	83 ec 04             	sub    $0x4,%esp
8010506c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010506f:	ff 75 f0             	pushl  -0x10(%ebp)
80105072:	50                   	push   %eax
80105073:	6a 01                	push   $0x1
80105075:	e8 06 fc ff ff       	call   80104c80 <argptr>
8010507a:	83 c4 10             	add    $0x10,%esp
8010507d:	85 c0                	test   %eax,%eax
8010507f:	78 1f                	js     801050a0 <sys_write+0x60>
  return filewrite(f, p, n);
80105081:	83 ec 04             	sub    $0x4,%esp
80105084:	ff 75 f0             	pushl  -0x10(%ebp)
80105087:	ff 75 f4             	pushl  -0xc(%ebp)
8010508a:	ff 75 ec             	pushl  -0x14(%ebp)
8010508d:	e8 fe bf ff ff       	call   80101090 <filewrite>
80105092:	83 c4 10             	add    $0x10,%esp
}
80105095:	c9                   	leave  
80105096:	c3                   	ret    
80105097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010509e:	66 90                	xchg   %ax,%ax
801050a0:	c9                   	leave  
    return -1;
801050a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050a6:	c3                   	ret    
801050a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ae:	66 90                	xchg   %ax,%ax

801050b0 <sys_close>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801050b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801050b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050bc:	e8 5f fe ff ff       	call   80104f20 <argfd.constprop.0>
801050c1:	85 c0                	test   %eax,%eax
801050c3:	78 2b                	js     801050f0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801050c5:	e8 66 ea ff ff       	call   80103b30 <myproc>
801050ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801050cd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050d0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801050d7:	00 
  fileclose(f);
801050d8:	ff 75 f4             	pushl  -0xc(%ebp)
801050db:	e8 f0 bd ff ff       	call   80100ed0 <fileclose>
  return 0;
801050e0:	83 c4 10             	add    $0x10,%esp
801050e3:	31 c0                	xor    %eax,%eax
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ee:	66 90                	xchg   %ax,%ax
801050f0:	c9                   	leave  
    return -1;
801050f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f6:	c3                   	ret    
801050f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050fe:	66 90                	xchg   %ax,%ax

80105100 <sys_fstat>:
{
80105100:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105101:	31 c0                	xor    %eax,%eax
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105108:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010510b:	e8 10 fe ff ff       	call   80104f20 <argfd.constprop.0>
80105110:	85 c0                	test   %eax,%eax
80105112:	78 2c                	js     80105140 <sys_fstat+0x40>
80105114:	83 ec 04             	sub    $0x4,%esp
80105117:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010511a:	6a 14                	push   $0x14
8010511c:	50                   	push   %eax
8010511d:	6a 01                	push   $0x1
8010511f:	e8 5c fb ff ff       	call   80104c80 <argptr>
80105124:	83 c4 10             	add    $0x10,%esp
80105127:	85 c0                	test   %eax,%eax
80105129:	78 15                	js     80105140 <sys_fstat+0x40>
  return filestat(f, st);
8010512b:	83 ec 08             	sub    $0x8,%esp
8010512e:	ff 75 f4             	pushl  -0xc(%ebp)
80105131:	ff 75 f0             	pushl  -0x10(%ebp)
80105134:	e8 77 be ff ff       	call   80100fb0 <filestat>
80105139:	83 c4 10             	add    $0x10,%esp
}
8010513c:	c9                   	leave  
8010513d:	c3                   	ret    
8010513e:	66 90                	xchg   %ax,%ax
80105140:	c9                   	leave  
    return -1;
80105141:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105146:	c3                   	ret    
80105147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010514e:	66 90                	xchg   %ax,%ax

80105150 <sys_link>:
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	57                   	push   %edi
80105154:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105155:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105158:	53                   	push   %ebx
80105159:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010515c:	50                   	push   %eax
8010515d:	6a 00                	push   $0x0
8010515f:	e8 7c fb ff ff       	call   80104ce0 <argstr>
80105164:	83 c4 10             	add    $0x10,%esp
80105167:	85 c0                	test   %eax,%eax
80105169:	0f 88 fb 00 00 00    	js     8010526a <sys_link+0x11a>
8010516f:	83 ec 08             	sub    $0x8,%esp
80105172:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105175:	50                   	push   %eax
80105176:	6a 01                	push   $0x1
80105178:	e8 63 fb ff ff       	call   80104ce0 <argstr>
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	85 c0                	test   %eax,%eax
80105182:	0f 88 e2 00 00 00    	js     8010526a <sys_link+0x11a>
  begin_op();
80105188:	e8 53 dd ff ff       	call   80102ee0 <begin_op>
  if((ip = namei(old)) == 0){
8010518d:	83 ec 0c             	sub    $0xc,%esp
80105190:	ff 75 d4             	pushl  -0x2c(%ebp)
80105193:	e8 38 ce ff ff       	call   80101fd0 <namei>
80105198:	83 c4 10             	add    $0x10,%esp
8010519b:	89 c3                	mov    %eax,%ebx
8010519d:	85 c0                	test   %eax,%eax
8010519f:	0f 84 e4 00 00 00    	je     80105289 <sys_link+0x139>
  ilock(ip);
801051a5:	83 ec 0c             	sub    $0xc,%esp
801051a8:	50                   	push   %eax
801051a9:	e8 82 c5 ff ff       	call   80101730 <ilock>
  if(ip->type == T_DIR){
801051ae:	83 c4 10             	add    $0x10,%esp
801051b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051b6:	0f 84 b5 00 00 00    	je     80105271 <sys_link+0x121>
  iupdate(ip);
801051bc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801051bf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801051c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051c7:	53                   	push   %ebx
801051c8:	e8 b3 c4 ff ff       	call   80101680 <iupdate>
  iunlock(ip);
801051cd:	89 1c 24             	mov    %ebx,(%esp)
801051d0:	e8 3b c6 ff ff       	call   80101810 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051d5:	58                   	pop    %eax
801051d6:	5a                   	pop    %edx
801051d7:	57                   	push   %edi
801051d8:	ff 75 d0             	pushl  -0x30(%ebp)
801051db:	e8 10 ce ff ff       	call   80101ff0 <nameiparent>
801051e0:	83 c4 10             	add    $0x10,%esp
801051e3:	89 c6                	mov    %eax,%esi
801051e5:	85 c0                	test   %eax,%eax
801051e7:	74 5b                	je     80105244 <sys_link+0xf4>
  ilock(dp);
801051e9:	83 ec 0c             	sub    $0xc,%esp
801051ec:	50                   	push   %eax
801051ed:	e8 3e c5 ff ff       	call   80101730 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	8b 03                	mov    (%ebx),%eax
801051f7:	39 06                	cmp    %eax,(%esi)
801051f9:	75 3d                	jne    80105238 <sys_link+0xe8>
801051fb:	83 ec 04             	sub    $0x4,%esp
801051fe:	ff 73 04             	pushl  0x4(%ebx)
80105201:	57                   	push   %edi
80105202:	56                   	push   %esi
80105203:	e8 08 cd ff ff       	call   80101f10 <dirlink>
80105208:	83 c4 10             	add    $0x10,%esp
8010520b:	85 c0                	test   %eax,%eax
8010520d:	78 29                	js     80105238 <sys_link+0xe8>
  iunlockput(dp);
8010520f:	83 ec 0c             	sub    $0xc,%esp
80105212:	56                   	push   %esi
80105213:	e8 a8 c7 ff ff       	call   801019c0 <iunlockput>
  iput(ip);
80105218:	89 1c 24             	mov    %ebx,(%esp)
8010521b:	e8 40 c6 ff ff       	call   80101860 <iput>
  end_op();
80105220:	e8 2b dd ff ff       	call   80102f50 <end_op>
  return 0;
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	31 c0                	xor    %eax,%eax
}
8010522a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010522d:	5b                   	pop    %ebx
8010522e:	5e                   	pop    %esi
8010522f:	5f                   	pop    %edi
80105230:	5d                   	pop    %ebp
80105231:	c3                   	ret    
80105232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105238:	83 ec 0c             	sub    $0xc,%esp
8010523b:	56                   	push   %esi
8010523c:	e8 7f c7 ff ff       	call   801019c0 <iunlockput>
    goto bad;
80105241:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105244:	83 ec 0c             	sub    $0xc,%esp
80105247:	53                   	push   %ebx
80105248:	e8 e3 c4 ff ff       	call   80101730 <ilock>
  ip->nlink--;
8010524d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105252:	89 1c 24             	mov    %ebx,(%esp)
80105255:	e8 26 c4 ff ff       	call   80101680 <iupdate>
  iunlockput(ip);
8010525a:	89 1c 24             	mov    %ebx,(%esp)
8010525d:	e8 5e c7 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105262:	e8 e9 dc ff ff       	call   80102f50 <end_op>
  return -1;
80105267:	83 c4 10             	add    $0x10,%esp
8010526a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526f:	eb b9                	jmp    8010522a <sys_link+0xda>
    iunlockput(ip);
80105271:	83 ec 0c             	sub    $0xc,%esp
80105274:	53                   	push   %ebx
80105275:	e8 46 c7 ff ff       	call   801019c0 <iunlockput>
    end_op();
8010527a:	e8 d1 dc ff ff       	call   80102f50 <end_op>
    return -1;
8010527f:	83 c4 10             	add    $0x10,%esp
80105282:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105287:	eb a1                	jmp    8010522a <sys_link+0xda>
    end_op();
80105289:	e8 c2 dc ff ff       	call   80102f50 <end_op>
    return -1;
8010528e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105293:	eb 95                	jmp    8010522a <sys_link+0xda>
80105295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052a0 <sys_unlink>:
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	57                   	push   %edi
801052a4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801052a5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052a8:	53                   	push   %ebx
801052a9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801052ac:	50                   	push   %eax
801052ad:	6a 00                	push   $0x0
801052af:	e8 2c fa ff ff       	call   80104ce0 <argstr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	0f 88 91 01 00 00    	js     80105450 <sys_unlink+0x1b0>
  begin_op();
801052bf:	e8 1c dc ff ff       	call   80102ee0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801052c4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801052c7:	83 ec 08             	sub    $0x8,%esp
801052ca:	53                   	push   %ebx
801052cb:	ff 75 c0             	pushl  -0x40(%ebp)
801052ce:	e8 1d cd ff ff       	call   80101ff0 <nameiparent>
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	89 c6                	mov    %eax,%esi
801052d8:	85 c0                	test   %eax,%eax
801052da:	0f 84 7a 01 00 00    	je     8010545a <sys_unlink+0x1ba>
  ilock(dp);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	50                   	push   %eax
801052e4:	e8 47 c4 ff ff       	call   80101730 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801052e9:	58                   	pop    %eax
801052ea:	5a                   	pop    %edx
801052eb:	68 a4 7c 10 80       	push   $0x80107ca4
801052f0:	53                   	push   %ebx
801052f1:	e8 4a c9 ff ff       	call   80101c40 <namecmp>
801052f6:	83 c4 10             	add    $0x10,%esp
801052f9:	85 c0                	test   %eax,%eax
801052fb:	0f 84 0f 01 00 00    	je     80105410 <sys_unlink+0x170>
80105301:	83 ec 08             	sub    $0x8,%esp
80105304:	68 a3 7c 10 80       	push   $0x80107ca3
80105309:	53                   	push   %ebx
8010530a:	e8 31 c9 ff ff       	call   80101c40 <namecmp>
8010530f:	83 c4 10             	add    $0x10,%esp
80105312:	85 c0                	test   %eax,%eax
80105314:	0f 84 f6 00 00 00    	je     80105410 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010531a:	83 ec 04             	sub    $0x4,%esp
8010531d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105320:	50                   	push   %eax
80105321:	53                   	push   %ebx
80105322:	56                   	push   %esi
80105323:	e8 38 c9 ff ff       	call   80101c60 <dirlookup>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	89 c3                	mov    %eax,%ebx
8010532d:	85 c0                	test   %eax,%eax
8010532f:	0f 84 db 00 00 00    	je     80105410 <sys_unlink+0x170>
  ilock(ip);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	50                   	push   %eax
80105339:	e8 f2 c3 ff ff       	call   80101730 <ilock>
  if(ip->nlink < 1)
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105346:	0f 8e 37 01 00 00    	jle    80105483 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010534c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105351:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105354:	74 6a                	je     801053c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105356:	83 ec 04             	sub    $0x4,%esp
80105359:	6a 10                	push   $0x10
8010535b:	6a 00                	push   $0x0
8010535d:	57                   	push   %edi
8010535e:	e8 ed f5 ff ff       	call   80104950 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105363:	6a 10                	push   $0x10
80105365:	ff 75 c4             	pushl  -0x3c(%ebp)
80105368:	57                   	push   %edi
80105369:	56                   	push   %esi
8010536a:	e8 a1 c7 ff ff       	call   80101b10 <writei>
8010536f:	83 c4 20             	add    $0x20,%esp
80105372:	83 f8 10             	cmp    $0x10,%eax
80105375:	0f 85 fb 00 00 00    	jne    80105476 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
8010537b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105380:	0f 84 aa 00 00 00    	je     80105430 <sys_unlink+0x190>
  iunlockput(dp);
80105386:	83 ec 0c             	sub    $0xc,%esp
80105389:	56                   	push   %esi
8010538a:	e8 31 c6 ff ff       	call   801019c0 <iunlockput>
  ip->nlink--;
8010538f:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105394:	89 1c 24             	mov    %ebx,(%esp)
80105397:	e8 e4 c2 ff ff       	call   80101680 <iupdate>
  iunlockput(ip);
8010539c:	89 1c 24             	mov    %ebx,(%esp)
8010539f:	e8 1c c6 ff ff       	call   801019c0 <iunlockput>
  end_op();
801053a4:	e8 a7 db ff ff       	call   80102f50 <end_op>
  return 0;
801053a9:	83 c4 10             	add    $0x10,%esp
801053ac:	31 c0                	xor    %eax,%eax
}
801053ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053b1:	5b                   	pop    %ebx
801053b2:	5e                   	pop    %esi
801053b3:	5f                   	pop    %edi
801053b4:	5d                   	pop    %ebp
801053b5:	c3                   	ret    
801053b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801053c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801053c4:	76 90                	jbe    80105356 <sys_unlink+0xb6>
801053c6:	ba 20 00 00 00       	mov    $0x20,%edx
801053cb:	eb 0f                	jmp    801053dc <sys_unlink+0x13c>
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
801053d0:	83 c2 10             	add    $0x10,%edx
801053d3:	39 53 58             	cmp    %edx,0x58(%ebx)
801053d6:	0f 86 7a ff ff ff    	jbe    80105356 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053dc:	6a 10                	push   $0x10
801053de:	52                   	push   %edx
801053df:	57                   	push   %edi
801053e0:	53                   	push   %ebx
801053e1:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801053e4:	e8 27 c6 ff ff       	call   80101a10 <readi>
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801053ef:	83 f8 10             	cmp    $0x10,%eax
801053f2:	75 75                	jne    80105469 <sys_unlink+0x1c9>
    if(de.inum != 0)
801053f4:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801053f9:	74 d5                	je     801053d0 <sys_unlink+0x130>
    iunlockput(ip);
801053fb:	83 ec 0c             	sub    $0xc,%esp
801053fe:	53                   	push   %ebx
801053ff:	e8 bc c5 ff ff       	call   801019c0 <iunlockput>
    goto bad;
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010540e:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	56                   	push   %esi
80105414:	e8 a7 c5 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105419:	e8 32 db ff ff       	call   80102f50 <end_op>
  return -1;
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105426:	eb 86                	jmp    801053ae <sys_unlink+0x10e>
80105428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop
    iupdate(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105433:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105438:	56                   	push   %esi
80105439:	e8 42 c2 ff ff       	call   80101680 <iupdate>
8010543e:	83 c4 10             	add    $0x10,%esp
80105441:	e9 40 ff ff ff       	jmp    80105386 <sys_unlink+0xe6>
80105446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105455:	e9 54 ff ff ff       	jmp    801053ae <sys_unlink+0x10e>
    end_op();
8010545a:	e8 f1 da ff ff       	call   80102f50 <end_op>
    return -1;
8010545f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105464:	e9 45 ff ff ff       	jmp    801053ae <sys_unlink+0x10e>
      panic("isdirempty: readi");
80105469:	83 ec 0c             	sub    $0xc,%esp
8010546c:	68 c8 7c 10 80       	push   $0x80107cc8
80105471:	e8 1a af ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105476:	83 ec 0c             	sub    $0xc,%esp
80105479:	68 da 7c 10 80       	push   $0x80107cda
8010547e:	e8 0d af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105483:	83 ec 0c             	sub    $0xc,%esp
80105486:	68 b6 7c 10 80       	push   $0x80107cb6
8010548b:	e8 00 af ff ff       	call   80100390 <panic>

80105490 <sys_open>:

int
sys_open(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105495:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105498:	53                   	push   %ebx
80105499:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010549c:	50                   	push   %eax
8010549d:	6a 00                	push   $0x0
8010549f:	e8 3c f8 ff ff       	call   80104ce0 <argstr>
801054a4:	83 c4 10             	add    $0x10,%esp
801054a7:	85 c0                	test   %eax,%eax
801054a9:	0f 88 8e 00 00 00    	js     8010553d <sys_open+0xad>
801054af:	83 ec 08             	sub    $0x8,%esp
801054b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054b5:	50                   	push   %eax
801054b6:	6a 01                	push   $0x1
801054b8:	e8 73 f7 ff ff       	call   80104c30 <argint>
801054bd:	83 c4 10             	add    $0x10,%esp
801054c0:	85 c0                	test   %eax,%eax
801054c2:	78 79                	js     8010553d <sys_open+0xad>
    return -1;

  begin_op();
801054c4:	e8 17 da ff ff       	call   80102ee0 <begin_op>

  if(omode & O_CREATE){
801054c9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054cd:	75 79                	jne    80105548 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054cf:	83 ec 0c             	sub    $0xc,%esp
801054d2:	ff 75 e0             	pushl  -0x20(%ebp)
801054d5:	e8 f6 ca ff ff       	call   80101fd0 <namei>
801054da:	83 c4 10             	add    $0x10,%esp
801054dd:	89 c6                	mov    %eax,%esi
801054df:	85 c0                	test   %eax,%eax
801054e1:	0f 84 7e 00 00 00    	je     80105565 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801054e7:	83 ec 0c             	sub    $0xc,%esp
801054ea:	50                   	push   %eax
801054eb:	e8 40 c2 ff ff       	call   80101730 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054f0:	83 c4 10             	add    $0x10,%esp
801054f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054f8:	0f 84 c2 00 00 00    	je     801055c0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054fe:	e8 0d b9 ff ff       	call   80100e10 <filealloc>
80105503:	89 c7                	mov    %eax,%edi
80105505:	85 c0                	test   %eax,%eax
80105507:	74 23                	je     8010552c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105509:	e8 22 e6 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010550e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105510:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105514:	85 d2                	test   %edx,%edx
80105516:	74 60                	je     80105578 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105518:	83 c3 01             	add    $0x1,%ebx
8010551b:	83 fb 10             	cmp    $0x10,%ebx
8010551e:	75 f0                	jne    80105510 <sys_open+0x80>
    if(f)
      fileclose(f);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	57                   	push   %edi
80105524:	e8 a7 b9 ff ff       	call   80100ed0 <fileclose>
80105529:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010552c:	83 ec 0c             	sub    $0xc,%esp
8010552f:	56                   	push   %esi
80105530:	e8 8b c4 ff ff       	call   801019c0 <iunlockput>
    end_op();
80105535:	e8 16 da ff ff       	call   80102f50 <end_op>
    return -1;
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105542:	eb 6d                	jmp    801055b1 <sys_open+0x121>
80105544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010554e:	31 c9                	xor    %ecx,%ecx
80105550:	ba 02 00 00 00       	mov    $0x2,%edx
80105555:	6a 00                	push   $0x0
80105557:	e8 24 f8 ff ff       	call   80104d80 <create>
    if(ip == 0){
8010555c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010555f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105561:	85 c0                	test   %eax,%eax
80105563:	75 99                	jne    801054fe <sys_open+0x6e>
      end_op();
80105565:	e8 e6 d9 ff ff       	call   80102f50 <end_op>
      return -1;
8010556a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010556f:	eb 40                	jmp    801055b1 <sys_open+0x121>
80105571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105578:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010557b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010557f:	56                   	push   %esi
80105580:	e8 8b c2 ff ff       	call   80101810 <iunlock>
  end_op();
80105585:	e8 c6 d9 ff ff       	call   80102f50 <end_op>

  f->type = FD_INODE;
8010558a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105590:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105593:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105596:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105599:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010559b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055a2:	f7 d0                	not    %eax
801055a4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055a7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055aa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055ad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801055b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b4:	89 d8                	mov    %ebx,%eax
801055b6:	5b                   	pop    %ebx
801055b7:	5e                   	pop    %esi
801055b8:	5f                   	pop    %edi
801055b9:	5d                   	pop    %ebp
801055ba:	c3                   	ret    
801055bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055bf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801055c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801055c3:	85 c9                	test   %ecx,%ecx
801055c5:	0f 84 33 ff ff ff    	je     801054fe <sys_open+0x6e>
801055cb:	e9 5c ff ff ff       	jmp    8010552c <sys_open+0x9c>

801055d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055d6:	e8 05 d9 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055db:	83 ec 08             	sub    $0x8,%esp
801055de:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055e1:	50                   	push   %eax
801055e2:	6a 00                	push   $0x0
801055e4:	e8 f7 f6 ff ff       	call   80104ce0 <argstr>
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	85 c0                	test   %eax,%eax
801055ee:	78 30                	js     80105620 <sys_mkdir+0x50>
801055f0:	83 ec 0c             	sub    $0xc,%esp
801055f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055f6:	31 c9                	xor    %ecx,%ecx
801055f8:	ba 01 00 00 00       	mov    $0x1,%edx
801055fd:	6a 00                	push   $0x0
801055ff:	e8 7c f7 ff ff       	call   80104d80 <create>
80105604:	83 c4 10             	add    $0x10,%esp
80105607:	85 c0                	test   %eax,%eax
80105609:	74 15                	je     80105620 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010560b:	83 ec 0c             	sub    $0xc,%esp
8010560e:	50                   	push   %eax
8010560f:	e8 ac c3 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105614:	e8 37 d9 ff ff       	call   80102f50 <end_op>
  return 0;
80105619:	83 c4 10             	add    $0x10,%esp
8010561c:	31 c0                	xor    %eax,%eax
}
8010561e:	c9                   	leave  
8010561f:	c3                   	ret    
    end_op();
80105620:	e8 2b d9 ff ff       	call   80102f50 <end_op>
    return -1;
80105625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010562a:	c9                   	leave  
8010562b:	c3                   	ret    
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_mknod>:

int
sys_mknod(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105636:	e8 a5 d8 ff ff       	call   80102ee0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010563b:	83 ec 08             	sub    $0x8,%esp
8010563e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105641:	50                   	push   %eax
80105642:	6a 00                	push   $0x0
80105644:	e8 97 f6 ff ff       	call   80104ce0 <argstr>
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	85 c0                	test   %eax,%eax
8010564e:	78 60                	js     801056b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105650:	83 ec 08             	sub    $0x8,%esp
80105653:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105656:	50                   	push   %eax
80105657:	6a 01                	push   $0x1
80105659:	e8 d2 f5 ff ff       	call   80104c30 <argint>
  if((argstr(0, &path)) < 0 ||
8010565e:	83 c4 10             	add    $0x10,%esp
80105661:	85 c0                	test   %eax,%eax
80105663:	78 4b                	js     801056b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105665:	83 ec 08             	sub    $0x8,%esp
80105668:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566b:	50                   	push   %eax
8010566c:	6a 02                	push   $0x2
8010566e:	e8 bd f5 ff ff       	call   80104c30 <argint>
     argint(1, &major) < 0 ||
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	78 36                	js     801056b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010567a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010567e:	83 ec 0c             	sub    $0xc,%esp
80105681:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105685:	ba 03 00 00 00       	mov    $0x3,%edx
8010568a:	50                   	push   %eax
8010568b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010568e:	e8 ed f6 ff ff       	call   80104d80 <create>
     argint(2, &minor) < 0 ||
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 c0                	test   %eax,%eax
80105698:	74 16                	je     801056b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010569a:	83 ec 0c             	sub    $0xc,%esp
8010569d:	50                   	push   %eax
8010569e:	e8 1d c3 ff ff       	call   801019c0 <iunlockput>
  end_op();
801056a3:	e8 a8 d8 ff ff       	call   80102f50 <end_op>
  return 0;
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	31 c0                	xor    %eax,%eax
}
801056ad:	c9                   	leave  
801056ae:	c3                   	ret    
801056af:	90                   	nop
    end_op();
801056b0:	e8 9b d8 ff ff       	call   80102f50 <end_op>
    return -1;
801056b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ba:	c9                   	leave  
801056bb:	c3                   	ret    
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_chdir>:

int
sys_chdir(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	56                   	push   %esi
801056c4:	53                   	push   %ebx
801056c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056c8:	e8 63 e4 ff ff       	call   80103b30 <myproc>
801056cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056cf:	e8 0c d8 ff ff       	call   80102ee0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056d4:	83 ec 08             	sub    $0x8,%esp
801056d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056da:	50                   	push   %eax
801056db:	6a 00                	push   $0x0
801056dd:	e8 fe f5 ff ff       	call   80104ce0 <argstr>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	78 77                	js     80105760 <sys_chdir+0xa0>
801056e9:	83 ec 0c             	sub    $0xc,%esp
801056ec:	ff 75 f4             	pushl  -0xc(%ebp)
801056ef:	e8 dc c8 ff ff       	call   80101fd0 <namei>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	89 c3                	mov    %eax,%ebx
801056f9:	85 c0                	test   %eax,%eax
801056fb:	74 63                	je     80105760 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056fd:	83 ec 0c             	sub    $0xc,%esp
80105700:	50                   	push   %eax
80105701:	e8 2a c0 ff ff       	call   80101730 <ilock>
  if(ip->type != T_DIR){
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010570e:	75 30                	jne    80105740 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	53                   	push   %ebx
80105714:	e8 f7 c0 ff ff       	call   80101810 <iunlock>
  iput(curproc->cwd);
80105719:	58                   	pop    %eax
8010571a:	ff 76 68             	pushl  0x68(%esi)
8010571d:	e8 3e c1 ff ff       	call   80101860 <iput>
  end_op();
80105722:	e8 29 d8 ff ff       	call   80102f50 <end_op>
  curproc->cwd = ip;
80105727:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	31 c0                	xor    %eax,%eax
}
8010572f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105732:	5b                   	pop    %ebx
80105733:	5e                   	pop    %esi
80105734:	5d                   	pop    %ebp
80105735:	c3                   	ret    
80105736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	53                   	push   %ebx
80105744:	e8 77 c2 ff ff       	call   801019c0 <iunlockput>
    end_op();
80105749:	e8 02 d8 ff ff       	call   80102f50 <end_op>
    return -1;
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105756:	eb d7                	jmp    8010572f <sys_chdir+0x6f>
80105758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010575f:	90                   	nop
    end_op();
80105760:	e8 eb d7 ff ff       	call   80102f50 <end_op>
    return -1;
80105765:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576a:	eb c3                	jmp    8010572f <sys_chdir+0x6f>
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_exec>:

int
sys_exec(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105775:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010577b:	53                   	push   %ebx
8010577c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105782:	50                   	push   %eax
80105783:	6a 00                	push   $0x0
80105785:	e8 56 f5 ff ff       	call   80104ce0 <argstr>
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	85 c0                	test   %eax,%eax
8010578f:	0f 88 87 00 00 00    	js     8010581c <sys_exec+0xac>
80105795:	83 ec 08             	sub    $0x8,%esp
80105798:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010579e:	50                   	push   %eax
8010579f:	6a 01                	push   $0x1
801057a1:	e8 8a f4 ff ff       	call   80104c30 <argint>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	85 c0                	test   %eax,%eax
801057ab:	78 6f                	js     8010581c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057ad:	83 ec 04             	sub    $0x4,%esp
801057b0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801057b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057b8:	68 80 00 00 00       	push   $0x80
801057bd:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801057c3:	6a 00                	push   $0x0
801057c5:	50                   	push   %eax
801057c6:	e8 85 f1 ff ff       	call   80104950 <memset>
801057cb:	83 c4 10             	add    $0x10,%esp
801057ce:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057d0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801057d6:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801057dd:	83 ec 08             	sub    $0x8,%esp
801057e0:	57                   	push   %edi
801057e1:	01 f0                	add    %esi,%eax
801057e3:	50                   	push   %eax
801057e4:	e8 a7 f3 ff ff       	call   80104b90 <fetchint>
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	85 c0                	test   %eax,%eax
801057ee:	78 2c                	js     8010581c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801057f0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057f6:	85 c0                	test   %eax,%eax
801057f8:	74 36                	je     80105830 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057fa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105800:	83 ec 08             	sub    $0x8,%esp
80105803:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105806:	52                   	push   %edx
80105807:	50                   	push   %eax
80105808:	e8 c3 f3 ff ff       	call   80104bd0 <fetchstr>
8010580d:	83 c4 10             	add    $0x10,%esp
80105810:	85 c0                	test   %eax,%eax
80105812:	78 08                	js     8010581c <sys_exec+0xac>
  for(i=0;; i++){
80105814:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105817:	83 fb 20             	cmp    $0x20,%ebx
8010581a:	75 b4                	jne    801057d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010581c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010581f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105824:	5b                   	pop    %ebx
80105825:	5e                   	pop    %esi
80105826:	5f                   	pop    %edi
80105827:	5d                   	pop    %ebp
80105828:	c3                   	ret    
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105839:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105840:	00 00 00 00 
  return exec(path, argv);
80105844:	50                   	push   %eax
80105845:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010584b:	e8 30 b2 ff ff       	call   80100a80 <exec>
80105850:	83 c4 10             	add    $0x10,%esp
}
80105853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105856:	5b                   	pop    %ebx
80105857:	5e                   	pop    %esi
80105858:	5f                   	pop    %edi
80105859:	5d                   	pop    %ebp
8010585a:	c3                   	ret    
8010585b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010585f:	90                   	nop

80105860 <sys_pipe>:

int
sys_pipe(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105865:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105868:	53                   	push   %ebx
80105869:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010586c:	6a 08                	push   $0x8
8010586e:	50                   	push   %eax
8010586f:	6a 00                	push   $0x0
80105871:	e8 0a f4 ff ff       	call   80104c80 <argptr>
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	85 c0                	test   %eax,%eax
8010587b:	78 4a                	js     801058c7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010587d:	83 ec 08             	sub    $0x8,%esp
80105880:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105883:	50                   	push   %eax
80105884:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105887:	50                   	push   %eax
80105888:	e8 03 dd ff ff       	call   80103590 <pipealloc>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	78 33                	js     801058c7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105894:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105897:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105899:	e8 92 e2 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010589e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058a0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058a4:	85 f6                	test   %esi,%esi
801058a6:	74 28                	je     801058d0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058a8:	83 c3 01             	add    $0x1,%ebx
801058ab:	83 fb 10             	cmp    $0x10,%ebx
801058ae:	75 f0                	jne    801058a0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801058b0:	83 ec 0c             	sub    $0xc,%esp
801058b3:	ff 75 e0             	pushl  -0x20(%ebp)
801058b6:	e8 15 b6 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
801058bb:	58                   	pop    %eax
801058bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801058bf:	e8 0c b6 ff ff       	call   80100ed0 <fileclose>
    return -1;
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cc:	eb 53                	jmp    80105921 <sys_pipe+0xc1>
801058ce:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801058d0:	8d 73 08             	lea    0x8(%ebx),%esi
801058d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058da:	e8 51 e2 ff ff       	call   80103b30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058df:	31 d2                	xor    %edx,%edx
801058e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801058e8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058ec:	85 c9                	test   %ecx,%ecx
801058ee:	74 20                	je     80105910 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801058f0:	83 c2 01             	add    $0x1,%edx
801058f3:	83 fa 10             	cmp    $0x10,%edx
801058f6:	75 f0                	jne    801058e8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801058f8:	e8 33 e2 ff ff       	call   80103b30 <myproc>
801058fd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105904:	00 
80105905:	eb a9                	jmp    801058b0 <sys_pipe+0x50>
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105910:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105914:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105917:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105919:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010591c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010591f:	31 c0                	xor    %eax,%eax
}
80105921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105924:	5b                   	pop    %ebx
80105925:	5e                   	pop    %esi
80105926:	5f                   	pop    %edi
80105927:	5d                   	pop    %ebp
80105928:	c3                   	ret    
80105929:	66 90                	xchg   %ax,%ax
8010592b:	66 90                	xchg   %ax,%ax
8010592d:	66 90                	xchg   %ax,%ax
8010592f:	90                   	nop

80105930 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105930:	e9 9b e3 ff ff       	jmp    80103cd0 <fork>
80105935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_exit>:
}

int
sys_exit(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 08             	sub    $0x8,%esp
  exit();
80105946:	e8 25 e6 ff ff       	call   80103f70 <exit>
  return 0;  // not reached
}
8010594b:	31 c0                	xor    %eax,%eax
8010594d:	c9                   	leave  
8010594e:	c3                   	ret    
8010594f:	90                   	nop

80105950 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105950:	e9 5b e8 ff ff       	jmp    801041b0 <wait>
80105955:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_kill>:
}

int
sys_kill(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105966:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105969:	50                   	push   %eax
8010596a:	6a 00                	push   $0x0
8010596c:	e8 bf f2 ff ff       	call   80104c30 <argint>
80105971:	83 c4 10             	add    $0x10,%esp
80105974:	85 c0                	test   %eax,%eax
80105976:	78 18                	js     80105990 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105978:	83 ec 0c             	sub    $0xc,%esp
8010597b:	ff 75 f4             	pushl  -0xc(%ebp)
8010597e:	e8 7d e9 ff ff       	call   80104300 <kill>
80105983:	83 c4 10             	add    $0x10,%esp
}
80105986:	c9                   	leave  
80105987:	c3                   	ret    
80105988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598f:	90                   	nop
80105990:	c9                   	leave  
    return -1;
80105991:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105996:	c3                   	ret    
80105997:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010599e:	66 90                	xchg   %ax,%ax

801059a0 <sys_getpid>:

int
sys_getpid(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059a6:	e8 85 e1 ff ff       	call   80103b30 <myproc>
801059ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801059ae:	c9                   	leave  
801059af:	c3                   	ret    

801059b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ba:	50                   	push   %eax
801059bb:	6a 00                	push   $0x0
801059bd:	e8 6e f2 ff ff       	call   80104c30 <argint>
801059c2:	83 c4 10             	add    $0x10,%esp
801059c5:	85 c0                	test   %eax,%eax
801059c7:	78 27                	js     801059f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059c9:	e8 62 e1 ff ff       	call   80103b30 <myproc>
  if(growproc(n) < 0)
801059ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059d1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059d3:	ff 75 f4             	pushl  -0xc(%ebp)
801059d6:	e8 75 e2 ff ff       	call   80103c50 <growproc>
801059db:	83 c4 10             	add    $0x10,%esp
801059de:	85 c0                	test   %eax,%eax
801059e0:	78 0e                	js     801059f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801059e2:	89 d8                	mov    %ebx,%eax
801059e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059e7:	c9                   	leave  
801059e8:	c3                   	ret    
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059f5:	eb eb                	jmp    801059e2 <sys_sbrk+0x32>
801059f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fe:	66 90                	xchg   %ax,%ax

80105a00 <sys_sleep>:

int
sys_sleep(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a0a:	50                   	push   %eax
80105a0b:	6a 00                	push   $0x0
80105a0d:	e8 1e f2 ff ff       	call   80104c30 <argint>
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	85 c0                	test   %eax,%eax
80105a17:	0f 88 8a 00 00 00    	js     80105aa7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a1d:	83 ec 0c             	sub    $0xc,%esp
80105a20:	68 60 4d 11 80       	push   $0x80114d60
80105a25:	e8 b6 ed ff ff       	call   801047e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a2d:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105a33:	83 c4 10             	add    $0x10,%esp
80105a36:	85 d2                	test   %edx,%edx
80105a38:	75 27                	jne    80105a61 <sys_sleep+0x61>
80105a3a:	eb 54                	jmp    80105a90 <sys_sleep+0x90>
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a40:	83 ec 08             	sub    $0x8,%esp
80105a43:	68 60 4d 11 80       	push   $0x80114d60
80105a48:	68 a0 55 11 80       	push   $0x801155a0
80105a4d:	e8 9e e6 ff ff       	call   801040f0 <sleep>
  while(ticks - ticks0 < n){
80105a52:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105a57:	83 c4 10             	add    $0x10,%esp
80105a5a:	29 d8                	sub    %ebx,%eax
80105a5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a5f:	73 2f                	jae    80105a90 <sys_sleep+0x90>
    if(myproc()->killed){
80105a61:	e8 ca e0 ff ff       	call   80103b30 <myproc>
80105a66:	8b 40 24             	mov    0x24(%eax),%eax
80105a69:	85 c0                	test   %eax,%eax
80105a6b:	74 d3                	je     80105a40 <sys_sleep+0x40>
      release(&tickslock);
80105a6d:	83 ec 0c             	sub    $0xc,%esp
80105a70:	68 60 4d 11 80       	push   $0x80114d60
80105a75:	e8 86 ee ff ff       	call   80104900 <release>
      return -1;
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a85:	c9                   	leave  
80105a86:	c3                   	ret    
80105a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	68 60 4d 11 80       	push   $0x80114d60
80105a98:	e8 63 ee ff ff       	call   80104900 <release>
  return 0;
80105a9d:	83 c4 10             	add    $0x10,%esp
80105aa0:	31 c0                	xor    %eax,%eax
}
80105aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aa5:	c9                   	leave  
80105aa6:	c3                   	ret    
    return -1;
80105aa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aac:	eb f4                	jmp    80105aa2 <sys_sleep+0xa2>
80105aae:	66 90                	xchg   %ax,%ax

80105ab0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	53                   	push   %ebx
80105ab4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ab7:	68 60 4d 11 80       	push   $0x80114d60
80105abc:	e8 1f ed ff ff       	call   801047e0 <acquire>
  xticks = ticks;
80105ac1:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
80105ac7:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105ace:	e8 2d ee ff ff       	call   80104900 <release>
  return xticks;
}
80105ad3:	89 d8                	mov    %ebx,%eax
80105ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad8:	c9                   	leave  
80105ad9:	c3                   	ret    
80105ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ae0 <sys_cps>:

int
sys_cps(void)
{
    return cps();
80105ae0:	e9 5b e9 ff ff       	jmp    80104440 <cps>
80105ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105af0 <sys_nps>:
}

int
sys_nps(void)
{
    return nps();
80105af0:	e9 1b ea ff ff       	jmp    80104510 <nps>
80105af5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b00 <sys_chpr>:
}

int
sys_chpr (void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if(argint(0, &pid) < 0)
80105b06:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b09:	50                   	push   %eax
80105b0a:	6a 00                	push   $0x0
80105b0c:	e8 1f f1 ff ff       	call   80104c30 <argint>
80105b11:	83 c4 10             	add    $0x10,%esp
80105b14:	85 c0                	test   %eax,%eax
80105b16:	78 28                	js     80105b40 <sys_chpr+0x40>
    return -1;
  if(argint(1, &pr) < 0)
80105b18:	83 ec 08             	sub    $0x8,%esp
80105b1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b1e:	50                   	push   %eax
80105b1f:	6a 01                	push   $0x1
80105b21:	e8 0a f1 ff ff       	call   80104c30 <argint>
80105b26:	83 c4 10             	add    $0x10,%esp
80105b29:	85 c0                	test   %eax,%eax
80105b2b:	78 13                	js     80105b40 <sys_chpr+0x40>
    return -1;

  return chpr ( pid, pr );
80105b2d:	83 ec 08             	sub    $0x8,%esp
80105b30:	ff 75 f4             	pushl  -0xc(%ebp)
80105b33:	ff 75 f0             	pushl  -0x10(%ebp)
80105b36:	e8 45 ea ff ff       	call   80104580 <chpr>
80105b3b:	83 c4 10             	add    $0x10,%esp
}
80105b3e:	c9                   	leave  
80105b3f:	c3                   	ret    
80105b40:	c9                   	leave  
    return -1;
80105b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b46:	c3                   	ret    
80105b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <sys_pfs>:

int sys_pfs(void)
{
    return pfs();
80105b50:	e9 bb c4 ff ff       	jmp    80102010 <pfs>

80105b55 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b55:	1e                   	push   %ds
  pushl %es
80105b56:	06                   	push   %es
  pushl %fs
80105b57:	0f a0                	push   %fs
  pushl %gs
80105b59:	0f a8                	push   %gs
  pushal
80105b5b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b5c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b60:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b62:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b64:	54                   	push   %esp
  call trap
80105b65:	e8 c6 00 00 00       	call   80105c30 <trap>
  addl $4, %esp
80105b6a:	83 c4 04             	add    $0x4,%esp

80105b6d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b6d:	61                   	popa   
  popl %gs
80105b6e:	0f a9                	pop    %gs
  popl %fs
80105b70:	0f a1                	pop    %fs
  popl %es
80105b72:	07                   	pop    %es
  popl %ds
80105b73:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b74:	83 c4 08             	add    $0x8,%esp
  iret
80105b77:	cf                   	iret   
80105b78:	66 90                	xchg   %ax,%ax
80105b7a:	66 90                	xchg   %ax,%ax
80105b7c:	66 90                	xchg   %ax,%ax
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b81:	31 c0                	xor    %eax,%eax
{
80105b83:	89 e5                	mov    %esp,%ebp
80105b85:	83 ec 08             	sub    $0x8,%esp
80105b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b90:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b97:	c7 04 c5 a2 4d 11 80 	movl   $0x8e000008,-0x7feeb25e(,%eax,8)
80105b9e:	08 00 00 8e 
80105ba2:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105ba9:	80 
80105baa:	c1 ea 10             	shr    $0x10,%edx
80105bad:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
80105bb4:	80 
  for(i = 0; i < 256; i++)
80105bb5:	83 c0 01             	add    $0x1,%eax
80105bb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105bbd:	75 d1                	jne    80105b90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105bbf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bc2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105bc7:	c7 05 a2 4f 11 80 08 	movl   $0xef000008,0x80114fa2
80105bce:	00 00 ef 
  initlock(&tickslock, "time");
80105bd1:	68 e9 7c 10 80       	push   $0x80107ce9
80105bd6:	68 60 4d 11 80       	push   $0x80114d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bdb:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105be1:	c1 e8 10             	shr    $0x10,%eax
80105be4:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6
  initlock(&tickslock, "time");
80105bea:	e8 f1 ea ff ff       	call   801046e0 <initlock>
}
80105bef:	83 c4 10             	add    $0x10,%esp
80105bf2:	c9                   	leave  
80105bf3:	c3                   	ret    
80105bf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop

80105c00 <idtinit>:

void
idtinit(void)
{
80105c00:	55                   	push   %ebp
  pd[0] = size-1;
80105c01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105c06:	89 e5                	mov    %esp,%ebp
80105c08:	83 ec 10             	sub    $0x10,%esp
80105c0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105c0f:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
80105c14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105c18:	c1 e8 10             	shr    $0x10,%eax
80105c1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105c1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105c22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105c25:	c9                   	leave  
80105c26:	c3                   	ret    
80105c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c2e:	66 90                	xchg   %ax,%ax

80105c30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c30:	55                   	push   %ebp
80105c31:	89 e5                	mov    %esp,%ebp
80105c33:	57                   	push   %edi
80105c34:	56                   	push   %esi
80105c35:	53                   	push   %ebx
80105c36:	83 ec 1c             	sub    $0x1c,%esp
80105c39:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105c3c:	8b 47 30             	mov    0x30(%edi),%eax
80105c3f:	83 f8 40             	cmp    $0x40,%eax
80105c42:	0f 84 b8 01 00 00    	je     80105e00 <trap+0x1d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c48:	83 e8 20             	sub    $0x20,%eax
80105c4b:	83 f8 1f             	cmp    $0x1f,%eax
80105c4e:	77 10                	ja     80105c60 <trap+0x30>
80105c50:	ff 24 85 90 7d 10 80 	jmp    *-0x7fef8270(,%eax,4)
80105c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c60:	e8 cb de ff ff       	call   80103b30 <myproc>
80105c65:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c68:	85 c0                	test   %eax,%eax
80105c6a:	0f 84 17 02 00 00    	je     80105e87 <trap+0x257>
80105c70:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105c74:	0f 84 0d 02 00 00    	je     80105e87 <trap+0x257>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c7a:	0f 20 d1             	mov    %cr2,%ecx
80105c7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c80:	e8 8b de ff ff       	call   80103b10 <cpuid>
80105c85:	8b 77 30             	mov    0x30(%edi),%esi
80105c88:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c8b:	8b 47 34             	mov    0x34(%edi),%eax
80105c8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105c91:	e8 9a de ff ff       	call   80103b30 <myproc>
80105c96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c99:	e8 92 de ff ff       	call   80103b30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ca1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ca4:	51                   	push   %ecx
80105ca5:	53                   	push   %ebx
80105ca6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105ca7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105caa:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105cad:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105cb0:	56                   	push   %esi
80105cb1:	52                   	push   %edx
80105cb2:	ff 70 10             	pushl  0x10(%eax)
80105cb5:	68 4c 7d 10 80       	push   $0x80107d4c
80105cba:	e8 f1 a9 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105cbf:	83 c4 20             	add    $0x20,%esp
80105cc2:	e8 69 de ff ff       	call   80103b30 <myproc>
80105cc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cce:	e8 5d de ff ff       	call   80103b30 <myproc>
80105cd3:	85 c0                	test   %eax,%eax
80105cd5:	74 1d                	je     80105cf4 <trap+0xc4>
80105cd7:	e8 54 de ff ff       	call   80103b30 <myproc>
80105cdc:	8b 50 24             	mov    0x24(%eax),%edx
80105cdf:	85 d2                	test   %edx,%edx
80105ce1:	74 11                	je     80105cf4 <trap+0xc4>
80105ce3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ce7:	83 e0 03             	and    $0x3,%eax
80105cea:	66 83 f8 03          	cmp    $0x3,%ax
80105cee:	0f 84 44 01 00 00    	je     80105e38 <trap+0x208>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105cf4:	e8 37 de ff ff       	call   80103b30 <myproc>
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	74 0b                	je     80105d08 <trap+0xd8>
80105cfd:	e8 2e de ff ff       	call   80103b30 <myproc>
80105d02:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105d06:	74 38                	je     80105d40 <trap+0x110>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d08:	e8 23 de ff ff       	call   80103b30 <myproc>
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	74 1d                	je     80105d2e <trap+0xfe>
80105d11:	e8 1a de ff ff       	call   80103b30 <myproc>
80105d16:	8b 40 24             	mov    0x24(%eax),%eax
80105d19:	85 c0                	test   %eax,%eax
80105d1b:	74 11                	je     80105d2e <trap+0xfe>
80105d1d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105d21:	83 e0 03             	and    $0x3,%eax
80105d24:	66 83 f8 03          	cmp    $0x3,%ax
80105d28:	0f 84 fb 00 00 00    	je     80105e29 <trap+0x1f9>
    exit();
}
80105d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d31:	5b                   	pop    %ebx
80105d32:	5e                   	pop    %esi
80105d33:	5f                   	pop    %edi
80105d34:	5d                   	pop    %ebp
80105d35:	c3                   	ret    
80105d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d40:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105d44:	75 c2                	jne    80105d08 <trap+0xd8>
    yield();
80105d46:	e8 55 e3 ff ff       	call   801040a0 <yield>
80105d4b:	eb bb                	jmp    80105d08 <trap+0xd8>
80105d4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105d50:	e8 bb dd ff ff       	call   80103b10 <cpuid>
80105d55:	85 c0                	test   %eax,%eax
80105d57:	0f 84 eb 00 00 00    	je     80105e48 <trap+0x218>
    lapiceoi();
80105d5d:	e8 2e cd ff ff       	call   80102a90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d62:	e8 c9 dd ff ff       	call   80103b30 <myproc>
80105d67:	85 c0                	test   %eax,%eax
80105d69:	0f 85 68 ff ff ff    	jne    80105cd7 <trap+0xa7>
80105d6f:	eb 83                	jmp    80105cf4 <trap+0xc4>
80105d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d78:	e8 d3 cb ff ff       	call   80102950 <kbdintr>
    lapiceoi();
80105d7d:	e8 0e cd ff ff       	call   80102a90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d82:	e8 a9 dd ff ff       	call   80103b30 <myproc>
80105d87:	85 c0                	test   %eax,%eax
80105d89:	0f 85 48 ff ff ff    	jne    80105cd7 <trap+0xa7>
80105d8f:	e9 60 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d98:	e8 83 02 00 00       	call   80106020 <uartintr>
    lapiceoi();
80105d9d:	e8 ee cc ff ff       	call   80102a90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da2:	e8 89 dd ff ff       	call   80103b30 <myproc>
80105da7:	85 c0                	test   %eax,%eax
80105da9:	0f 85 28 ff ff ff    	jne    80105cd7 <trap+0xa7>
80105daf:	e9 40 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105db8:	8b 77 38             	mov    0x38(%edi),%esi
80105dbb:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105dbf:	e8 4c dd ff ff       	call   80103b10 <cpuid>
80105dc4:	56                   	push   %esi
80105dc5:	53                   	push   %ebx
80105dc6:	50                   	push   %eax
80105dc7:	68 f4 7c 10 80       	push   $0x80107cf4
80105dcc:	e8 df a8 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105dd1:	e8 ba cc ff ff       	call   80102a90 <lapiceoi>
    break;
80105dd6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd9:	e8 52 dd ff ff       	call   80103b30 <myproc>
80105dde:	85 c0                	test   %eax,%eax
80105de0:	0f 85 f1 fe ff ff    	jne    80105cd7 <trap+0xa7>
80105de6:	e9 09 ff ff ff       	jmp    80105cf4 <trap+0xc4>
80105deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
    ideintr();
80105df0:	e8 ab c5 ff ff       	call   801023a0 <ideintr>
80105df5:	e9 63 ff ff ff       	jmp    80105d5d <trap+0x12d>
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105e00:	e8 2b dd ff ff       	call   80103b30 <myproc>
80105e05:	8b 58 24             	mov    0x24(%eax),%ebx
80105e08:	85 db                	test   %ebx,%ebx
80105e0a:	75 74                	jne    80105e80 <trap+0x250>
    myproc()->tf = tf;
80105e0c:	e8 1f dd ff ff       	call   80103b30 <myproc>
80105e11:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105e14:	e8 07 ef ff ff       	call   80104d20 <syscall>
    if(myproc()->killed)
80105e19:	e8 12 dd ff ff       	call   80103b30 <myproc>
80105e1e:	8b 48 24             	mov    0x24(%eax),%ecx
80105e21:	85 c9                	test   %ecx,%ecx
80105e23:	0f 84 05 ff ff ff    	je     80105d2e <trap+0xfe>
}
80105e29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e2c:	5b                   	pop    %ebx
80105e2d:	5e                   	pop    %esi
80105e2e:	5f                   	pop    %edi
80105e2f:	5d                   	pop    %ebp
      exit();
80105e30:	e9 3b e1 ff ff       	jmp    80103f70 <exit>
80105e35:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105e38:	e8 33 e1 ff ff       	call   80103f70 <exit>
80105e3d:	e9 b2 fe ff ff       	jmp    80105cf4 <trap+0xc4>
80105e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e48:	83 ec 0c             	sub    $0xc,%esp
80105e4b:	68 60 4d 11 80       	push   $0x80114d60
80105e50:	e8 8b e9 ff ff       	call   801047e0 <acquire>
      wakeup(&ticks);
80105e55:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)
      ticks++;
80105e5c:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
80105e63:	e8 38 e4 ff ff       	call   801042a0 <wakeup>
      release(&tickslock);
80105e68:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105e6f:	e8 8c ea ff ff       	call   80104900 <release>
80105e74:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105e77:	e9 e1 fe ff ff       	jmp    80105d5d <trap+0x12d>
80105e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105e80:	e8 eb e0 ff ff       	call   80103f70 <exit>
80105e85:	eb 85                	jmp    80105e0c <trap+0x1dc>
80105e87:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e8a:	e8 81 dc ff ff       	call   80103b10 <cpuid>
80105e8f:	83 ec 0c             	sub    $0xc,%esp
80105e92:	56                   	push   %esi
80105e93:	53                   	push   %ebx
80105e94:	50                   	push   %eax
80105e95:	ff 77 30             	pushl  0x30(%edi)
80105e98:	68 18 7d 10 80       	push   $0x80107d18
80105e9d:	e8 0e a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105ea2:	83 c4 14             	add    $0x14,%esp
80105ea5:	68 ee 7c 10 80       	push   $0x80107cee
80105eaa:	e8 e1 a4 ff ff       	call   80100390 <panic>
80105eaf:	90                   	nop

80105eb0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105eb0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	74 17                	je     80105ed0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eb9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ebe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ebf:	a8 01                	test   $0x1,%al
80105ec1:	74 0d                	je     80105ed0 <uartgetc+0x20>
80105ec3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ec8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ec9:	0f b6 c0             	movzbl %al,%eax
80105ecc:	c3                   	ret    
80105ecd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed5:	c3                   	ret    
80105ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edd:	8d 76 00             	lea    0x0(%esi),%esi

80105ee0 <uartputc.part.0>:
uartputc(int c)
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	57                   	push   %edi
80105ee4:	89 c7                	mov    %eax,%edi
80105ee6:	56                   	push   %esi
80105ee7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105eec:	53                   	push   %ebx
80105eed:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ef2:	83 ec 0c             	sub    $0xc,%esp
80105ef5:	eb 1b                	jmp    80105f12 <uartputc.part.0+0x32>
80105ef7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efe:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105f00:	83 ec 0c             	sub    $0xc,%esp
80105f03:	6a 0a                	push   $0xa
80105f05:	e8 a6 cb ff ff       	call   80102ab0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f0a:	83 c4 10             	add    $0x10,%esp
80105f0d:	83 eb 01             	sub    $0x1,%ebx
80105f10:	74 07                	je     80105f19 <uartputc.part.0+0x39>
80105f12:	89 f2                	mov    %esi,%edx
80105f14:	ec                   	in     (%dx),%al
80105f15:	a8 20                	test   $0x20,%al
80105f17:	74 e7                	je     80105f00 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f19:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f1e:	89 f8                	mov    %edi,%eax
80105f20:	ee                   	out    %al,(%dx)
}
80105f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f24:	5b                   	pop    %ebx
80105f25:	5e                   	pop    %esi
80105f26:	5f                   	pop    %edi
80105f27:	5d                   	pop    %ebp
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f30 <uartinit>:
{
80105f30:	55                   	push   %ebp
80105f31:	31 c9                	xor    %ecx,%ecx
80105f33:	89 c8                	mov    %ecx,%eax
80105f35:	89 e5                	mov    %esp,%ebp
80105f37:	57                   	push   %edi
80105f38:	56                   	push   %esi
80105f39:	53                   	push   %ebx
80105f3a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f3f:	89 da                	mov    %ebx,%edx
80105f41:	83 ec 0c             	sub    $0xc,%esp
80105f44:	ee                   	out    %al,(%dx)
80105f45:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f4f:	89 fa                	mov    %edi,%edx
80105f51:	ee                   	out    %al,(%dx)
80105f52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f5c:	ee                   	out    %al,(%dx)
80105f5d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f62:	89 c8                	mov    %ecx,%eax
80105f64:	89 f2                	mov    %esi,%edx
80105f66:	ee                   	out    %al,(%dx)
80105f67:	b8 03 00 00 00       	mov    $0x3,%eax
80105f6c:	89 fa                	mov    %edi,%edx
80105f6e:	ee                   	out    %al,(%dx)
80105f6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f74:	89 c8                	mov    %ecx,%eax
80105f76:	ee                   	out    %al,(%dx)
80105f77:	b8 01 00 00 00       	mov    $0x1,%eax
80105f7c:	89 f2                	mov    %esi,%edx
80105f7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f84:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f85:	3c ff                	cmp    $0xff,%al
80105f87:	74 56                	je     80105fdf <uartinit+0xaf>
  uart = 1;
80105f89:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105f90:	00 00 00 
80105f93:	89 da                	mov    %ebx,%edx
80105f95:	ec                   	in     (%dx),%al
80105f96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f9b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f9c:	83 ec 08             	sub    $0x8,%esp
80105f9f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105fa4:	bb 10 7e 10 80       	mov    $0x80107e10,%ebx
  ioapicenable(IRQ_COM1, 0);
80105fa9:	6a 00                	push   $0x0
80105fab:	6a 04                	push   $0x4
80105fad:	e8 3e c6 ff ff       	call   801025f0 <ioapicenable>
80105fb2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105fb5:	b8 78 00 00 00       	mov    $0x78,%eax
80105fba:	eb 08                	jmp    80105fc4 <uartinit+0x94>
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fc0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105fc4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105fca:	85 d2                	test   %edx,%edx
80105fcc:	74 08                	je     80105fd6 <uartinit+0xa6>
    uartputc(*p);
80105fce:	0f be c0             	movsbl %al,%eax
80105fd1:	e8 0a ff ff ff       	call   80105ee0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105fd6:	89 f0                	mov    %esi,%eax
80105fd8:	83 c3 01             	add    $0x1,%ebx
80105fdb:	84 c0                	test   %al,%al
80105fdd:	75 e1                	jne    80105fc0 <uartinit+0x90>
}
80105fdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe2:	5b                   	pop    %ebx
80105fe3:	5e                   	pop    %esi
80105fe4:	5f                   	pop    %edi
80105fe5:	5d                   	pop    %ebp
80105fe6:	c3                   	ret    
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <uartputc>:
{
80105ff0:	55                   	push   %ebp
  if(!uart)
80105ff1:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105ff7:	89 e5                	mov    %esp,%ebp
80105ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105ffc:	85 d2                	test   %edx,%edx
80105ffe:	74 10                	je     80106010 <uartputc+0x20>
}
80106000:	5d                   	pop    %ebp
80106001:	e9 da fe ff ff       	jmp    80105ee0 <uartputc.part.0>
80106006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600d:	8d 76 00             	lea    0x0(%esi),%esi
80106010:	5d                   	pop    %ebp
80106011:	c3                   	ret    
80106012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106020 <uartintr>:

void
uartintr(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106026:	68 b0 5e 10 80       	push   $0x80105eb0
8010602b:	e8 30 a8 ff ff       	call   80100860 <consoleintr>
}
80106030:	83 c4 10             	add    $0x10,%esp
80106033:	c9                   	leave  
80106034:	c3                   	ret    

80106035 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $0
80106037:	6a 00                	push   $0x0
  jmp alltraps
80106039:	e9 17 fb ff ff       	jmp    80105b55 <alltraps>

8010603e <vector1>:
.globl vector1
vector1:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $1
80106040:	6a 01                	push   $0x1
  jmp alltraps
80106042:	e9 0e fb ff ff       	jmp    80105b55 <alltraps>

80106047 <vector2>:
.globl vector2
vector2:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $2
80106049:	6a 02                	push   $0x2
  jmp alltraps
8010604b:	e9 05 fb ff ff       	jmp    80105b55 <alltraps>

80106050 <vector3>:
.globl vector3
vector3:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $3
80106052:	6a 03                	push   $0x3
  jmp alltraps
80106054:	e9 fc fa ff ff       	jmp    80105b55 <alltraps>

80106059 <vector4>:
.globl vector4
vector4:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $4
8010605b:	6a 04                	push   $0x4
  jmp alltraps
8010605d:	e9 f3 fa ff ff       	jmp    80105b55 <alltraps>

80106062 <vector5>:
.globl vector5
vector5:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $5
80106064:	6a 05                	push   $0x5
  jmp alltraps
80106066:	e9 ea fa ff ff       	jmp    80105b55 <alltraps>

8010606b <vector6>:
.globl vector6
vector6:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $6
8010606d:	6a 06                	push   $0x6
  jmp alltraps
8010606f:	e9 e1 fa ff ff       	jmp    80105b55 <alltraps>

80106074 <vector7>:
.globl vector7
vector7:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $7
80106076:	6a 07                	push   $0x7
  jmp alltraps
80106078:	e9 d8 fa ff ff       	jmp    80105b55 <alltraps>

8010607d <vector8>:
.globl vector8
vector8:
  pushl $8
8010607d:	6a 08                	push   $0x8
  jmp alltraps
8010607f:	e9 d1 fa ff ff       	jmp    80105b55 <alltraps>

80106084 <vector9>:
.globl vector9
vector9:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $9
80106086:	6a 09                	push   $0x9
  jmp alltraps
80106088:	e9 c8 fa ff ff       	jmp    80105b55 <alltraps>

8010608d <vector10>:
.globl vector10
vector10:
  pushl $10
8010608d:	6a 0a                	push   $0xa
  jmp alltraps
8010608f:	e9 c1 fa ff ff       	jmp    80105b55 <alltraps>

80106094 <vector11>:
.globl vector11
vector11:
  pushl $11
80106094:	6a 0b                	push   $0xb
  jmp alltraps
80106096:	e9 ba fa ff ff       	jmp    80105b55 <alltraps>

8010609b <vector12>:
.globl vector12
vector12:
  pushl $12
8010609b:	6a 0c                	push   $0xc
  jmp alltraps
8010609d:	e9 b3 fa ff ff       	jmp    80105b55 <alltraps>

801060a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801060a2:	6a 0d                	push   $0xd
  jmp alltraps
801060a4:	e9 ac fa ff ff       	jmp    80105b55 <alltraps>

801060a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801060a9:	6a 0e                	push   $0xe
  jmp alltraps
801060ab:	e9 a5 fa ff ff       	jmp    80105b55 <alltraps>

801060b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $15
801060b2:	6a 0f                	push   $0xf
  jmp alltraps
801060b4:	e9 9c fa ff ff       	jmp    80105b55 <alltraps>

801060b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $16
801060bb:	6a 10                	push   $0x10
  jmp alltraps
801060bd:	e9 93 fa ff ff       	jmp    80105b55 <alltraps>

801060c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060c2:	6a 11                	push   $0x11
  jmp alltraps
801060c4:	e9 8c fa ff ff       	jmp    80105b55 <alltraps>

801060c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $18
801060cb:	6a 12                	push   $0x12
  jmp alltraps
801060cd:	e9 83 fa ff ff       	jmp    80105b55 <alltraps>

801060d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $19
801060d4:	6a 13                	push   $0x13
  jmp alltraps
801060d6:	e9 7a fa ff ff       	jmp    80105b55 <alltraps>

801060db <vector20>:
.globl vector20
vector20:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $20
801060dd:	6a 14                	push   $0x14
  jmp alltraps
801060df:	e9 71 fa ff ff       	jmp    80105b55 <alltraps>

801060e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $21
801060e6:	6a 15                	push   $0x15
  jmp alltraps
801060e8:	e9 68 fa ff ff       	jmp    80105b55 <alltraps>

801060ed <vector22>:
.globl vector22
vector22:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $22
801060ef:	6a 16                	push   $0x16
  jmp alltraps
801060f1:	e9 5f fa ff ff       	jmp    80105b55 <alltraps>

801060f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $23
801060f8:	6a 17                	push   $0x17
  jmp alltraps
801060fa:	e9 56 fa ff ff       	jmp    80105b55 <alltraps>

801060ff <vector24>:
.globl vector24
vector24:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $24
80106101:	6a 18                	push   $0x18
  jmp alltraps
80106103:	e9 4d fa ff ff       	jmp    80105b55 <alltraps>

80106108 <vector25>:
.globl vector25
vector25:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $25
8010610a:	6a 19                	push   $0x19
  jmp alltraps
8010610c:	e9 44 fa ff ff       	jmp    80105b55 <alltraps>

80106111 <vector26>:
.globl vector26
vector26:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $26
80106113:	6a 1a                	push   $0x1a
  jmp alltraps
80106115:	e9 3b fa ff ff       	jmp    80105b55 <alltraps>

8010611a <vector27>:
.globl vector27
vector27:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $27
8010611c:	6a 1b                	push   $0x1b
  jmp alltraps
8010611e:	e9 32 fa ff ff       	jmp    80105b55 <alltraps>

80106123 <vector28>:
.globl vector28
vector28:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $28
80106125:	6a 1c                	push   $0x1c
  jmp alltraps
80106127:	e9 29 fa ff ff       	jmp    80105b55 <alltraps>

8010612c <vector29>:
.globl vector29
vector29:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $29
8010612e:	6a 1d                	push   $0x1d
  jmp alltraps
80106130:	e9 20 fa ff ff       	jmp    80105b55 <alltraps>

80106135 <vector30>:
.globl vector30
vector30:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $30
80106137:	6a 1e                	push   $0x1e
  jmp alltraps
80106139:	e9 17 fa ff ff       	jmp    80105b55 <alltraps>

8010613e <vector31>:
.globl vector31
vector31:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $31
80106140:	6a 1f                	push   $0x1f
  jmp alltraps
80106142:	e9 0e fa ff ff       	jmp    80105b55 <alltraps>

80106147 <vector32>:
.globl vector32
vector32:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $32
80106149:	6a 20                	push   $0x20
  jmp alltraps
8010614b:	e9 05 fa ff ff       	jmp    80105b55 <alltraps>

80106150 <vector33>:
.globl vector33
vector33:
  pushl $0
80106150:	6a 00                	push   $0x0
  pushl $33
80106152:	6a 21                	push   $0x21
  jmp alltraps
80106154:	e9 fc f9 ff ff       	jmp    80105b55 <alltraps>

80106159 <vector34>:
.globl vector34
vector34:
  pushl $0
80106159:	6a 00                	push   $0x0
  pushl $34
8010615b:	6a 22                	push   $0x22
  jmp alltraps
8010615d:	e9 f3 f9 ff ff       	jmp    80105b55 <alltraps>

80106162 <vector35>:
.globl vector35
vector35:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $35
80106164:	6a 23                	push   $0x23
  jmp alltraps
80106166:	e9 ea f9 ff ff       	jmp    80105b55 <alltraps>

8010616b <vector36>:
.globl vector36
vector36:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $36
8010616d:	6a 24                	push   $0x24
  jmp alltraps
8010616f:	e9 e1 f9 ff ff       	jmp    80105b55 <alltraps>

80106174 <vector37>:
.globl vector37
vector37:
  pushl $0
80106174:	6a 00                	push   $0x0
  pushl $37
80106176:	6a 25                	push   $0x25
  jmp alltraps
80106178:	e9 d8 f9 ff ff       	jmp    80105b55 <alltraps>

8010617d <vector38>:
.globl vector38
vector38:
  pushl $0
8010617d:	6a 00                	push   $0x0
  pushl $38
8010617f:	6a 26                	push   $0x26
  jmp alltraps
80106181:	e9 cf f9 ff ff       	jmp    80105b55 <alltraps>

80106186 <vector39>:
.globl vector39
vector39:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $39
80106188:	6a 27                	push   $0x27
  jmp alltraps
8010618a:	e9 c6 f9 ff ff       	jmp    80105b55 <alltraps>

8010618f <vector40>:
.globl vector40
vector40:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $40
80106191:	6a 28                	push   $0x28
  jmp alltraps
80106193:	e9 bd f9 ff ff       	jmp    80105b55 <alltraps>

80106198 <vector41>:
.globl vector41
vector41:
  pushl $0
80106198:	6a 00                	push   $0x0
  pushl $41
8010619a:	6a 29                	push   $0x29
  jmp alltraps
8010619c:	e9 b4 f9 ff ff       	jmp    80105b55 <alltraps>

801061a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801061a1:	6a 00                	push   $0x0
  pushl $42
801061a3:	6a 2a                	push   $0x2a
  jmp alltraps
801061a5:	e9 ab f9 ff ff       	jmp    80105b55 <alltraps>

801061aa <vector43>:
.globl vector43
vector43:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $43
801061ac:	6a 2b                	push   $0x2b
  jmp alltraps
801061ae:	e9 a2 f9 ff ff       	jmp    80105b55 <alltraps>

801061b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $44
801061b5:	6a 2c                	push   $0x2c
  jmp alltraps
801061b7:	e9 99 f9 ff ff       	jmp    80105b55 <alltraps>

801061bc <vector45>:
.globl vector45
vector45:
  pushl $0
801061bc:	6a 00                	push   $0x0
  pushl $45
801061be:	6a 2d                	push   $0x2d
  jmp alltraps
801061c0:	e9 90 f9 ff ff       	jmp    80105b55 <alltraps>

801061c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $46
801061c7:	6a 2e                	push   $0x2e
  jmp alltraps
801061c9:	e9 87 f9 ff ff       	jmp    80105b55 <alltraps>

801061ce <vector47>:
.globl vector47
vector47:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $47
801061d0:	6a 2f                	push   $0x2f
  jmp alltraps
801061d2:	e9 7e f9 ff ff       	jmp    80105b55 <alltraps>

801061d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $48
801061d9:	6a 30                	push   $0x30
  jmp alltraps
801061db:	e9 75 f9 ff ff       	jmp    80105b55 <alltraps>

801061e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $49
801061e2:	6a 31                	push   $0x31
  jmp alltraps
801061e4:	e9 6c f9 ff ff       	jmp    80105b55 <alltraps>

801061e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $50
801061eb:	6a 32                	push   $0x32
  jmp alltraps
801061ed:	e9 63 f9 ff ff       	jmp    80105b55 <alltraps>

801061f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $51
801061f4:	6a 33                	push   $0x33
  jmp alltraps
801061f6:	e9 5a f9 ff ff       	jmp    80105b55 <alltraps>

801061fb <vector52>:
.globl vector52
vector52:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $52
801061fd:	6a 34                	push   $0x34
  jmp alltraps
801061ff:	e9 51 f9 ff ff       	jmp    80105b55 <alltraps>

80106204 <vector53>:
.globl vector53
vector53:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $53
80106206:	6a 35                	push   $0x35
  jmp alltraps
80106208:	e9 48 f9 ff ff       	jmp    80105b55 <alltraps>

8010620d <vector54>:
.globl vector54
vector54:
  pushl $0
8010620d:	6a 00                	push   $0x0
  pushl $54
8010620f:	6a 36                	push   $0x36
  jmp alltraps
80106211:	e9 3f f9 ff ff       	jmp    80105b55 <alltraps>

80106216 <vector55>:
.globl vector55
vector55:
  pushl $0
80106216:	6a 00                	push   $0x0
  pushl $55
80106218:	6a 37                	push   $0x37
  jmp alltraps
8010621a:	e9 36 f9 ff ff       	jmp    80105b55 <alltraps>

8010621f <vector56>:
.globl vector56
vector56:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $56
80106221:	6a 38                	push   $0x38
  jmp alltraps
80106223:	e9 2d f9 ff ff       	jmp    80105b55 <alltraps>

80106228 <vector57>:
.globl vector57
vector57:
  pushl $0
80106228:	6a 00                	push   $0x0
  pushl $57
8010622a:	6a 39                	push   $0x39
  jmp alltraps
8010622c:	e9 24 f9 ff ff       	jmp    80105b55 <alltraps>

80106231 <vector58>:
.globl vector58
vector58:
  pushl $0
80106231:	6a 00                	push   $0x0
  pushl $58
80106233:	6a 3a                	push   $0x3a
  jmp alltraps
80106235:	e9 1b f9 ff ff       	jmp    80105b55 <alltraps>

8010623a <vector59>:
.globl vector59
vector59:
  pushl $0
8010623a:	6a 00                	push   $0x0
  pushl $59
8010623c:	6a 3b                	push   $0x3b
  jmp alltraps
8010623e:	e9 12 f9 ff ff       	jmp    80105b55 <alltraps>

80106243 <vector60>:
.globl vector60
vector60:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $60
80106245:	6a 3c                	push   $0x3c
  jmp alltraps
80106247:	e9 09 f9 ff ff       	jmp    80105b55 <alltraps>

8010624c <vector61>:
.globl vector61
vector61:
  pushl $0
8010624c:	6a 00                	push   $0x0
  pushl $61
8010624e:	6a 3d                	push   $0x3d
  jmp alltraps
80106250:	e9 00 f9 ff ff       	jmp    80105b55 <alltraps>

80106255 <vector62>:
.globl vector62
vector62:
  pushl $0
80106255:	6a 00                	push   $0x0
  pushl $62
80106257:	6a 3e                	push   $0x3e
  jmp alltraps
80106259:	e9 f7 f8 ff ff       	jmp    80105b55 <alltraps>

8010625e <vector63>:
.globl vector63
vector63:
  pushl $0
8010625e:	6a 00                	push   $0x0
  pushl $63
80106260:	6a 3f                	push   $0x3f
  jmp alltraps
80106262:	e9 ee f8 ff ff       	jmp    80105b55 <alltraps>

80106267 <vector64>:
.globl vector64
vector64:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $64
80106269:	6a 40                	push   $0x40
  jmp alltraps
8010626b:	e9 e5 f8 ff ff       	jmp    80105b55 <alltraps>

80106270 <vector65>:
.globl vector65
vector65:
  pushl $0
80106270:	6a 00                	push   $0x0
  pushl $65
80106272:	6a 41                	push   $0x41
  jmp alltraps
80106274:	e9 dc f8 ff ff       	jmp    80105b55 <alltraps>

80106279 <vector66>:
.globl vector66
vector66:
  pushl $0
80106279:	6a 00                	push   $0x0
  pushl $66
8010627b:	6a 42                	push   $0x42
  jmp alltraps
8010627d:	e9 d3 f8 ff ff       	jmp    80105b55 <alltraps>

80106282 <vector67>:
.globl vector67
vector67:
  pushl $0
80106282:	6a 00                	push   $0x0
  pushl $67
80106284:	6a 43                	push   $0x43
  jmp alltraps
80106286:	e9 ca f8 ff ff       	jmp    80105b55 <alltraps>

8010628b <vector68>:
.globl vector68
vector68:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $68
8010628d:	6a 44                	push   $0x44
  jmp alltraps
8010628f:	e9 c1 f8 ff ff       	jmp    80105b55 <alltraps>

80106294 <vector69>:
.globl vector69
vector69:
  pushl $0
80106294:	6a 00                	push   $0x0
  pushl $69
80106296:	6a 45                	push   $0x45
  jmp alltraps
80106298:	e9 b8 f8 ff ff       	jmp    80105b55 <alltraps>

8010629d <vector70>:
.globl vector70
vector70:
  pushl $0
8010629d:	6a 00                	push   $0x0
  pushl $70
8010629f:	6a 46                	push   $0x46
  jmp alltraps
801062a1:	e9 af f8 ff ff       	jmp    80105b55 <alltraps>

801062a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801062a6:	6a 00                	push   $0x0
  pushl $71
801062a8:	6a 47                	push   $0x47
  jmp alltraps
801062aa:	e9 a6 f8 ff ff       	jmp    80105b55 <alltraps>

801062af <vector72>:
.globl vector72
vector72:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $72
801062b1:	6a 48                	push   $0x48
  jmp alltraps
801062b3:	e9 9d f8 ff ff       	jmp    80105b55 <alltraps>

801062b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062b8:	6a 00                	push   $0x0
  pushl $73
801062ba:	6a 49                	push   $0x49
  jmp alltraps
801062bc:	e9 94 f8 ff ff       	jmp    80105b55 <alltraps>

801062c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062c1:	6a 00                	push   $0x0
  pushl $74
801062c3:	6a 4a                	push   $0x4a
  jmp alltraps
801062c5:	e9 8b f8 ff ff       	jmp    80105b55 <alltraps>

801062ca <vector75>:
.globl vector75
vector75:
  pushl $0
801062ca:	6a 00                	push   $0x0
  pushl $75
801062cc:	6a 4b                	push   $0x4b
  jmp alltraps
801062ce:	e9 82 f8 ff ff       	jmp    80105b55 <alltraps>

801062d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $76
801062d5:	6a 4c                	push   $0x4c
  jmp alltraps
801062d7:	e9 79 f8 ff ff       	jmp    80105b55 <alltraps>

801062dc <vector77>:
.globl vector77
vector77:
  pushl $0
801062dc:	6a 00                	push   $0x0
  pushl $77
801062de:	6a 4d                	push   $0x4d
  jmp alltraps
801062e0:	e9 70 f8 ff ff       	jmp    80105b55 <alltraps>

801062e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062e5:	6a 00                	push   $0x0
  pushl $78
801062e7:	6a 4e                	push   $0x4e
  jmp alltraps
801062e9:	e9 67 f8 ff ff       	jmp    80105b55 <alltraps>

801062ee <vector79>:
.globl vector79
vector79:
  pushl $0
801062ee:	6a 00                	push   $0x0
  pushl $79
801062f0:	6a 4f                	push   $0x4f
  jmp alltraps
801062f2:	e9 5e f8 ff ff       	jmp    80105b55 <alltraps>

801062f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $80
801062f9:	6a 50                	push   $0x50
  jmp alltraps
801062fb:	e9 55 f8 ff ff       	jmp    80105b55 <alltraps>

80106300 <vector81>:
.globl vector81
vector81:
  pushl $0
80106300:	6a 00                	push   $0x0
  pushl $81
80106302:	6a 51                	push   $0x51
  jmp alltraps
80106304:	e9 4c f8 ff ff       	jmp    80105b55 <alltraps>

80106309 <vector82>:
.globl vector82
vector82:
  pushl $0
80106309:	6a 00                	push   $0x0
  pushl $82
8010630b:	6a 52                	push   $0x52
  jmp alltraps
8010630d:	e9 43 f8 ff ff       	jmp    80105b55 <alltraps>

80106312 <vector83>:
.globl vector83
vector83:
  pushl $0
80106312:	6a 00                	push   $0x0
  pushl $83
80106314:	6a 53                	push   $0x53
  jmp alltraps
80106316:	e9 3a f8 ff ff       	jmp    80105b55 <alltraps>

8010631b <vector84>:
.globl vector84
vector84:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $84
8010631d:	6a 54                	push   $0x54
  jmp alltraps
8010631f:	e9 31 f8 ff ff       	jmp    80105b55 <alltraps>

80106324 <vector85>:
.globl vector85
vector85:
  pushl $0
80106324:	6a 00                	push   $0x0
  pushl $85
80106326:	6a 55                	push   $0x55
  jmp alltraps
80106328:	e9 28 f8 ff ff       	jmp    80105b55 <alltraps>

8010632d <vector86>:
.globl vector86
vector86:
  pushl $0
8010632d:	6a 00                	push   $0x0
  pushl $86
8010632f:	6a 56                	push   $0x56
  jmp alltraps
80106331:	e9 1f f8 ff ff       	jmp    80105b55 <alltraps>

80106336 <vector87>:
.globl vector87
vector87:
  pushl $0
80106336:	6a 00                	push   $0x0
  pushl $87
80106338:	6a 57                	push   $0x57
  jmp alltraps
8010633a:	e9 16 f8 ff ff       	jmp    80105b55 <alltraps>

8010633f <vector88>:
.globl vector88
vector88:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $88
80106341:	6a 58                	push   $0x58
  jmp alltraps
80106343:	e9 0d f8 ff ff       	jmp    80105b55 <alltraps>

80106348 <vector89>:
.globl vector89
vector89:
  pushl $0
80106348:	6a 00                	push   $0x0
  pushl $89
8010634a:	6a 59                	push   $0x59
  jmp alltraps
8010634c:	e9 04 f8 ff ff       	jmp    80105b55 <alltraps>

80106351 <vector90>:
.globl vector90
vector90:
  pushl $0
80106351:	6a 00                	push   $0x0
  pushl $90
80106353:	6a 5a                	push   $0x5a
  jmp alltraps
80106355:	e9 fb f7 ff ff       	jmp    80105b55 <alltraps>

8010635a <vector91>:
.globl vector91
vector91:
  pushl $0
8010635a:	6a 00                	push   $0x0
  pushl $91
8010635c:	6a 5b                	push   $0x5b
  jmp alltraps
8010635e:	e9 f2 f7 ff ff       	jmp    80105b55 <alltraps>

80106363 <vector92>:
.globl vector92
vector92:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $92
80106365:	6a 5c                	push   $0x5c
  jmp alltraps
80106367:	e9 e9 f7 ff ff       	jmp    80105b55 <alltraps>

8010636c <vector93>:
.globl vector93
vector93:
  pushl $0
8010636c:	6a 00                	push   $0x0
  pushl $93
8010636e:	6a 5d                	push   $0x5d
  jmp alltraps
80106370:	e9 e0 f7 ff ff       	jmp    80105b55 <alltraps>

80106375 <vector94>:
.globl vector94
vector94:
  pushl $0
80106375:	6a 00                	push   $0x0
  pushl $94
80106377:	6a 5e                	push   $0x5e
  jmp alltraps
80106379:	e9 d7 f7 ff ff       	jmp    80105b55 <alltraps>

8010637e <vector95>:
.globl vector95
vector95:
  pushl $0
8010637e:	6a 00                	push   $0x0
  pushl $95
80106380:	6a 5f                	push   $0x5f
  jmp alltraps
80106382:	e9 ce f7 ff ff       	jmp    80105b55 <alltraps>

80106387 <vector96>:
.globl vector96
vector96:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $96
80106389:	6a 60                	push   $0x60
  jmp alltraps
8010638b:	e9 c5 f7 ff ff       	jmp    80105b55 <alltraps>

80106390 <vector97>:
.globl vector97
vector97:
  pushl $0
80106390:	6a 00                	push   $0x0
  pushl $97
80106392:	6a 61                	push   $0x61
  jmp alltraps
80106394:	e9 bc f7 ff ff       	jmp    80105b55 <alltraps>

80106399 <vector98>:
.globl vector98
vector98:
  pushl $0
80106399:	6a 00                	push   $0x0
  pushl $98
8010639b:	6a 62                	push   $0x62
  jmp alltraps
8010639d:	e9 b3 f7 ff ff       	jmp    80105b55 <alltraps>

801063a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801063a2:	6a 00                	push   $0x0
  pushl $99
801063a4:	6a 63                	push   $0x63
  jmp alltraps
801063a6:	e9 aa f7 ff ff       	jmp    80105b55 <alltraps>

801063ab <vector100>:
.globl vector100
vector100:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $100
801063ad:	6a 64                	push   $0x64
  jmp alltraps
801063af:	e9 a1 f7 ff ff       	jmp    80105b55 <alltraps>

801063b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $101
801063b6:	6a 65                	push   $0x65
  jmp alltraps
801063b8:	e9 98 f7 ff ff       	jmp    80105b55 <alltraps>

801063bd <vector102>:
.globl vector102
vector102:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $102
801063bf:	6a 66                	push   $0x66
  jmp alltraps
801063c1:	e9 8f f7 ff ff       	jmp    80105b55 <alltraps>

801063c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063c6:	6a 00                	push   $0x0
  pushl $103
801063c8:	6a 67                	push   $0x67
  jmp alltraps
801063ca:	e9 86 f7 ff ff       	jmp    80105b55 <alltraps>

801063cf <vector104>:
.globl vector104
vector104:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $104
801063d1:	6a 68                	push   $0x68
  jmp alltraps
801063d3:	e9 7d f7 ff ff       	jmp    80105b55 <alltraps>

801063d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063d8:	6a 00                	push   $0x0
  pushl $105
801063da:	6a 69                	push   $0x69
  jmp alltraps
801063dc:	e9 74 f7 ff ff       	jmp    80105b55 <alltraps>

801063e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063e1:	6a 00                	push   $0x0
  pushl $106
801063e3:	6a 6a                	push   $0x6a
  jmp alltraps
801063e5:	e9 6b f7 ff ff       	jmp    80105b55 <alltraps>

801063ea <vector107>:
.globl vector107
vector107:
  pushl $0
801063ea:	6a 00                	push   $0x0
  pushl $107
801063ec:	6a 6b                	push   $0x6b
  jmp alltraps
801063ee:	e9 62 f7 ff ff       	jmp    80105b55 <alltraps>

801063f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $108
801063f5:	6a 6c                	push   $0x6c
  jmp alltraps
801063f7:	e9 59 f7 ff ff       	jmp    80105b55 <alltraps>

801063fc <vector109>:
.globl vector109
vector109:
  pushl $0
801063fc:	6a 00                	push   $0x0
  pushl $109
801063fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106400:	e9 50 f7 ff ff       	jmp    80105b55 <alltraps>

80106405 <vector110>:
.globl vector110
vector110:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $110
80106407:	6a 6e                	push   $0x6e
  jmp alltraps
80106409:	e9 47 f7 ff ff       	jmp    80105b55 <alltraps>

8010640e <vector111>:
.globl vector111
vector111:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $111
80106410:	6a 6f                	push   $0x6f
  jmp alltraps
80106412:	e9 3e f7 ff ff       	jmp    80105b55 <alltraps>

80106417 <vector112>:
.globl vector112
vector112:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $112
80106419:	6a 70                	push   $0x70
  jmp alltraps
8010641b:	e9 35 f7 ff ff       	jmp    80105b55 <alltraps>

80106420 <vector113>:
.globl vector113
vector113:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $113
80106422:	6a 71                	push   $0x71
  jmp alltraps
80106424:	e9 2c f7 ff ff       	jmp    80105b55 <alltraps>

80106429 <vector114>:
.globl vector114
vector114:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $114
8010642b:	6a 72                	push   $0x72
  jmp alltraps
8010642d:	e9 23 f7 ff ff       	jmp    80105b55 <alltraps>

80106432 <vector115>:
.globl vector115
vector115:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $115
80106434:	6a 73                	push   $0x73
  jmp alltraps
80106436:	e9 1a f7 ff ff       	jmp    80105b55 <alltraps>

8010643b <vector116>:
.globl vector116
vector116:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $116
8010643d:	6a 74                	push   $0x74
  jmp alltraps
8010643f:	e9 11 f7 ff ff       	jmp    80105b55 <alltraps>

80106444 <vector117>:
.globl vector117
vector117:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $117
80106446:	6a 75                	push   $0x75
  jmp alltraps
80106448:	e9 08 f7 ff ff       	jmp    80105b55 <alltraps>

8010644d <vector118>:
.globl vector118
vector118:
  pushl $0
8010644d:	6a 00                	push   $0x0
  pushl $118
8010644f:	6a 76                	push   $0x76
  jmp alltraps
80106451:	e9 ff f6 ff ff       	jmp    80105b55 <alltraps>

80106456 <vector119>:
.globl vector119
vector119:
  pushl $0
80106456:	6a 00                	push   $0x0
  pushl $119
80106458:	6a 77                	push   $0x77
  jmp alltraps
8010645a:	e9 f6 f6 ff ff       	jmp    80105b55 <alltraps>

8010645f <vector120>:
.globl vector120
vector120:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $120
80106461:	6a 78                	push   $0x78
  jmp alltraps
80106463:	e9 ed f6 ff ff       	jmp    80105b55 <alltraps>

80106468 <vector121>:
.globl vector121
vector121:
  pushl $0
80106468:	6a 00                	push   $0x0
  pushl $121
8010646a:	6a 79                	push   $0x79
  jmp alltraps
8010646c:	e9 e4 f6 ff ff       	jmp    80105b55 <alltraps>

80106471 <vector122>:
.globl vector122
vector122:
  pushl $0
80106471:	6a 00                	push   $0x0
  pushl $122
80106473:	6a 7a                	push   $0x7a
  jmp alltraps
80106475:	e9 db f6 ff ff       	jmp    80105b55 <alltraps>

8010647a <vector123>:
.globl vector123
vector123:
  pushl $0
8010647a:	6a 00                	push   $0x0
  pushl $123
8010647c:	6a 7b                	push   $0x7b
  jmp alltraps
8010647e:	e9 d2 f6 ff ff       	jmp    80105b55 <alltraps>

80106483 <vector124>:
.globl vector124
vector124:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $124
80106485:	6a 7c                	push   $0x7c
  jmp alltraps
80106487:	e9 c9 f6 ff ff       	jmp    80105b55 <alltraps>

8010648c <vector125>:
.globl vector125
vector125:
  pushl $0
8010648c:	6a 00                	push   $0x0
  pushl $125
8010648e:	6a 7d                	push   $0x7d
  jmp alltraps
80106490:	e9 c0 f6 ff ff       	jmp    80105b55 <alltraps>

80106495 <vector126>:
.globl vector126
vector126:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $126
80106497:	6a 7e                	push   $0x7e
  jmp alltraps
80106499:	e9 b7 f6 ff ff       	jmp    80105b55 <alltraps>

8010649e <vector127>:
.globl vector127
vector127:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $127
801064a0:	6a 7f                	push   $0x7f
  jmp alltraps
801064a2:	e9 ae f6 ff ff       	jmp    80105b55 <alltraps>

801064a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $128
801064a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801064ae:	e9 a2 f6 ff ff       	jmp    80105b55 <alltraps>

801064b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $129
801064b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064ba:	e9 96 f6 ff ff       	jmp    80105b55 <alltraps>

801064bf <vector130>:
.globl vector130
vector130:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $130
801064c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064c6:	e9 8a f6 ff ff       	jmp    80105b55 <alltraps>

801064cb <vector131>:
.globl vector131
vector131:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $131
801064cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064d2:	e9 7e f6 ff ff       	jmp    80105b55 <alltraps>

801064d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $132
801064d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064de:	e9 72 f6 ff ff       	jmp    80105b55 <alltraps>

801064e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $133
801064e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064ea:	e9 66 f6 ff ff       	jmp    80105b55 <alltraps>

801064ef <vector134>:
.globl vector134
vector134:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $134
801064f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064f6:	e9 5a f6 ff ff       	jmp    80105b55 <alltraps>

801064fb <vector135>:
.globl vector135
vector135:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $135
801064fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106502:	e9 4e f6 ff ff       	jmp    80105b55 <alltraps>

80106507 <vector136>:
.globl vector136
vector136:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $136
80106509:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010650e:	e9 42 f6 ff ff       	jmp    80105b55 <alltraps>

80106513 <vector137>:
.globl vector137
vector137:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $137
80106515:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010651a:	e9 36 f6 ff ff       	jmp    80105b55 <alltraps>

8010651f <vector138>:
.globl vector138
vector138:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $138
80106521:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106526:	e9 2a f6 ff ff       	jmp    80105b55 <alltraps>

8010652b <vector139>:
.globl vector139
vector139:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $139
8010652d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106532:	e9 1e f6 ff ff       	jmp    80105b55 <alltraps>

80106537 <vector140>:
.globl vector140
vector140:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $140
80106539:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010653e:	e9 12 f6 ff ff       	jmp    80105b55 <alltraps>

80106543 <vector141>:
.globl vector141
vector141:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $141
80106545:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010654a:	e9 06 f6 ff ff       	jmp    80105b55 <alltraps>

8010654f <vector142>:
.globl vector142
vector142:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $142
80106551:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106556:	e9 fa f5 ff ff       	jmp    80105b55 <alltraps>

8010655b <vector143>:
.globl vector143
vector143:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $143
8010655d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106562:	e9 ee f5 ff ff       	jmp    80105b55 <alltraps>

80106567 <vector144>:
.globl vector144
vector144:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $144
80106569:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010656e:	e9 e2 f5 ff ff       	jmp    80105b55 <alltraps>

80106573 <vector145>:
.globl vector145
vector145:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $145
80106575:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010657a:	e9 d6 f5 ff ff       	jmp    80105b55 <alltraps>

8010657f <vector146>:
.globl vector146
vector146:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $146
80106581:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106586:	e9 ca f5 ff ff       	jmp    80105b55 <alltraps>

8010658b <vector147>:
.globl vector147
vector147:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $147
8010658d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106592:	e9 be f5 ff ff       	jmp    80105b55 <alltraps>

80106597 <vector148>:
.globl vector148
vector148:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $148
80106599:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010659e:	e9 b2 f5 ff ff       	jmp    80105b55 <alltraps>

801065a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $149
801065a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801065aa:	e9 a6 f5 ff ff       	jmp    80105b55 <alltraps>

801065af <vector150>:
.globl vector150
vector150:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $150
801065b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065b6:	e9 9a f5 ff ff       	jmp    80105b55 <alltraps>

801065bb <vector151>:
.globl vector151
vector151:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $151
801065bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065c2:	e9 8e f5 ff ff       	jmp    80105b55 <alltraps>

801065c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $152
801065c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065ce:	e9 82 f5 ff ff       	jmp    80105b55 <alltraps>

801065d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $153
801065d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065da:	e9 76 f5 ff ff       	jmp    80105b55 <alltraps>

801065df <vector154>:
.globl vector154
vector154:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $154
801065e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065e6:	e9 6a f5 ff ff       	jmp    80105b55 <alltraps>

801065eb <vector155>:
.globl vector155
vector155:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $155
801065ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065f2:	e9 5e f5 ff ff       	jmp    80105b55 <alltraps>

801065f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $156
801065f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065fe:	e9 52 f5 ff ff       	jmp    80105b55 <alltraps>

80106603 <vector157>:
.globl vector157
vector157:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $157
80106605:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010660a:	e9 46 f5 ff ff       	jmp    80105b55 <alltraps>

8010660f <vector158>:
.globl vector158
vector158:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $158
80106611:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106616:	e9 3a f5 ff ff       	jmp    80105b55 <alltraps>

8010661b <vector159>:
.globl vector159
vector159:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $159
8010661d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106622:	e9 2e f5 ff ff       	jmp    80105b55 <alltraps>

80106627 <vector160>:
.globl vector160
vector160:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $160
80106629:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010662e:	e9 22 f5 ff ff       	jmp    80105b55 <alltraps>

80106633 <vector161>:
.globl vector161
vector161:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $161
80106635:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010663a:	e9 16 f5 ff ff       	jmp    80105b55 <alltraps>

8010663f <vector162>:
.globl vector162
vector162:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $162
80106641:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106646:	e9 0a f5 ff ff       	jmp    80105b55 <alltraps>

8010664b <vector163>:
.globl vector163
vector163:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $163
8010664d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106652:	e9 fe f4 ff ff       	jmp    80105b55 <alltraps>

80106657 <vector164>:
.globl vector164
vector164:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $164
80106659:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010665e:	e9 f2 f4 ff ff       	jmp    80105b55 <alltraps>

80106663 <vector165>:
.globl vector165
vector165:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $165
80106665:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010666a:	e9 e6 f4 ff ff       	jmp    80105b55 <alltraps>

8010666f <vector166>:
.globl vector166
vector166:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $166
80106671:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106676:	e9 da f4 ff ff       	jmp    80105b55 <alltraps>

8010667b <vector167>:
.globl vector167
vector167:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $167
8010667d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106682:	e9 ce f4 ff ff       	jmp    80105b55 <alltraps>

80106687 <vector168>:
.globl vector168
vector168:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $168
80106689:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010668e:	e9 c2 f4 ff ff       	jmp    80105b55 <alltraps>

80106693 <vector169>:
.globl vector169
vector169:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $169
80106695:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010669a:	e9 b6 f4 ff ff       	jmp    80105b55 <alltraps>

8010669f <vector170>:
.globl vector170
vector170:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $170
801066a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801066a6:	e9 aa f4 ff ff       	jmp    80105b55 <alltraps>

801066ab <vector171>:
.globl vector171
vector171:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $171
801066ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066b2:	e9 9e f4 ff ff       	jmp    80105b55 <alltraps>

801066b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $172
801066b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066be:	e9 92 f4 ff ff       	jmp    80105b55 <alltraps>

801066c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $173
801066c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066ca:	e9 86 f4 ff ff       	jmp    80105b55 <alltraps>

801066cf <vector174>:
.globl vector174
vector174:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $174
801066d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066d6:	e9 7a f4 ff ff       	jmp    80105b55 <alltraps>

801066db <vector175>:
.globl vector175
vector175:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $175
801066dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066e2:	e9 6e f4 ff ff       	jmp    80105b55 <alltraps>

801066e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $176
801066e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066ee:	e9 62 f4 ff ff       	jmp    80105b55 <alltraps>

801066f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $177
801066f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066fa:	e9 56 f4 ff ff       	jmp    80105b55 <alltraps>

801066ff <vector178>:
.globl vector178
vector178:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $178
80106701:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106706:	e9 4a f4 ff ff       	jmp    80105b55 <alltraps>

8010670b <vector179>:
.globl vector179
vector179:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $179
8010670d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106712:	e9 3e f4 ff ff       	jmp    80105b55 <alltraps>

80106717 <vector180>:
.globl vector180
vector180:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $180
80106719:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010671e:	e9 32 f4 ff ff       	jmp    80105b55 <alltraps>

80106723 <vector181>:
.globl vector181
vector181:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $181
80106725:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010672a:	e9 26 f4 ff ff       	jmp    80105b55 <alltraps>

8010672f <vector182>:
.globl vector182
vector182:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $182
80106731:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106736:	e9 1a f4 ff ff       	jmp    80105b55 <alltraps>

8010673b <vector183>:
.globl vector183
vector183:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $183
8010673d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106742:	e9 0e f4 ff ff       	jmp    80105b55 <alltraps>

80106747 <vector184>:
.globl vector184
vector184:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $184
80106749:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010674e:	e9 02 f4 ff ff       	jmp    80105b55 <alltraps>

80106753 <vector185>:
.globl vector185
vector185:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $185
80106755:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010675a:	e9 f6 f3 ff ff       	jmp    80105b55 <alltraps>

8010675f <vector186>:
.globl vector186
vector186:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $186
80106761:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106766:	e9 ea f3 ff ff       	jmp    80105b55 <alltraps>

8010676b <vector187>:
.globl vector187
vector187:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $187
8010676d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106772:	e9 de f3 ff ff       	jmp    80105b55 <alltraps>

80106777 <vector188>:
.globl vector188
vector188:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $188
80106779:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010677e:	e9 d2 f3 ff ff       	jmp    80105b55 <alltraps>

80106783 <vector189>:
.globl vector189
vector189:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $189
80106785:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010678a:	e9 c6 f3 ff ff       	jmp    80105b55 <alltraps>

8010678f <vector190>:
.globl vector190
vector190:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $190
80106791:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106796:	e9 ba f3 ff ff       	jmp    80105b55 <alltraps>

8010679b <vector191>:
.globl vector191
vector191:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $191
8010679d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801067a2:	e9 ae f3 ff ff       	jmp    80105b55 <alltraps>

801067a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $192
801067a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801067ae:	e9 a2 f3 ff ff       	jmp    80105b55 <alltraps>

801067b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $193
801067b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067ba:	e9 96 f3 ff ff       	jmp    80105b55 <alltraps>

801067bf <vector194>:
.globl vector194
vector194:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $194
801067c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067c6:	e9 8a f3 ff ff       	jmp    80105b55 <alltraps>

801067cb <vector195>:
.globl vector195
vector195:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $195
801067cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067d2:	e9 7e f3 ff ff       	jmp    80105b55 <alltraps>

801067d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $196
801067d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067de:	e9 72 f3 ff ff       	jmp    80105b55 <alltraps>

801067e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $197
801067e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067ea:	e9 66 f3 ff ff       	jmp    80105b55 <alltraps>

801067ef <vector198>:
.globl vector198
vector198:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $198
801067f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067f6:	e9 5a f3 ff ff       	jmp    80105b55 <alltraps>

801067fb <vector199>:
.globl vector199
vector199:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $199
801067fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106802:	e9 4e f3 ff ff       	jmp    80105b55 <alltraps>

80106807 <vector200>:
.globl vector200
vector200:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $200
80106809:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010680e:	e9 42 f3 ff ff       	jmp    80105b55 <alltraps>

80106813 <vector201>:
.globl vector201
vector201:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $201
80106815:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010681a:	e9 36 f3 ff ff       	jmp    80105b55 <alltraps>

8010681f <vector202>:
.globl vector202
vector202:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $202
80106821:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106826:	e9 2a f3 ff ff       	jmp    80105b55 <alltraps>

8010682b <vector203>:
.globl vector203
vector203:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $203
8010682d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106832:	e9 1e f3 ff ff       	jmp    80105b55 <alltraps>

80106837 <vector204>:
.globl vector204
vector204:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $204
80106839:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010683e:	e9 12 f3 ff ff       	jmp    80105b55 <alltraps>

80106843 <vector205>:
.globl vector205
vector205:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $205
80106845:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010684a:	e9 06 f3 ff ff       	jmp    80105b55 <alltraps>

8010684f <vector206>:
.globl vector206
vector206:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $206
80106851:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106856:	e9 fa f2 ff ff       	jmp    80105b55 <alltraps>

8010685b <vector207>:
.globl vector207
vector207:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $207
8010685d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106862:	e9 ee f2 ff ff       	jmp    80105b55 <alltraps>

80106867 <vector208>:
.globl vector208
vector208:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $208
80106869:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010686e:	e9 e2 f2 ff ff       	jmp    80105b55 <alltraps>

80106873 <vector209>:
.globl vector209
vector209:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $209
80106875:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010687a:	e9 d6 f2 ff ff       	jmp    80105b55 <alltraps>

8010687f <vector210>:
.globl vector210
vector210:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $210
80106881:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106886:	e9 ca f2 ff ff       	jmp    80105b55 <alltraps>

8010688b <vector211>:
.globl vector211
vector211:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $211
8010688d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106892:	e9 be f2 ff ff       	jmp    80105b55 <alltraps>

80106897 <vector212>:
.globl vector212
vector212:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $212
80106899:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010689e:	e9 b2 f2 ff ff       	jmp    80105b55 <alltraps>

801068a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $213
801068a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801068aa:	e9 a6 f2 ff ff       	jmp    80105b55 <alltraps>

801068af <vector214>:
.globl vector214
vector214:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $214
801068b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068b6:	e9 9a f2 ff ff       	jmp    80105b55 <alltraps>

801068bb <vector215>:
.globl vector215
vector215:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $215
801068bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068c2:	e9 8e f2 ff ff       	jmp    80105b55 <alltraps>

801068c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $216
801068c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068ce:	e9 82 f2 ff ff       	jmp    80105b55 <alltraps>

801068d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $217
801068d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068da:	e9 76 f2 ff ff       	jmp    80105b55 <alltraps>

801068df <vector218>:
.globl vector218
vector218:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $218
801068e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068e6:	e9 6a f2 ff ff       	jmp    80105b55 <alltraps>

801068eb <vector219>:
.globl vector219
vector219:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $219
801068ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068f2:	e9 5e f2 ff ff       	jmp    80105b55 <alltraps>

801068f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $220
801068f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068fe:	e9 52 f2 ff ff       	jmp    80105b55 <alltraps>

80106903 <vector221>:
.globl vector221
vector221:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $221
80106905:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010690a:	e9 46 f2 ff ff       	jmp    80105b55 <alltraps>

8010690f <vector222>:
.globl vector222
vector222:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $222
80106911:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106916:	e9 3a f2 ff ff       	jmp    80105b55 <alltraps>

8010691b <vector223>:
.globl vector223
vector223:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $223
8010691d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106922:	e9 2e f2 ff ff       	jmp    80105b55 <alltraps>

80106927 <vector224>:
.globl vector224
vector224:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $224
80106929:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010692e:	e9 22 f2 ff ff       	jmp    80105b55 <alltraps>

80106933 <vector225>:
.globl vector225
vector225:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $225
80106935:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010693a:	e9 16 f2 ff ff       	jmp    80105b55 <alltraps>

8010693f <vector226>:
.globl vector226
vector226:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $226
80106941:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106946:	e9 0a f2 ff ff       	jmp    80105b55 <alltraps>

8010694b <vector227>:
.globl vector227
vector227:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $227
8010694d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106952:	e9 fe f1 ff ff       	jmp    80105b55 <alltraps>

80106957 <vector228>:
.globl vector228
vector228:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $228
80106959:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010695e:	e9 f2 f1 ff ff       	jmp    80105b55 <alltraps>

80106963 <vector229>:
.globl vector229
vector229:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $229
80106965:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010696a:	e9 e6 f1 ff ff       	jmp    80105b55 <alltraps>

8010696f <vector230>:
.globl vector230
vector230:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $230
80106971:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106976:	e9 da f1 ff ff       	jmp    80105b55 <alltraps>

8010697b <vector231>:
.globl vector231
vector231:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $231
8010697d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106982:	e9 ce f1 ff ff       	jmp    80105b55 <alltraps>

80106987 <vector232>:
.globl vector232
vector232:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $232
80106989:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010698e:	e9 c2 f1 ff ff       	jmp    80105b55 <alltraps>

80106993 <vector233>:
.globl vector233
vector233:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $233
80106995:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010699a:	e9 b6 f1 ff ff       	jmp    80105b55 <alltraps>

8010699f <vector234>:
.globl vector234
vector234:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $234
801069a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801069a6:	e9 aa f1 ff ff       	jmp    80105b55 <alltraps>

801069ab <vector235>:
.globl vector235
vector235:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $235
801069ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069b2:	e9 9e f1 ff ff       	jmp    80105b55 <alltraps>

801069b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $236
801069b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069be:	e9 92 f1 ff ff       	jmp    80105b55 <alltraps>

801069c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $237
801069c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069ca:	e9 86 f1 ff ff       	jmp    80105b55 <alltraps>

801069cf <vector238>:
.globl vector238
vector238:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $238
801069d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069d6:	e9 7a f1 ff ff       	jmp    80105b55 <alltraps>

801069db <vector239>:
.globl vector239
vector239:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $239
801069dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069e2:	e9 6e f1 ff ff       	jmp    80105b55 <alltraps>

801069e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $240
801069e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069ee:	e9 62 f1 ff ff       	jmp    80105b55 <alltraps>

801069f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $241
801069f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069fa:	e9 56 f1 ff ff       	jmp    80105b55 <alltraps>

801069ff <vector242>:
.globl vector242
vector242:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $242
80106a01:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106a06:	e9 4a f1 ff ff       	jmp    80105b55 <alltraps>

80106a0b <vector243>:
.globl vector243
vector243:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $243
80106a0d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a12:	e9 3e f1 ff ff       	jmp    80105b55 <alltraps>

80106a17 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $244
80106a19:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a1e:	e9 32 f1 ff ff       	jmp    80105b55 <alltraps>

80106a23 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $245
80106a25:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a2a:	e9 26 f1 ff ff       	jmp    80105b55 <alltraps>

80106a2f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $246
80106a31:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a36:	e9 1a f1 ff ff       	jmp    80105b55 <alltraps>

80106a3b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $247
80106a3d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a42:	e9 0e f1 ff ff       	jmp    80105b55 <alltraps>

80106a47 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $248
80106a49:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a4e:	e9 02 f1 ff ff       	jmp    80105b55 <alltraps>

80106a53 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $249
80106a55:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a5a:	e9 f6 f0 ff ff       	jmp    80105b55 <alltraps>

80106a5f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $250
80106a61:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a66:	e9 ea f0 ff ff       	jmp    80105b55 <alltraps>

80106a6b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $251
80106a6d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a72:	e9 de f0 ff ff       	jmp    80105b55 <alltraps>

80106a77 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $252
80106a79:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a7e:	e9 d2 f0 ff ff       	jmp    80105b55 <alltraps>

80106a83 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $253
80106a85:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a8a:	e9 c6 f0 ff ff       	jmp    80105b55 <alltraps>

80106a8f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $254
80106a91:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a96:	e9 ba f0 ff ff       	jmp    80105b55 <alltraps>

80106a9b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $255
80106a9d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106aa2:	e9 ae f0 ff ff       	jmp    80105b55 <alltraps>
80106aa7:	66 90                	xchg   %ax,%ax
80106aa9:	66 90                	xchg   %ax,%ax
80106aab:	66 90                	xchg   %ax,%ax
80106aad:	66 90                	xchg   %ax,%ax
80106aaf:	90                   	nop

80106ab0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	56                   	push   %esi
80106ab5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106ab7:	c1 ea 16             	shr    $0x16,%edx
{
80106aba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106abb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106abe:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ac1:	8b 07                	mov    (%edi),%eax
80106ac3:	a8 01                	test   $0x1,%al
80106ac5:	74 29                	je     80106af0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ac7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106acc:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ad2:	c1 ee 0a             	shr    $0xa,%esi
}
80106ad5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106ad8:	89 f2                	mov    %esi,%edx
80106ada:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106ae0:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106ae3:	5b                   	pop    %ebx
80106ae4:	5e                   	pop    %esi
80106ae5:	5f                   	pop    %edi
80106ae6:	5d                   	pop    %ebp
80106ae7:	c3                   	ret    
80106ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aef:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106af0:	85 c9                	test   %ecx,%ecx
80106af2:	74 2c                	je     80106b20 <walkpgdir+0x70>
80106af4:	e8 f7 bc ff ff       	call   801027f0 <kalloc>
80106af9:	89 c3                	mov    %eax,%ebx
80106afb:	85 c0                	test   %eax,%eax
80106afd:	74 21                	je     80106b20 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106aff:	83 ec 04             	sub    $0x4,%esp
80106b02:	68 00 10 00 00       	push   $0x1000
80106b07:	6a 00                	push   $0x0
80106b09:	50                   	push   %eax
80106b0a:	e8 41 de ff ff       	call   80104950 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b0f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b15:	83 c4 10             	add    $0x10,%esp
80106b18:	83 c8 07             	or     $0x7,%eax
80106b1b:	89 07                	mov    %eax,(%edi)
80106b1d:	eb b3                	jmp    80106ad2 <walkpgdir+0x22>
80106b1f:	90                   	nop
}
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106b23:	31 c0                	xor    %eax,%eax
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b30 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b35:	89 d6                	mov    %edx,%esi
{
80106b37:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106b38:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106b3e:	83 ec 1c             	sub    $0x1c,%esp
80106b41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b44:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b47:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b50:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b53:	29 f7                	sub    %esi,%edi
80106b55:	eb 21                	jmp    80106b78 <mappages+0x48>
80106b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b5e:	66 90                	xchg   %ax,%ax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106b60:	f6 00 01             	testb  $0x1,(%eax)
80106b63:	75 45                	jne    80106baa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b65:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106b68:	83 cb 01             	or     $0x1,%ebx
80106b6b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106b6d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106b70:	74 2e                	je     80106ba0 <mappages+0x70>
      break;
    a += PGSIZE;
80106b72:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b7b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b80:	89 f2                	mov    %esi,%edx
80106b82:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106b85:	e8 26 ff ff ff       	call   80106ab0 <walkpgdir>
80106b8a:	85 c0                	test   %eax,%eax
80106b8c:	75 d2                	jne    80106b60 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b96:	5b                   	pop    %ebx
80106b97:	5e                   	pop    %esi
80106b98:	5f                   	pop    %edi
80106b99:	5d                   	pop    %ebp
80106b9a:	c3                   	ret    
80106b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b9f:	90                   	nop
80106ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ba3:	31 c0                	xor    %eax,%eax
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
      panic("remap");
80106baa:	83 ec 0c             	sub    $0xc,%esp
80106bad:	68 18 7e 10 80       	push   $0x80107e18
80106bb2:	e8 d9 97 ff ff       	call   80100390 <panic>
80106bb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bbe:	66 90                	xchg   %ax,%ax

80106bc0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	89 c7                	mov    %eax,%edi
80106bc6:	56                   	push   %esi
80106bc7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bc8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106bce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bd4:	83 ec 1c             	sub    $0x1c,%esp
80106bd7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106bda:	39 d3                	cmp    %edx,%ebx
80106bdc:	73 5a                	jae    80106c38 <deallocuvm.part.0+0x78>
80106bde:	89 d6                	mov    %edx,%esi
80106be0:	eb 10                	jmp    80106bf2 <deallocuvm.part.0+0x32>
80106be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106be8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bee:	39 de                	cmp    %ebx,%esi
80106bf0:	76 46                	jbe    80106c38 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106bf2:	31 c9                	xor    %ecx,%ecx
80106bf4:	89 da                	mov    %ebx,%edx
80106bf6:	89 f8                	mov    %edi,%eax
80106bf8:	e8 b3 fe ff ff       	call   80106ab0 <walkpgdir>
    if(!pte)
80106bfd:	85 c0                	test   %eax,%eax
80106bff:	74 47                	je     80106c48 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106c01:	8b 10                	mov    (%eax),%edx
80106c03:	f6 c2 01             	test   $0x1,%dl
80106c06:	74 e0                	je     80106be8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106c08:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106c0e:	74 46                	je     80106c56 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106c10:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106c13:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106c19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106c1c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c22:	52                   	push   %edx
80106c23:	e8 08 ba ff ff       	call   80102630 <kfree>
      *pte = 0;
80106c28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c2b:	83 c4 10             	add    $0x10,%esp
80106c2e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106c34:	39 de                	cmp    %ebx,%esi
80106c36:	77 ba                	ja     80106bf2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106c38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c3e:	5b                   	pop    %ebx
80106c3f:	5e                   	pop    %esi
80106c40:	5f                   	pop    %edi
80106c41:	5d                   	pop    %ebp
80106c42:	c3                   	ret    
80106c43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c47:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c48:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c4e:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106c54:	eb 98                	jmp    80106bee <deallocuvm.part.0+0x2e>
        panic("kfree");
80106c56:	83 ec 0c             	sub    $0xc,%esp
80106c59:	68 16 77 10 80       	push   $0x80107716
80106c5e:	e8 2d 97 ff ff       	call   80100390 <panic>
80106c63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c70 <seginit>:
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c76:	e8 95 ce ff ff       	call   80103b10 <cpuid>
  pd[0] = size-1;
80106c7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c8a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106c91:	ff 00 00 
80106c94:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106c9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c9e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106ca5:	ff 00 00 
80106ca8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106caf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cb2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106cb9:	ff 00 00 
80106cbc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106cc3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106cc6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106ccd:	ff 00 00 
80106cd0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106cd7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106cda:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106cdf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106ce3:	c1 e8 10             	shr    $0x10,%eax
80106ce6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106cea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ced:	0f 01 10             	lgdtl  (%eax)
}
80106cf0:	c9                   	leave  
80106cf1:	c3                   	ret    
80106cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d00:	a1 a4 55 11 80       	mov    0x801155a4,%eax
80106d05:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d0a:	0f 22 d8             	mov    %eax,%cr3
}
80106d0d:	c3                   	ret    
80106d0e:	66 90                	xchg   %ax,%ax

80106d10 <switchuvm>:
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
80106d16:	83 ec 1c             	sub    $0x1c,%esp
80106d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106d1c:	85 db                	test   %ebx,%ebx
80106d1e:	0f 84 cb 00 00 00    	je     80106def <switchuvm+0xdf>
  if(p->kstack == 0)
80106d24:	8b 43 08             	mov    0x8(%ebx),%eax
80106d27:	85 c0                	test   %eax,%eax
80106d29:	0f 84 da 00 00 00    	je     80106e09 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d2f:	8b 43 04             	mov    0x4(%ebx),%eax
80106d32:	85 c0                	test   %eax,%eax
80106d34:	0f 84 c2 00 00 00    	je     80106dfc <switchuvm+0xec>
  pushcli();
80106d3a:	e8 51 da ff ff       	call   80104790 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d3f:	e8 4c cd ff ff       	call   80103a90 <mycpu>
80106d44:	89 c6                	mov    %eax,%esi
80106d46:	e8 45 cd ff ff       	call   80103a90 <mycpu>
80106d4b:	89 c7                	mov    %eax,%edi
80106d4d:	e8 3e cd ff ff       	call   80103a90 <mycpu>
80106d52:	83 c7 08             	add    $0x8,%edi
80106d55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d58:	e8 33 cd ff ff       	call   80103a90 <mycpu>
80106d5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d60:	ba 67 00 00 00       	mov    $0x67,%edx
80106d65:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d6c:	83 c0 08             	add    $0x8,%eax
80106d6f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d76:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d7b:	83 c1 08             	add    $0x8,%ecx
80106d7e:	c1 e8 18             	shr    $0x18,%eax
80106d81:	c1 e9 10             	shr    $0x10,%ecx
80106d84:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
80106d8a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106d90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d95:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d9c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106da1:	e8 ea cc ff ff       	call   80103a90 <mycpu>
80106da6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106dad:	e8 de cc ff ff       	call   80103a90 <mycpu>
80106db2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106db6:	8b 73 08             	mov    0x8(%ebx),%esi
80106db9:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106dbf:	e8 cc cc ff ff       	call   80103a90 <mycpu>
80106dc4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106dc7:	e8 c4 cc ff ff       	call   80103a90 <mycpu>
80106dcc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106dd0:	b8 28 00 00 00       	mov    $0x28,%eax
80106dd5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106dd8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ddb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106de0:	0f 22 d8             	mov    %eax,%cr3
}
80106de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de6:	5b                   	pop    %ebx
80106de7:	5e                   	pop    %esi
80106de8:	5f                   	pop    %edi
80106de9:	5d                   	pop    %ebp
  popcli();
80106dea:	e9 b1 da ff ff       	jmp    801048a0 <popcli>
    panic("switchuvm: no process");
80106def:	83 ec 0c             	sub    $0xc,%esp
80106df2:	68 1e 7e 10 80       	push   $0x80107e1e
80106df7:	e8 94 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	68 49 7e 10 80       	push   $0x80107e49
80106e04:	e8 87 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106e09:	83 ec 0c             	sub    $0xc,%esp
80106e0c:	68 34 7e 10 80       	push   $0x80107e34
80106e11:	e8 7a 95 ff ff       	call   80100390 <panic>
80106e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1d:	8d 76 00             	lea    0x0(%esi),%esi

80106e20 <inituvm>:
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	83 ec 1c             	sub    $0x1c,%esp
80106e29:	8b 45 08             	mov    0x8(%ebp),%eax
80106e2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106e2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106e32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e3b:	77 49                	ja     80106e86 <inituvm+0x66>
  mem = kalloc();
80106e3d:	e8 ae b9 ff ff       	call   801027f0 <kalloc>
  memset(mem, 0, PGSIZE);
80106e42:	83 ec 04             	sub    $0x4,%esp
80106e45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e4c:	6a 00                	push   $0x0
80106e4e:	50                   	push   %eax
80106e4f:	e8 fc da ff ff       	call   80104950 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e54:	58                   	pop    %eax
80106e55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e5b:	5a                   	pop    %edx
80106e5c:	6a 06                	push   $0x6
80106e5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e63:	31 d2                	xor    %edx,%edx
80106e65:	50                   	push   %eax
80106e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e69:	e8 c2 fc ff ff       	call   80106b30 <mappages>
  memmove(mem, init, sz);
80106e6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e71:	83 c4 10             	add    $0x10,%esp
80106e74:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e7d:	5b                   	pop    %ebx
80106e7e:	5e                   	pop    %esi
80106e7f:	5f                   	pop    %edi
80106e80:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e81:	e9 6a db ff ff       	jmp    801049f0 <memmove>
    panic("inituvm: more than a page");
80106e86:	83 ec 0c             	sub    $0xc,%esp
80106e89:	68 5d 7e 10 80       	push   $0x80107e5d
80106e8e:	e8 fd 94 ff ff       	call   80100390 <panic>
80106e93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ea0 <loaduvm>:
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
80106ea6:	83 ec 1c             	sub    $0x1c,%esp
80106ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eac:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106eaf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106eb4:	0f 85 8d 00 00 00    	jne    80106f47 <loaduvm+0xa7>
80106eba:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106ebc:	89 f3                	mov    %esi,%ebx
80106ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ec1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ec4:	01 f0                	add    %esi,%eax
80106ec6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ec9:	85 f6                	test   %esi,%esi
80106ecb:	75 11                	jne    80106ede <loaduvm+0x3e>
80106ecd:	eb 61                	jmp    80106f30 <loaduvm+0x90>
80106ecf:	90                   	nop
80106ed0:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ed6:	89 f0                	mov    %esi,%eax
80106ed8:	29 d8                	sub    %ebx,%eax
80106eda:	39 c6                	cmp    %eax,%esi
80106edc:	76 52                	jbe    80106f30 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ede:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ee1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee4:	31 c9                	xor    %ecx,%ecx
80106ee6:	29 da                	sub    %ebx,%edx
80106ee8:	e8 c3 fb ff ff       	call   80106ab0 <walkpgdir>
80106eed:	85 c0                	test   %eax,%eax
80106eef:	74 49                	je     80106f3a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106ef1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ef3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ef6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106efb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f00:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106f06:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f09:	29 d9                	sub    %ebx,%ecx
80106f0b:	05 00 00 00 80       	add    $0x80000000,%eax
80106f10:	57                   	push   %edi
80106f11:	51                   	push   %ecx
80106f12:	50                   	push   %eax
80106f13:	ff 75 10             	pushl  0x10(%ebp)
80106f16:	e8 f5 aa ff ff       	call   80101a10 <readi>
80106f1b:	83 c4 10             	add    $0x10,%esp
80106f1e:	39 f8                	cmp    %edi,%eax
80106f20:	74 ae                	je     80106ed0 <loaduvm+0x30>
}
80106f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f2a:	5b                   	pop    %ebx
80106f2b:	5e                   	pop    %esi
80106f2c:	5f                   	pop    %edi
80106f2d:	5d                   	pop    %ebp
80106f2e:	c3                   	ret    
80106f2f:	90                   	nop
80106f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f33:	31 c0                	xor    %eax,%eax
}
80106f35:	5b                   	pop    %ebx
80106f36:	5e                   	pop    %esi
80106f37:	5f                   	pop    %edi
80106f38:	5d                   	pop    %ebp
80106f39:	c3                   	ret    
      panic("loaduvm: address should exist");
80106f3a:	83 ec 0c             	sub    $0xc,%esp
80106f3d:	68 77 7e 10 80       	push   $0x80107e77
80106f42:	e8 49 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f47:	83 ec 0c             	sub    $0xc,%esp
80106f4a:	68 18 7f 10 80       	push   $0x80107f18
80106f4f:	e8 3c 94 ff ff       	call   80100390 <panic>
80106f54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f5f:	90                   	nop

80106f60 <allocuvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f69:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f6c:	85 ff                	test   %edi,%edi
80106f6e:	0f 88 bc 00 00 00    	js     80107030 <allocuvm+0xd0>
  if(newsz < oldsz)
80106f74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f77:	0f 82 a3 00 00 00    	jb     80107020 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f80:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f8c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f8f:	0f 86 8e 00 00 00    	jbe    80107023 <allocuvm+0xc3>
80106f95:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f98:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f9b:	eb 42                	jmp    80106fdf <allocuvm+0x7f>
80106f9d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106fa0:	83 ec 04             	sub    $0x4,%esp
80106fa3:	68 00 10 00 00       	push   $0x1000
80106fa8:	6a 00                	push   $0x0
80106faa:	50                   	push   %eax
80106fab:	e8 a0 d9 ff ff       	call   80104950 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fb0:	58                   	pop    %eax
80106fb1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106fb7:	5a                   	pop    %edx
80106fb8:	6a 06                	push   $0x6
80106fba:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fbf:	89 da                	mov    %ebx,%edx
80106fc1:	50                   	push   %eax
80106fc2:	89 f8                	mov    %edi,%eax
80106fc4:	e8 67 fb ff ff       	call   80106b30 <mappages>
80106fc9:	83 c4 10             	add    $0x10,%esp
80106fcc:	85 c0                	test   %eax,%eax
80106fce:	78 70                	js     80107040 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106fd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fd6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106fd9:	0f 86 a1 00 00 00    	jbe    80107080 <allocuvm+0x120>
    mem = kalloc();
80106fdf:	e8 0c b8 ff ff       	call   801027f0 <kalloc>
80106fe4:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106fe6:	85 c0                	test   %eax,%eax
80106fe8:	75 b6                	jne    80106fa0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106fea:	83 ec 0c             	sub    $0xc,%esp
80106fed:	68 95 7e 10 80       	push   $0x80107e95
80106ff2:	e8 b9 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106ff7:	83 c4 10             	add    $0x10,%esp
80106ffa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ffd:	39 45 10             	cmp    %eax,0x10(%ebp)
80107000:	74 2e                	je     80107030 <allocuvm+0xd0>
80107002:	89 c1                	mov    %eax,%ecx
80107004:	8b 55 10             	mov    0x10(%ebp),%edx
80107007:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
8010700a:	31 ff                	xor    %edi,%edi
8010700c:	e8 af fb ff ff       	call   80106bc0 <deallocuvm.part.0>
}
80107011:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107014:	89 f8                	mov    %edi,%eax
80107016:	5b                   	pop    %ebx
80107017:	5e                   	pop    %esi
80107018:	5f                   	pop    %edi
80107019:	5d                   	pop    %ebp
8010701a:	c3                   	ret    
8010701b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010701f:	90                   	nop
    return oldsz;
80107020:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107026:	89 f8                	mov    %edi,%eax
80107028:	5b                   	pop    %ebx
80107029:	5e                   	pop    %esi
8010702a:	5f                   	pop    %edi
8010702b:	5d                   	pop    %ebp
8010702c:	c3                   	ret    
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
80107030:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107033:	31 ff                	xor    %edi,%edi
}
80107035:	5b                   	pop    %ebx
80107036:	89 f8                	mov    %edi,%eax
80107038:	5e                   	pop    %esi
80107039:	5f                   	pop    %edi
8010703a:	5d                   	pop    %ebp
8010703b:	c3                   	ret    
8010703c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107040:	83 ec 0c             	sub    $0xc,%esp
80107043:	68 ad 7e 10 80       	push   $0x80107ead
80107048:	e8 63 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
8010704d:	83 c4 10             	add    $0x10,%esp
80107050:	8b 45 0c             	mov    0xc(%ebp),%eax
80107053:	39 45 10             	cmp    %eax,0x10(%ebp)
80107056:	74 0d                	je     80107065 <allocuvm+0x105>
80107058:	89 c1                	mov    %eax,%ecx
8010705a:	8b 55 10             	mov    0x10(%ebp),%edx
8010705d:	8b 45 08             	mov    0x8(%ebp),%eax
80107060:	e8 5b fb ff ff       	call   80106bc0 <deallocuvm.part.0>
      kfree(mem);
80107065:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107068:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010706a:	56                   	push   %esi
8010706b:	e8 c0 b5 ff ff       	call   80102630 <kfree>
      return 0;
80107070:	83 c4 10             	add    $0x10,%esp
}
80107073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107076:	89 f8                	mov    %edi,%eax
80107078:	5b                   	pop    %ebx
80107079:	5e                   	pop    %esi
8010707a:	5f                   	pop    %edi
8010707b:	5d                   	pop    %ebp
8010707c:	c3                   	ret    
8010707d:	8d 76 00             	lea    0x0(%esi),%esi
80107080:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107083:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107086:	5b                   	pop    %ebx
80107087:	5e                   	pop    %esi
80107088:	89 f8                	mov    %edi,%eax
8010708a:	5f                   	pop    %edi
8010708b:	5d                   	pop    %ebp
8010708c:	c3                   	ret    
8010708d:	8d 76 00             	lea    0x0(%esi),%esi

80107090 <deallocuvm>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	8b 55 0c             	mov    0xc(%ebp),%edx
80107096:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107099:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010709c:	39 d1                	cmp    %edx,%ecx
8010709e:	73 10                	jae    801070b0 <deallocuvm+0x20>
}
801070a0:	5d                   	pop    %ebp
801070a1:	e9 1a fb ff ff       	jmp    80106bc0 <deallocuvm.part.0>
801070a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ad:	8d 76 00             	lea    0x0(%esi),%esi
801070b0:	89 d0                	mov    %edx,%eax
801070b2:	5d                   	pop    %ebp
801070b3:	c3                   	ret    
801070b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070bf:	90                   	nop

801070c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 0c             	sub    $0xc,%esp
801070c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070cc:	85 f6                	test   %esi,%esi
801070ce:	74 59                	je     80107129 <freevm+0x69>
  if(newsz >= oldsz)
801070d0:	31 c9                	xor    %ecx,%ecx
801070d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070d7:	89 f0                	mov    %esi,%eax
801070d9:	89 f3                	mov    %esi,%ebx
801070db:	e8 e0 fa ff ff       	call   80106bc0 <deallocuvm.part.0>
freevm(pde_t *pgdir)
801070e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070e6:	eb 0f                	jmp    801070f7 <freevm+0x37>
801070e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ef:	90                   	nop
801070f0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070f3:	39 df                	cmp    %ebx,%edi
801070f5:	74 23                	je     8010711a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070f7:	8b 03                	mov    (%ebx),%eax
801070f9:	a8 01                	test   $0x1,%al
801070fb:	74 f3                	je     801070f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107102:	83 ec 0c             	sub    $0xc,%esp
80107105:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107108:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010710d:	50                   	push   %eax
8010710e:	e8 1d b5 ff ff       	call   80102630 <kfree>
80107113:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107116:	39 df                	cmp    %ebx,%edi
80107118:	75 dd                	jne    801070f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010711a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010711d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107120:	5b                   	pop    %ebx
80107121:	5e                   	pop    %esi
80107122:	5f                   	pop    %edi
80107123:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107124:	e9 07 b5 ff ff       	jmp    80102630 <kfree>
    panic("freevm: no pgdir");
80107129:	83 ec 0c             	sub    $0xc,%esp
8010712c:	68 c9 7e 10 80       	push   $0x80107ec9
80107131:	e8 5a 92 ff ff       	call   80100390 <panic>
80107136:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713d:	8d 76 00             	lea    0x0(%esi),%esi

80107140 <setupkvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	56                   	push   %esi
80107144:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107145:	e8 a6 b6 ff ff       	call   801027f0 <kalloc>
8010714a:	89 c6                	mov    %eax,%esi
8010714c:	85 c0                	test   %eax,%eax
8010714e:	74 42                	je     80107192 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107150:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107153:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107158:	68 00 10 00 00       	push   $0x1000
8010715d:	6a 00                	push   $0x0
8010715f:	50                   	push   %eax
80107160:	e8 eb d7 ff ff       	call   80104950 <memset>
80107165:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107168:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010716b:	83 ec 08             	sub    $0x8,%esp
8010716e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107171:	ff 73 0c             	pushl  0xc(%ebx)
80107174:	8b 13                	mov    (%ebx),%edx
80107176:	50                   	push   %eax
80107177:	29 c1                	sub    %eax,%ecx
80107179:	89 f0                	mov    %esi,%eax
8010717b:	e8 b0 f9 ff ff       	call   80106b30 <mappages>
80107180:	83 c4 10             	add    $0x10,%esp
80107183:	85 c0                	test   %eax,%eax
80107185:	78 19                	js     801071a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107187:	83 c3 10             	add    $0x10,%ebx
8010718a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107190:	75 d6                	jne    80107168 <setupkvm+0x28>
}
80107192:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107195:	89 f0                	mov    %esi,%eax
80107197:	5b                   	pop    %ebx
80107198:	5e                   	pop    %esi
80107199:	5d                   	pop    %ebp
8010719a:	c3                   	ret    
8010719b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010719f:	90                   	nop
      freevm(pgdir);
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	56                   	push   %esi
      return 0;
801071a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801071a6:	e8 15 ff ff ff       	call   801070c0 <freevm>
      return 0;
801071ab:	83 c4 10             	add    $0x10,%esp
}
801071ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801071b1:	89 f0                	mov    %esi,%eax
801071b3:	5b                   	pop    %ebx
801071b4:	5e                   	pop    %esi
801071b5:	5d                   	pop    %ebp
801071b6:	c3                   	ret    
801071b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071be:	66 90                	xchg   %ax,%ax

801071c0 <kvmalloc>:
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071c6:	e8 75 ff ff ff       	call   80107140 <setupkvm>
801071cb:	a3 a4 55 11 80       	mov    %eax,0x801155a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071d0:	05 00 00 00 80       	add    $0x80000000,%eax
801071d5:	0f 22 d8             	mov    %eax,%cr3
}
801071d8:	c9                   	leave  
801071d9:	c3                   	ret    
801071da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071e1:	31 c9                	xor    %ecx,%ecx
{
801071e3:	89 e5                	mov    %esp,%ebp
801071e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071eb:	8b 45 08             	mov    0x8(%ebp),%eax
801071ee:	e8 bd f8 ff ff       	call   80106ab0 <walkpgdir>
  if(pte == 0)
801071f3:	85 c0                	test   %eax,%eax
801071f5:	74 05                	je     801071fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801071f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071fa:	c9                   	leave  
801071fb:	c3                   	ret    
    panic("clearpteu");
801071fc:	83 ec 0c             	sub    $0xc,%esp
801071ff:	68 da 7e 10 80       	push   $0x80107eda
80107204:	e8 87 91 ff ff       	call   80100390 <panic>
80107209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107210 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107219:	e8 22 ff ff ff       	call   80107140 <setupkvm>
8010721e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107221:	85 c0                	test   %eax,%eax
80107223:	0f 84 a0 00 00 00    	je     801072c9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107229:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010722c:	85 c9                	test   %ecx,%ecx
8010722e:	0f 84 95 00 00 00    	je     801072c9 <copyuvm+0xb9>
80107234:	31 f6                	xor    %esi,%esi
80107236:	eb 4e                	jmp    80107286 <copyuvm+0x76>
80107238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107240:	83 ec 04             	sub    $0x4,%esp
80107243:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107249:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010724c:	68 00 10 00 00       	push   $0x1000
80107251:	57                   	push   %edi
80107252:	50                   	push   %eax
80107253:	e8 98 d7 ff ff       	call   801049f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107258:	58                   	pop    %eax
80107259:	5a                   	pop    %edx
8010725a:	53                   	push   %ebx
8010725b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010725e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107261:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107266:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010726c:	52                   	push   %edx
8010726d:	89 f2                	mov    %esi,%edx
8010726f:	e8 bc f8 ff ff       	call   80106b30 <mappages>
80107274:	83 c4 10             	add    $0x10,%esp
80107277:	85 c0                	test   %eax,%eax
80107279:	78 39                	js     801072b4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010727b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107281:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107284:	76 43                	jbe    801072c9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107286:	8b 45 08             	mov    0x8(%ebp),%eax
80107289:	31 c9                	xor    %ecx,%ecx
8010728b:	89 f2                	mov    %esi,%edx
8010728d:	e8 1e f8 ff ff       	call   80106ab0 <walkpgdir>
80107292:	85 c0                	test   %eax,%eax
80107294:	74 3e                	je     801072d4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107296:	8b 18                	mov    (%eax),%ebx
80107298:	f6 c3 01             	test   $0x1,%bl
8010729b:	74 44                	je     801072e1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010729d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010729f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801072a5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801072ab:	e8 40 b5 ff ff       	call   801027f0 <kalloc>
801072b0:	85 c0                	test   %eax,%eax
801072b2:	75 8c                	jne    80107240 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801072b4:	83 ec 0c             	sub    $0xc,%esp
801072b7:	ff 75 e0             	pushl  -0x20(%ebp)
801072ba:	e8 01 fe ff ff       	call   801070c0 <freevm>
  return 0;
801072bf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801072c6:	83 c4 10             	add    $0x10,%esp
}
801072c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072cf:	5b                   	pop    %ebx
801072d0:	5e                   	pop    %esi
801072d1:	5f                   	pop    %edi
801072d2:	5d                   	pop    %ebp
801072d3:	c3                   	ret    
      panic("copyuvm: pte should exist");
801072d4:	83 ec 0c             	sub    $0xc,%esp
801072d7:	68 e4 7e 10 80       	push   $0x80107ee4
801072dc:	e8 af 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
801072e1:	83 ec 0c             	sub    $0xc,%esp
801072e4:	68 fe 7e 10 80       	push   $0x80107efe
801072e9:	e8 a2 90 ff ff       	call   80100390 <panic>
801072ee:	66 90                	xchg   %ax,%ax

801072f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072f1:	31 c9                	xor    %ecx,%ecx
{
801072f3:	89 e5                	mov    %esp,%ebp
801072f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072fb:	8b 45 08             	mov    0x8(%ebp),%eax
801072fe:	e8 ad f7 ff ff       	call   80106ab0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107303:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107305:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107306:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107308:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010730d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107310:	05 00 00 00 80       	add    $0x80000000,%eax
80107315:	83 fa 05             	cmp    $0x5,%edx
80107318:	ba 00 00 00 00       	mov    $0x0,%edx
8010731d:	0f 45 c2             	cmovne %edx,%eax
}
80107320:	c3                   	ret    
80107321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732f:	90                   	nop

80107330 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 0c             	sub    $0xc,%esp
80107339:	8b 75 14             	mov    0x14(%ebp),%esi
8010733c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010733f:	85 f6                	test   %esi,%esi
80107341:	75 38                	jne    8010737b <copyout+0x4b>
80107343:	eb 6b                	jmp    801073b0 <copyout+0x80>
80107345:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107348:	8b 55 0c             	mov    0xc(%ebp),%edx
8010734b:	89 fb                	mov    %edi,%ebx
8010734d:	29 d3                	sub    %edx,%ebx
8010734f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107355:	39 f3                	cmp    %esi,%ebx
80107357:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010735a:	29 fa                	sub    %edi,%edx
8010735c:	83 ec 04             	sub    $0x4,%esp
8010735f:	01 c2                	add    %eax,%edx
80107361:	53                   	push   %ebx
80107362:	ff 75 10             	pushl  0x10(%ebp)
80107365:	52                   	push   %edx
80107366:	e8 85 d6 ff ff       	call   801049f0 <memmove>
    len -= n;
    buf += n;
8010736b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
8010736e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107374:	83 c4 10             	add    $0x10,%esp
80107377:	29 de                	sub    %ebx,%esi
80107379:	74 35                	je     801073b0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
8010737b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
8010737d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107380:	89 55 0c             	mov    %edx,0xc(%ebp)
80107383:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107389:	57                   	push   %edi
8010738a:	ff 75 08             	pushl  0x8(%ebp)
8010738d:	e8 5e ff ff ff       	call   801072f0 <uva2ka>
    if(pa0 == 0)
80107392:	83 c4 10             	add    $0x10,%esp
80107395:	85 c0                	test   %eax,%eax
80107397:	75 af                	jne    80107348 <copyout+0x18>
  }
  return 0;
}
80107399:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010739c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073a1:	5b                   	pop    %ebx
801073a2:	5e                   	pop    %esi
801073a3:	5f                   	pop    %edi
801073a4:	5d                   	pop    %ebp
801073a5:	c3                   	ret    
801073a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ad:	8d 76 00             	lea    0x0(%esi),%esi
801073b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073b3:	31 c0                	xor    %eax,%eax
}
801073b5:	5b                   	pop    %ebx
801073b6:	5e                   	pop    %esi
801073b7:	5f                   	pop    %edi
801073b8:	5d                   	pop    %ebp
801073b9:	c3                   	ret    
