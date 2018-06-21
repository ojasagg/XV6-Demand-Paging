
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d0 30 10 80       	mov    $0x801030d0,%eax
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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 80 75 10 80       	push   $0x80107580
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 a5 43 00 00       	call   80104400 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 75 10 80       	push   $0x80107587
80100097:	50                   	push   %eax
80100098:	e8 53 42 00 00       	call   801042f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 17 44 00 00       	call   80104500 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 b9 44 00 00       	call   80104620 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 41 00 00       	call   80104330 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 dd 21 00 00       	call   80102360 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 8e 75 10 80       	push   $0x8010758e
80100198:	e8 03 03 00 00       	call   801004a0 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 42 00 00       	call   801043d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 97 21 00 00       	jmp    80102360 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 75 10 80       	push   $0x8010759f
801001d1:	e8 ca 02 00 00       	call   801004a0 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 41 00 00       	call   801043d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");
	
  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 41 00 00       	call   80104390 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 f0 42 00 00       	call   80104500 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");
	
  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");
	
  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 bf 43 00 00       	jmp    80104620 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 75 10 80       	push   $0x801075a6
80100269:	e8 32 02 00 00       	call   801004a0 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <write_page_to_disk>:
/* Write 4096 bytes pg to the eight consecutive
 * starting at blk.
 */
void
write_page_to_disk(uint dev, char *pg, uint blk)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010027c:	8b 45 08             	mov    0x8(%ebp),%eax
8010027f:	8b 75 10             	mov    0x10(%ebp),%esi
	if(pg==0)
80100282:	85 db                	test   %ebx,%ebx
/* Write 4096 bytes pg to the eight consecutive
 * starting at blk.
 */
void
write_page_to_disk(uint dev, char *pg, uint blk)
{
80100284:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(pg==0)
80100287:	0f 84 83 00 00 00    	je     80100310 <write_page_to_disk+0xa0>
		{
			cprintf("Returning\n");
			return ;
		}
	cprintf("wriitng to disk\n");
8010028d:	83 ec 0c             	sub    $0xc,%esp
80100290:	68 b8 75 10 80       	push   $0x801075b8
80100295:	e8 f6 04 00 00       	call   80100790 <cprintf>
8010029a:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801002a0:	83 c4 10             	add    $0x10,%esp
801002a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801002a6:	8d 76 00             	lea    0x0(%esi),%esi
801002a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
	int i;
	struct buf* b;
	for(i = 0; i<8; i++)
	{
		begin_op();
801002b0:	e8 0b 2b 00 00       	call   80102dc0 <begin_op>
		b = bread(dev, blk+i);
801002b5:	83 ec 08             	sub    $0x8,%esp
801002b8:	56                   	push   %esi
801002b9:	ff 75 e4             	pushl  -0x1c(%ebp)
801002bc:	83 c6 01             	add    $0x1,%esi
801002bf:	e8 0c fe ff ff       	call   801000d0 <bread>
801002c4:	89 c7                	mov    %eax,%edi
		memmove(b->data, pg+i*512,512);
801002c6:	8d 40 5c             	lea    0x5c(%eax),%eax
801002c9:	83 c4 0c             	add    $0xc,%esp
801002cc:	68 00 02 00 00       	push   $0x200
801002d1:	53                   	push   %ebx
801002d2:	81 c3 00 02 00 00    	add    $0x200,%ebx
801002d8:	50                   	push   %eax
801002d9:	e8 42 44 00 00       	call   80104720 <memmove>
		log_write(b);
801002de:	89 3c 24             	mov    %edi,(%esp)
801002e1:	e8 ba 2c 00 00       	call   80102fa0 <log_write>
		brelse(b);
801002e6:	89 3c 24             	mov    %edi,(%esp)
801002e9:	e8 f2 fe ff ff       	call   801001e0 <brelse>
		end_op();
801002ee:	e8 3d 2b 00 00       	call   80102e30 <end_op>
			return ;
		}
	cprintf("wriitng to disk\n");
	int i;
	struct buf* b;
	for(i = 0; i<8; i++)
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
801002f9:	75 b5                	jne    801002b0 <write_page_to_disk+0x40>
		memmove(b->data, pg+i*512,512);
		log_write(b);
		brelse(b);
		end_op();
	}
	cprintf("write complete\n");
801002fb:	c7 45 08 c9 75 10 80 	movl   $0x801075c9,0x8(%ebp)
}
80100302:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100305:	5b                   	pop    %ebx
80100306:	5e                   	pop    %esi
80100307:	5f                   	pop    %edi
80100308:	5d                   	pop    %ebp
		memmove(b->data, pg+i*512,512);
		log_write(b);
		brelse(b);
		end_op();
	}
	cprintf("write complete\n");
80100309:	e9 82 04 00 00       	jmp    80100790 <cprintf>
8010030e:	66 90                	xchg   %ax,%ax
void
write_page_to_disk(uint dev, char *pg, uint blk)
{
	if(pg==0)
		{
			cprintf("Returning\n");
80100310:	c7 45 08 ad 75 10 80 	movl   $0x801075ad,0x8(%ebp)
		log_write(b);
		brelse(b);
		end_op();
	}
	cprintf("write complete\n");
}
80100317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010031a:	5b                   	pop    %ebx
8010031b:	5e                   	pop    %esi
8010031c:	5f                   	pop    %edi
8010031d:	5d                   	pop    %ebp
		memmove(b->data, pg+i*512,512);
		log_write(b);
		brelse(b);
		end_op();
	}
	cprintf("write complete\n");
8010031e:	e9 6d 04 00 00       	jmp    80100790 <cprintf>
80100323:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100330 <read_page_from_disk>:
/* Read 4096 bytes from the eight consecutive
 * starting at blk into pg.
 */
void
read_page_from_disk(uint dev, char *pg, uint blk)
{
80100330:	55                   	push   %ebp
80100331:	89 e5                	mov    %esp,%ebp
80100333:	57                   	push   %edi
80100334:	56                   	push   %esi
80100335:	53                   	push   %ebx
80100336:	83 ec 1c             	sub    $0x1c,%esp
80100339:	8b 45 08             	mov    0x8(%ebp),%eax
8010033c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010033f:	8b 75 10             	mov    0x10(%ebp),%esi
80100342:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100345:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010034b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010034e:	66 90                	xchg   %ax,%ax
	int i;
	for(i = 0; i<8; i++)
	{
		struct buf* b = bread(dev, blk+i);
80100350:	83 ec 08             	sub    $0x8,%esp
80100353:	56                   	push   %esi
80100354:	ff 75 e0             	pushl  -0x20(%ebp)
80100357:	83 c6 01             	add    $0x1,%esi
8010035a:	e8 71 fd ff ff       	call   801000d0 <bread>
8010035f:	89 c7                	mov    %eax,%edi
		memmove(pg+i*512, b->data, 512);
80100361:	8d 40 5c             	lea    0x5c(%eax),%eax
80100364:	83 c4 0c             	add    $0xc,%esp
80100367:	68 00 02 00 00       	push   $0x200
8010036c:	50                   	push   %eax
8010036d:	53                   	push   %ebx
8010036e:	81 c3 00 02 00 00    	add    $0x200,%ebx
80100374:	e8 a7 43 00 00       	call   80104720 <memmove>
		//cprintf("hiiiii\n");
		brelse(b);
80100379:	89 3c 24             	mov    %edi,(%esp)
8010037c:	e8 5f fe ff ff       	call   801001e0 <brelse>
 */
void
read_page_from_disk(uint dev, char *pg, uint blk)
{
	int i;
	for(i = 0; i<8; i++)
80100381:	83 c4 10             	add    $0x10,%esp
80100384:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100387:	75 c7                	jne    80100350 <read_page_from_disk+0x20>
		struct buf* b = bread(dev, blk+i);
		memmove(pg+i*512, b->data, 512);
		//cprintf("hiiiii\n");
		brelse(b);
	}
	cprintf("read complete\n");
80100389:	c7 45 08 d9 75 10 80 	movl   $0x801075d9,0x8(%ebp)
}
80100390:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100393:	5b                   	pop    %ebx
80100394:	5e                   	pop    %esi
80100395:	5f                   	pop    %edi
80100396:	5d                   	pop    %ebp
		struct buf* b = bread(dev, blk+i);
		memmove(pg+i*512, b->data, 512);
		//cprintf("hiiiii\n");
		brelse(b);
	}
	cprintf("read complete\n");
80100397:	e9 f4 03 00 00       	jmp    80100790 <cprintf>
8010039c:	66 90                	xchg   %ax,%ax
8010039e:	66 90                	xchg   %ax,%ax

801003a0 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	57                   	push   %edi
801003a4:	56                   	push   %esi
801003a5:	53                   	push   %ebx
801003a6:	83 ec 28             	sub    $0x28,%esp
801003a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801003ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
801003af:	57                   	push   %edi
801003b0:	e8 0b 16 00 00       	call   801019c0 <iunlock>
  target = n;
  acquire(&cons.lock);
801003b5:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801003bc:	e8 3f 41 00 00       	call   80104500 <acquire>
  while(n > 0){
801003c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
801003c4:	83 c4 10             	add    $0x10,%esp
801003c7:	31 c0                	xor    %eax,%eax
801003c9:	85 db                	test   %ebx,%ebx
801003cb:	0f 8e 9a 00 00 00    	jle    8010046b <consoleread+0xcb>
    while(input.r == input.w){
801003d1:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801003d6:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801003dc:	74 24                	je     80100402 <consoleread+0x62>
801003de:	eb 58                	jmp    80100438 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	68 20 b5 10 80       	push   $0x8010b520
801003e8:	68 a0 0f 11 80       	push   $0x80110fa0
801003ed:	e8 7e 3b 00 00       	call   80103f70 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801003f2:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801003f7:	83 c4 10             	add    $0x10,%esp
801003fa:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100400:	75 36                	jne    80100438 <consoleread+0x98>
      if(myproc()->killed){
80100402:	e8 e9 35 00 00       	call   801039f0 <myproc>
80100407:	8b 40 24             	mov    0x24(%eax),%eax
8010040a:	85 c0                	test   %eax,%eax
8010040c:	74 d2                	je     801003e0 <consoleread+0x40>
        release(&cons.lock);
8010040e:	83 ec 0c             	sub    $0xc,%esp
80100411:	68 20 b5 10 80       	push   $0x8010b520
80100416:	e8 05 42 00 00       	call   80104620 <release>
        ilock(ip);
8010041b:	89 3c 24             	mov    %edi,(%esp)
8010041e:	e8 bd 14 00 00       	call   801018e0 <ilock>
        return -1;
80100423:	83 c4 10             	add    $0x10,%esp
80100426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010042b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010042e:	5b                   	pop    %ebx
8010042f:	5e                   	pop    %esi
80100430:	5f                   	pop    %edi
80100431:	5d                   	pop    %ebp
80100432:	c3                   	ret    
80100433:	90                   	nop
80100434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100438:	8d 50 01             	lea    0x1(%eax),%edx
8010043b:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100441:	89 c2                	mov    %eax,%edx
80100443:	83 e2 7f             	and    $0x7f,%edx
80100446:	0f be 92 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%edx
    if(c == C('D')){  // EOF
8010044d:	83 fa 04             	cmp    $0x4,%edx
80100450:	74 39                	je     8010048b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100452:	83 c6 01             	add    $0x1,%esi
    --n;
80100455:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100458:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010045b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010045e:	74 35                	je     80100495 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100460:	85 db                	test   %ebx,%ebx
80100462:	0f 85 69 ff ff ff    	jne    801003d1 <consoleread+0x31>
80100468:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010046b:	83 ec 0c             	sub    $0xc,%esp
8010046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100471:	68 20 b5 10 80       	push   $0x8010b520
80100476:	e8 a5 41 00 00       	call   80104620 <release>
  ilock(ip);
8010047b:	89 3c 24             	mov    %edi,(%esp)
8010047e:	e8 5d 14 00 00       	call   801018e0 <ilock>

  return target - n;
80100483:	83 c4 10             	add    $0x10,%esp
80100486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100489:	eb a0                	jmp    8010042b <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010048b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010048e:	76 05                	jbe    80100495 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100490:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100495:	8b 45 10             	mov    0x10(%ebp),%eax
80100498:	29 d8                	sub    %ebx,%eax
8010049a:	eb cf                	jmp    8010046b <consoleread+0xcb>
8010049c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801004a0 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
801004a0:	55                   	push   %ebp
801004a1:	89 e5                	mov    %esp,%ebp
801004a3:	56                   	push   %esi
801004a4:	53                   	push   %ebx
801004a5:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
801004a8:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
801004a9:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801004b0:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
801004b3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801004b6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
801004b9:	e8 a2 24 00 00       	call   80102960 <lapicid>
801004be:	83 ec 08             	sub    $0x8,%esp
801004c1:	50                   	push   %eax
801004c2:	68 e8 75 10 80       	push   $0x801075e8
801004c7:	e8 c4 02 00 00       	call   80100790 <cprintf>
  cprintf(s);
801004cc:	58                   	pop    %eax
801004cd:	ff 75 08             	pushl  0x8(%ebp)
801004d0:	e8 bb 02 00 00       	call   80100790 <cprintf>
  cprintf("\n");
801004d5:	c7 04 24 f3 76 10 80 	movl   $0x801076f3,(%esp)
801004dc:	e8 af 02 00 00       	call   80100790 <cprintf>
  getcallerpcs(&s, pcs);
801004e1:	5a                   	pop    %edx
801004e2:	8d 45 08             	lea    0x8(%ebp),%eax
801004e5:	59                   	pop    %ecx
801004e6:	53                   	push   %ebx
801004e7:	50                   	push   %eax
801004e8:	e8 33 3f 00 00       	call   80104420 <getcallerpcs>
801004ed:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801004f0:	83 ec 08             	sub    $0x8,%esp
801004f3:	ff 33                	pushl  (%ebx)
801004f5:	83 c3 04             	add    $0x4,%ebx
801004f8:	68 fc 75 10 80       	push   $0x801075fc
801004fd:	e8 8e 02 00 00       	call   80100790 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
80100502:	83 c4 10             	add    $0x10,%esp
80100505:	39 f3                	cmp    %esi,%ebx
80100507:	75 e7                	jne    801004f0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
80100509:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100510:	00 00 00 
80100513:	eb fe                	jmp    80100513 <panic+0x73>
80100515:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100520 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
80100520:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100526:	85 d2                	test   %edx,%edx
80100528:	74 06                	je     80100530 <consputc+0x10>
8010052a:	fa                   	cli    
8010052b:	eb fe                	jmp    8010052b <consputc+0xb>
8010052d:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100530:	55                   	push   %ebp
80100531:	89 e5                	mov    %esp,%ebp
80100533:	57                   	push   %edi
80100534:	56                   	push   %esi
80100535:	53                   	push   %ebx
80100536:	89 c3                	mov    %eax,%ebx
80100538:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010053b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100540:	0f 84 b8 00 00 00    	je     801005fe <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100546:	83 ec 0c             	sub    $0xc,%esp
80100549:	50                   	push   %eax
8010054a:	e8 91 5a 00 00       	call   80105fe0 <uartputc>
8010054f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100552:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100557:	b8 0e 00 00 00       	mov    $0xe,%eax
8010055c:	89 fa                	mov    %edi,%edx
8010055e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010055f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100564:	89 f2                	mov    %esi,%edx
80100566:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100567:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010056a:	89 fa                	mov    %edi,%edx
8010056c:	c1 e0 08             	shl    $0x8,%eax
8010056f:	89 c1                	mov    %eax,%ecx
80100571:	b8 0f 00 00 00       	mov    $0xf,%eax
80100576:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100577:	89 f2                	mov    %esi,%edx
80100579:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010057a:	0f b6 c0             	movzbl %al,%eax
8010057d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010057f:	83 fb 0a             	cmp    $0xa,%ebx
80100582:	0f 84 0b 01 00 00    	je     80100693 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100588:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010058e:	0f 84 e6 00 00 00    	je     8010067a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100594:	0f b6 d3             	movzbl %bl,%edx
80100597:	8d 78 01             	lea    0x1(%eax),%edi
8010059a:	80 ce 07             	or     $0x7,%dh
8010059d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
801005a4:	80 

  if(pos < 0 || pos > 25*80)
801005a5:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
801005ab:	0f 8f bc 00 00 00    	jg     8010066d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
801005b1:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
801005b7:	7f 6f                	jg     80100628 <consputc+0x108>
801005b9:	89 f8                	mov    %edi,%eax
801005bb:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
801005c2:	89 fb                	mov    %edi,%ebx
801005c4:	c1 e8 08             	shr    $0x8,%eax
801005c7:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801005c9:	bf d4 03 00 00       	mov    $0x3d4,%edi
801005ce:	b8 0e 00 00 00       	mov    $0xe,%eax
801005d3:	89 fa                	mov    %edi,%edx
801005d5:	ee                   	out    %al,(%dx)
801005d6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801005db:	89 f0                	mov    %esi,%eax
801005dd:	ee                   	out    %al,(%dx)
801005de:	b8 0f 00 00 00       	mov    $0xf,%eax
801005e3:	89 fa                	mov    %edi,%edx
801005e5:	ee                   	out    %al,(%dx)
801005e6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801005eb:	89 d8                	mov    %ebx,%eax
801005ed:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801005ee:	b8 20 07 00 00       	mov    $0x720,%eax
801005f3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801005f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f9:	5b                   	pop    %ebx
801005fa:	5e                   	pop    %esi
801005fb:	5f                   	pop    %edi
801005fc:	5d                   	pop    %ebp
801005fd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801005fe:	83 ec 0c             	sub    $0xc,%esp
80100601:	6a 08                	push   $0x8
80100603:	e8 d8 59 00 00       	call   80105fe0 <uartputc>
80100608:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010060f:	e8 cc 59 00 00       	call   80105fe0 <uartputc>
80100614:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010061b:	e8 c0 59 00 00       	call   80105fe0 <uartputc>
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	e9 2a ff ff ff       	jmp    80100552 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100628:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
8010062b:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010062e:	68 60 0e 00 00       	push   $0xe60
80100633:	68 a0 80 0b 80       	push   $0x800b80a0
80100638:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010063d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100644:	e8 d7 40 00 00       	call   80104720 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100649:	b8 80 07 00 00       	mov    $0x780,%eax
8010064e:	83 c4 0c             	add    $0xc,%esp
80100651:	29 d8                	sub    %ebx,%eax
80100653:	01 c0                	add    %eax,%eax
80100655:	50                   	push   %eax
80100656:	6a 00                	push   $0x0
80100658:	56                   	push   %esi
80100659:	e8 12 40 00 00       	call   80104670 <memset>
8010065e:	89 f1                	mov    %esi,%ecx
80100660:	83 c4 10             	add    $0x10,%esp
80100663:	be 07 00 00 00       	mov    $0x7,%esi
80100668:	e9 5c ff ff ff       	jmp    801005c9 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010066d:	83 ec 0c             	sub    $0xc,%esp
80100670:	68 00 76 10 80       	push   $0x80107600
80100675:	e8 26 fe ff ff       	call   801004a0 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010067a:	85 c0                	test   %eax,%eax
8010067c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010067f:	0f 85 20 ff ff ff    	jne    801005a5 <consputc+0x85>
80100685:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010068a:	31 db                	xor    %ebx,%ebx
8010068c:	31 f6                	xor    %esi,%esi
8010068e:	e9 36 ff ff ff       	jmp    801005c9 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100693:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100698:	f7 ea                	imul   %edx
8010069a:	89 d0                	mov    %edx,%eax
8010069c:	c1 e8 05             	shr    $0x5,%eax
8010069f:	8d 04 80             	lea    (%eax,%eax,4),%eax
801006a2:	c1 e0 04             	shl    $0x4,%eax
801006a5:	8d 78 50             	lea    0x50(%eax),%edi
801006a8:	e9 f8 fe ff ff       	jmp    801005a5 <consputc+0x85>
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	89 d6                	mov    %edx,%esi
801006b8:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801006bb:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801006bd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801006c0:	74 0c                	je     801006ce <printint+0x1e>
801006c2:	89 c7                	mov    %eax,%edi
801006c4:	c1 ef 1f             	shr    $0x1f,%edi
801006c7:	85 c0                	test   %eax,%eax
801006c9:	89 7d d4             	mov    %edi,-0x2c(%ebp)
801006cc:	78 51                	js     8010071f <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
801006ce:	31 ff                	xor    %edi,%edi
801006d0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801006d3:	eb 05                	jmp    801006da <printint+0x2a>
801006d5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801006d8:	89 cf                	mov    %ecx,%edi
801006da:	31 d2                	xor    %edx,%edx
801006dc:	8d 4f 01             	lea    0x1(%edi),%ecx
801006df:	f7 f6                	div    %esi
801006e1:	0f b6 92 2c 76 10 80 	movzbl -0x7fef89d4(%edx),%edx
  }while((x /= base) != 0);
801006e8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801006ea:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801006ed:	75 e9                	jne    801006d8 <printint+0x28>

  if(sign)
801006ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801006f2:	85 c0                	test   %eax,%eax
801006f4:	74 08                	je     801006fe <printint+0x4e>
    buf[i++] = '-';
801006f6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801006fb:	8d 4f 02             	lea    0x2(%edi),%ecx
801006fe:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
80100702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
80100708:	0f be 06             	movsbl (%esi),%eax
8010070b:	83 ee 01             	sub    $0x1,%esi
8010070e:	e8 0d fe ff ff       	call   80100520 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100713:	39 de                	cmp    %ebx,%esi
80100715:	75 f1                	jne    80100708 <printint+0x58>
    consputc(buf[i]);
}
80100717:	83 c4 2c             	add    $0x2c,%esp
8010071a:	5b                   	pop    %ebx
8010071b:	5e                   	pop    %esi
8010071c:	5f                   	pop    %edi
8010071d:	5d                   	pop    %ebp
8010071e:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
8010071f:	f7 d8                	neg    %eax
80100721:	eb ab                	jmp    801006ce <printint+0x1e>
80100723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100730 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100730:	55                   	push   %ebp
80100731:	89 e5                	mov    %esp,%ebp
80100733:	57                   	push   %edi
80100734:	56                   	push   %esi
80100735:	53                   	push   %ebx
80100736:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100739:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010073c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010073f:	e8 7c 12 00 00       	call   801019c0 <iunlock>
  acquire(&cons.lock);
80100744:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010074b:	e8 b0 3d 00 00       	call   80104500 <acquire>
80100750:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100753:	83 c4 10             	add    $0x10,%esp
80100756:	85 f6                	test   %esi,%esi
80100758:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010075b:	7e 12                	jle    8010076f <consolewrite+0x3f>
8010075d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100760:	0f b6 07             	movzbl (%edi),%eax
80100763:	83 c7 01             	add    $0x1,%edi
80100766:	e8 b5 fd ff ff       	call   80100520 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010076b:	39 df                	cmp    %ebx,%edi
8010076d:	75 f1                	jne    80100760 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010076f:	83 ec 0c             	sub    $0xc,%esp
80100772:	68 20 b5 10 80       	push   $0x8010b520
80100777:	e8 a4 3e 00 00       	call   80104620 <release>
  ilock(ip);
8010077c:	58                   	pop    %eax
8010077d:	ff 75 08             	pushl  0x8(%ebp)
80100780:	e8 5b 11 00 00       	call   801018e0 <ilock>

  return n;
}
80100785:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100788:	89 f0                	mov    %esi,%eax
8010078a:	5b                   	pop    %ebx
8010078b:	5e                   	pop    %esi
8010078c:	5f                   	pop    %edi
8010078d:	5d                   	pop    %ebp
8010078e:	c3                   	ret    
8010078f:	90                   	nop

80100790 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100790:	55                   	push   %ebp
80100791:	89 e5                	mov    %esp,%ebp
80100793:	57                   	push   %edi
80100794:	56                   	push   %esi
80100795:	53                   	push   %ebx
80100796:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100799:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010079e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801007a3:	0f 85 47 01 00 00    	jne    801008f0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
801007a9:	8b 45 08             	mov    0x8(%ebp),%eax
801007ac:	85 c0                	test   %eax,%eax
801007ae:	89 c1                	mov    %eax,%ecx
801007b0:	0f 84 4f 01 00 00    	je     80100905 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b6:	0f b6 00             	movzbl (%eax),%eax
801007b9:	31 db                	xor    %ebx,%ebx
801007bb:	8d 75 0c             	lea    0xc(%ebp),%esi
801007be:	89 cf                	mov    %ecx,%edi
801007c0:	85 c0                	test   %eax,%eax
801007c2:	75 55                	jne    80100819 <cprintf+0x89>
801007c4:	eb 68                	jmp    8010082e <cprintf+0x9e>
801007c6:	8d 76 00             	lea    0x0(%esi),%esi
801007c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801007d0:	83 c3 01             	add    $0x1,%ebx
801007d3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801007d7:	85 d2                	test   %edx,%edx
801007d9:	74 53                	je     8010082e <cprintf+0x9e>
      break;
    switch(c){
801007db:	83 fa 70             	cmp    $0x70,%edx
801007de:	74 7a                	je     8010085a <cprintf+0xca>
801007e0:	7f 6e                	jg     80100850 <cprintf+0xc0>
801007e2:	83 fa 25             	cmp    $0x25,%edx
801007e5:	0f 84 ad 00 00 00    	je     80100898 <cprintf+0x108>
801007eb:	83 fa 64             	cmp    $0x64,%edx
801007ee:	0f 85 84 00 00 00    	jne    80100878 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801007f4:	8d 46 04             	lea    0x4(%esi),%eax
801007f7:	b9 01 00 00 00       	mov    $0x1,%ecx
801007fc:	ba 0a 00 00 00       	mov    $0xa,%edx
80100801:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100804:	8b 06                	mov    (%esi),%eax
80100806:	e8 a5 fe ff ff       	call   801006b0 <printint>
8010080b:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010080e:	83 c3 01             	add    $0x1,%ebx
80100811:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
80100815:	85 c0                	test   %eax,%eax
80100817:	74 15                	je     8010082e <cprintf+0x9e>
    if(c != '%'){
80100819:	83 f8 25             	cmp    $0x25,%eax
8010081c:	74 b2                	je     801007d0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
8010081e:	e8 fd fc ff ff       	call   80100520 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100823:	83 c3 01             	add    $0x1,%ebx
80100826:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
8010082a:	85 c0                	test   %eax,%eax
8010082c:	75 eb                	jne    80100819 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
8010082e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100831:	85 c0                	test   %eax,%eax
80100833:	74 10                	je     80100845 <cprintf+0xb5>
    release(&cons.lock);
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 20 b5 10 80       	push   $0x8010b520
8010083d:	e8 de 3d 00 00       	call   80104620 <release>
80100842:	83 c4 10             	add    $0x10,%esp
}
80100845:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100848:	5b                   	pop    %ebx
80100849:	5e                   	pop    %esi
8010084a:	5f                   	pop    %edi
8010084b:	5d                   	pop    %ebp
8010084c:	c3                   	ret    
8010084d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100850:	83 fa 73             	cmp    $0x73,%edx
80100853:	74 5b                	je     801008b0 <cprintf+0x120>
80100855:	83 fa 78             	cmp    $0x78,%edx
80100858:	75 1e                	jne    80100878 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010085a:	8d 46 04             	lea    0x4(%esi),%eax
8010085d:	31 c9                	xor    %ecx,%ecx
8010085f:	ba 10 00 00 00       	mov    $0x10,%edx
80100864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100867:	8b 06                	mov    (%esi),%eax
80100869:	e8 42 fe ff ff       	call   801006b0 <printint>
8010086e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100871:	eb 9b                	jmp    8010080e <cprintf+0x7e>
80100873:	90                   	nop
80100874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100878:	b8 25 00 00 00       	mov    $0x25,%eax
8010087d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100880:	e8 9b fc ff ff       	call   80100520 <consputc>
      consputc(c);
80100885:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100888:	89 d0                	mov    %edx,%eax
8010088a:	e8 91 fc ff ff       	call   80100520 <consputc>
      break;
8010088f:	e9 7a ff ff ff       	jmp    8010080e <cprintf+0x7e>
80100894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100898:	b8 25 00 00 00       	mov    $0x25,%eax
8010089d:	e8 7e fc ff ff       	call   80100520 <consputc>
801008a2:	e9 7c ff ff ff       	jmp    80100823 <cprintf+0x93>
801008a7:	89 f6                	mov    %esi,%esi
801008a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801008b0:	8d 46 04             	lea    0x4(%esi),%eax
801008b3:	8b 36                	mov    (%esi),%esi
801008b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
801008b8:	b8 13 76 10 80       	mov    $0x80107613,%eax
801008bd:	85 f6                	test   %esi,%esi
801008bf:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
801008c2:	0f be 06             	movsbl (%esi),%eax
801008c5:	84 c0                	test   %al,%al
801008c7:	74 16                	je     801008df <cprintf+0x14f>
801008c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801008d0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801008d3:	e8 48 fc ff ff       	call   80100520 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801008d8:	0f be 06             	movsbl (%esi),%eax
801008db:	84 c0                	test   %al,%al
801008dd:	75 f1                	jne    801008d0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801008df:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801008e2:	e9 27 ff ff ff       	jmp    8010080e <cprintf+0x7e>
801008e7:	89 f6                	mov    %esi,%esi
801008e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801008f0:	83 ec 0c             	sub    $0xc,%esp
801008f3:	68 20 b5 10 80       	push   $0x8010b520
801008f8:	e8 03 3c 00 00       	call   80104500 <acquire>
801008fd:	83 c4 10             	add    $0x10,%esp
80100900:	e9 a4 fe ff ff       	jmp    801007a9 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
80100905:	83 ec 0c             	sub    $0xc,%esp
80100908:	68 1a 76 10 80       	push   $0x8010761a
8010090d:	e8 8e fb ff ff       	call   801004a0 <panic>
80100912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100920 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100920:	55                   	push   %ebp
80100921:	89 e5                	mov    %esp,%ebp
80100923:	57                   	push   %edi
80100924:	56                   	push   %esi
80100925:	53                   	push   %ebx
  int c, doprocdump = 0;
80100926:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100928:	83 ec 18             	sub    $0x18,%esp
8010092b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
8010092e:	68 20 b5 10 80       	push   $0x8010b520
80100933:	e8 c8 3b 00 00       	call   80104500 <acquire>
  while((c = getc()) >= 0){
80100938:	83 c4 10             	add    $0x10,%esp
8010093b:	90                   	nop
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100940:	ff d3                	call   *%ebx
80100942:	85 c0                	test   %eax,%eax
80100944:	89 c7                	mov    %eax,%edi
80100946:	78 48                	js     80100990 <consoleintr+0x70>
    switch(c){
80100948:	83 ff 10             	cmp    $0x10,%edi
8010094b:	0f 84 3f 01 00 00    	je     80100a90 <consoleintr+0x170>
80100951:	7e 5d                	jle    801009b0 <consoleintr+0x90>
80100953:	83 ff 15             	cmp    $0x15,%edi
80100956:	0f 84 dc 00 00 00    	je     80100a38 <consoleintr+0x118>
8010095c:	83 ff 7f             	cmp    $0x7f,%edi
8010095f:	75 54                	jne    801009b5 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100961:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100966:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096c:	74 d2                	je     80100940 <consoleintr+0x20>
        input.e--;
8010096e:	83 e8 01             	sub    $0x1,%eax
80100971:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100976:	b8 00 01 00 00       	mov    $0x100,%eax
8010097b:	e8 a0 fb ff ff       	call   80100520 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100980:	ff d3                	call   *%ebx
80100982:	85 c0                	test   %eax,%eax
80100984:	89 c7                	mov    %eax,%edi
80100986:	79 c0                	jns    80100948 <consoleintr+0x28>
80100988:	90                   	nop
80100989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100990:	83 ec 0c             	sub    $0xc,%esp
80100993:	68 20 b5 10 80       	push   $0x8010b520
80100998:	e8 83 3c 00 00       	call   80104620 <release>
  if(doprocdump) {
8010099d:	83 c4 10             	add    $0x10,%esp
801009a0:	85 f6                	test   %esi,%esi
801009a2:	0f 85 f8 00 00 00    	jne    80100aa0 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
801009a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009ab:	5b                   	pop    %ebx
801009ac:	5e                   	pop    %esi
801009ad:	5f                   	pop    %edi
801009ae:	5d                   	pop    %ebp
801009af:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
801009b0:	83 ff 08             	cmp    $0x8,%edi
801009b3:	74 ac                	je     80100961 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009b5:	85 ff                	test   %edi,%edi
801009b7:	74 87                	je     80100940 <consoleintr+0x20>
801009b9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009be:	89 c2                	mov    %eax,%edx
801009c0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801009c6:	83 fa 7f             	cmp    $0x7f,%edx
801009c9:	0f 87 71 ff ff ff    	ja     80100940 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
801009cf:	8d 50 01             	lea    0x1(%eax),%edx
801009d2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801009d5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801009d8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801009de:	0f 84 c8 00 00 00    	je     80100aac <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801009e4:	89 f9                	mov    %edi,%ecx
801009e6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801009ec:	89 f8                	mov    %edi,%eax
801009ee:	e8 2d fb ff ff       	call   80100520 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009f3:	83 ff 0a             	cmp    $0xa,%edi
801009f6:	0f 84 c1 00 00 00    	je     80100abd <consoleintr+0x19d>
801009fc:	83 ff 04             	cmp    $0x4,%edi
801009ff:	0f 84 b8 00 00 00    	je     80100abd <consoleintr+0x19d>
80100a05:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
80100a0a:	83 e8 80             	sub    $0xffffff80,%eax
80100a0d:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100a13:	0f 85 27 ff ff ff    	jne    80100940 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
80100a19:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
80100a1c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a21:	68 a0 0f 11 80       	push   $0x80110fa0
80100a26:	e8 15 37 00 00       	call   80104140 <wakeup>
80100a2b:	83 c4 10             	add    $0x10,%esp
80100a2e:	e9 0d ff ff ff       	jmp    80100940 <consoleintr+0x20>
80100a33:	90                   	nop
80100a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100a38:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100a3d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100a43:	75 2b                	jne    80100a70 <consoleintr+0x150>
80100a45:	e9 f6 fe ff ff       	jmp    80100940 <consoleintr+0x20>
80100a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100a50:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100a55:	b8 00 01 00 00       	mov    $0x100,%eax
80100a5a:	e8 c1 fa ff ff       	call   80100520 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100a5f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100a64:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100a6a:	0f 84 d0 fe ff ff    	je     80100940 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a70:	83 e8 01             	sub    $0x1,%eax
80100a73:	89 c2                	mov    %eax,%edx
80100a75:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100a78:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100a7f:	75 cf                	jne    80100a50 <consoleintr+0x130>
80100a81:	e9 ba fe ff ff       	jmp    80100940 <consoleintr+0x20>
80100a86:	8d 76 00             	lea    0x0(%esi),%esi
80100a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100a90:	be 01 00 00 00       	mov    $0x1,%esi
80100a95:	e9 a6 fe ff ff       	jmp    80100940 <consoleintr+0x20>
80100a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aa3:	5b                   	pop    %ebx
80100aa4:	5e                   	pop    %esi
80100aa5:	5f                   	pop    %edi
80100aa6:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100aa7:	e9 84 37 00 00       	jmp    80104230 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
80100aac:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100ab3:	b8 0a 00 00 00       	mov    $0xa,%eax
80100ab8:	e8 63 fa ff ff       	call   80100520 <consputc>
80100abd:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100ac2:	e9 52 ff ff ff       	jmp    80100a19 <consoleintr+0xf9>
80100ac7:	89 f6                	mov    %esi,%esi
80100ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ad0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ad6:	68 23 76 10 80       	push   $0x80107623
80100adb:	68 20 b5 10 80       	push   $0x8010b520
80100ae0:	e8 1b 39 00 00       	call   80104400 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ae5:	58                   	pop    %eax
80100ae6:	5a                   	pop    %edx
80100ae7:	6a 00                	push   $0x0
80100ae9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100aeb:	c7 05 6c 19 11 80 30 	movl   $0x80100730,0x8011196c
80100af2:	07 10 80 
  devsw[CONSOLE].read = consoleread;
80100af5:	c7 05 68 19 11 80 a0 	movl   $0x801003a0,0x80111968
80100afc:	03 10 80 
  cons.locking = 1;
80100aff:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100b06:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b09:	e8 02 1a 00 00       	call   80102510 <ioapicenable>
}
80100b0e:	83 c4 10             	add    $0x10,%esp
80100b11:	c9                   	leave  
80100b12:	c3                   	ret    
80100b13:	66 90                	xchg   %ax,%ax
80100b15:	66 90                	xchg   %ax,%ax
80100b17:	66 90                	xchg   %ax,%ax
80100b19:	66 90                	xchg   %ax,%ax
80100b1b:	66 90                	xchg   %ax,%ax
80100b1d:	66 90                	xchg   %ax,%ax
80100b1f:	90                   	nop

80100b20 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b20:	55                   	push   %ebp
80100b21:	89 e5                	mov    %esp,%ebp
80100b23:	57                   	push   %edi
80100b24:	56                   	push   %esi
80100b25:	53                   	push   %ebx
80100b26:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b2c:	e8 bf 2e 00 00       	call   801039f0 <myproc>
80100b31:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100b37:	e8 84 22 00 00       	call   80102dc0 <begin_op>

  if((ip = namei(path)) == 0){
80100b3c:	83 ec 0c             	sub    $0xc,%esp
80100b3f:	ff 75 08             	pushl  0x8(%ebp)
80100b42:	e8 e9 15 00 00       	call   80102130 <namei>
80100b47:	83 c4 10             	add    $0x10,%esp
80100b4a:	85 c0                	test   %eax,%eax
80100b4c:	0f 84 9c 01 00 00    	je     80100cee <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	89 c3                	mov    %eax,%ebx
80100b57:	50                   	push   %eax
80100b58:	e8 83 0d 00 00       	call   801018e0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b5d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b63:	6a 34                	push   $0x34
80100b65:	6a 00                	push   $0x0
80100b67:	50                   	push   %eax
80100b68:	53                   	push   %ebx
80100b69:	e8 52 10 00 00       	call   80101bc0 <readi>
80100b6e:	83 c4 20             	add    $0x20,%esp
80100b71:	83 f8 34             	cmp    $0x34,%eax
80100b74:	74 22                	je     80100b98 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b76:	83 ec 0c             	sub    $0xc,%esp
80100b79:	53                   	push   %ebx
80100b7a:	e8 f1 0f 00 00       	call   80101b70 <iunlockput>
    end_op();
80100b7f:	e8 ac 22 00 00       	call   80102e30 <end_op>
80100b84:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b8f:	5b                   	pop    %ebx
80100b90:	5e                   	pop    %esi
80100b91:	5f                   	pop    %edi
80100b92:	5d                   	pop    %ebp
80100b93:	c3                   	ret    
80100b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b98:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b9f:	45 4c 46 
80100ba2:	75 d2                	jne    80100b76 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100ba4:	e8 07 66 00 00       	call   801071b0 <setupkvm>
80100ba9:	85 c0                	test   %eax,%eax
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	74 c3                	je     80100b76 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100bba:	00 
80100bbb:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100bc1:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100bc8:	00 00 00 
80100bcb:	0f 84 c5 00 00 00    	je     80100c96 <exec+0x176>
80100bd1:	31 ff                	xor    %edi,%edi
80100bd3:	eb 18                	jmp    80100bed <exec+0xcd>
80100bd5:	8d 76 00             	lea    0x0(%esi),%esi
80100bd8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bdf:	83 c7 01             	add    $0x1,%edi
80100be2:	83 c6 20             	add    $0x20,%esi
80100be5:	39 f8                	cmp    %edi,%eax
80100be7:	0f 8e a9 00 00 00    	jle    80100c96 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bed:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bf3:	6a 20                	push   $0x20
80100bf5:	56                   	push   %esi
80100bf6:	50                   	push   %eax
80100bf7:	53                   	push   %ebx
80100bf8:	e8 c3 0f 00 00       	call   80101bc0 <readi>
80100bfd:	83 c4 10             	add    $0x10,%esp
80100c00:	83 f8 20             	cmp    $0x20,%eax
80100c03:	75 7b                	jne    80100c80 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c05:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c0c:	75 ca                	jne    80100bd8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100c0e:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c14:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100c1a:	72 64                	jb     80100c80 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c1c:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100c22:	72 5c                	jb     80100c80 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c24:	83 ec 04             	sub    $0x4,%esp
80100c27:	50                   	push   %eax
80100c28:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100c2e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c34:	e8 c7 63 00 00       	call   80107000 <allocuvm>
80100c39:	83 c4 10             	add    $0x10,%esp
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100c44:	74 3a                	je     80100c80 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100c46:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c4c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c51:	75 2d                	jne    80100c80 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c53:	83 ec 0c             	sub    $0xc,%esp
80100c56:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c5c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c62:	53                   	push   %ebx
80100c63:	50                   	push   %eax
80100c64:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c6a:	e8 d1 62 00 00       	call   80106f40 <loaduvm>
80100c6f:	83 c4 20             	add    $0x20,%esp
80100c72:	85 c0                	test   %eax,%eax
80100c74:	0f 89 5e ff ff ff    	jns    80100bd8 <exec+0xb8>
80100c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c80:	83 ec 0c             	sub    $0xc,%esp
80100c83:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c89:	e8 a2 64 00 00       	call   80107130 <freevm>
80100c8e:	83 c4 10             	add    $0x10,%esp
80100c91:	e9 e0 fe ff ff       	jmp    80100b76 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c96:	83 ec 0c             	sub    $0xc,%esp
80100c99:	53                   	push   %ebx
80100c9a:	e8 d1 0e 00 00       	call   80101b70 <iunlockput>
  end_op();
80100c9f:	e8 8c 21 00 00       	call   80102e30 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100ca4:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100caa:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100cad:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb7:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100cbd:	52                   	push   %edx
80100cbe:	50                   	push   %eax
80100cbf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cc5:	e8 36 63 00 00       	call   80107000 <allocuvm>
80100cca:	83 c4 10             	add    $0x10,%esp
80100ccd:	85 c0                	test   %eax,%eax
80100ccf:	89 c6                	mov    %eax,%esi
80100cd1:	75 3a                	jne    80100d0d <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100cd3:	83 ec 0c             	sub    $0xc,%esp
80100cd6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cdc:	e8 4f 64 00 00       	call   80107130 <freevm>
80100ce1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100ce4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ce9:	e9 9e fe ff ff       	jmp    80100b8c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100cee:	e8 3d 21 00 00       	call   80102e30 <end_op>
    cprintf("exec: fail\n");
80100cf3:	83 ec 0c             	sub    $0xc,%esp
80100cf6:	68 3d 76 10 80       	push   $0x8010763d
80100cfb:	e8 90 fa ff ff       	call   80100790 <cprintf>
    return -1;
80100d00:	83 c4 10             	add    $0x10,%esp
80100d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d08:	e9 7f fe ff ff       	jmp    80100b8c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d0d:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100d13:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d16:	31 ff                	xor    %edi,%edi
80100d18:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d1a:	50                   	push   %eax
80100d1b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d21:	e8 2a 66 00 00       	call   80107350 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d26:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d29:	83 c4 10             	add    $0x10,%esp
80100d2c:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100d32:	8b 00                	mov    (%eax),%eax
80100d34:	85 c0                	test   %eax,%eax
80100d36:	74 79                	je     80100db1 <exec+0x291>
80100d38:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100d3e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100d44:	eb 13                	jmp    80100d59 <exec+0x239>
80100d46:	8d 76 00             	lea    0x0(%esi),%esi
80100d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100d50:	83 ff 20             	cmp    $0x20,%edi
80100d53:	0f 84 7a ff ff ff    	je     80100cd3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d59:	83 ec 0c             	sub    $0xc,%esp
80100d5c:	50                   	push   %eax
80100d5d:	e8 4e 3b 00 00       	call   801048b0 <strlen>
80100d62:	f7 d0                	not    %eax
80100d64:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d66:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d69:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d6a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d6d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d70:	e8 3b 3b 00 00       	call   801048b0 <strlen>
80100d75:	83 c0 01             	add    $0x1,%eax
80100d78:	50                   	push   %eax
80100d79:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d7c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d7f:	53                   	push   %ebx
80100d80:	56                   	push   %esi
80100d81:	e8 4a 67 00 00       	call   801074d0 <copyout>
80100d86:	83 c4 20             	add    $0x20,%esp
80100d89:	85 c0                	test   %eax,%eax
80100d8b:	0f 88 42 ff ff ff    	js     80100cd3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d91:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100d94:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d9b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100d9e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100da4:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100da7:	85 c0                	test   %eax,%eax
80100da9:	75 a5                	jne    80100d50 <exec+0x230>
80100dab:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100db1:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100db8:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100dba:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100dc1:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100dc5:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100dcc:	ff ff ff 
  ustack[1] = argc;
80100dcf:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dd5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100dd7:	83 c0 0c             	add    $0xc,%eax
80100dda:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ddc:	50                   	push   %eax
80100ddd:	52                   	push   %edx
80100dde:	53                   	push   %ebx
80100ddf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100de5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100deb:	e8 e0 66 00 00       	call   801074d0 <copyout>
80100df0:	83 c4 10             	add    $0x10,%esp
80100df3:	85 c0                	test   %eax,%eax
80100df5:	0f 88 d8 fe ff ff    	js     80100cd3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80100dfe:	0f b6 10             	movzbl (%eax),%edx
80100e01:	84 d2                	test   %dl,%dl
80100e03:	74 19                	je     80100e1e <exec+0x2fe>
80100e05:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100e08:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100e0b:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e0e:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100e11:	0f 44 c8             	cmove  %eax,%ecx
80100e14:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e17:	84 d2                	test   %dl,%dl
80100e19:	75 f0                	jne    80100e0b <exec+0x2eb>
80100e1b:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100e1e:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100e24:	50                   	push   %eax
80100e25:	6a 10                	push   $0x10
80100e27:	ff 75 08             	pushl  0x8(%ebp)
80100e2a:	89 f8                	mov    %edi,%eax
80100e2c:	83 c0 6c             	add    $0x6c,%eax
80100e2f:	50                   	push   %eax
80100e30:	e8 3b 3a 00 00       	call   80104870 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100e35:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100e3b:	89 f8                	mov    %edi,%eax
80100e3d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100e40:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100e42:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100e45:	89 c1                	mov    %eax,%ecx
80100e47:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e4d:	8b 40 18             	mov    0x18(%eax),%eax
80100e50:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e53:	8b 41 18             	mov    0x18(%ecx),%eax
80100e56:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e59:	89 0c 24             	mov    %ecx,(%esp)
80100e5c:	e8 4f 5f 00 00       	call   80106db0 <switchuvm>
  freevm(oldpgdir);
80100e61:	89 3c 24             	mov    %edi,(%esp)
80100e64:	e8 c7 62 00 00       	call   80107130 <freevm>
  return 0;
80100e69:	83 c4 10             	add    $0x10,%esp
80100e6c:	31 c0                	xor    %eax,%eax
80100e6e:	e9 19 fd ff ff       	jmp    80100b8c <exec+0x6c>
80100e73:	66 90                	xchg   %ax,%ax
80100e75:	66 90                	xchg   %ax,%ax
80100e77:	66 90                	xchg   %ax,%ax
80100e79:	66 90                	xchg   %ax,%ax
80100e7b:	66 90                	xchg   %ax,%ax
80100e7d:	66 90                	xchg   %ax,%ax
80100e7f:	90                   	nop

80100e80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e86:	68 49 76 10 80       	push   $0x80107649
80100e8b:	68 c0 0f 11 80       	push   $0x80110fc0
80100e90:	e8 6b 35 00 00       	call   80104400 <initlock>
}
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	c9                   	leave  
80100e99:	c3                   	ret    
80100e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ea0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ea4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ea9:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100eac:	68 c0 0f 11 80       	push   $0x80110fc0
80100eb1:	e8 4a 36 00 00       	call   80104500 <acquire>
80100eb6:	83 c4 10             	add    $0x10,%esp
80100eb9:	eb 10                	jmp    80100ecb <filealloc+0x2b>
80100ebb:	90                   	nop
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec0:	83 c3 18             	add    $0x18,%ebx
80100ec3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100ec9:	74 25                	je     80100ef0 <filealloc+0x50>
    if(f->ref == 0){
80100ecb:	8b 43 04             	mov    0x4(%ebx),%eax
80100ece:	85 c0                	test   %eax,%eax
80100ed0:	75 ee                	jne    80100ec0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ed2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100ed5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100edc:	68 c0 0f 11 80       	push   $0x80110fc0
80100ee1:	e8 3a 37 00 00       	call   80104620 <release>
      return f;
80100ee6:	89 d8                	mov    %ebx,%eax
80100ee8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100eeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eee:	c9                   	leave  
80100eef:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
80100ef3:	68 c0 0f 11 80       	push   $0x80110fc0
80100ef8:	e8 23 37 00 00       	call   80104620 <release>
  return 0;
80100efd:	83 c4 10             	add    $0x10,%esp
80100f00:	31 c0                	xor    %eax,%eax
}
80100f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f05:	c9                   	leave  
80100f06:	c3                   	ret    
80100f07:	89 f6                	mov    %esi,%esi
80100f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 10             	sub    $0x10,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f1a:	68 c0 0f 11 80       	push   $0x80110fc0
80100f1f:	e8 dc 35 00 00       	call   80104500 <acquire>
  if(f->ref < 1)
80100f24:	8b 43 04             	mov    0x4(%ebx),%eax
80100f27:	83 c4 10             	add    $0x10,%esp
80100f2a:	85 c0                	test   %eax,%eax
80100f2c:	7e 1a                	jle    80100f48 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f2e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f31:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100f34:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f37:	68 c0 0f 11 80       	push   $0x80110fc0
80100f3c:	e8 df 36 00 00       	call   80104620 <release>
  return f;
}
80100f41:	89 d8                	mov    %ebx,%eax
80100f43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f46:	c9                   	leave  
80100f47:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	68 50 76 10 80       	push   $0x80107650
80100f50:	e8 4b f5 ff ff       	call   801004a0 <panic>
80100f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 28             	sub    $0x28,%esp
80100f69:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100f6c:	68 c0 0f 11 80       	push   $0x80110fc0
80100f71:	e8 8a 35 00 00       	call   80104500 <acquire>
  if(f->ref < 1)
80100f76:	8b 47 04             	mov    0x4(%edi),%eax
80100f79:	83 c4 10             	add    $0x10,%esp
80100f7c:	85 c0                	test   %eax,%eax
80100f7e:	0f 8e 9b 00 00 00    	jle    8010101f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f84:	83 e8 01             	sub    $0x1,%eax
80100f87:	85 c0                	test   %eax,%eax
80100f89:	89 47 04             	mov    %eax,0x4(%edi)
80100f8c:	74 1a                	je     80100fa8 <fileclose+0x48>
    release(&ftable.lock);
80100f8e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f98:	5b                   	pop    %ebx
80100f99:	5e                   	pop    %esi
80100f9a:	5f                   	pop    %edi
80100f9b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100f9c:	e9 7f 36 00 00       	jmp    80104620 <release>
80100fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100fa8:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100fac:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100fae:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fb1:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100fb4:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fba:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fbd:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100fc0:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fc5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100fc8:	e8 53 36 00 00       	call   80104620 <release>

  if(ff.type == FD_PIPE)
80100fcd:	83 c4 10             	add    $0x10,%esp
80100fd0:	83 fb 01             	cmp    $0x1,%ebx
80100fd3:	74 13                	je     80100fe8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fd5:	83 fb 02             	cmp    $0x2,%ebx
80100fd8:	74 26                	je     80101000 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fdd:	5b                   	pop    %ebx
80100fde:	5e                   	pop    %esi
80100fdf:	5f                   	pop    %edi
80100fe0:	5d                   	pop    %ebp
80100fe1:	c3                   	ret    
80100fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100fe8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fec:	83 ec 08             	sub    $0x8,%esp
80100fef:	53                   	push   %ebx
80100ff0:	56                   	push   %esi
80100ff1:	e8 6a 25 00 00       	call   80103560 <pipeclose>
80100ff6:	83 c4 10             	add    $0x10,%esp
80100ff9:	eb df                	jmp    80100fda <fileclose+0x7a>
80100ffb:	90                   	nop
80100ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80101000:	e8 bb 1d 00 00       	call   80102dc0 <begin_op>
    iput(ff.ip);
80101005:	83 ec 0c             	sub    $0xc,%esp
80101008:	ff 75 e0             	pushl  -0x20(%ebp)
8010100b:	e8 00 0a 00 00       	call   80101a10 <iput>
    end_op();
80101010:	83 c4 10             	add    $0x10,%esp
  }
}
80101013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101016:	5b                   	pop    %ebx
80101017:	5e                   	pop    %esi
80101018:	5f                   	pop    %edi
80101019:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
8010101a:	e9 11 1e 00 00       	jmp    80102e30 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	68 58 76 10 80       	push   $0x80107658
80101027:	e8 74 f4 ff ff       	call   801004a0 <panic>
8010102c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101030 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	53                   	push   %ebx
80101034:	83 ec 04             	sub    $0x4,%esp
80101037:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010103a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010103d:	75 31                	jne    80101070 <filestat+0x40>
    ilock(f->ip);
8010103f:	83 ec 0c             	sub    $0xc,%esp
80101042:	ff 73 10             	pushl  0x10(%ebx)
80101045:	e8 96 08 00 00       	call   801018e0 <ilock>
    stati(f->ip, st);
8010104a:	58                   	pop    %eax
8010104b:	5a                   	pop    %edx
8010104c:	ff 75 0c             	pushl  0xc(%ebp)
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 39 0b 00 00       	call   80101b90 <stati>
    iunlock(f->ip);
80101057:	59                   	pop    %ecx
80101058:	ff 73 10             	pushl  0x10(%ebx)
8010105b:	e8 60 09 00 00       	call   801019c0 <iunlock>
    return 0;
80101060:	83 c4 10             	add    $0x10,%esp
80101063:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101065:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101068:	c9                   	leave  
80101069:	c3                   	ret    
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80101070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101078:	c9                   	leave  
80101079:	c3                   	ret    
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101080 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 0c             	sub    $0xc,%esp
80101089:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010108c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010108f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101092:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101096:	74 60                	je     801010f8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101098:	8b 03                	mov    (%ebx),%eax
8010109a:	83 f8 01             	cmp    $0x1,%eax
8010109d:	74 41                	je     801010e0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010109f:	83 f8 02             	cmp    $0x2,%eax
801010a2:	75 5b                	jne    801010ff <fileread+0x7f>
    ilock(f->ip);
801010a4:	83 ec 0c             	sub    $0xc,%esp
801010a7:	ff 73 10             	pushl  0x10(%ebx)
801010aa:	e8 31 08 00 00       	call   801018e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010af:	57                   	push   %edi
801010b0:	ff 73 14             	pushl  0x14(%ebx)
801010b3:	56                   	push   %esi
801010b4:	ff 73 10             	pushl  0x10(%ebx)
801010b7:	e8 04 0b 00 00       	call   80101bc0 <readi>
801010bc:	83 c4 20             	add    $0x20,%esp
801010bf:	85 c0                	test   %eax,%eax
801010c1:	89 c6                	mov    %eax,%esi
801010c3:	7e 03                	jle    801010c8 <fileread+0x48>
      f->off += r;
801010c5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010c8:	83 ec 0c             	sub    $0xc,%esp
801010cb:	ff 73 10             	pushl  0x10(%ebx)
801010ce:	e8 ed 08 00 00       	call   801019c0 <iunlock>
    return r;
801010d3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010d6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
801010d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010db:	5b                   	pop    %ebx
801010dc:	5e                   	pop    %esi
801010dd:	5f                   	pop    %edi
801010de:	5d                   	pop    %ebp
801010df:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
801010e0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
801010ed:	e9 0e 26 00 00       	jmp    80103700 <piperead>
801010f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
801010f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010fd:	eb d9                	jmp    801010d8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 62 76 10 80       	push   $0x80107662
80101107:	e8 94 f3 ff ff       	call   801004a0 <panic>
8010110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101110 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
80101119:	8b 75 08             	mov    0x8(%ebp),%esi
8010111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010111f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101123:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101126:	8b 45 10             	mov    0x10(%ebp),%eax
80101129:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010112c:	0f 84 aa 00 00 00    	je     801011dc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101132:	8b 06                	mov    (%esi),%eax
80101134:	83 f8 01             	cmp    $0x1,%eax
80101137:	0f 84 c2 00 00 00    	je     801011ff <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010113d:	83 f8 02             	cmp    $0x2,%eax
80101140:	0f 85 d8 00 00 00    	jne    8010121e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101146:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101149:	31 ff                	xor    %edi,%edi
8010114b:	85 c0                	test   %eax,%eax
8010114d:	7f 34                	jg     80101183 <filewrite+0x73>
8010114f:	e9 9c 00 00 00       	jmp    801011f0 <filewrite+0xe0>
80101154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101158:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010115b:	83 ec 0c             	sub    $0xc,%esp
8010115e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101161:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101164:	e8 57 08 00 00       	call   801019c0 <iunlock>
      end_op();
80101169:	e8 c2 1c 00 00       	call   80102e30 <end_op>
8010116e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101171:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101174:	39 d8                	cmp    %ebx,%eax
80101176:	0f 85 95 00 00 00    	jne    80101211 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010117c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010117e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101181:	7e 6d                	jle    801011f0 <filewrite+0xe0>
      int n1 = n - i;
80101183:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101186:	b8 00 06 00 00       	mov    $0x600,%eax
8010118b:	29 fb                	sub    %edi,%ebx
8010118d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101193:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101196:	e8 25 1c 00 00       	call   80102dc0 <begin_op>
      ilock(f->ip);
8010119b:	83 ec 0c             	sub    $0xc,%esp
8010119e:	ff 76 10             	pushl  0x10(%esi)
801011a1:	e8 3a 07 00 00       	call   801018e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	53                   	push   %ebx
801011aa:	ff 76 14             	pushl  0x14(%esi)
801011ad:	01 f8                	add    %edi,%eax
801011af:	50                   	push   %eax
801011b0:	ff 76 10             	pushl  0x10(%esi)
801011b3:	e8 08 0b 00 00       	call   80101cc0 <writei>
801011b8:	83 c4 20             	add    $0x20,%esp
801011bb:	85 c0                	test   %eax,%eax
801011bd:	7f 99                	jg     80101158 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
801011bf:	83 ec 0c             	sub    $0xc,%esp
801011c2:	ff 76 10             	pushl  0x10(%esi)
801011c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c8:	e8 f3 07 00 00       	call   801019c0 <iunlock>
      end_op();
801011cd:	e8 5e 1c 00 00       	call   80102e30 <end_op>

      if(r < 0)
801011d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011d5:	83 c4 10             	add    $0x10,%esp
801011d8:	85 c0                	test   %eax,%eax
801011da:	74 98                	je     80101174 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801011dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801011df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011e4:	5b                   	pop    %ebx
801011e5:	5e                   	pop    %esi
801011e6:	5f                   	pop    %edi
801011e7:	5d                   	pop    %ebp
801011e8:	c3                   	ret    
801011e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801011f0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011f3:	75 e7                	jne    801011dc <filewrite+0xcc>
  }
  panic("filewrite");
}
801011f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011f8:	89 f8                	mov    %edi,%eax
801011fa:	5b                   	pop    %ebx
801011fb:	5e                   	pop    %esi
801011fc:	5f                   	pop    %edi
801011fd:	5d                   	pop    %ebp
801011fe:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801011ff:	8b 46 0c             	mov    0xc(%esi),%eax
80101202:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101205:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101208:	5b                   	pop    %ebx
80101209:	5e                   	pop    %esi
8010120a:	5f                   	pop    %edi
8010120b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010120c:	e9 ef 23 00 00       	jmp    80103600 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	68 6b 76 10 80       	push   $0x8010766b
80101219:	e8 82 f2 ff ff       	call   801004a0 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010121e:	83 ec 0c             	sub    $0xc,%esp
80101221:	68 71 76 10 80       	push   $0x80107671
80101226:	e8 75 f2 ff ff       	call   801004a0 <panic>
8010122b:	66 90                	xchg   %ax,%ax
8010122d:	66 90                	xchg   %ax,%ax
8010122f:	90                   	nop

80101230 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 85 00 00 00    	je     801012cf <balloc+0x9f>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010126e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101273:	83 c4 10             	add    $0x10,%esp
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2d                	jmp    801012aa <balloc+0x7a>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101299:	85 d7                	test   %edx,%edi
8010129b:	74 43                	je     801012e0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129d:	83 c0 01             	add    $0x1,%eax
801012a0:	83 c6 01             	add    $0x1,%esi
801012a3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012a8:	74 05                	je     801012af <balloc+0x7f>
801012aa:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801012ad:	72 d1                	jb     80101280 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b5:	e8 26 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801012ba:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c1:	83 c4 10             	add    $0x10,%esp
801012c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c7:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012cd:	77 82                	ja     80101251 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801012cf:	83 ec 0c             	sub    $0xc,%esp
801012d2:	68 7b 76 10 80       	push   $0x8010767b
801012d7:	e8 c4 f1 ff ff       	call   801004a0 <panic>
801012dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
       // log_write(bp);
        brelse(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 fa                	or     %edi,%edx
801012e8:	88 54 08 5c          	mov    %dl,0x5c(%eax,%ecx,1)
       // log_write(bp);
        brelse(bp);
801012ec:	50                   	push   %eax
801012ed:	e8 ee ee ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801012f2:	58                   	pop    %eax
801012f3:	5a                   	pop    %edx
801012f4:	56                   	push   %esi
801012f5:	ff 75 d8             	pushl  -0x28(%ebp)
801012f8:	e8 d3 ed ff ff       	call   801000d0 <bread>
801012fd:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012ff:	8d 40 5c             	lea    0x5c(%eax),%eax
80101302:	83 c4 0c             	add    $0xc,%esp
80101305:	68 00 02 00 00       	push   $0x200
8010130a:	6a 00                	push   $0x0
8010130c:	50                   	push   %eax
8010130d:	e8 5e 33 00 00       	call   80104670 <memset>
  //log_write(bp);
  brelse(bp);
80101312:	89 1c 24             	mov    %ebx,(%esp)
80101315:	e8 c6 ee ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010131a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131d:	89 f0                	mov    %esi,%eax
8010131f:	5b                   	pop    %ebx
80101320:	5e                   	pop    %esi
80101321:	5f                   	pop    %edi
80101322:	5d                   	pop    %ebp
80101323:	c3                   	ret    
80101324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010132a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101330 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101330:	55                   	push   %ebp
80101331:	89 e5                	mov    %esp,%ebp
80101333:	57                   	push   %edi
80101334:	56                   	push   %esi
80101335:	53                   	push   %ebx
80101336:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101338:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010133f:	83 ec 28             	sub    $0x28,%esp
80101342:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101345:	68 e0 19 11 80       	push   $0x801119e0
8010134a:	e8 b1 31 00 00       	call   80104500 <acquire>
8010134f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101352:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101355:	eb 1b                	jmp    80101372 <iget+0x42>
80101357:	89 f6                	mov    %esi,%esi
80101359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101360:	85 f6                	test   %esi,%esi
80101362:	74 44                	je     801013a8 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101364:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010136a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101370:	74 4e                	je     801013c0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101372:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101375:	85 c9                	test   %ecx,%ecx
80101377:	7e e7                	jle    80101360 <iget+0x30>
80101379:	39 3b                	cmp    %edi,(%ebx)
8010137b:	75 e3                	jne    80101360 <iget+0x30>
8010137d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101380:	75 de                	jne    80101360 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101382:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101385:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101388:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010138a:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010138f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101392:	e8 89 32 00 00       	call   80104620 <release>
      return ip;
80101397:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139d:	89 f0                	mov    %esi,%eax
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5f                   	pop    %edi
801013a2:	5d                   	pop    %ebp
801013a3:	c3                   	ret    
801013a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a8:	85 c9                	test   %ecx,%ecx
801013aa:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ad:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b3:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013b9:	75 b7                	jne    80101372 <iget+0x42>
801013bb:	90                   	nop
801013bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c0:	85 f6                	test   %esi,%esi
801013c2:	74 2d                	je     801013f1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013c4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801013c7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013cc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013d3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013da:	68 e0 19 11 80       	push   $0x801119e0
801013df:	e8 3c 32 00 00       	call   80104620 <release>

  return ip;
801013e4:	83 c4 10             	add    $0x10,%esp
}
801013e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ea:	89 f0                	mov    %esi,%eax
801013ec:	5b                   	pop    %ebx
801013ed:	5e                   	pop    %esi
801013ee:	5f                   	pop    %edi
801013ef:	5d                   	pop    %ebp
801013f0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801013f1:	83 ec 0c             	sub    $0xc,%esp
801013f4:	68 91 76 10 80       	push   $0x80107691
801013f9:	e8 a2 f0 ff ff       	call   801004a0 <panic>
801013fe:	66 90                	xchg   %ax,%ax

80101400 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	57                   	push   %edi
80101404:	56                   	push   %esi
80101405:	53                   	push   %ebx
80101406:	89 c6                	mov    %eax,%esi
80101408:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010140b:	83 fa 0b             	cmp    $0xb,%edx
8010140e:	77 18                	ja     80101428 <bmap+0x28>
80101410:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101413:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101416:	85 c0                	test   %eax,%eax
80101418:	74 76                	je     80101490 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010141a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010141d:	5b                   	pop    %ebx
8010141e:	5e                   	pop    %esi
8010141f:	5f                   	pop    %edi
80101420:	5d                   	pop    %ebp
80101421:	c3                   	ret    
80101422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101428:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010142b:	83 fb 7f             	cmp    $0x7f,%ebx
8010142e:	0f 87 83 00 00 00    	ja     801014b7 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101434:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010143a:	85 c0                	test   %eax,%eax
8010143c:	74 6a                	je     801014a8 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010143e:	83 ec 08             	sub    $0x8,%esp
80101441:	50                   	push   %eax
80101442:	ff 36                	pushl  (%esi)
80101444:	e8 87 ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101449:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010144d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101450:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101452:	8b 1a                	mov    (%edx),%ebx
80101454:	85 db                	test   %ebx,%ebx
80101456:	75 1d                	jne    80101475 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101458:	8b 06                	mov    (%esi),%eax
8010145a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010145d:	e8 ce fd ff ff       	call   80101230 <balloc>
80101462:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101465:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101468:	89 c3                	mov    %eax,%ebx
8010146a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010146c:	57                   	push   %edi
8010146d:	e8 2e 1b 00 00       	call   80102fa0 <log_write>
80101472:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 62 ed ff ff       	call   801001e0 <brelse>
8010147e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101484:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	90                   	nop
8010148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	e8 99 fd ff ff       	call   80101230 <balloc>
80101497:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010149a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010149d:	5b                   	pop    %ebx
8010149e:	5e                   	pop    %esi
8010149f:	5f                   	pop    %edi
801014a0:	5d                   	pop    %ebp
801014a1:	c3                   	ret    
801014a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014a8:	8b 06                	mov    (%esi),%eax
801014aa:	e8 81 fd ff ff       	call   80101230 <balloc>
801014af:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014b5:	eb 87                	jmp    8010143e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
801014b7:	83 ec 0c             	sub    $0xc,%esp
801014ba:	68 a1 76 10 80       	push   $0x801076a1
801014bf:	e8 dc ef ff ff       	call   801004a0 <panic>
801014c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801014d0 <readsb>:
int numallocblocks = 0;

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	56                   	push   %esi
801014d4:	53                   	push   %ebx
801014d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801014d8:	83 ec 08             	sub    $0x8,%esp
801014db:	6a 01                	push   $0x1
801014dd:	ff 75 08             	pushl  0x8(%ebp)
801014e0:	e8 eb eb ff ff       	call   801000d0 <bread>
801014e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801014e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801014ea:	83 c4 0c             	add    $0xc,%esp
801014ed:	6a 1c                	push   $0x1c
801014ef:	50                   	push   %eax
801014f0:	56                   	push   %esi
801014f1:	e8 2a 32 00 00       	call   80104720 <memmove>
  brelse(bp);
801014f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014f9:	83 c4 10             	add    $0x10,%esp
}
801014fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ff:	5b                   	pop    %ebx
80101500:	5e                   	pop    %esi
80101501:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101502:	e9 d9 ec ff ff       	jmp    801001e0 <brelse>
80101507:	89 f6                	mov    %esi,%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101510 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	56                   	push   %esi
80101514:	53                   	push   %ebx
80101515:	89 d3                	mov    %edx,%ebx
80101517:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101519:	83 ec 08             	sub    $0x8,%esp
8010151c:	68 c0 19 11 80       	push   $0x801119c0
80101521:	50                   	push   %eax
80101522:	e8 a9 ff ff ff       	call   801014d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101527:	58                   	pop    %eax
80101528:	5a                   	pop    %edx
80101529:	89 da                	mov    %ebx,%edx
8010152b:	c1 ea 0c             	shr    $0xc,%edx
8010152e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101534:	52                   	push   %edx
80101535:	56                   	push   %esi
80101536:	e8 95 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010153b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010153d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101543:	ba 01 00 00 00       	mov    $0x1,%edx
  if((bp->data[bi/8] & m) == 0)
80101548:	c1 fb 03             	sar    $0x3,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
8010154b:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010154e:	83 c4 10             	add    $0x10,%esp
80101551:	0f b6 74 18 5c       	movzbl 0x5c(%eax,%ebx,1),%esi
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101556:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101558:	85 d6                	test   %edx,%esi
8010155a:	74 1d                	je     80101579 <bfree+0x69>
8010155c:	89 f1                	mov    %esi,%ecx
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010155e:	f7 d2                	not    %edx
 // log_write(bp);
  brelse(bp);
80101560:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101563:	21 d1                	and    %edx,%ecx
80101565:	88 4c 18 5c          	mov    %cl,0x5c(%eax,%ebx,1)
 // log_write(bp);
  brelse(bp);
80101569:	50                   	push   %eax
8010156a:	e8 71 ec ff ff       	call   801001e0 <brelse>
}
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101575:	5b                   	pop    %ebx
80101576:	5e                   	pop    %esi
80101577:	5d                   	pop    %ebp
80101578:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101579:	83 ec 0c             	sub    $0xc,%esp
8010157c:	68 b4 76 10 80       	push   $0x801076b4
80101581:	e8 1a ef ff ff       	call   801004a0 <panic>
80101586:	8d 76 00             	lea    0x0(%esi),%esi
80101589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101590 <balloc_page>:
 * free blocks. It is okay, if you assume that the first
 * block is always 8 bytes aligned.
 */
uint
balloc_page(uint dev)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	57                   	push   %edi
80101594:	56                   	push   %esi
80101595:	53                   	push   %ebx
	readsb(dev, &sb);
	int i ;	
	uint n[8];
	uint f[sb.nblocks];
	int fcount = 0;
	for(i=0;i<8;i++)
80101596:	31 ff                	xor    %edi,%edi
	cprintf("balloc page \n");
	readsb(dev, &sb);
	int i ;	
	uint n[8];
	uint f[sb.nblocks];
	int fcount = 0;
80101598:	31 db                	xor    %ebx,%ebx
 * free blocks. It is okay, if you assume that the first
 * block is always 8 bytes aligned.
 */
uint
balloc_page(uint dev)
{
8010159a:	83 ec 48             	sub    $0x48,%esp
	cprintf("balloc page \n");
8010159d:	68 e7 76 10 80       	push   $0x801076e7
801015a2:	e8 e9 f1 ff ff       	call   80100790 <cprintf>
	readsb(dev, &sb);
801015a7:	58                   	pop    %eax
801015a8:	5a                   	pop    %edx
801015a9:	68 c0 19 11 80       	push   $0x801119c0
801015ae:	ff 75 08             	pushl  0x8(%ebp)
801015b1:	e8 1a ff ff ff       	call   801014d0 <readsb>
	int i ;	
	uint n[8];
	uint f[sb.nblocks];
801015b6:	a1 c4 19 11 80       	mov    0x801119c4,%eax
801015bb:	83 c4 10             	add    $0x10,%esp
801015be:	8d 04 85 12 00 00 00 	lea    0x12(,%eax,4),%eax
801015c5:	83 e0 f0             	and    $0xfffffff0,%eax
801015c8:	29 c4                	sub    %eax,%esp
801015ca:	89 e6                	mov    %esp,%esi
801015cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	int fcount = 0;
	for(i=0;i<8;i++)
	{
		n[i] = balloc(dev);
801015d0:	8b 45 08             	mov    0x8(%ebp),%eax
801015d3:	e8 58 fc ff ff       	call   80101230 <balloc>
		cprintf("bvalue %d\n",n[i]);
801015d8:	83 ec 08             	sub    $0x8,%esp
	uint n[8];
	uint f[sb.nblocks];
	int fcount = 0;
	for(i=0;i<8;i++)
	{
		n[i] = balloc(dev);
801015db:	89 44 bd c8          	mov    %eax,-0x38(%ebp,%edi,4)
		cprintf("bvalue %d\n",n[i]);
801015df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801015e2:	50                   	push   %eax
801015e3:	68 c7 76 10 80       	push   $0x801076c7
801015e8:	e8 a3 f1 ff ff       	call   80100790 <cprintf>
		//cprintf("ek block allocated\n");
		if(i>0 && ((n[i]-n[i-1])>1))
801015ed:	83 c4 10             	add    $0x10,%esp
801015f0:	85 ff                	test   %edi,%edi
801015f2:	0f 84 98 00 00 00    	je     80101690 <balloc_page+0x100>
801015f8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801015fb:	2b 44 bd c4          	sub    -0x3c(%ebp,%edi,4),%eax
801015ff:	83 f8 01             	cmp    $0x1,%eax
80101602:	76 3c                	jbe    80101640 <balloc_page+0xb0>
		{	
			cprintf("oops\n");
80101604:	83 ec 0c             	sub    $0xc,%esp
80101607:	68 d2 76 10 80       	push   $0x801076d2
8010160c:	e8 7f f1 ff ff       	call   80100790 <cprintf>
80101611:	8d 4f 01             	lea    0x1(%edi),%ecx
80101614:	8d 14 9e             	lea    (%esi,%ebx,4),%edx
80101617:	83 c4 10             	add    $0x10,%esp
			for(int j = 0 ; j<=i ; j++)
8010161a:	31 c0                	xor    %eax,%eax
8010161c:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
8010161f:	90                   	nop
				f[fcount+j]=n[j];
80101620:	8b 5c 85 c8          	mov    -0x38(%ebp,%eax,4),%ebx
80101624:	89 1c 82             	mov    %ebx,(%edx,%eax,4)
		cprintf("bvalue %d\n",n[i]);
		//cprintf("ek block allocated\n");
		if(i>0 && ((n[i]-n[i-1])>1))
		{	
			cprintf("oops\n");
			for(int j = 0 ; j<=i ; j++)
80101627:	83 c0 01             	add    $0x1,%eax
8010162a:	39 c8                	cmp    %ecx,%eax
8010162c:	75 f2                	jne    80101620 <balloc_page+0x90>
8010162e:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
				f[fcount+j]=n[j];
			fcount += i;
80101631:	01 fb                	add    %edi,%ebx
	readsb(dev, &sb);
	int i ;	
	uint n[8];
	uint f[sb.nblocks];
	int fcount = 0;
	for(i=0;i<8;i++)
80101633:	bf 01 00 00 00       	mov    $0x1,%edi
80101638:	eb 96                	jmp    801015d0 <balloc_page+0x40>
8010163a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101640:	83 c7 01             	add    $0x1,%edi
80101643:	83 ff 08             	cmp    $0x8,%edi
80101646:	75 88                	jne    801015d0 <balloc_page+0x40>
			fcount += i;
			i = 0;
		}
	}
	
	for(i = 0 ; i<fcount; i++)
80101648:	31 ff                	xor    %edi,%edi
8010164a:	85 db                	test   %ebx,%ebx
8010164c:	74 26                	je     80101674 <balloc_page+0xe4>
8010164e:	66 90                	xchg   %ax,%ax
	{
		cprintf("freeing mem\n");
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	68 f5 76 10 80       	push   $0x801076f5
80101658:	e8 33 f1 ff ff       	call   80100790 <cprintf>
		bfree(ROOTDEV, f[i]);
8010165d:	8b 14 be             	mov    (%esi,%edi,4),%edx
80101660:	b8 01 00 00 00       	mov    $0x1,%eax
			fcount += i;
			i = 0;
		}
	}
	
	for(i = 0 ; i<fcount; i++)
80101665:	83 c7 01             	add    $0x1,%edi
	{
		cprintf("freeing mem\n");
		bfree(ROOTDEV, f[i]);
80101668:	e8 a3 fe ff ff       	call   80101510 <bfree>
			fcount += i;
			i = 0;
		}
	}
	
	for(i = 0 ; i<fcount; i++)
8010166d:	83 c4 10             	add    $0x10,%esp
80101670:	39 df                	cmp    %ebx,%edi
80101672:	75 dc                	jne    80101650 <balloc_page+0xc0>
	{
		cprintf("freeing mem\n");
		bfree(ROOTDEV, f[i]);
	}
	cprintf("returning from balloc page \n");
80101674:	83 ec 0c             	sub    $0xc,%esp
80101677:	68 d8 76 10 80       	push   $0x801076d8
8010167c:	e8 0f f1 ff ff       	call   80100790 <cprintf>
	return n[0];				
80101681:	8b 45 c8             	mov    -0x38(%ebp),%eax
}
80101684:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101687:	5b                   	pop    %ebx
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
8010168b:	c3                   	ret    
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	readsb(dev, &sb);
	int i ;	
	uint n[8];
	uint f[sb.nblocks];
	int fcount = 0;
	for(i=0;i<8;i++)
80101690:	bf 01 00 00 00       	mov    $0x1,%edi
80101695:	e9 36 ff ff ff       	jmp    801015d0 <balloc_page+0x40>
8010169a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801016a0 <bfree_page>:

/* Free disk blocks allocated using balloc_page.
 */
void
bfree_page(int dev, uint b)
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	56                   	push   %esi
801016a4:	53                   	push   %ebx
801016a5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	cprintf("FREEING MEM\n");
801016a8:	83 ec 0c             	sub    $0xc,%esp
801016ab:	68 02 77 10 80       	push   $0x80107702
	uint i ;
	for(i = b ; i< b+8; i++)
801016b0:	8d 73 08             	lea    0x8(%ebx),%esi
/* Free disk blocks allocated using balloc_page.
 */
void
bfree_page(int dev, uint b)
{
	cprintf("FREEING MEM\n");
801016b3:	e8 d8 f0 ff ff       	call   80100790 <cprintf>
	uint i ;
	for(i = b ; i< b+8; i++)
801016b8:	83 c4 10             	add    $0x10,%esp
801016bb:	39 f3                	cmp    %esi,%ebx
801016bd:	73 14                	jae    801016d3 <bfree_page+0x33>
801016bf:	90                   	nop
	{
		bfree(ROOTDEV, i);
801016c0:	89 da                	mov    %ebx,%edx
801016c2:	b8 01 00 00 00       	mov    $0x1,%eax
void
bfree_page(int dev, uint b)
{
	cprintf("FREEING MEM\n");
	uint i ;
	for(i = b ; i< b+8; i++)
801016c7:	83 c3 01             	add    $0x1,%ebx
	{
		bfree(ROOTDEV, i);
801016ca:	e8 41 fe ff ff       	call   80101510 <bfree>
void
bfree_page(int dev, uint b)
{
	cprintf("FREEING MEM\n");
	uint i ;
	for(i = b ; i< b+8; i++)
801016cf:	39 f3                	cmp    %esi,%ebx
801016d1:	75 ed                	jne    801016c0 <bfree_page+0x20>
	{
		bfree(ROOTDEV, i);
	}
}
801016d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d6:	5b                   	pop    %ebx
801016d7:	5e                   	pop    %esi
801016d8:	5d                   	pop    %ebp
801016d9:	c3                   	ret    
801016da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801016e0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	53                   	push   %ebx
801016e4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801016e9:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801016ec:	68 0f 77 10 80       	push   $0x8010770f
801016f1:	68 e0 19 11 80       	push   $0x801119e0
801016f6:	e8 05 2d 00 00       	call   80104400 <initlock>
801016fb:	83 c4 10             	add    $0x10,%esp
801016fe:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101700:	83 ec 08             	sub    $0x8,%esp
80101703:	68 16 77 10 80       	push   $0x80107716
80101708:	53                   	push   %ebx
80101709:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010170f:	e8 dc 2b 00 00       	call   801042f0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101714:	83 c4 10             	add    $0x10,%esp
80101717:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010171d:	75 e1                	jne    80101700 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010171f:	83 ec 08             	sub    $0x8,%esp
80101722:	68 c0 19 11 80       	push   $0x801119c0
80101727:	ff 75 08             	pushl  0x8(%ebp)
8010172a:	e8 a1 fd ff ff       	call   801014d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010172f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101735:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010173b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101741:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101747:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010174d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101753:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101759:	68 7c 77 10 80       	push   $0x8010777c
8010175e:	e8 2d f0 ff ff       	call   80100790 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101763:	83 c4 30             	add    $0x30,%esp
80101766:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101769:	c9                   	leave  
8010176a:	c3                   	ret    
8010176b:	90                   	nop
8010176c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101770 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	57                   	push   %edi
80101774:	56                   	push   %esi
80101775:	53                   	push   %ebx
80101776:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101779:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101780:	8b 45 0c             	mov    0xc(%ebp),%eax
80101783:	8b 75 08             	mov    0x8(%ebp),%esi
80101786:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101789:	0f 86 91 00 00 00    	jbe    80101820 <ialloc+0xb0>
8010178f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101794:	eb 21                	jmp    801017b7 <ialloc+0x47>
80101796:	8d 76 00             	lea    0x0(%esi),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801017a0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017a3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801017a6:	57                   	push   %edi
801017a7:	e8 34 ea ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801017ac:	83 c4 10             	add    $0x10,%esp
801017af:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
801017b5:	76 69                	jbe    80101820 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801017b7:	89 d8                	mov    %ebx,%eax
801017b9:	83 ec 08             	sub    $0x8,%esp
801017bc:	c1 e8 03             	shr    $0x3,%eax
801017bf:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017c5:	50                   	push   %eax
801017c6:	56                   	push   %esi
801017c7:	e8 04 e9 ff ff       	call   801000d0 <bread>
801017cc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801017ce:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801017d0:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
801017d3:	83 e0 07             	and    $0x7,%eax
801017d6:	c1 e0 06             	shl    $0x6,%eax
801017d9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801017dd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801017e1:	75 bd                	jne    801017a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017e3:	83 ec 04             	sub    $0x4,%esp
801017e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017e9:	6a 40                	push   $0x40
801017eb:	6a 00                	push   $0x0
801017ed:	51                   	push   %ecx
801017ee:	e8 7d 2e 00 00       	call   80104670 <memset>
      dip->type = type;
801017f3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017fa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017fd:	89 3c 24             	mov    %edi,(%esp)
80101800:	e8 9b 17 00 00       	call   80102fa0 <log_write>
      brelse(bp);
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 d3 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010180d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101810:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101813:	89 da                	mov    %ebx,%edx
80101815:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101817:	5b                   	pop    %ebx
80101818:	5e                   	pop    %esi
80101819:	5f                   	pop    %edi
8010181a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010181b:	e9 10 fb ff ff       	jmp    80101330 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101820:	83 ec 0c             	sub    $0xc,%esp
80101823:	68 1c 77 10 80       	push   $0x8010771c
80101828:	e8 73 ec ff ff       	call   801004a0 <panic>
8010182d:	8d 76 00             	lea    0x0(%esi),%esi

80101830 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	56                   	push   %esi
80101834:	53                   	push   %ebx
80101835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101838:	83 ec 08             	sub    $0x8,%esp
8010183b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101841:	c1 e8 03             	shr    $0x3,%eax
80101844:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010184a:	50                   	push   %eax
8010184b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010184e:	e8 7d e8 ff ff       	call   801000d0 <bread>
80101853:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101855:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101858:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010185c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010185f:	83 e0 07             	and    $0x7,%eax
80101862:	c1 e0 06             	shl    $0x6,%eax
80101865:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101869:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010186c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101870:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101873:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101877:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010187b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010187f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101883:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101887:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010188a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010188d:	6a 34                	push   $0x34
8010188f:	53                   	push   %ebx
80101890:	50                   	push   %eax
80101891:	e8 8a 2e 00 00       	call   80104720 <memmove>
  log_write(bp);
80101896:	89 34 24             	mov    %esi,(%esp)
80101899:	e8 02 17 00 00       	call   80102fa0 <log_write>
  brelse(bp);
8010189e:	89 75 08             	mov    %esi,0x8(%ebp)
801018a1:	83 c4 10             	add    $0x10,%esp
}
801018a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018a7:	5b                   	pop    %ebx
801018a8:	5e                   	pop    %esi
801018a9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801018aa:	e9 31 e9 ff ff       	jmp    801001e0 <brelse>
801018af:	90                   	nop

801018b0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	53                   	push   %ebx
801018b4:	83 ec 10             	sub    $0x10,%esp
801018b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801018ba:	68 e0 19 11 80       	push   $0x801119e0
801018bf:	e8 3c 2c 00 00       	call   80104500 <acquire>
  ip->ref++;
801018c4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018c8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018cf:	e8 4c 2d 00 00       	call   80104620 <release>
  return ip;
}
801018d4:	89 d8                	mov    %ebx,%eax
801018d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018d9:	c9                   	leave  
801018da:	c3                   	ret    
801018db:	90                   	nop
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018e0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	56                   	push   %esi
801018e4:	53                   	push   %ebx
801018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801018e8:	85 db                	test   %ebx,%ebx
801018ea:	0f 84 b7 00 00 00    	je     801019a7 <ilock+0xc7>
801018f0:	8b 53 08             	mov    0x8(%ebx),%edx
801018f3:	85 d2                	test   %edx,%edx
801018f5:	0f 8e ac 00 00 00    	jle    801019a7 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
801018fb:	8d 43 0c             	lea    0xc(%ebx),%eax
801018fe:	83 ec 0c             	sub    $0xc,%esp
80101901:	50                   	push   %eax
80101902:	e8 29 2a 00 00       	call   80104330 <acquiresleep>

  if(ip->valid == 0){
80101907:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010190a:	83 c4 10             	add    $0x10,%esp
8010190d:	85 c0                	test   %eax,%eax
8010190f:	74 0f                	je     80101920 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101911:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101914:	5b                   	pop    %ebx
80101915:	5e                   	pop    %esi
80101916:	5d                   	pop    %ebp
80101917:	c3                   	ret    
80101918:	90                   	nop
80101919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101920:	8b 43 04             	mov    0x4(%ebx),%eax
80101923:	83 ec 08             	sub    $0x8,%esp
80101926:	c1 e8 03             	shr    $0x3,%eax
80101929:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010192f:	50                   	push   %eax
80101930:	ff 33                	pushl  (%ebx)
80101932:	e8 99 e7 ff ff       	call   801000d0 <bread>
80101937:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101939:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010193c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010193f:	83 e0 07             	and    $0x7,%eax
80101942:	c1 e0 06             	shl    $0x6,%eax
80101945:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101949:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010194c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010194f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101953:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101957:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010195b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010195f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101963:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101967:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010196b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010196e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101971:	6a 34                	push   $0x34
80101973:	50                   	push   %eax
80101974:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101977:	50                   	push   %eax
80101978:	e8 a3 2d 00 00       	call   80104720 <memmove>
    brelse(bp);
8010197d:	89 34 24             	mov    %esi,(%esp)
80101980:	e8 5b e8 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101985:	83 c4 10             	add    $0x10,%esp
80101988:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010198d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101994:	0f 85 77 ff ff ff    	jne    80101911 <ilock+0x31>
      panic("ilock: no type");
8010199a:	83 ec 0c             	sub    $0xc,%esp
8010199d:	68 34 77 10 80       	push   $0x80107734
801019a2:	e8 f9 ea ff ff       	call   801004a0 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801019a7:	83 ec 0c             	sub    $0xc,%esp
801019aa:	68 2e 77 10 80       	push   $0x8010772e
801019af:	e8 ec ea ff ff       	call   801004a0 <panic>
801019b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801019c0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	56                   	push   %esi
801019c4:	53                   	push   %ebx
801019c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019c8:	85 db                	test   %ebx,%ebx
801019ca:	74 28                	je     801019f4 <iunlock+0x34>
801019cc:	8d 73 0c             	lea    0xc(%ebx),%esi
801019cf:	83 ec 0c             	sub    $0xc,%esp
801019d2:	56                   	push   %esi
801019d3:	e8 f8 29 00 00       	call   801043d0 <holdingsleep>
801019d8:	83 c4 10             	add    $0x10,%esp
801019db:	85 c0                	test   %eax,%eax
801019dd:	74 15                	je     801019f4 <iunlock+0x34>
801019df:	8b 43 08             	mov    0x8(%ebx),%eax
801019e2:	85 c0                	test   %eax,%eax
801019e4:	7e 0e                	jle    801019f4 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
801019e6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019ec:	5b                   	pop    %ebx
801019ed:	5e                   	pop    %esi
801019ee:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801019ef:	e9 9c 29 00 00       	jmp    80104390 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801019f4:	83 ec 0c             	sub    $0xc,%esp
801019f7:	68 43 77 10 80       	push   $0x80107743
801019fc:	e8 9f ea ff ff       	call   801004a0 <panic>
80101a01:	eb 0d                	jmp    80101a10 <iput>
80101a03:	90                   	nop
80101a04:	90                   	nop
80101a05:	90                   	nop
80101a06:	90                   	nop
80101a07:	90                   	nop
80101a08:	90                   	nop
80101a09:	90                   	nop
80101a0a:	90                   	nop
80101a0b:	90                   	nop
80101a0c:	90                   	nop
80101a0d:	90                   	nop
80101a0e:	90                   	nop
80101a0f:	90                   	nop

80101a10 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	57                   	push   %edi
80101a14:	56                   	push   %esi
80101a15:	53                   	push   %ebx
80101a16:	83 ec 28             	sub    $0x28,%esp
80101a19:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
80101a1c:	8d 7e 0c             	lea    0xc(%esi),%edi
80101a1f:	57                   	push   %edi
80101a20:	e8 0b 29 00 00       	call   80104330 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a25:	8b 56 4c             	mov    0x4c(%esi),%edx
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 d2                	test   %edx,%edx
80101a2d:	74 07                	je     80101a36 <iput+0x26>
80101a2f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101a34:	74 32                	je     80101a68 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	57                   	push   %edi
80101a3a:	e8 51 29 00 00       	call   80104390 <releasesleep>

  acquire(&icache.lock);
80101a3f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a46:	e8 b5 2a 00 00       	call   80104500 <acquire>
  ip->ref--;
80101a4b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
80101a4f:	83 c4 10             	add    $0x10,%esp
80101a52:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5c:	5b                   	pop    %ebx
80101a5d:	5e                   	pop    %esi
80101a5e:	5f                   	pop    %edi
80101a5f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101a60:	e9 bb 2b 00 00       	jmp    80104620 <release>
80101a65:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101a68:	83 ec 0c             	sub    $0xc,%esp
80101a6b:	68 e0 19 11 80       	push   $0x801119e0
80101a70:	e8 8b 2a 00 00       	call   80104500 <acquire>
    int r = ip->ref;
80101a75:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101a78:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101a7f:	e8 9c 2b 00 00       	call   80104620 <release>
    if(r == 1){
80101a84:	83 c4 10             	add    $0x10,%esp
80101a87:	83 fb 01             	cmp    $0x1,%ebx
80101a8a:	75 aa                	jne    80101a36 <iput+0x26>
80101a8c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101a92:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a95:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101a98:	89 cf                	mov    %ecx,%edi
80101a9a:	eb 0b                	jmp    80101aa7 <iput+0x97>
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aa0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101aa3:	39 fb                	cmp    %edi,%ebx
80101aa5:	74 19                	je     80101ac0 <iput+0xb0>
    if(ip->addrs[i]){
80101aa7:	8b 13                	mov    (%ebx),%edx
80101aa9:	85 d2                	test   %edx,%edx
80101aab:	74 f3                	je     80101aa0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101aad:	8b 06                	mov    (%esi),%eax
80101aaf:	e8 5c fa ff ff       	call   80101510 <bfree>
      ip->addrs[i] = 0;
80101ab4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101aba:	eb e4                	jmp    80101aa0 <iput+0x90>
80101abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101ac0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101ac6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ac9:	85 c0                	test   %eax,%eax
80101acb:	75 33                	jne    80101b00 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101acd:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101ad0:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101ad7:	56                   	push   %esi
80101ad8:	e8 53 fd ff ff       	call   80101830 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
80101add:	31 c0                	xor    %eax,%eax
80101adf:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101ae3:	89 34 24             	mov    %esi,(%esp)
80101ae6:	e8 45 fd ff ff       	call   80101830 <iupdate>
      ip->valid = 0;
80101aeb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101af2:	83 c4 10             	add    $0x10,%esp
80101af5:	e9 3c ff ff ff       	jmp    80101a36 <iput+0x26>
80101afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b00:	83 ec 08             	sub    $0x8,%esp
80101b03:	50                   	push   %eax
80101b04:	ff 36                	pushl  (%esi)
80101b06:	e8 c5 e5 ff ff       	call   801000d0 <bread>
80101b0b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b11:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101b17:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	89 cf                	mov    %ecx,%edi
80101b1f:	eb 0e                	jmp    80101b2f <iput+0x11f>
80101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b28:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101b2b:	39 fb                	cmp    %edi,%ebx
80101b2d:	74 0f                	je     80101b3e <iput+0x12e>
      if(a[j])
80101b2f:	8b 13                	mov    (%ebx),%edx
80101b31:	85 d2                	test   %edx,%edx
80101b33:	74 f3                	je     80101b28 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b35:	8b 06                	mov    (%esi),%eax
80101b37:	e8 d4 f9 ff ff       	call   80101510 <bfree>
80101b3c:	eb ea                	jmp    80101b28 <iput+0x118>
    }
    brelse(bp);
80101b3e:	83 ec 0c             	sub    $0xc,%esp
80101b41:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b44:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b47:	e8 94 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b4c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101b52:	8b 06                	mov    (%esi),%eax
80101b54:	e8 b7 f9 ff ff       	call   80101510 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b59:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101b60:	00 00 00 
80101b63:	83 c4 10             	add    $0x10,%esp
80101b66:	e9 62 ff ff ff       	jmp    80101acd <iput+0xbd>
80101b6b:	90                   	nop
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b70 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	53                   	push   %ebx
80101b74:	83 ec 10             	sub    $0x10,%esp
80101b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101b7a:	53                   	push   %ebx
80101b7b:	e8 40 fe ff ff       	call   801019c0 <iunlock>
  iput(ip);
80101b80:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b83:	83 c4 10             	add    $0x10,%esp
}
80101b86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b89:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
80101b8a:	e9 81 fe ff ff       	jmp    80101a10 <iput>
80101b8f:	90                   	nop

80101b90 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	8b 55 08             	mov    0x8(%ebp),%edx
80101b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b99:	8b 0a                	mov    (%edx),%ecx
80101b9b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b9e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ba1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ba4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ba8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101bab:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101baf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101bb3:	8b 52 58             	mov    0x58(%edx),%edx
80101bb6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bb9:	5d                   	pop    %ebp
80101bba:	c3                   	ret    
80101bbb:	90                   	nop
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bc0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bcf:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bd2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101bd7:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bda:	8b 7d 14             	mov    0x14(%ebp),%edi
80101bdd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101be0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101be3:	0f 84 a7 00 00 00    	je     80101c90 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101be9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bec:	8b 40 58             	mov    0x58(%eax),%eax
80101bef:	39 f0                	cmp    %esi,%eax
80101bf1:	0f 82 c1 00 00 00    	jb     80101cb8 <readi+0xf8>
80101bf7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101bfa:	89 fa                	mov    %edi,%edx
80101bfc:	01 f2                	add    %esi,%edx
80101bfe:	0f 82 b4 00 00 00    	jb     80101cb8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c04:	89 c1                	mov    %eax,%ecx
80101c06:	29 f1                	sub    %esi,%ecx
80101c08:	39 d0                	cmp    %edx,%eax
80101c0a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c0d:	31 ff                	xor    %edi,%edi
80101c0f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c11:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c14:	74 6d                	je     80101c83 <readi+0xc3>
80101c16:	8d 76 00             	lea    0x0(%esi),%esi
80101c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c20:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c23:	89 f2                	mov    %esi,%edx
80101c25:	c1 ea 09             	shr    $0x9,%edx
80101c28:	89 d8                	mov    %ebx,%eax
80101c2a:	e8 d1 f7 ff ff       	call   80101400 <bmap>
80101c2f:	83 ec 08             	sub    $0x8,%esp
80101c32:	50                   	push   %eax
80101c33:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c35:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c3a:	e8 91 e4 ff ff       	call   801000d0 <bread>
80101c3f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c44:	89 f1                	mov    %esi,%ecx
80101c46:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101c4c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101c4f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c52:	29 cb                	sub    %ecx,%ebx
80101c54:	29 f8                	sub    %edi,%eax
80101c56:	39 c3                	cmp    %eax,%ebx
80101c58:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c5b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101c5f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c60:	01 df                	add    %ebx,%edi
80101c62:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101c64:	50                   	push   %eax
80101c65:	ff 75 e0             	pushl  -0x20(%ebp)
80101c68:	e8 b3 2a 00 00       	call   80104720 <memmove>
    brelse(bp);
80101c6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c70:	89 14 24             	mov    %edx,(%esp)
80101c73:	e8 68 e5 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c78:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c7b:	83 c4 10             	add    $0x10,%esp
80101c7e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c81:	77 9d                	ja     80101c20 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101c83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c89:	5b                   	pop    %ebx
80101c8a:	5e                   	pop    %esi
80101c8b:	5f                   	pop    %edi
80101c8c:	5d                   	pop    %ebp
80101c8d:	c3                   	ret    
80101c8e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 1e                	ja     80101cb8 <readi+0xf8>
80101c9a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 13                	je     80101cb8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ca5:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cbd:	eb c7                	jmp    80101c86 <readi+0xc6>
80101cbf:	90                   	nop

80101cc0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	56                   	push   %esi
80101cc5:	53                   	push   %ebx
80101cc6:	83 ec 1c             	sub    $0x1c,%esp
80101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101ccf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cd2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101cd7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cda:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cdd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ce0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ce3:	0f 84 b7 00 00 00    	je     80101da0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ce9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cec:	39 70 58             	cmp    %esi,0x58(%eax)
80101cef:	0f 82 eb 00 00 00    	jb     80101de0 <writei+0x120>
80101cf5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cf8:	89 f8                	mov    %edi,%eax
80101cfa:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101cfc:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d01:	0f 87 d9 00 00 00    	ja     80101de0 <writei+0x120>
80101d07:	39 c6                	cmp    %eax,%esi
80101d09:	0f 87 d1 00 00 00    	ja     80101de0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d0f:	85 ff                	test   %edi,%edi
80101d11:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d18:	74 78                	je     80101d92 <writei+0xd2>
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d20:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d23:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d25:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d2a:	c1 ea 09             	shr    $0x9,%edx
80101d2d:	89 f8                	mov    %edi,%eax
80101d2f:	e8 cc f6 ff ff       	call   80101400 <bmap>
80101d34:	83 ec 08             	sub    $0x8,%esp
80101d37:	50                   	push   %eax
80101d38:	ff 37                	pushl  (%edi)
80101d3a:	e8 91 e3 ff ff       	call   801000d0 <bread>
80101d3f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d41:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d44:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101d47:	89 f1                	mov    %esi,%ecx
80101d49:	83 c4 0c             	add    $0xc,%esp
80101d4c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101d52:	29 cb                	sub    %ecx,%ebx
80101d54:	39 c3                	cmp    %eax,%ebx
80101d56:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d59:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101d5d:	53                   	push   %ebx
80101d5e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d61:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101d63:	50                   	push   %eax
80101d64:	e8 b7 29 00 00       	call   80104720 <memmove>
    log_write(bp);
80101d69:	89 3c 24             	mov    %edi,(%esp)
80101d6c:	e8 2f 12 00 00       	call   80102fa0 <log_write>
    brelse(bp);
80101d71:	89 3c 24             	mov    %edi,(%esp)
80101d74:	e8 67 e4 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d79:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d7c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d7f:	83 c4 10             	add    $0x10,%esp
80101d82:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d85:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101d88:	77 96                	ja     80101d20 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101d8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d8d:	3b 70 58             	cmp    0x58(%eax),%esi
80101d90:	77 36                	ja     80101dc8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d92:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d95:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d98:	5b                   	pop    %ebx
80101d99:	5e                   	pop    %esi
80101d9a:	5f                   	pop    %edi
80101d9b:	5d                   	pop    %ebp
80101d9c:	c3                   	ret    
80101d9d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101da0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101da4:	66 83 f8 09          	cmp    $0x9,%ax
80101da8:	77 36                	ja     80101de0 <writei+0x120>
80101daa:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101db1:	85 c0                	test   %eax,%eax
80101db3:	74 2b                	je     80101de0 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101db5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101db8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dbb:	5b                   	pop    %ebx
80101dbc:	5e                   	pop    %esi
80101dbd:	5f                   	pop    %edi
80101dbe:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101dbf:	ff e0                	jmp    *%eax
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101dc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dcb:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101dce:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101dd1:	50                   	push   %eax
80101dd2:	e8 59 fa ff ff       	call   80101830 <iupdate>
80101dd7:	83 c4 10             	add    $0x10,%esp
80101dda:	eb b6                	jmp    80101d92 <writei+0xd2>
80101ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de5:	eb ae                	jmp    80101d95 <writei+0xd5>
80101de7:	89 f6                	mov    %esi,%esi
80101de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101df0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101df6:	6a 0e                	push   $0xe
80101df8:	ff 75 0c             	pushl  0xc(%ebp)
80101dfb:	ff 75 08             	pushl  0x8(%ebp)
80101dfe:	e8 9d 29 00 00       	call   801047a0 <strncmp>
}
80101e03:	c9                   	leave  
80101e04:	c3                   	ret    
80101e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 1c             	sub    $0x1c,%esp
80101e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e21:	0f 85 80 00 00 00    	jne    80101ea7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e27:	8b 53 58             	mov    0x58(%ebx),%edx
80101e2a:	31 ff                	xor    %edi,%edi
80101e2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2f:	85 d2                	test   %edx,%edx
80101e31:	75 0d                	jne    80101e40 <dirlookup+0x30>
80101e33:	eb 5b                	jmp    80101e90 <dirlookup+0x80>
80101e35:	8d 76 00             	lea    0x0(%esi),%esi
80101e38:	83 c7 10             	add    $0x10,%edi
80101e3b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e3e:	76 50                	jbe    80101e90 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e40:	6a 10                	push   $0x10
80101e42:	57                   	push   %edi
80101e43:	56                   	push   %esi
80101e44:	53                   	push   %ebx
80101e45:	e8 76 fd ff ff       	call   80101bc0 <readi>
80101e4a:	83 c4 10             	add    $0x10,%esp
80101e4d:	83 f8 10             	cmp    $0x10,%eax
80101e50:	75 48                	jne    80101e9a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101e52:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e57:	74 df                	je     80101e38 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101e59:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e5c:	83 ec 04             	sub    $0x4,%esp
80101e5f:	6a 0e                	push   $0xe
80101e61:	50                   	push   %eax
80101e62:	ff 75 0c             	pushl  0xc(%ebp)
80101e65:	e8 36 29 00 00       	call   801047a0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101e6a:	83 c4 10             	add    $0x10,%esp
80101e6d:	85 c0                	test   %eax,%eax
80101e6f:	75 c7                	jne    80101e38 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101e71:	8b 45 10             	mov    0x10(%ebp),%eax
80101e74:	85 c0                	test   %eax,%eax
80101e76:	74 05                	je     80101e7d <dirlookup+0x6d>
        *poff = off;
80101e78:	8b 45 10             	mov    0x10(%ebp),%eax
80101e7b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101e7d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101e81:	8b 03                	mov    (%ebx),%eax
80101e83:	e8 a8 f4 ff ff       	call   80101330 <iget>
    }
  }

  return 0;
}
80101e88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e8b:	5b                   	pop    %ebx
80101e8c:	5e                   	pop    %esi
80101e8d:	5f                   	pop    %edi
80101e8e:	5d                   	pop    %ebp
80101e8f:	c3                   	ret    
80101e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101e93:	31 c0                	xor    %eax,%eax
}
80101e95:	5b                   	pop    %ebx
80101e96:	5e                   	pop    %esi
80101e97:	5f                   	pop    %edi
80101e98:	5d                   	pop    %ebp
80101e99:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101e9a:	83 ec 0c             	sub    $0xc,%esp
80101e9d:	68 5d 77 10 80       	push   $0x8010775d
80101ea2:	e8 f9 e5 ff ff       	call   801004a0 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101ea7:	83 ec 0c             	sub    $0xc,%esp
80101eaa:	68 4b 77 10 80       	push   $0x8010774b
80101eaf:	e8 ec e5 ff ff       	call   801004a0 <panic>
80101eb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101eba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101ec0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ec0:	55                   	push   %ebp
80101ec1:	89 e5                	mov    %esp,%ebp
80101ec3:	57                   	push   %edi
80101ec4:	56                   	push   %esi
80101ec5:	53                   	push   %ebx
80101ec6:	89 cf                	mov    %ecx,%edi
80101ec8:	89 c3                	mov    %eax,%ebx
80101eca:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ecd:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ed0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ed3:	0f 84 53 01 00 00    	je     8010202c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ed9:	e8 12 1b 00 00       	call   801039f0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ede:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ee1:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101ee4:	68 e0 19 11 80       	push   $0x801119e0
80101ee9:	e8 12 26 00 00       	call   80104500 <acquire>
  ip->ref++;
80101eee:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ef2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101ef9:	e8 22 27 00 00       	call   80104620 <release>
80101efe:	83 c4 10             	add    $0x10,%esp
80101f01:	eb 08                	jmp    80101f0b <namex+0x4b>
80101f03:	90                   	nop
80101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101f08:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101f0b:	0f b6 03             	movzbl (%ebx),%eax
80101f0e:	3c 2f                	cmp    $0x2f,%al
80101f10:	74 f6                	je     80101f08 <namex+0x48>
    path++;
  if(*path == 0)
80101f12:	84 c0                	test   %al,%al
80101f14:	0f 84 e3 00 00 00    	je     80101ffd <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101f1a:	0f b6 03             	movzbl (%ebx),%eax
80101f1d:	89 da                	mov    %ebx,%edx
80101f1f:	84 c0                	test   %al,%al
80101f21:	0f 84 ac 00 00 00    	je     80101fd3 <namex+0x113>
80101f27:	3c 2f                	cmp    $0x2f,%al
80101f29:	75 09                	jne    80101f34 <namex+0x74>
80101f2b:	e9 a3 00 00 00       	jmp    80101fd3 <namex+0x113>
80101f30:	84 c0                	test   %al,%al
80101f32:	74 0a                	je     80101f3e <namex+0x7e>
    path++;
80101f34:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101f37:	0f b6 02             	movzbl (%edx),%eax
80101f3a:	3c 2f                	cmp    $0x2f,%al
80101f3c:	75 f2                	jne    80101f30 <namex+0x70>
80101f3e:	89 d1                	mov    %edx,%ecx
80101f40:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101f42:	83 f9 0d             	cmp    $0xd,%ecx
80101f45:	0f 8e 8d 00 00 00    	jle    80101fd8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101f4b:	83 ec 04             	sub    $0x4,%esp
80101f4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f51:	6a 0e                	push   $0xe
80101f53:	53                   	push   %ebx
80101f54:	57                   	push   %edi
80101f55:	e8 c6 27 00 00       	call   80104720 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101f5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101f5d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101f60:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101f62:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101f65:	75 11                	jne    80101f78 <namex+0xb8>
80101f67:	89 f6                	mov    %esi,%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101f70:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101f73:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f76:	74 f8                	je     80101f70 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f78:	83 ec 0c             	sub    $0xc,%esp
80101f7b:	56                   	push   %esi
80101f7c:	e8 5f f9 ff ff       	call   801018e0 <ilock>
    if(ip->type != T_DIR){
80101f81:	83 c4 10             	add    $0x10,%esp
80101f84:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f89:	0f 85 7f 00 00 00    	jne    8010200e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f92:	85 d2                	test   %edx,%edx
80101f94:	74 09                	je     80101f9f <namex+0xdf>
80101f96:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f99:	0f 84 a3 00 00 00    	je     80102042 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f9f:	83 ec 04             	sub    $0x4,%esp
80101fa2:	6a 00                	push   $0x0
80101fa4:	57                   	push   %edi
80101fa5:	56                   	push   %esi
80101fa6:	e8 65 fe ff ff       	call   80101e10 <dirlookup>
80101fab:	83 c4 10             	add    $0x10,%esp
80101fae:	85 c0                	test   %eax,%eax
80101fb0:	74 5c                	je     8010200e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101fb2:	83 ec 0c             	sub    $0xc,%esp
80101fb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101fb8:	56                   	push   %esi
80101fb9:	e8 02 fa ff ff       	call   801019c0 <iunlock>
  iput(ip);
80101fbe:	89 34 24             	mov    %esi,(%esp)
80101fc1:	e8 4a fa ff ff       	call   80101a10 <iput>
80101fc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101fc9:	83 c4 10             	add    $0x10,%esp
80101fcc:	89 c6                	mov    %eax,%esi
80101fce:	e9 38 ff ff ff       	jmp    80101f0b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101fd3:	31 c9                	xor    %ecx,%ecx
80101fd5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101fd8:	83 ec 04             	sub    $0x4,%esp
80101fdb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101fde:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101fe1:	51                   	push   %ecx
80101fe2:	53                   	push   %ebx
80101fe3:	57                   	push   %edi
80101fe4:	e8 37 27 00 00       	call   80104720 <memmove>
    name[len] = 0;
80101fe9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fef:	83 c4 10             	add    $0x10,%esp
80101ff2:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101ff6:	89 d3                	mov    %edx,%ebx
80101ff8:	e9 65 ff ff ff       	jmp    80101f62 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102000:	85 c0                	test   %eax,%eax
80102002:	75 54                	jne    80102058 <namex+0x198>
80102004:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80102006:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102009:	5b                   	pop    %ebx
8010200a:	5e                   	pop    %esi
8010200b:	5f                   	pop    %edi
8010200c:	5d                   	pop    %ebp
8010200d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
8010200e:	83 ec 0c             	sub    $0xc,%esp
80102011:	56                   	push   %esi
80102012:	e8 a9 f9 ff ff       	call   801019c0 <iunlock>
  iput(ip);
80102017:	89 34 24             	mov    %esi,(%esp)
8010201a:	e8 f1 f9 ff ff       	call   80101a10 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
8010201f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102022:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80102025:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102027:	5b                   	pop    %ebx
80102028:	5e                   	pop    %esi
80102029:	5f                   	pop    %edi
8010202a:	5d                   	pop    %ebp
8010202b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
8010202c:	ba 01 00 00 00       	mov    $0x1,%edx
80102031:	b8 01 00 00 00       	mov    $0x1,%eax
80102036:	e8 f5 f2 ff ff       	call   80101330 <iget>
8010203b:	89 c6                	mov    %eax,%esi
8010203d:	e9 c9 fe ff ff       	jmp    80101f0b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80102042:	83 ec 0c             	sub    $0xc,%esp
80102045:	56                   	push   %esi
80102046:	e8 75 f9 ff ff       	call   801019c0 <iunlock>
      return ip;
8010204b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
8010204e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80102051:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80102053:	5b                   	pop    %ebx
80102054:	5e                   	pop    %esi
80102055:	5f                   	pop    %edi
80102056:	5d                   	pop    %ebp
80102057:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	56                   	push   %esi
8010205c:	e8 af f9 ff ff       	call   80101a10 <iput>
    return 0;
80102061:	83 c4 10             	add    $0x10,%esp
80102064:	31 c0                	xor    %eax,%eax
80102066:	eb 9e                	jmp    80102006 <namex+0x146>
80102068:	90                   	nop
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 20             	sub    $0x20,%esp
80102079:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010207c:	6a 00                	push   $0x0
8010207e:	ff 75 0c             	pushl  0xc(%ebp)
80102081:	53                   	push   %ebx
80102082:	e8 89 fd ff ff       	call   80101e10 <dirlookup>
80102087:	83 c4 10             	add    $0x10,%esp
8010208a:	85 c0                	test   %eax,%eax
8010208c:	75 67                	jne    801020f5 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010208e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102091:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102094:	85 ff                	test   %edi,%edi
80102096:	74 29                	je     801020c1 <dirlink+0x51>
80102098:	31 ff                	xor    %edi,%edi
8010209a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010209d:	eb 09                	jmp    801020a8 <dirlink+0x38>
8010209f:	90                   	nop
801020a0:	83 c7 10             	add    $0x10,%edi
801020a3:	39 7b 58             	cmp    %edi,0x58(%ebx)
801020a6:	76 19                	jbe    801020c1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a8:	6a 10                	push   $0x10
801020aa:	57                   	push   %edi
801020ab:	56                   	push   %esi
801020ac:	53                   	push   %ebx
801020ad:	e8 0e fb ff ff       	call   80101bc0 <readi>
801020b2:	83 c4 10             	add    $0x10,%esp
801020b5:	83 f8 10             	cmp    $0x10,%eax
801020b8:	75 4e                	jne    80102108 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
801020ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020bf:	75 df                	jne    801020a0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
801020c1:	8d 45 da             	lea    -0x26(%ebp),%eax
801020c4:	83 ec 04             	sub    $0x4,%esp
801020c7:	6a 0e                	push   $0xe
801020c9:	ff 75 0c             	pushl  0xc(%ebp)
801020cc:	50                   	push   %eax
801020cd:	e8 3e 27 00 00       	call   80104810 <strncpy>
  de.inum = inum;
801020d2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020d5:	6a 10                	push   $0x10
801020d7:	57                   	push   %edi
801020d8:	56                   	push   %esi
801020d9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
801020da:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020de:	e8 dd fb ff ff       	call   80101cc0 <writei>
801020e3:	83 c4 20             	add    $0x20,%esp
801020e6:	83 f8 10             	cmp    $0x10,%eax
801020e9:	75 2a                	jne    80102115 <dirlink+0xa5>
    panic("dirlink");

  return 0;
801020eb:	31 c0                	xor    %eax,%eax
}
801020ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020f0:	5b                   	pop    %ebx
801020f1:	5e                   	pop    %esi
801020f2:	5f                   	pop    %edi
801020f3:	5d                   	pop    %ebp
801020f4:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
801020f5:	83 ec 0c             	sub    $0xc,%esp
801020f8:	50                   	push   %eax
801020f9:	e8 12 f9 ff ff       	call   80101a10 <iput>
    return -1;
801020fe:	83 c4 10             	add    $0x10,%esp
80102101:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102106:	eb e5                	jmp    801020ed <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80102108:	83 ec 0c             	sub    $0xc,%esp
8010210b:	68 6c 77 10 80       	push   $0x8010776c
80102110:	e8 8b e3 ff ff       	call   801004a0 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80102115:	83 ec 0c             	sub    $0xc,%esp
80102118:	68 66 7d 10 80       	push   $0x80107d66
8010211d:	e8 7e e3 ff ff       	call   801004a0 <panic>
80102122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80102130:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102131:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80102133:	89 e5                	mov    %esp,%ebp
80102135:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102138:	8b 45 08             	mov    0x8(%ebp),%eax
8010213b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010213e:	e8 7d fd ff ff       	call   80101ec0 <namex>
}
80102143:	c9                   	leave  
80102144:	c3                   	ret    
80102145:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102150 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102150:	55                   	push   %ebp
  return namex(path, 1, name);
80102151:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80102156:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102158:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010215b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010215e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010215f:	e9 5c fd ff ff       	jmp    80101ec0 <namex>
80102164:	66 90                	xchg   %ax,%ax
80102166:	66 90                	xchg   %ax,%ax
80102168:	66 90                	xchg   %ax,%ax
8010216a:	66 90                	xchg   %ax,%ax
8010216c:	66 90                	xchg   %ax,%ax
8010216e:	66 90                	xchg   %ax,%ax

80102170 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102170:	55                   	push   %ebp
  if(b == 0)
80102171:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102173:	89 e5                	mov    %esp,%ebp
80102175:	56                   	push   %esi
80102176:	53                   	push   %ebx
  if(b == 0)
80102177:	0f 84 ad 00 00 00    	je     8010222a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010217d:	8b 58 08             	mov    0x8(%eax),%ebx
80102180:	89 c1                	mov    %eax,%ecx
80102182:	81 fb ff f3 01 00    	cmp    $0x1f3ff,%ebx
80102188:	0f 87 8f 00 00 00    	ja     8010221d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102193:	90                   	nop
80102194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102198:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102199:	83 e0 c0             	and    $0xffffffc0,%eax
8010219c:	3c 40                	cmp    $0x40,%al
8010219e:	75 f8                	jne    80102198 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a0:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021a5:	31 c0                	xor    %eax,%eax
801021a7:	ee                   	out    %al,(%dx)
801021a8:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021ad:	b8 01 00 00 00       	mov    $0x1,%eax
801021b2:	ee                   	out    %al,(%dx)
801021b3:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021b8:	89 d8                	mov    %ebx,%eax
801021ba:	ee                   	out    %al,(%dx)
801021bb:	89 d8                	mov    %ebx,%eax
801021bd:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021c2:	c1 f8 08             	sar    $0x8,%eax
801021c5:	ee                   	out    %al,(%dx)
801021c6:	89 d8                	mov    %ebx,%eax
801021c8:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021cd:	c1 f8 10             	sar    $0x10,%eax
801021d0:	ee                   	out    %al,(%dx)
801021d1:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
801021d5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021da:	83 e0 01             	and    $0x1,%eax
801021dd:	c1 e0 04             	shl    $0x4,%eax
801021e0:	83 c8 e0             	or     $0xffffffe0,%eax
801021e3:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
801021e4:	f6 01 04             	testb  $0x4,(%ecx)
801021e7:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ec:	75 12                	jne    80102200 <idestart+0x90>
801021ee:	b8 20 00 00 00       	mov    $0x20,%eax
801021f3:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021f7:	5b                   	pop    %ebx
801021f8:	5e                   	pop    %esi
801021f9:	5d                   	pop    %ebp
801021fa:	c3                   	ret    
801021fb:	90                   	nop
801021fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102200:	b8 30 00 00 00       	mov    $0x30,%eax
80102205:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102206:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010220b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010220e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102213:	fc                   	cld    
80102214:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102216:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102219:	5b                   	pop    %ebx
8010221a:	5e                   	pop    %esi
8010221b:	5d                   	pop    %ebp
8010221c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010221d:	83 ec 0c             	sub    $0xc,%esp
80102220:	68 d8 77 10 80       	push   $0x801077d8
80102225:	e8 76 e2 ff ff       	call   801004a0 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010222a:	83 ec 0c             	sub    $0xc,%esp
8010222d:	68 cf 77 10 80       	push   $0x801077cf
80102232:	e8 69 e2 ff ff       	call   801004a0 <panic>
80102237:	89 f6                	mov    %esi,%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102240 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102246:	68 ea 77 10 80       	push   $0x801077ea
8010224b:	68 80 b5 10 80       	push   $0x8010b580
80102250:	e8 ab 21 00 00       	call   80104400 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102255:	58                   	pop    %eax
80102256:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010225b:	5a                   	pop    %edx
8010225c:	83 e8 01             	sub    $0x1,%eax
8010225f:	50                   	push   %eax
80102260:	6a 0e                	push   $0xe
80102262:	e8 a9 02 00 00       	call   80102510 <ioapicenable>
80102267:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010226a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	83 e0 c0             	and    $0xffffffc0,%eax
80102274:	3c 40                	cmp    $0x40,%al
80102276:	75 f8                	jne    80102270 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102278:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010227d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102282:	ee                   	out    %al,(%dx)
80102283:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102288:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010228d:	eb 06                	jmp    80102295 <ideinit+0x55>
8010228f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102290:	83 e9 01             	sub    $0x1,%ecx
80102293:	74 0f                	je     801022a4 <ideinit+0x64>
80102295:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102296:	84 c0                	test   %al,%al
80102298:	74 f6                	je     80102290 <ideinit+0x50>
      havedisk1 = 1;
8010229a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801022a1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022a4:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022a9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022ae:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
801022af:	c9                   	leave  
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ideintr>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	57                   	push   %edi
801022c4:	56                   	push   %esi
801022c5:	53                   	push   %ebx
801022c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022c9:	68 80 b5 10 80       	push   $0x8010b580
801022ce:	e8 2d 22 00 00       	call   80104500 <acquire>

  if((b = idequeue) == 0){
801022d3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801022d9:	83 c4 10             	add    $0x10,%esp
801022dc:	85 db                	test   %ebx,%ebx
801022de:	74 34                	je     80102314 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022e0:	8b 43 58             	mov    0x58(%ebx),%eax
801022e3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022e8:	8b 33                	mov    (%ebx),%esi
801022ea:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022f0:	74 3e                	je     80102330 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022f2:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022f5:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022f8:	83 ce 02             	or     $0x2,%esi
801022fb:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022fd:	53                   	push   %ebx
801022fe:	e8 3d 1e 00 00       	call   80104140 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102303:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102308:	83 c4 10             	add    $0x10,%esp
8010230b:	85 c0                	test   %eax,%eax
8010230d:	74 05                	je     80102314 <ideintr+0x54>
    idestart(idequeue);
8010230f:	e8 5c fe ff ff       	call   80102170 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102314:	83 ec 0c             	sub    $0xc,%esp
80102317:	68 80 b5 10 80       	push   $0x8010b580
8010231c:	e8 ff 22 00 00       	call   80104620 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102321:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102324:	5b                   	pop    %ebx
80102325:	5e                   	pop    %esi
80102326:	5f                   	pop    %edi
80102327:	5d                   	pop    %ebp
80102328:	c3                   	ret    
80102329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102330:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102335:	8d 76 00             	lea    0x0(%esi),%esi
80102338:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102339:	89 c1                	mov    %eax,%ecx
8010233b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010233e:	80 f9 40             	cmp    $0x40,%cl
80102341:	75 f5                	jne    80102338 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102343:	a8 21                	test   $0x21,%al
80102345:	75 ab                	jne    801022f2 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102347:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010234a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010234f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102354:	fc                   	cld    
80102355:	f3 6d                	rep insl (%dx),%es:(%edi)
80102357:	8b 33                	mov    (%ebx),%esi
80102359:	eb 97                	jmp    801022f2 <ideintr+0x32>
8010235b:	90                   	nop
8010235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102360 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	53                   	push   %ebx
80102364:	83 ec 10             	sub    $0x10,%esp
80102367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010236a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010236d:	50                   	push   %eax
8010236e:	e8 5d 20 00 00       	call   801043d0 <holdingsleep>
80102373:	83 c4 10             	add    $0x10,%esp
80102376:	85 c0                	test   %eax,%eax
80102378:	0f 84 ad 00 00 00    	je     8010242b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 e0 06             	and    $0x6,%eax
80102383:	83 f8 02             	cmp    $0x2,%eax
80102386:	0f 84 b9 00 00 00    	je     80102445 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010238c:	8b 53 04             	mov    0x4(%ebx),%edx
8010238f:	85 d2                	test   %edx,%edx
80102391:	74 0d                	je     801023a0 <iderw+0x40>
80102393:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102398:	85 c0                	test   %eax,%eax
8010239a:	0f 84 98 00 00 00    	je     80102438 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	68 80 b5 10 80       	push   $0x8010b580
801023a8:	e8 53 21 00 00       	call   80104500 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023ad:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801023b3:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
801023b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023bd:	85 d2                	test   %edx,%edx
801023bf:	75 09                	jne    801023ca <iderw+0x6a>
801023c1:	eb 58                	jmp    8010241b <iderw+0xbb>
801023c3:	90                   	nop
801023c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023c8:	89 c2                	mov    %eax,%edx
801023ca:	8b 42 58             	mov    0x58(%edx),%eax
801023cd:	85 c0                	test   %eax,%eax
801023cf:	75 f7                	jne    801023c8 <iderw+0x68>
801023d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023d6:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
801023dc:	74 44                	je     80102422 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 e0 06             	and    $0x6,%eax
801023e3:	83 f8 02             	cmp    $0x2,%eax
801023e6:	74 23                	je     8010240b <iderw+0xab>
801023e8:	90                   	nop
801023e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801023f0:	83 ec 08             	sub    $0x8,%esp
801023f3:	68 80 b5 10 80       	push   $0x8010b580
801023f8:	53                   	push   %ebx
801023f9:	e8 72 1b 00 00       	call   80103f70 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023fe:	8b 03                	mov    (%ebx),%eax
80102400:	83 c4 10             	add    $0x10,%esp
80102403:	83 e0 06             	and    $0x6,%eax
80102406:	83 f8 02             	cmp    $0x2,%eax
80102409:	75 e5                	jne    801023f0 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010240b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102412:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102415:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102416:	e9 05 22 00 00       	jmp    80104620 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010241b:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102420:	eb b2                	jmp    801023d4 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102422:	89 d8                	mov    %ebx,%eax
80102424:	e8 47 fd ff ff       	call   80102170 <idestart>
80102429:	eb b3                	jmp    801023de <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010242b:	83 ec 0c             	sub    $0xc,%esp
8010242e:	68 ee 77 10 80       	push   $0x801077ee
80102433:	e8 68 e0 ff ff       	call   801004a0 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102438:	83 ec 0c             	sub    $0xc,%esp
8010243b:	68 19 78 10 80       	push   $0x80107819
80102440:	e8 5b e0 ff ff       	call   801004a0 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102445:	83 ec 0c             	sub    $0xc,%esp
80102448:	68 04 78 10 80       	push   $0x80107804
8010244d:	e8 4e e0 ff ff       	call   801004a0 <panic>
80102452:	66 90                	xchg   %ax,%ax
80102454:	66 90                	xchg   %ax,%ax
80102456:	66 90                	xchg   %ax,%ax
80102458:	66 90                	xchg   %ax,%ax
8010245a:	66 90                	xchg   %ax,%ax
8010245c:	66 90                	xchg   %ax,%ax
8010245e:	66 90                	xchg   %ax,%ax

80102460 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102460:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102461:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102468:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010246b:	89 e5                	mov    %esp,%ebp
8010246d:	56                   	push   %esi
8010246e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010246f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102476:	00 00 00 
  return ioapic->data;
80102479:	8b 15 34 36 11 80    	mov    0x80113634,%edx
8010247f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102482:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102488:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010248e:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102495:	89 f0                	mov    %esi,%eax
80102497:	c1 e8 10             	shr    $0x10,%eax
8010249a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010249d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024a0:	c1 e8 18             	shr    $0x18,%eax
801024a3:	39 d0                	cmp    %edx,%eax
801024a5:	74 16                	je     801024bd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 38 78 10 80       	push   $0x80107838
801024af:	e8 dc e2 ff ff       	call   80100790 <cprintf>
801024b4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801024ba:	83 c4 10             	add    $0x10,%esp
801024bd:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024c0:	ba 10 00 00 00       	mov    $0x10,%edx
801024c5:	b8 20 00 00 00       	mov    $0x20,%eax
801024ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801024d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801024d2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024d8:	89 c3                	mov    %eax,%ebx
801024da:	81 cb 00 00 01 00    	or     $0x10000,%ebx
801024e0:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801024e3:	89 59 10             	mov    %ebx,0x10(%ecx)
801024e6:	8d 5a 01             	lea    0x1(%edx),%ebx
801024e9:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024ec:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801024ee:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801024f0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801024f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024fd:	75 d1                	jne    801024d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102502:	5b                   	pop    %ebx
80102503:	5e                   	pop    %esi
80102504:	5d                   	pop    %ebp
80102505:	c3                   	ret    
80102506:	8d 76 00             	lea    0x0(%esi),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102510:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102511:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102517:	89 e5                	mov    %esp,%ebp
80102519:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010251c:	8d 50 20             	lea    0x20(%eax),%edx
8010251f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102523:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102525:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010252b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010252e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102531:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102534:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102536:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010253b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010253e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102541:	5d                   	pop    %ebp
80102542:	c3                   	ret    
80102543:	66 90                	xchg   %ax,%ax
80102545:	66 90                	xchg   %ax,%ax
80102547:	66 90                	xchg   %ax,%ax
80102549:	66 90                	xchg   %ax,%ax
8010254b:	66 90                	xchg   %ax,%ax
8010254d:	66 90                	xchg   %ax,%ax
8010254f:	90                   	nop

80102550 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	53                   	push   %ebx
80102554:	83 ec 04             	sub    $0x4,%esp
80102557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010255a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102560:	75 70                	jne    801025d2 <kfree+0x82>
80102562:	81 fb a8 64 11 80    	cmp    $0x801164a8,%ebx
80102568:	72 68                	jb     801025d2 <kfree+0x82>
8010256a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102570:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
80102575:	77 5b                	ja     801025d2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102577:	83 ec 04             	sub    $0x4,%esp
8010257a:	68 00 10 00 00       	push   $0x1000
8010257f:	6a 01                	push   $0x1
80102581:	53                   	push   %ebx
80102582:	e8 e9 20 00 00       	call   80104670 <memset>

  if(kmem.use_lock)
80102587:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	85 d2                	test   %edx,%edx
80102592:	75 2c                	jne    801025c0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102594:	a1 78 36 11 80       	mov    0x80113678,%eax
80102599:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010259b:	a1 74 36 11 80       	mov    0x80113674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801025a0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801025a6:	85 c0                	test   %eax,%eax
801025a8:	75 06                	jne    801025b0 <kfree+0x60>
    release(&kmem.lock);
}
801025aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025ad:	c9                   	leave  
801025ae:	c3                   	ret    
801025af:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801025b0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801025b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025ba:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
801025bb:	e9 60 20 00 00       	jmp    80104620 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
801025c0:	83 ec 0c             	sub    $0xc,%esp
801025c3:	68 40 36 11 80       	push   $0x80113640
801025c8:	e8 33 1f 00 00       	call   80104500 <acquire>
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	eb c2                	jmp    80102594 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
801025d2:	83 ec 0c             	sub    $0xc,%esp
801025d5:	68 6a 78 10 80       	push   $0x8010786a
801025da:	e8 c1 de ff ff       	call   801004a0 <panic>
801025df:	90                   	nop

801025e0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <freerange+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010260e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 33 ff ff ff       	call   80102550 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 f3                	cmp    %esi,%ebx
80102622:	76 e4                	jbe    80102608 <freerange+0x28>
    kfree(p);
}
80102624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret    
8010262b:	90                   	nop
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
80102635:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102638:	83 ec 08             	sub    $0x8,%esp
8010263b:	68 70 78 10 80       	push   $0x80107870
80102640:	68 40 36 11 80       	push   $0x80113640
80102645:	e8 b6 1d 00 00       	call   80104400 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010264a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102650:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102657:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010265a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102660:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102666:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010266c:	39 de                	cmp    %ebx,%esi
8010266e:	72 1c                	jb     8010268c <kinit1+0x5c>
    kfree(p);
80102670:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102676:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102679:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010267f:	50                   	push   %eax
80102680:	e8 cb fe ff ff       	call   80102550 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102685:	83 c4 10             	add    $0x10,%esp
80102688:	39 de                	cmp    %ebx,%esi
8010268a:	73 e4                	jae    80102670 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010268c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010268f:	5b                   	pop    %ebx
80102690:	5e                   	pop    %esi
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	56                   	push   %esi
801026a4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801026a8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801026ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026bd:	39 de                	cmp    %ebx,%esi
801026bf:	72 23                	jb     801026e4 <kinit2+0x44>
801026c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801026ce:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026d7:	50                   	push   %eax
801026d8:	e8 73 fe ff ff       	call   80102550 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026dd:	83 c4 10             	add    $0x10,%esp
801026e0:	39 de                	cmp    %ebx,%esi
801026e2:	73 e4                	jae    801026c8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801026e4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801026eb:	00 00 00 
}
801026ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026f1:	5b                   	pop    %ebx
801026f2:	5e                   	pop    %esi
801026f3:	5d                   	pop    %ebp
801026f4:	c3                   	ret    
801026f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	53                   	push   %ebx
80102704:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102707:	a1 74 36 11 80       	mov    0x80113674,%eax
8010270c:	85 c0                	test   %eax,%eax
8010270e:	75 30                	jne    80102740 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102710:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102716:	85 db                	test   %ebx,%ebx
80102718:	74 1c                	je     80102736 <kalloc+0x36>
    kmem.freelist = r->next;
8010271a:	8b 13                	mov    (%ebx),%edx
8010271c:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
80102722:	85 c0                	test   %eax,%eax
80102724:	74 10                	je     80102736 <kalloc+0x36>
    release(&kmem.lock);
80102726:	83 ec 0c             	sub    $0xc,%esp
80102729:	68 40 36 11 80       	push   $0x80113640
8010272e:	e8 ed 1e 00 00       	call   80104620 <release>
80102733:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102736:	89 d8                	mov    %ebx,%eax
80102738:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010273b:	c9                   	leave  
8010273c:	c3                   	ret    
8010273d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102740:	83 ec 0c             	sub    $0xc,%esp
80102743:	68 40 36 11 80       	push   $0x80113640
80102748:	e8 b3 1d 00 00       	call   80104500 <acquire>
  r = kmem.freelist;
8010274d:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r)
80102753:	83 c4 10             	add    $0x10,%esp
80102756:	a1 74 36 11 80       	mov    0x80113674,%eax
8010275b:	85 db                	test   %ebx,%ebx
8010275d:	75 bb                	jne    8010271a <kalloc+0x1a>
8010275f:	eb c1                	jmp    80102722 <kalloc+0x22>
80102761:	66 90                	xchg   %ax,%ax
80102763:	66 90                	xchg   %ax,%ax
80102765:	66 90                	xchg   %ax,%ax
80102767:	66 90                	xchg   %ax,%ax
80102769:	66 90                	xchg   %ax,%ax
8010276b:	66 90                	xchg   %ax,%ax
8010276d:	66 90                	xchg   %ax,%ax
8010276f:	90                   	nop

80102770 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102770:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102771:	ba 64 00 00 00       	mov    $0x64,%edx
80102776:	89 e5                	mov    %esp,%ebp
80102778:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102779:	a8 01                	test   $0x1,%al
8010277b:	0f 84 af 00 00 00    	je     80102830 <kbdgetc+0xc0>
80102781:	ba 60 00 00 00       	mov    $0x60,%edx
80102786:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102787:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010278a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102790:	74 7e                	je     80102810 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102792:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102794:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010279a:	79 24                	jns    801027c0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010279c:	f6 c1 40             	test   $0x40,%cl
8010279f:	75 05                	jne    801027a6 <kbdgetc+0x36>
801027a1:	89 c2                	mov    %eax,%edx
801027a3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801027a6:	0f b6 82 a0 79 10 80 	movzbl -0x7fef8660(%edx),%eax
801027ad:	83 c8 40             	or     $0x40,%eax
801027b0:	0f b6 c0             	movzbl %al,%eax
801027b3:	f7 d0                	not    %eax
801027b5:	21 c8                	and    %ecx,%eax
801027b7:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
801027bc:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027be:	5d                   	pop    %ebp
801027bf:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027c0:	f6 c1 40             	test   $0x40,%cl
801027c3:	74 09                	je     801027ce <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027c5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027c8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027cb:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801027ce:	0f b6 82 a0 79 10 80 	movzbl -0x7fef8660(%edx),%eax
801027d5:	09 c1                	or     %eax,%ecx
801027d7:	0f b6 82 a0 78 10 80 	movzbl -0x7fef8760(%edx),%eax
801027de:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801027e0:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801027e2:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801027e8:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027eb:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801027ee:	8b 04 85 80 78 10 80 	mov    -0x7fef8780(,%eax,4),%eax
801027f5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801027f9:	74 c3                	je     801027be <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
801027fb:	8d 50 9f             	lea    -0x61(%eax),%edx
801027fe:	83 fa 19             	cmp    $0x19,%edx
80102801:	77 1d                	ja     80102820 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102803:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102806:	5d                   	pop    %ebp
80102807:	c3                   	ret    
80102808:	90                   	nop
80102809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102810:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102812:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102819:	5d                   	pop    %ebp
8010281a:	c3                   	ret    
8010281b:	90                   	nop
8010281c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102820:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102823:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102826:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102827:	83 f9 19             	cmp    $0x19,%ecx
8010282a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010282d:	c3                   	ret    
8010282e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102835:	5d                   	pop    %ebp
80102836:	c3                   	ret    
80102837:	89 f6                	mov    %esi,%esi
80102839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102840 <kbdintr>:

void
kbdintr(void)
{
80102840:	55                   	push   %ebp
80102841:	89 e5                	mov    %esp,%ebp
80102843:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102846:	68 70 27 10 80       	push   $0x80102770
8010284b:	e8 d0 e0 ff ff       	call   80100920 <consoleintr>
}
80102850:	83 c4 10             	add    $0x10,%esp
80102853:	c9                   	leave  
80102854:	c3                   	ret    
80102855:	66 90                	xchg   %ax,%ax
80102857:	66 90                	xchg   %ax,%ax
80102859:	66 90                	xchg   %ax,%ax
8010285b:	66 90                	xchg   %ax,%ax
8010285d:	66 90                	xchg   %ax,%ax
8010285f:	90                   	nop

80102860 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102860:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102865:	55                   	push   %ebp
80102866:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102868:	85 c0                	test   %eax,%eax
8010286a:	0f 84 c8 00 00 00    	je     80102938 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102870:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102877:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010287d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102884:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102887:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102891:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102894:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102897:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010289e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028a1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028a4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028ab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ae:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028b1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028b8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028be:	8b 50 30             	mov    0x30(%eax),%edx
801028c1:	c1 ea 10             	shr    $0x10,%edx
801028c4:	80 fa 03             	cmp    $0x3,%dl
801028c7:	77 77                	ja     80102940 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028c9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028d6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028dd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028e3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ed:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028f0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028f7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028fa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028fd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102904:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102907:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010290a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102911:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102914:	8b 50 20             	mov    0x20(%eax),%edx
80102917:	89 f6                	mov    %esi,%esi
80102919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102920:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102926:	80 e6 10             	and    $0x10,%dh
80102929:	75 f5                	jne    80102920 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010292b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102932:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102935:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102938:	5d                   	pop    %ebp
80102939:	c3                   	ret    
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102940:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102947:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 50 20             	mov    0x20(%eax),%edx
8010294d:	e9 77 ff ff ff       	jmp    801028c9 <lapicinit+0x69>
80102952:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102960 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102960:	a1 7c 36 11 80       	mov    0x8011367c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102965:	55                   	push   %ebp
80102966:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102968:	85 c0                	test   %eax,%eax
8010296a:	74 0c                	je     80102978 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010296c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010296f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102970:	c1 e8 18             	shr    $0x18,%eax
}
80102973:	c3                   	ret    
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102978:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010297a:	5d                   	pop    %ebp
8010297b:	c3                   	ret    
8010297c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102980 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102980:	a1 7c 36 11 80       	mov    0x8011367c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102985:	55                   	push   %ebp
80102986:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102988:	85 c0                	test   %eax,%eax
8010298a:	74 0d                	je     80102999 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010298c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102993:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102999:	5d                   	pop    %ebp
8010299a:	c3                   	ret    
8010299b:	90                   	nop
8010299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801029a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801029a0:	55                   	push   %ebp
801029a1:	89 e5                	mov    %esp,%ebp
}
801029a3:	5d                   	pop    %ebp
801029a4:	c3                   	ret    
801029a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	ba 70 00 00 00       	mov    $0x70,%edx
801029b6:	b8 0f 00 00 00       	mov    $0xf,%eax
801029bb:	89 e5                	mov    %esp,%ebp
801029bd:	53                   	push   %ebx
801029be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029c4:	ee                   	out    %al,(%dx)
801029c5:	ba 71 00 00 00       	mov    $0x71,%edx
801029ca:	b8 0a 00 00 00       	mov    $0xa,%eax
801029cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029d0:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029d2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029dd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801029e0:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029e3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029e5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801029e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029ee:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801029f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029f9:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801029fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a06:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a13:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a1c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a25:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a2e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a37:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102a3a:	5b                   	pop    %ebx
80102a3b:	5d                   	pop    %ebp
80102a3c:	c3                   	ret    
80102a3d:	8d 76 00             	lea    0x0(%esi),%esi

80102a40 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102a40:	55                   	push   %ebp
80102a41:	ba 70 00 00 00       	mov    $0x70,%edx
80102a46:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a4b:	89 e5                	mov    %esp,%ebp
80102a4d:	57                   	push   %edi
80102a4e:	56                   	push   %esi
80102a4f:	53                   	push   %ebx
80102a50:	83 ec 4c             	sub    $0x4c,%esp
80102a53:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	ba 71 00 00 00       	mov    $0x71,%edx
80102a59:	ec                   	in     (%dx),%al
80102a5a:	83 e0 04             	and    $0x4,%eax
80102a5d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a60:	31 db                	xor    %ebx,%ebx
80102a62:	88 45 b7             	mov    %al,-0x49(%ebp)
80102a65:	bf 70 00 00 00       	mov    $0x70,%edi
80102a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a70:	89 d8                	mov    %ebx,%eax
80102a72:	89 fa                	mov    %edi,%edx
80102a74:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a75:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a7a:	89 ca                	mov    %ecx,%edx
80102a7c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102a7d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a80:	89 fa                	mov    %edi,%edx
80102a82:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a85:	b8 02 00 00 00       	mov    $0x2,%eax
80102a8a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8b:	89 ca                	mov    %ecx,%edx
80102a8d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102a8e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a91:	89 fa                	mov    %edi,%edx
80102a93:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a96:	b8 04 00 00 00       	mov    $0x4,%eax
80102a9b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9c:	89 ca                	mov    %ecx,%edx
80102a9e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102a9f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa2:	89 fa                	mov    %edi,%edx
80102aa4:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aa7:	b8 07 00 00 00       	mov    $0x7,%eax
80102aac:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	89 ca                	mov    %ecx,%edx
80102aaf:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102ab0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab3:	89 fa                	mov    %edi,%edx
80102ab5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ab8:	b8 08 00 00 00       	mov    $0x8,%eax
80102abd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102ac1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 fa                	mov    %edi,%edx
80102ac6:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102ac9:	b8 09 00 00 00       	mov    $0x9,%eax
80102ace:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acf:	89 ca                	mov    %ecx,%edx
80102ad1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102ad2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad5:	89 fa                	mov    %edi,%edx
80102ad7:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102ada:	b8 0a 00 00 00       	mov    $0xa,%eax
80102adf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ae3:	84 c0                	test   %al,%al
80102ae5:	78 89                	js     80102a70 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae7:	89 d8                	mov    %ebx,%eax
80102ae9:	89 fa                	mov    %edi,%edx
80102aeb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aec:	89 ca                	mov    %ecx,%edx
80102aee:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102aef:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af2:	89 fa                	mov    %edi,%edx
80102af4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102af7:	b8 02 00 00 00       	mov    $0x2,%eax
80102afc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afd:	89 ca                	mov    %ecx,%edx
80102aff:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102b00:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b03:	89 fa                	mov    %edi,%edx
80102b05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b08:	b8 04 00 00 00       	mov    $0x4,%eax
80102b0d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0e:	89 ca                	mov    %ecx,%edx
80102b10:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102b11:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b14:	89 fa                	mov    %edi,%edx
80102b16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b19:	b8 07 00 00 00       	mov    $0x7,%eax
80102b1e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1f:	89 ca                	mov    %ecx,%edx
80102b21:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102b22:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b25:	89 fa                	mov    %edi,%edx
80102b27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b2f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b30:	89 ca                	mov    %ecx,%edx
80102b32:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102b33:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b36:	89 fa                	mov    %edi,%edx
80102b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b40:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b41:	89 ca                	mov    %ecx,%edx
80102b43:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102b44:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b47:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102b4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b4d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b50:	6a 18                	push   $0x18
80102b52:	56                   	push   %esi
80102b53:	50                   	push   %eax
80102b54:	e8 67 1b 00 00       	call   801046c0 <memcmp>
80102b59:	83 c4 10             	add    $0x10,%esp
80102b5c:	85 c0                	test   %eax,%eax
80102b5e:	0f 85 0c ff ff ff    	jne    80102a70 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b64:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102b68:	75 78                	jne    80102be2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b6a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b6d:	89 c2                	mov    %eax,%edx
80102b6f:	83 e0 0f             	and    $0xf,%eax
80102b72:	c1 ea 04             	shr    $0x4,%edx
80102b75:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b78:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b7b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b7e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b81:	89 c2                	mov    %eax,%edx
80102b83:	83 e0 0f             	and    $0xf,%eax
80102b86:	c1 ea 04             	shr    $0x4,%edx
80102b89:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b8c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b8f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b92:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b95:	89 c2                	mov    %eax,%edx
80102b97:	83 e0 0f             	and    $0xf,%eax
80102b9a:	c1 ea 04             	shr    $0x4,%edx
80102b9d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba0:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ba3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ba6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ba9:	89 c2                	mov    %eax,%edx
80102bab:	83 e0 0f             	and    $0xf,%eax
80102bae:	c1 ea 04             	shr    $0x4,%edx
80102bb1:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bb4:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bb7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bba:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bbd:	89 c2                	mov    %eax,%edx
80102bbf:	83 e0 0f             	and    $0xf,%eax
80102bc2:	c1 ea 04             	shr    $0x4,%edx
80102bc5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bc8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bcb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bce:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd1:	89 c2                	mov    %eax,%edx
80102bd3:	83 e0 0f             	and    $0xf,%eax
80102bd6:	c1 ea 04             	shr    $0x4,%edx
80102bd9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bdf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102be2:	8b 75 08             	mov    0x8(%ebp),%esi
80102be5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102be8:	89 06                	mov    %eax,(%esi)
80102bea:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bed:	89 46 04             	mov    %eax,0x4(%esi)
80102bf0:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bf3:	89 46 08             	mov    %eax,0x8(%esi)
80102bf6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bf9:	89 46 0c             	mov    %eax,0xc(%esi)
80102bfc:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bff:	89 46 10             	mov    %eax,0x10(%esi)
80102c02:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c05:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c08:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c12:	5b                   	pop    %ebx
80102c13:	5e                   	pop    %esi
80102c14:	5f                   	pop    %edi
80102c15:	5d                   	pop    %ebp
80102c16:	c3                   	ret    
80102c17:	66 90                	xchg   %ax,%ax
80102c19:	66 90                	xchg   %ax,%ax
80102c1b:	66 90                	xchg   %ax,%ax
80102c1d:	66 90                	xchg   %ax,%ax
80102c1f:	90                   	nop

80102c20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c20:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102c26:	85 c9                	test   %ecx,%ecx
80102c28:	0f 8e 85 00 00 00    	jle    80102cb3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102c2e:	55                   	push   %ebp
80102c2f:	89 e5                	mov    %esp,%ebp
80102c31:	57                   	push   %edi
80102c32:	56                   	push   %esi
80102c33:	53                   	push   %ebx
80102c34:	31 db                	xor    %ebx,%ebx
80102c36:	83 ec 0c             	sub    $0xc,%esp
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c40:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c45:	83 ec 08             	sub    $0x8,%esp
80102c48:	01 d8                	add    %ebx,%eax
80102c4a:	83 c0 01             	add    $0x1,%eax
80102c4d:	50                   	push   %eax
80102c4e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c54:	e8 77 d4 ff ff       	call   801000d0 <bread>
80102c59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5b:	58                   	pop    %eax
80102c5c:	5a                   	pop    %edx
80102c5d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102c64:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c6d:	e8 5e d4 ff ff       	call   801000d0 <bread>
80102c72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c74:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c77:	83 c4 0c             	add    $0xc,%esp
80102c7a:	68 00 02 00 00       	push   $0x200
80102c7f:	50                   	push   %eax
80102c80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c83:	50                   	push   %eax
80102c84:	e8 97 1a 00 00       	call   80104720 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c89:	89 34 24             	mov    %esi,(%esp)
80102c8c:	e8 0f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c91:	89 3c 24             	mov    %edi,(%esp)
80102c94:	e8 47 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c99:	89 34 24             	mov    %esi,(%esp)
80102c9c:	e8 3f d5 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ca1:	83 c4 10             	add    $0x10,%esp
80102ca4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102caa:	7f 94                	jg     80102c40 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102cac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102caf:	5b                   	pop    %ebx
80102cb0:	5e                   	pop    %esi
80102cb1:	5f                   	pop    %edi
80102cb2:	5d                   	pop    %ebp
80102cb3:	f3 c3                	repz ret 
80102cb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cc7:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102ccd:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102cd3:	e8 f8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102cd8:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102cde:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ce1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ce3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ce5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ce8:	7e 1f                	jle    80102d09 <write_head+0x49>
80102cea:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102cf1:	31 d2                	xor    %edx,%edx
80102cf3:	90                   	nop
80102cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102cf8:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102cfe:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102d02:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d05:	39 c2                	cmp    %eax,%edx
80102d07:	75 ef                	jne    80102cf8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102d09:	83 ec 0c             	sub    $0xc,%esp
80102d0c:	53                   	push   %ebx
80102d0d:	e8 8e d4 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102d12:	89 1c 24             	mov    %ebx,(%esp)
80102d15:	e8 c6 d4 ff ff       	call   801001e0 <brelse>
}
80102d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d1d:	c9                   	leave  
80102d1e:	c3                   	ret    
80102d1f:	90                   	nop

80102d20 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	53                   	push   %ebx
80102d24:	83 ec 2c             	sub    $0x2c,%esp
80102d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102d2a:	68 a0 7a 10 80       	push   $0x80107aa0
80102d2f:	68 80 36 11 80       	push   $0x80113680
80102d34:	e8 c7 16 00 00       	call   80104400 <initlock>
  readsb(dev, &sb);
80102d39:	58                   	pop    %eax
80102d3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d3d:	5a                   	pop    %edx
80102d3e:	50                   	push   %eax
80102d3f:	53                   	push   %ebx
80102d40:	e8 8b e7 ff ff       	call   801014d0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102d45:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102d48:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102d4b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102d4c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102d52:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102d58:	a3 b4 36 11 80       	mov    %eax,0x801136b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102d5d:	5a                   	pop    %edx
80102d5e:	50                   	push   %eax
80102d5f:	53                   	push   %ebx
80102d60:	e8 6b d3 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102d65:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d68:	83 c4 10             	add    $0x10,%esp
80102d6b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102d6d:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102d73:	7e 1c                	jle    80102d91 <initlog+0x71>
80102d75:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102d7c:	31 d2                	xor    %edx,%edx
80102d7e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d80:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d84:	83 c2 04             	add    $0x4,%edx
80102d87:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102d8d:	39 da                	cmp    %ebx,%edx
80102d8f:	75 ef                	jne    80102d80 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102d91:	83 ec 0c             	sub    $0xc,%esp
80102d94:	50                   	push   %eax
80102d95:	e8 46 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d9a:	e8 81 fe ff ff       	call   80102c20 <install_trans>
  log.lh.n = 0;
80102d9f:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102da6:	00 00 00 
  write_head(); // clear the log
80102da9:	e8 12 ff ff ff       	call   80102cc0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102dae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102db1:	c9                   	leave  
80102db2:	c3                   	ret    
80102db3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102dc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102dc6:	68 80 36 11 80       	push   $0x80113680
80102dcb:	e8 30 17 00 00       	call   80104500 <acquire>
80102dd0:	83 c4 10             	add    $0x10,%esp
80102dd3:	eb 18                	jmp    80102ded <begin_op+0x2d>
80102dd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102dd8:	83 ec 08             	sub    $0x8,%esp
80102ddb:	68 80 36 11 80       	push   $0x80113680
80102de0:	68 80 36 11 80       	push   $0x80113680
80102de5:	e8 86 11 00 00       	call   80103f70 <sleep>
80102dea:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102ded:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102df2:	85 c0                	test   %eax,%eax
80102df4:	75 e2                	jne    80102dd8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102df6:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102dfb:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102e01:	83 c0 01             	add    $0x1,%eax
80102e04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e0a:	83 fa 1e             	cmp    $0x1e,%edx
80102e0d:	7f c9                	jg     80102dd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e0f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102e12:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102e17:	68 80 36 11 80       	push   $0x80113680
80102e1c:	e8 ff 17 00 00       	call   80104620 <release>
      break;
    }
  }
}
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	c9                   	leave  
80102e25:	c3                   	ret    
80102e26:	8d 76 00             	lea    0x0(%esi),%esi
80102e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	57                   	push   %edi
80102e34:	56                   	push   %esi
80102e35:	53                   	push   %ebx
80102e36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e39:	68 80 36 11 80       	push   $0x80113680
80102e3e:	e8 bd 16 00 00       	call   80104500 <acquire>
  log.outstanding -= 1;
80102e43:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102e48:	8b 1d c0 36 11 80    	mov    0x801136c0,%ebx
80102e4e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102e51:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102e54:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102e56:	a3 bc 36 11 80       	mov    %eax,0x801136bc
  if(log.committing)
80102e5b:	0f 85 23 01 00 00    	jne    80102f84 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e61:	85 c0                	test   %eax,%eax
80102e63:	0f 85 f7 00 00 00    	jne    80102f60 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e69:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102e6c:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102e73:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e76:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e78:	68 80 36 11 80       	push   $0x80113680
80102e7d:	e8 9e 17 00 00       	call   80104620 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e82:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e88:	83 c4 10             	add    $0x10,%esp
80102e8b:	85 c9                	test   %ecx,%ecx
80102e8d:	0f 8e 8a 00 00 00    	jle    80102f1d <end_op+0xed>
80102e93:	90                   	nop
80102e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e98:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e9d:	83 ec 08             	sub    $0x8,%esp
80102ea0:	01 d8                	add    %ebx,%eax
80102ea2:	83 c0 01             	add    $0x1,%eax
80102ea5:	50                   	push   %eax
80102ea6:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102eac:	e8 1f d2 ff ff       	call   801000d0 <bread>
80102eb1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eb3:	58                   	pop    %eax
80102eb4:	5a                   	pop    %edx
80102eb5:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102ebc:	ff 35 c4 36 11 80    	pushl  0x801136c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ec2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ec5:	e8 06 d2 ff ff       	call   801000d0 <bread>
80102eca:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ecc:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ecf:	83 c4 0c             	add    $0xc,%esp
80102ed2:	68 00 02 00 00       	push   $0x200
80102ed7:	50                   	push   %eax
80102ed8:	8d 46 5c             	lea    0x5c(%esi),%eax
80102edb:	50                   	push   %eax
80102edc:	e8 3f 18 00 00       	call   80104720 <memmove>
    bwrite(to);  // write the log
80102ee1:	89 34 24             	mov    %esi,(%esp)
80102ee4:	e8 b7 d2 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102ee9:	89 3c 24             	mov    %edi,(%esp)
80102eec:	e8 ef d2 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102ef1:	89 34 24             	mov    %esi,(%esp)
80102ef4:	e8 e7 d2 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ef9:	83 c4 10             	add    $0x10,%esp
80102efc:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102f02:	7c 94                	jl     80102e98 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f04:	e8 b7 fd ff ff       	call   80102cc0 <write_head>
    install_trans(); // Now install writes to home locations
80102f09:	e8 12 fd ff ff       	call   80102c20 <install_trans>
    log.lh.n = 0;
80102f0e:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102f15:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f18:	e8 a3 fd ff ff       	call   80102cc0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102f1d:	83 ec 0c             	sub    $0xc,%esp
80102f20:	68 80 36 11 80       	push   $0x80113680
80102f25:	e8 d6 15 00 00       	call   80104500 <acquire>
    log.committing = 0;
    wakeup(&log);
80102f2a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102f31:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102f38:	00 00 00 
    wakeup(&log);
80102f3b:	e8 00 12 00 00       	call   80104140 <wakeup>
    release(&log.lock);
80102f40:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102f47:	e8 d4 16 00 00       	call   80104620 <release>
80102f4c:	83 c4 10             	add    $0x10,%esp
  }
}
80102f4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f52:	5b                   	pop    %ebx
80102f53:	5e                   	pop    %esi
80102f54:	5f                   	pop    %edi
80102f55:	5d                   	pop    %ebp
80102f56:	c3                   	ret    
80102f57:	89 f6                	mov    %esi,%esi
80102f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102f60:	83 ec 0c             	sub    $0xc,%esp
80102f63:	68 80 36 11 80       	push   $0x80113680
80102f68:	e8 d3 11 00 00       	call   80104140 <wakeup>
  }
  release(&log.lock);
80102f6d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102f74:	e8 a7 16 00 00       	call   80104620 <release>
80102f79:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f7f:	5b                   	pop    %ebx
80102f80:	5e                   	pop    %esi
80102f81:	5f                   	pop    %edi
80102f82:	5d                   	pop    %ebp
80102f83:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102f84:	83 ec 0c             	sub    $0xc,%esp
80102f87:	68 a4 7a 10 80       	push   $0x80107aa4
80102f8c:	e8 0f d5 ff ff       	call   801004a0 <panic>
80102f91:	eb 0d                	jmp    80102fa0 <log_write>
80102f93:	90                   	nop
80102f94:	90                   	nop
80102f95:	90                   	nop
80102f96:	90                   	nop
80102f97:	90                   	nop
80102f98:	90                   	nop
80102f99:	90                   	nop
80102f9a:	90                   	nop
80102f9b:	90                   	nop
80102f9c:	90                   	nop
80102f9d:	90                   	nop
80102f9e:	90                   	nop
80102f9f:	90                   	nop

80102fa0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	53                   	push   %ebx
80102fa4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fa7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fb0:	83 fa 1d             	cmp    $0x1d,%edx
80102fb3:	0f 8f 97 00 00 00    	jg     80103050 <log_write+0xb0>
80102fb9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102fbe:	83 e8 01             	sub    $0x1,%eax
80102fc1:	39 c2                	cmp    %eax,%edx
80102fc3:	0f 8d 87 00 00 00    	jge    80103050 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fc9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102fce:	85 c0                	test   %eax,%eax
80102fd0:	0f 8e 87 00 00 00    	jle    8010305d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fd6:	83 ec 0c             	sub    $0xc,%esp
80102fd9:	68 80 36 11 80       	push   $0x80113680
80102fde:	e8 1d 15 00 00       	call   80104500 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fe3:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102fe9:	83 c4 10             	add    $0x10,%esp
80102fec:	83 fa 00             	cmp    $0x0,%edx
80102fef:	7e 50                	jle    80103041 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102ff4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ff6:	3b 0d cc 36 11 80    	cmp    0x801136cc,%ecx
80102ffc:	75 0b                	jne    80103009 <log_write+0x69>
80102ffe:	eb 38                	jmp    80103038 <log_write+0x98>
80103000:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80103007:	74 2f                	je     80103038 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103009:	83 c0 01             	add    $0x1,%eax
8010300c:	39 d0                	cmp    %edx,%eax
8010300e:	75 f0                	jne    80103000 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103010:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103017:	83 c2 01             	add    $0x1,%edx
8010301a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80103020:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103023:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
8010302a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010302d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010302e:	e9 ed 15 00 00       	jmp    80104620 <release>
80103033:	90                   	nop
80103034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103038:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
8010303f:	eb df                	jmp    80103020 <log_write+0x80>
80103041:	8b 43 08             	mov    0x8(%ebx),%eax
80103044:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103049:	75 d5                	jne    80103020 <log_write+0x80>
8010304b:	eb ca                	jmp    80103017 <log_write+0x77>
8010304d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103050:	83 ec 0c             	sub    $0xc,%esp
80103053:	68 b3 7a 10 80       	push   $0x80107ab3
80103058:	e8 43 d4 ff ff       	call   801004a0 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010305d:	83 ec 0c             	sub    $0xc,%esp
80103060:	68 c9 7a 10 80       	push   $0x80107ac9
80103065:	e8 36 d4 ff ff       	call   801004a0 <panic>
8010306a:	66 90                	xchg   %ax,%ax
8010306c:	66 90                	xchg   %ax,%ax
8010306e:	66 90                	xchg   %ax,%ax

80103070 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	53                   	push   %ebx
80103074:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103077:	e8 54 09 00 00       	call   801039d0 <cpuid>
8010307c:	89 c3                	mov    %eax,%ebx
8010307e:	e8 4d 09 00 00       	call   801039d0 <cpuid>
80103083:	83 ec 04             	sub    $0x4,%esp
80103086:	53                   	push   %ebx
80103087:	50                   	push   %eax
80103088:	68 e4 7a 10 80       	push   $0x80107ae4
8010308d:	e8 fe d6 ff ff       	call   80100790 <cprintf>
  idtinit();       // load idt register
80103092:	e8 f9 28 00 00       	call   80105990 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103097:	e8 b4 08 00 00       	call   80103950 <mycpu>
8010309c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010309e:	b8 01 00 00 00       	mov    $0x1,%eax
801030a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030aa:	e8 d1 0b 00 00       	call   80103c80 <scheduler>
801030af:	90                   	nop

801030b0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030b6:	e8 d5 3c 00 00       	call   80106d90 <switchkvm>
  seginit();
801030bb:	e8 d0 3b 00 00       	call   80106c90 <seginit>
  lapicinit();
801030c0:	e8 9b f7 ff ff       	call   80102860 <lapicinit>
  mpmain();
801030c5:	e8 a6 ff ff ff       	call   80103070 <mpmain>
801030ca:	66 90                	xchg   %ax,%ax
801030cc:	66 90                	xchg   %ax,%ax
801030ce:	66 90                	xchg   %ax,%ax

801030d0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801030d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030d4:	83 e4 f0             	and    $0xfffffff0,%esp
801030d7:	ff 71 fc             	pushl  -0x4(%ecx)
801030da:	55                   	push   %ebp
801030db:	89 e5                	mov    %esp,%ebp
801030dd:	53                   	push   %ebx
801030de:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801030df:	bb 80 37 11 80       	mov    $0x80113780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030e4:	83 ec 08             	sub    $0x8,%esp
801030e7:	68 00 00 40 80       	push   $0x80400000
801030ec:	68 a8 64 11 80       	push   $0x801164a8
801030f1:	e8 3a f5 ff ff       	call   80102630 <kinit1>
  kvmalloc();      // kernel page table
801030f6:	e8 35 41 00 00       	call   80107230 <kvmalloc>
  mpinit();        // detect other processors
801030fb:	e8 70 01 00 00       	call   80103270 <mpinit>
  lapicinit();     // interrupt controller
80103100:	e8 5b f7 ff ff       	call   80102860 <lapicinit>
  seginit();       // segment descriptors
80103105:	e8 86 3b 00 00       	call   80106c90 <seginit>
  picinit();       // disable pic
8010310a:	e8 31 03 00 00       	call   80103440 <picinit>
  ioapicinit();    // another interrupt controller
8010310f:	e8 4c f3 ff ff       	call   80102460 <ioapicinit>
  consoleinit();   // console hardware
80103114:	e8 b7 d9 ff ff       	call   80100ad0 <consoleinit>
  uartinit();      // serial port
80103119:	e8 02 2e 00 00       	call   80105f20 <uartinit>
  pinit();         // process table
8010311e:	e8 0d 08 00 00       	call   80103930 <pinit>
  tvinit();        // trap vectors
80103123:	e8 c8 27 00 00       	call   801058f0 <tvinit>
  binit();         // buffer cache
80103128:	e8 13 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010312d:	e8 4e dd ff ff       	call   80100e80 <fileinit>
  ideinit();       // disk 
80103132:	e8 09 f1 ff ff       	call   80102240 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103137:	83 c4 0c             	add    $0xc,%esp
8010313a:	68 8a 00 00 00       	push   $0x8a
8010313f:	68 8c b4 10 80       	push   $0x8010b48c
80103144:	68 00 70 00 80       	push   $0x80007000
80103149:	e8 d2 15 00 00       	call   80104720 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010314e:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103155:	00 00 00 
80103158:	83 c4 10             	add    $0x10,%esp
8010315b:	05 80 37 11 80       	add    $0x80113780,%eax
80103160:	39 d8                	cmp    %ebx,%eax
80103162:	76 6f                	jbe    801031d3 <main+0x103>
80103164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103168:	e8 e3 07 00 00       	call   80103950 <mycpu>
8010316d:	39 d8                	cmp    %ebx,%eax
8010316f:	74 49                	je     801031ba <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103171:	e8 8a f5 ff ff       	call   80102700 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103176:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
8010317b:	c7 05 f8 6f 00 80 b0 	movl   $0x801030b0,0x80006ff8
80103182:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103185:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010318c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010318f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103194:	0f b6 03             	movzbl (%ebx),%eax
80103197:	83 ec 08             	sub    $0x8,%esp
8010319a:	68 00 70 00 00       	push   $0x7000
8010319f:	50                   	push   %eax
801031a0:	e8 0b f8 ff ff       	call   801029b0 <lapicstartap>
801031a5:	83 c4 10             	add    $0x10,%esp
801031a8:	90                   	nop
801031a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031b6:	85 c0                	test   %eax,%eax
801031b8:	74 f6                	je     801031b0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801031ba:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801031c1:	00 00 00 
801031c4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031ca:	05 80 37 11 80       	add    $0x80113780,%eax
801031cf:	39 c3                	cmp    %eax,%ebx
801031d1:	72 95                	jb     80103168 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031d3:	83 ec 08             	sub    $0x8,%esp
801031d6:	68 00 00 40 80       	push   $0x80400000
801031db:	68 00 00 40 80       	push   $0x80400000
801031e0:	e8 bb f4 ff ff       	call   801026a0 <kinit2>
  userinit();      // first user process
801031e5:	e8 36 08 00 00       	call   80103a20 <userinit>
  mpmain();        // finish this processor's setup
801031ea:	e8 81 fe ff ff       	call   80103070 <mpmain>
801031ef:	90                   	nop

801031f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031fb:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801031fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031ff:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103202:	39 de                	cmp    %ebx,%esi
80103204:	73 48                	jae    8010324e <mpsearch1+0x5e>
80103206:	8d 76 00             	lea    0x0(%esi),%esi
80103209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103210:	83 ec 04             	sub    $0x4,%esp
80103213:	8d 7e 10             	lea    0x10(%esi),%edi
80103216:	6a 04                	push   $0x4
80103218:	68 f8 7a 10 80       	push   $0x80107af8
8010321d:	56                   	push   %esi
8010321e:	e8 9d 14 00 00       	call   801046c0 <memcmp>
80103223:	83 c4 10             	add    $0x10,%esp
80103226:	85 c0                	test   %eax,%eax
80103228:	75 1e                	jne    80103248 <mpsearch1+0x58>
8010322a:	8d 7e 10             	lea    0x10(%esi),%edi
8010322d:	89 f2                	mov    %esi,%edx
8010322f:	31 c9                	xor    %ecx,%ecx
80103231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103238:	0f b6 02             	movzbl (%edx),%eax
8010323b:	83 c2 01             	add    $0x1,%edx
8010323e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103240:	39 fa                	cmp    %edi,%edx
80103242:	75 f4                	jne    80103238 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103244:	84 c9                	test   %cl,%cl
80103246:	74 10                	je     80103258 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103248:	39 fb                	cmp    %edi,%ebx
8010324a:	89 fe                	mov    %edi,%esi
8010324c:	77 c2                	ja     80103210 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010324e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103251:	31 c0                	xor    %eax,%eax
}
80103253:	5b                   	pop    %ebx
80103254:	5e                   	pop    %esi
80103255:	5f                   	pop    %edi
80103256:	5d                   	pop    %ebp
80103257:	c3                   	ret    
80103258:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325b:	89 f0                	mov    %esi,%eax
8010325d:	5b                   	pop    %ebx
8010325e:	5e                   	pop    %esi
8010325f:	5f                   	pop    %edi
80103260:	5d                   	pop    %ebp
80103261:	c3                   	ret    
80103262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103270 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103279:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103280:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103287:	c1 e0 08             	shl    $0x8,%eax
8010328a:	09 d0                	or     %edx,%eax
8010328c:	c1 e0 04             	shl    $0x4,%eax
8010328f:	85 c0                	test   %eax,%eax
80103291:	75 1b                	jne    801032ae <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103293:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010329a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032a1:	c1 e0 08             	shl    $0x8,%eax
801032a4:	09 d0                	or     %edx,%eax
801032a6:	c1 e0 0a             	shl    $0xa,%eax
801032a9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801032ae:	ba 00 04 00 00       	mov    $0x400,%edx
801032b3:	e8 38 ff ff ff       	call   801031f0 <mpsearch1>
801032b8:	85 c0                	test   %eax,%eax
801032ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032bd:	0f 84 37 01 00 00    	je     801033fa <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032c6:	8b 58 04             	mov    0x4(%eax),%ebx
801032c9:	85 db                	test   %ebx,%ebx
801032cb:	0f 84 43 01 00 00    	je     80103414 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032d1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801032d7:	83 ec 04             	sub    $0x4,%esp
801032da:	6a 04                	push   $0x4
801032dc:	68 fd 7a 10 80       	push   $0x80107afd
801032e1:	56                   	push   %esi
801032e2:	e8 d9 13 00 00       	call   801046c0 <memcmp>
801032e7:	83 c4 10             	add    $0x10,%esp
801032ea:	85 c0                	test   %eax,%eax
801032ec:	0f 85 22 01 00 00    	jne    80103414 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801032f2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032f9:	3c 01                	cmp    $0x1,%al
801032fb:	74 08                	je     80103305 <mpinit+0x95>
801032fd:	3c 04                	cmp    $0x4,%al
801032ff:	0f 85 0f 01 00 00    	jne    80103414 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103305:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010330c:	85 ff                	test   %edi,%edi
8010330e:	74 21                	je     80103331 <mpinit+0xc1>
80103310:	31 d2                	xor    %edx,%edx
80103312:	31 c0                	xor    %eax,%eax
80103314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103318:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010331f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103320:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103323:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103325:	39 c7                	cmp    %eax,%edi
80103327:	75 ef                	jne    80103318 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103329:	84 d2                	test   %dl,%dl
8010332b:	0f 85 e3 00 00 00    	jne    80103414 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103331:	85 f6                	test   %esi,%esi
80103333:	0f 84 db 00 00 00    	je     80103414 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103339:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010333f:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103344:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010334b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103351:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103356:	01 d6                	add    %edx,%esi
80103358:	90                   	nop
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103360:	39 c6                	cmp    %eax,%esi
80103362:	76 23                	jbe    80103387 <mpinit+0x117>
80103364:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103367:	80 fa 04             	cmp    $0x4,%dl
8010336a:	0f 87 c0 00 00 00    	ja     80103430 <mpinit+0x1c0>
80103370:	ff 24 95 3c 7b 10 80 	jmp    *-0x7fef84c4(,%edx,4)
80103377:	89 f6                	mov    %esi,%esi
80103379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103380:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103383:	39 c6                	cmp    %eax,%esi
80103385:	77 dd                	ja     80103364 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103387:	85 db                	test   %ebx,%ebx
80103389:	0f 84 92 00 00 00    	je     80103421 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010338f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103392:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103396:	74 15                	je     801033ad <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103398:	ba 22 00 00 00       	mov    $0x22,%edx
8010339d:	b8 70 00 00 00       	mov    $0x70,%eax
801033a2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033a3:	ba 23 00 00 00       	mov    $0x23,%edx
801033a8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033a9:	83 c8 01             	or     $0x1,%eax
801033ac:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801033ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033b0:	5b                   	pop    %ebx
801033b1:	5e                   	pop    %esi
801033b2:	5f                   	pop    %edi
801033b3:	5d                   	pop    %ebp
801033b4:	c3                   	ret    
801033b5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801033b8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801033be:	83 f9 07             	cmp    $0x7,%ecx
801033c1:	7f 19                	jg     801033dc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033c3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801033c7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801033cd:	83 c1 01             	add    $0x1,%ecx
801033d0:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033d6:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801033dc:	83 c0 14             	add    $0x14,%eax
      continue;
801033df:	e9 7c ff ff ff       	jmp    80103360 <mpinit+0xf0>
801033e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801033e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801033ec:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801033ef:	88 15 60 37 11 80    	mov    %dl,0x80113760
      p += sizeof(struct mpioapic);
      continue;
801033f5:	e9 66 ff ff ff       	jmp    80103360 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801033fa:	ba 00 00 01 00       	mov    $0x10000,%edx
801033ff:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103404:	e8 e7 fd ff ff       	call   801031f0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103409:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010340b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010340e:	0f 85 af fe ff ff    	jne    801032c3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103414:	83 ec 0c             	sub    $0xc,%esp
80103417:	68 02 7b 10 80       	push   $0x80107b02
8010341c:	e8 7f d0 ff ff       	call   801004a0 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103421:	83 ec 0c             	sub    $0xc,%esp
80103424:	68 1c 7b 10 80       	push   $0x80107b1c
80103429:	e8 72 d0 ff ff       	call   801004a0 <panic>
8010342e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103430:	31 db                	xor    %ebx,%ebx
80103432:	e9 30 ff ff ff       	jmp    80103367 <mpinit+0xf7>
80103437:	66 90                	xchg   %ax,%ax
80103439:	66 90                	xchg   %ax,%ax
8010343b:	66 90                	xchg   %ax,%ax
8010343d:	66 90                	xchg   %ax,%ax
8010343f:	90                   	nop

80103440 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103440:	55                   	push   %ebp
80103441:	ba 21 00 00 00       	mov    $0x21,%edx
80103446:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010344b:	89 e5                	mov    %esp,%ebp
8010344d:	ee                   	out    %al,(%dx)
8010344e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103453:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103454:	5d                   	pop    %ebp
80103455:	c3                   	ret    
80103456:	66 90                	xchg   %ax,%ax
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	8b 75 08             	mov    0x8(%ebp),%esi
8010346c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010346f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103475:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010347b:	e8 20 da ff ff       	call   80100ea0 <filealloc>
80103480:	85 c0                	test   %eax,%eax
80103482:	89 06                	mov    %eax,(%esi)
80103484:	0f 84 a8 00 00 00    	je     80103532 <pipealloc+0xd2>
8010348a:	e8 11 da ff ff       	call   80100ea0 <filealloc>
8010348f:	85 c0                	test   %eax,%eax
80103491:	89 03                	mov    %eax,(%ebx)
80103493:	0f 84 87 00 00 00    	je     80103520 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103499:	e8 62 f2 ff ff       	call   80102700 <kalloc>
8010349e:	85 c0                	test   %eax,%eax
801034a0:	89 c7                	mov    %eax,%edi
801034a2:	0f 84 b0 00 00 00    	je     80103558 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034a8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801034ab:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034b2:	00 00 00 
  p->writeopen = 1;
801034b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034bc:	00 00 00 
  p->nwrite = 0;
801034bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034c6:	00 00 00 
  p->nread = 0;
801034c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034d0:	00 00 00 
  initlock(&p->lock, "pipe");
801034d3:	68 50 7b 10 80       	push   $0x80107b50
801034d8:	50                   	push   %eax
801034d9:	e8 22 0f 00 00       	call   80104400 <initlock>
  (*f0)->type = FD_PIPE;
801034de:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034e0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801034e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034e9:	8b 06                	mov    (%esi),%eax
801034eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034ef:	8b 06                	mov    (%esi),%eax
801034f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034f5:	8b 06                	mov    (%esi),%eax
801034f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034fa:	8b 03                	mov    (%ebx),%eax
801034fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103502:	8b 03                	mov    (%ebx),%eax
80103504:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103508:	8b 03                	mov    (%ebx),%eax
8010350a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010350e:	8b 03                	mov    (%ebx),%eax
80103510:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103513:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103516:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103518:	5b                   	pop    %ebx
80103519:	5e                   	pop    %esi
8010351a:	5f                   	pop    %edi
8010351b:	5d                   	pop    %ebp
8010351c:	c3                   	ret    
8010351d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103520:	8b 06                	mov    (%esi),%eax
80103522:	85 c0                	test   %eax,%eax
80103524:	74 1e                	je     80103544 <pipealloc+0xe4>
    fileclose(*f0);
80103526:	83 ec 0c             	sub    $0xc,%esp
80103529:	50                   	push   %eax
8010352a:	e8 31 da ff ff       	call   80100f60 <fileclose>
8010352f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103532:	8b 03                	mov    (%ebx),%eax
80103534:	85 c0                	test   %eax,%eax
80103536:	74 0c                	je     80103544 <pipealloc+0xe4>
    fileclose(*f1);
80103538:	83 ec 0c             	sub    $0xc,%esp
8010353b:	50                   	push   %eax
8010353c:	e8 1f da ff ff       	call   80100f60 <fileclose>
80103541:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103544:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010354c:	5b                   	pop    %ebx
8010354d:	5e                   	pop    %esi
8010354e:	5f                   	pop    %edi
8010354f:	5d                   	pop    %ebp
80103550:	c3                   	ret    
80103551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103558:	8b 06                	mov    (%esi),%eax
8010355a:	85 c0                	test   %eax,%eax
8010355c:	75 c8                	jne    80103526 <pipealloc+0xc6>
8010355e:	eb d2                	jmp    80103532 <pipealloc+0xd2>

80103560 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	56                   	push   %esi
80103564:	53                   	push   %ebx
80103565:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103568:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	53                   	push   %ebx
8010356f:	e8 8c 0f 00 00       	call   80104500 <acquire>
  if(writable){
80103574:	83 c4 10             	add    $0x10,%esp
80103577:	85 f6                	test   %esi,%esi
80103579:	74 45                	je     801035c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010357b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103581:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103584:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010358b:	00 00 00 
    wakeup(&p->nread);
8010358e:	50                   	push   %eax
8010358f:	e8 ac 0b 00 00       	call   80104140 <wakeup>
80103594:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103597:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010359d:	85 d2                	test   %edx,%edx
8010359f:	75 0a                	jne    801035ab <pipeclose+0x4b>
801035a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035a7:	85 c0                	test   %eax,%eax
801035a9:	74 35                	je     801035e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b1:	5b                   	pop    %ebx
801035b2:	5e                   	pop    %esi
801035b3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035b4:	e9 67 10 00 00       	jmp    80104620 <release>
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801035c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035c6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 67 0b 00 00       	call   80104140 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb b9                	jmp    80103597 <pipeclose+0x37>
801035de:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	53                   	push   %ebx
801035e4:	e8 37 10 00 00       	call   80104620 <release>
    kfree((char*)p);
801035e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ec:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801035ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035f2:	5b                   	pop    %ebx
801035f3:	5e                   	pop    %esi
801035f4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801035f5:	e9 56 ef ff ff       	jmp    80102550 <kfree>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103600 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	57                   	push   %edi
80103604:	56                   	push   %esi
80103605:	53                   	push   %ebx
80103606:	83 ec 28             	sub    $0x28,%esp
80103609:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010360c:	53                   	push   %ebx
8010360d:	e8 ee 0e 00 00       	call   80104500 <acquire>
  for(i = 0; i < n; i++){
80103612:	8b 45 10             	mov    0x10(%ebp),%eax
80103615:	83 c4 10             	add    $0x10,%esp
80103618:	85 c0                	test   %eax,%eax
8010361a:	0f 8e b9 00 00 00    	jle    801036d9 <pipewrite+0xd9>
80103620:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103623:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103629:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010362f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103635:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103638:	03 4d 10             	add    0x10(%ebp),%ecx
8010363b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010363e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103644:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010364a:	39 d0                	cmp    %edx,%eax
8010364c:	74 38                	je     80103686 <pipewrite+0x86>
8010364e:	eb 59                	jmp    801036a9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103650:	e8 9b 03 00 00       	call   801039f0 <myproc>
80103655:	8b 48 24             	mov    0x24(%eax),%ecx
80103658:	85 c9                	test   %ecx,%ecx
8010365a:	75 34                	jne    80103690 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010365c:	83 ec 0c             	sub    $0xc,%esp
8010365f:	57                   	push   %edi
80103660:	e8 db 0a 00 00       	call   80104140 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103665:	58                   	pop    %eax
80103666:	5a                   	pop    %edx
80103667:	53                   	push   %ebx
80103668:	56                   	push   %esi
80103669:	e8 02 09 00 00       	call   80103f70 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010366e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103674:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	05 00 02 00 00       	add    $0x200,%eax
80103682:	39 c2                	cmp    %eax,%edx
80103684:	75 2a                	jne    801036b0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103686:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010368c:	85 c0                	test   %eax,%eax
8010368e:	75 c0                	jne    80103650 <pipewrite+0x50>
        release(&p->lock);
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	53                   	push   %ebx
80103694:	e8 87 0f 00 00       	call   80104620 <release>
        return -1;
80103699:	83 c4 10             	add    $0x10,%esp
8010369c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036a4:	5b                   	pop    %ebx
801036a5:	5e                   	pop    %esi
801036a6:	5f                   	pop    %edi
801036a7:	5d                   	pop    %ebp
801036a8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a9:	89 c2                	mov    %eax,%edx
801036ab:	90                   	nop
801036ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801036b3:	8d 42 01             	lea    0x1(%edx),%eax
801036b6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801036ba:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036c0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036c6:	0f b6 09             	movzbl (%ecx),%ecx
801036c9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801036cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801036d0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801036d3:	0f 85 65 ff ff ff    	jne    8010363e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036df:	83 ec 0c             	sub    $0xc,%esp
801036e2:	50                   	push   %eax
801036e3:	e8 58 0a 00 00       	call   80104140 <wakeup>
  release(&p->lock);
801036e8:	89 1c 24             	mov    %ebx,(%esp)
801036eb:	e8 30 0f 00 00       	call   80104620 <release>
  return n;
801036f0:	83 c4 10             	add    $0x10,%esp
801036f3:	8b 45 10             	mov    0x10(%ebp),%eax
801036f6:	eb a9                	jmp    801036a1 <pipewrite+0xa1>
801036f8:	90                   	nop
801036f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103700 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	57                   	push   %edi
80103704:	56                   	push   %esi
80103705:	53                   	push   %ebx
80103706:	83 ec 18             	sub    $0x18,%esp
80103709:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010370c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010370f:	53                   	push   %ebx
80103710:	e8 eb 0d 00 00       	call   80104500 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010371e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103724:	75 6a                	jne    80103790 <piperead+0x90>
80103726:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010372c:	85 f6                	test   %esi,%esi
8010372e:	0f 84 cc 00 00 00    	je     80103800 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103734:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010373a:	eb 2d                	jmp    80103769 <piperead+0x69>
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103740:	83 ec 08             	sub    $0x8,%esp
80103743:	53                   	push   %ebx
80103744:	56                   	push   %esi
80103745:	e8 26 08 00 00       	call   80103f70 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374a:	83 c4 10             	add    $0x10,%esp
8010374d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103753:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103759:	75 35                	jne    80103790 <piperead+0x90>
8010375b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103761:	85 d2                	test   %edx,%edx
80103763:	0f 84 97 00 00 00    	je     80103800 <piperead+0x100>
    if(myproc()->killed){
80103769:	e8 82 02 00 00       	call   801039f0 <myproc>
8010376e:	8b 48 24             	mov    0x24(%eax),%ecx
80103771:	85 c9                	test   %ecx,%ecx
80103773:	74 cb                	je     80103740 <piperead+0x40>
      release(&p->lock);
80103775:	83 ec 0c             	sub    $0xc,%esp
80103778:	53                   	push   %ebx
80103779:	e8 a2 0e 00 00       	call   80104620 <release>
      return -1;
8010377e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103781:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103789:	5b                   	pop    %ebx
8010378a:	5e                   	pop    %esi
8010378b:	5f                   	pop    %edi
8010378c:	5d                   	pop    %ebp
8010378d:	c3                   	ret    
8010378e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103790:	8b 45 10             	mov    0x10(%ebp),%eax
80103793:	85 c0                	test   %eax,%eax
80103795:	7e 69                	jle    80103800 <piperead+0x100>
    if(p->nread == p->nwrite)
80103797:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010379d:	31 c9                	xor    %ecx,%ecx
8010379f:	eb 15                	jmp    801037b6 <piperead+0xb6>
801037a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037a8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801037ae:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801037b4:	74 5a                	je     80103810 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037b6:	8d 70 01             	lea    0x1(%eax),%esi
801037b9:	25 ff 01 00 00       	and    $0x1ff,%eax
801037be:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801037c4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801037c9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037cc:	83 c1 01             	add    $0x1,%ecx
801037cf:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801037d2:	75 d4                	jne    801037a8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037d4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801037da:	83 ec 0c             	sub    $0xc,%esp
801037dd:	50                   	push   %eax
801037de:	e8 5d 09 00 00       	call   80104140 <wakeup>
  release(&p->lock);
801037e3:	89 1c 24             	mov    %ebx,(%esp)
801037e6:	e8 35 0e 00 00       	call   80104620 <release>
  return i;
801037eb:	8b 45 10             	mov    0x10(%ebp),%eax
801037ee:	83 c4 10             	add    $0x10,%esp
}
801037f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037f4:	5b                   	pop    %ebx
801037f5:	5e                   	pop    %esi
801037f6:	5f                   	pop    %edi
801037f7:	5d                   	pop    %ebp
801037f8:	c3                   	ret    
801037f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103800:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103807:	eb cb                	jmp    801037d4 <piperead+0xd4>
80103809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103810:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103813:	eb bf                	jmp    801037d4 <piperead+0xd4>
80103815:	66 90                	xchg   %ax,%ax
80103817:	66 90                	xchg   %ax,%ax
80103819:	66 90                	xchg   %ax,%ax
8010381b:	66 90                	xchg   %ax,%ax
8010381d:	66 90                	xchg   %ax,%ax
8010381f:	90                   	nop

80103820 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103824:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103829:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010382c:	68 20 3d 11 80       	push   $0x80113d20
80103831:	e8 ca 0c 00 00       	call   80104500 <acquire>
80103836:	83 c4 10             	add    $0x10,%esp
80103839:	eb 10                	jmp    8010384b <allocproc+0x2b>
8010383b:	90                   	nop
8010383c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103840:	83 c3 7c             	add    $0x7c,%ebx
80103843:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103849:	74 75                	je     801038c0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010384b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010384e:	85 c0                	test   %eax,%eax
80103850:	75 ee                	jne    80103840 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103852:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103857:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
8010385a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103861:	68 20 3d 11 80       	push   $0x80113d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103866:	8d 50 01             	lea    0x1(%eax),%edx
80103869:	89 43 10             	mov    %eax,0x10(%ebx)
8010386c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

  release(&ptable.lock);
80103872:	e8 a9 0d 00 00       	call   80104620 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103877:	e8 84 ee ff ff       	call   80102700 <kalloc>
8010387c:	83 c4 10             	add    $0x10,%esp
8010387f:	85 c0                	test   %eax,%eax
80103881:	89 43 08             	mov    %eax,0x8(%ebx)
80103884:	74 51                	je     801038d7 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103886:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010388c:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010388f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103894:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103897:	c7 40 14 e2 58 10 80 	movl   $0x801058e2,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010389e:	6a 14                	push   $0x14
801038a0:	6a 00                	push   $0x0
801038a2:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801038a3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038a6:	e8 c5 0d 00 00       	call   80104670 <memset>
  p->context->eip = (uint)forkret;
801038ab:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038ae:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801038b1:	c7 40 10 e0 38 10 80 	movl   $0x801038e0,0x10(%eax)

  return p;
801038b8:	89 d8                	mov    %ebx,%eax
}
801038ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038bd:	c9                   	leave  
801038be:	c3                   	ret    
801038bf:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
801038c0:	83 ec 0c             	sub    $0xc,%esp
801038c3:	68 20 3d 11 80       	push   $0x80113d20
801038c8:	e8 53 0d 00 00       	call   80104620 <release>
  return 0;
801038cd:	83 c4 10             	add    $0x10,%esp
801038d0:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801038d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d5:	c9                   	leave  
801038d6:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801038d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038de:	eb da                	jmp    801038ba <allocproc+0x9a>

801038e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038e6:	68 20 3d 11 80       	push   $0x80113d20
801038eb:	e8 30 0d 00 00       	call   80104620 <release>

  if (first) {
801038f0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	85 c0                	test   %eax,%eax
801038fa:	75 04                	jne    80103900 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038fc:	c9                   	leave  
801038fd:	c3                   	ret    
801038fe:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103900:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103903:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010390a:	00 00 00 
    iinit(ROOTDEV);
8010390d:	6a 01                	push   $0x1
8010390f:	e8 cc dd ff ff       	call   801016e0 <iinit>
    initlog(ROOTDEV);
80103914:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010391b:	e8 00 f4 ff ff       	call   80102d20 <initlog>
80103920:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103923:	c9                   	leave  
80103924:	c3                   	ret    
80103925:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103930 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103936:	68 55 7b 10 80       	push   $0x80107b55
8010393b:	68 20 3d 11 80       	push   $0x80113d20
80103940:	e8 bb 0a 00 00       	call   80104400 <initlock>
}
80103945:	83 c4 10             	add    $0x10,%esp
80103948:	c9                   	leave  
80103949:	c3                   	ret    
8010394a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103950 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	56                   	push   %esi
80103954:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103955:	9c                   	pushf  
80103956:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103957:	f6 c4 02             	test   $0x2,%ah
8010395a:	75 5b                	jne    801039b7 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010395c:	e8 ff ef ff ff       	call   80102960 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103961:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103967:	85 f6                	test   %esi,%esi
80103969:	7e 3f                	jle    801039aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010396b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103972:	39 d0                	cmp    %edx,%eax
80103974:	74 30                	je     801039a6 <mycpu+0x56>
80103976:	b9 30 38 11 80       	mov    $0x80113830,%ecx
8010397b:	31 d2                	xor    %edx,%edx
8010397d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103980:	83 c2 01             	add    $0x1,%edx
80103983:	39 f2                	cmp    %esi,%edx
80103985:	74 23                	je     801039aa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103987:	0f b6 19             	movzbl (%ecx),%ebx
8010398a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103990:	39 d8                	cmp    %ebx,%eax
80103992:	75 ec                	jne    80103980 <mycpu+0x30>
      return &cpus[i];
80103994:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010399a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010399d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010399e:	05 80 37 11 80       	add    $0x80113780,%eax
  }
  panic("unknown apicid\n");
}
801039a3:	5e                   	pop    %esi
801039a4:	5d                   	pop    %ebp
801039a5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801039a6:	31 d2                	xor    %edx,%edx
801039a8:	eb ea                	jmp    80103994 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801039aa:	83 ec 0c             	sub    $0xc,%esp
801039ad:	68 5c 7b 10 80       	push   $0x80107b5c
801039b2:	e8 e9 ca ff ff       	call   801004a0 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
801039b7:	83 ec 0c             	sub    $0xc,%esp
801039ba:	68 38 7c 10 80       	push   $0x80107c38
801039bf:	e8 dc ca ff ff       	call   801004a0 <panic>
801039c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039d0 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039d6:	e8 75 ff ff ff       	call   80103950 <mycpu>
801039db:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
801039e0:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
801039e1:	c1 f8 04             	sar    $0x4,%eax
801039e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ea:	c3                   	ret    
801039eb:	90                   	nop
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039f0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	53                   	push   %ebx
801039f4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801039f7:	e8 c4 0a 00 00       	call   801044c0 <pushcli>
  c = mycpu();
801039fc:	e8 4f ff ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103a01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a07:	e8 a4 0b 00 00       	call   801045b0 <popcli>
  return p;
}
80103a0c:	83 c4 04             	add    $0x4,%esp
80103a0f:	89 d8                	mov    %ebx,%eax
80103a11:	5b                   	pop    %ebx
80103a12:	5d                   	pop    %ebp
80103a13:	c3                   	ret    
80103a14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a20 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	53                   	push   %ebx
80103a24:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103a27:	e8 f4 fd ff ff       	call   80103820 <allocproc>
80103a2c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103a2e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a33:	e8 78 37 00 00       	call   801071b0 <setupkvm>
80103a38:	85 c0                	test   %eax,%eax
80103a3a:	89 43 04             	mov    %eax,0x4(%ebx)
80103a3d:	0f 84 bd 00 00 00    	je     80103b00 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a43:	83 ec 04             	sub    $0x4,%esp
80103a46:	68 2c 00 00 00       	push   $0x2c
80103a4b:	68 60 b4 10 80       	push   $0x8010b460
80103a50:	50                   	push   %eax
80103a51:	e8 6a 34 00 00       	call   80106ec0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103a56:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103a59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a5f:	6a 4c                	push   $0x4c
80103a61:	6a 00                	push   $0x0
80103a63:	ff 73 18             	pushl  0x18(%ebx)
80103a66:	e8 05 0c 00 00       	call   80104670 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a73:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a78:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a86:	8b 43 18             	mov    0x18(%ebx),%eax
80103a89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a8d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a91:	8b 43 18             	mov    0x18(%ebx),%eax
80103a94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a98:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a9c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103aa6:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ab0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103aba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103abd:	6a 10                	push   $0x10
80103abf:	68 85 7b 10 80       	push   $0x80107b85
80103ac4:	50                   	push   %eax
80103ac5:	e8 a6 0d 00 00       	call   80104870 <safestrcpy>
  p->cwd = namei("/");
80103aca:	c7 04 24 8e 7b 10 80 	movl   $0x80107b8e,(%esp)
80103ad1:	e8 5a e6 ff ff       	call   80102130 <namei>
80103ad6:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103ad9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ae0:	e8 1b 0a 00 00       	call   80104500 <acquire>

  p->state = RUNNABLE;
80103ae5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103aec:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103af3:	e8 28 0b 00 00       	call   80104620 <release>
}
80103af8:	83 c4 10             	add    $0x10,%esp
80103afb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103afe:	c9                   	leave  
80103aff:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103b00:	83 ec 0c             	sub    $0xc,%esp
80103b03:	68 6c 7b 10 80       	push   $0x80107b6c
80103b08:	e8 93 c9 ff ff       	call   801004a0 <panic>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi

80103b10 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx
80103b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b18:	e8 a3 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103b1d:	e8 2e fe ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b22:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103b28:	e8 83 0a 00 00       	call   801045b0 <popcli>
int
growproc(int n)
{
  struct proc *curproc = myproc();

  if (n < 0 || n > KERNBASE || curproc->sz + n > KERNBASE)
80103b2d:	89 d8                	mov    %ebx,%eax
80103b2f:	c1 e8 1f             	shr    $0x1f,%eax
80103b32:	84 c0                	test   %al,%al
80103b34:	75 1a                	jne    80103b50 <growproc+0x40>
80103b36:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103b3c:	77 12                	ja     80103b50 <growproc+0x40>
80103b3e:	03 1e                	add    (%esi),%ebx
80103b40:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80103b46:	77 08                	ja     80103b50 <growproc+0x40>
	  return -1;
  curproc->sz += n;
80103b48:	89 1e                	mov    %ebx,(%esi)
  return 0;
80103b4a:	31 c0                	xor    %eax,%eax
}
80103b4c:	5b                   	pop    %ebx
80103b4d:	5e                   	pop    %esi
80103b4e:	5d                   	pop    %ebp
80103b4f:	c3                   	ret    
growproc(int n)
{
  struct proc *curproc = myproc();

  if (n < 0 || n > KERNBASE || curproc->sz + n > KERNBASE)
	  return -1;
80103b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b55:	eb f5                	jmp    80103b4c <growproc+0x3c>
80103b57:	89 f6                	mov    %esi,%esi
80103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b60 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	57                   	push   %edi
80103b64:	56                   	push   %esi
80103b65:	53                   	push   %ebx
80103b66:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b69:	e8 52 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103b6e:	e8 dd fd ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103b73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b79:	e8 32 0a 00 00       	call   801045b0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103b7e:	e8 9d fc ff ff       	call   80103820 <allocproc>
80103b83:	85 c0                	test   %eax,%eax
80103b85:	89 c7                	mov    %eax,%edi
80103b87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b8a:	0f 84 b5 00 00 00    	je     80103c45 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b90:	83 ec 08             	sub    $0x8,%esp
80103b93:	ff 33                	pushl  (%ebx)
80103b95:	ff 73 04             	pushl  0x4(%ebx)
80103b98:	e8 e3 37 00 00       	call   80107380 <copyuvm>
80103b9d:	83 c4 10             	add    $0x10,%esp
80103ba0:	85 c0                	test   %eax,%eax
80103ba2:	89 47 04             	mov    %eax,0x4(%edi)
80103ba5:	0f 84 a1 00 00 00    	je     80103c4c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103bab:	8b 03                	mov    (%ebx),%eax
80103bad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103bb0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103bb2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103bb5:	89 c8                	mov    %ecx,%eax
80103bb7:	8b 79 18             	mov    0x18(%ecx),%edi
80103bba:	8b 73 18             	mov    0x18(%ebx),%esi
80103bbd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103bc2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103bc4:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103bc6:	8b 40 18             	mov    0x18(%eax),%eax
80103bc9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103bd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bd4:	85 c0                	test   %eax,%eax
80103bd6:	74 13                	je     80103beb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bd8:	83 ec 0c             	sub    $0xc,%esp
80103bdb:	50                   	push   %eax
80103bdc:	e8 2f d3 ff ff       	call   80100f10 <filedup>
80103be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103be4:	83 c4 10             	add    $0x10,%esp
80103be7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103beb:	83 c6 01             	add    $0x1,%esi
80103bee:	83 fe 10             	cmp    $0x10,%esi
80103bf1:	75 dd                	jne    80103bd0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103bf3:	83 ec 0c             	sub    $0xc,%esp
80103bf6:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bf9:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103bfc:	e8 af dc ff ff       	call   801018b0 <idup>
80103c01:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c04:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103c07:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c0d:	6a 10                	push   $0x10
80103c0f:	53                   	push   %ebx
80103c10:	50                   	push   %eax
80103c11:	e8 5a 0c 00 00       	call   80104870 <safestrcpy>

  pid = np->pid;
80103c16:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103c19:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c20:	e8 db 08 00 00       	call   80104500 <acquire>

  np->state = RUNNABLE;
80103c25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103c2c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c33:	e8 e8 09 00 00       	call   80104620 <release>

  return pid;
80103c38:	83 c4 10             	add    $0x10,%esp
80103c3b:	89 d8                	mov    %ebx,%eax
}
80103c3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c40:	5b                   	pop    %ebx
80103c41:	5e                   	pop    %esi
80103c42:	5f                   	pop    %edi
80103c43:	5d                   	pop    %ebp
80103c44:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103c45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c4a:	eb f1                	jmp    80103c3d <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103c4c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103c4f:	83 ec 0c             	sub    $0xc,%esp
80103c52:	ff 77 08             	pushl  0x8(%edi)
80103c55:	e8 f6 e8 ff ff       	call   80102550 <kfree>
    np->kstack = 0;
80103c5a:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103c61:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103c68:	83 c4 10             	add    $0x10,%esp
80103c6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c70:	eb cb                	jmp    80103c3d <fork+0xdd>
80103c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c80 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103c89:	e8 c2 fc ff ff       	call   80103950 <mycpu>
80103c8e:	8d 78 04             	lea    0x4(%eax),%edi
80103c91:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c93:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c9a:	00 00 00 
80103c9d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103ca0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ca1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103ca9:	68 20 3d 11 80       	push   $0x80113d20
80103cae:	e8 4d 08 00 00       	call   80104500 <acquire>
80103cb3:	83 c4 10             	add    $0x10,%esp
80103cb6:	eb 13                	jmp    80103ccb <scheduler+0x4b>
80103cb8:	90                   	nop
80103cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc0:	83 c3 7c             	add    $0x7c,%ebx
80103cc3:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80103cc9:	74 45                	je     80103d10 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103ccb:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ccf:	75 ef                	jne    80103cc0 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103cd1:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103cd4:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103cda:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cdb:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103cde:	e8 cd 30 00 00       	call   80106db0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103ce3:	58                   	pop    %eax
80103ce4:	5a                   	pop    %edx
80103ce5:	ff 73 a0             	pushl  -0x60(%ebx)
80103ce8:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103ce9:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80103cf0:	e8 d6 0b 00 00       	call   801048cb <swtch>
      switchkvm();
80103cf5:	e8 96 30 00 00       	call   80106d90 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103cfa:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cfd:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103d03:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d0a:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d0d:	75 bc                	jne    80103ccb <scheduler+0x4b>
80103d0f:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103d10:	83 ec 0c             	sub    $0xc,%esp
80103d13:	68 20 3d 11 80       	push   $0x80113d20
80103d18:	e8 03 09 00 00       	call   80104620 <release>

  }
80103d1d:	83 c4 10             	add    $0x10,%esp
80103d20:	e9 7b ff ff ff       	jmp    80103ca0 <scheduler+0x20>
80103d25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d30 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	56                   	push   %esi
80103d34:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d35:	e8 86 07 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103d3a:	e8 11 fc ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103d3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d45:	e8 66 08 00 00       	call   801045b0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103d4a:	83 ec 0c             	sub    $0xc,%esp
80103d4d:	68 20 3d 11 80       	push   $0x80113d20
80103d52:	e8 29 07 00 00       	call   80104480 <holding>
80103d57:	83 c4 10             	add    $0x10,%esp
80103d5a:	85 c0                	test   %eax,%eax
80103d5c:	74 4f                	je     80103dad <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103d5e:	e8 ed fb ff ff       	call   80103950 <mycpu>
80103d63:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d6a:	75 68                	jne    80103dd4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103d6c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d70:	74 55                	je     80103dc7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d72:	9c                   	pushf  
80103d73:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103d74:	f6 c4 02             	test   $0x2,%ah
80103d77:	75 41                	jne    80103dba <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103d79:	e8 d2 fb ff ff       	call   80103950 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d7e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103d81:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d87:	e8 c4 fb ff ff       	call   80103950 <mycpu>
80103d8c:	83 ec 08             	sub    $0x8,%esp
80103d8f:	ff 70 04             	pushl  0x4(%eax)
80103d92:	53                   	push   %ebx
80103d93:	e8 33 0b 00 00       	call   801048cb <swtch>
  mycpu()->intena = intena;
80103d98:	e8 b3 fb ff ff       	call   80103950 <mycpu>
}
80103d9d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103da0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103da6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103da9:	5b                   	pop    %ebx
80103daa:	5e                   	pop    %esi
80103dab:	5d                   	pop    %ebp
80103dac:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103dad:	83 ec 0c             	sub    $0xc,%esp
80103db0:	68 90 7b 10 80       	push   $0x80107b90
80103db5:	e8 e6 c6 ff ff       	call   801004a0 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	68 bc 7b 10 80       	push   $0x80107bbc
80103dc2:	e8 d9 c6 ff ff       	call   801004a0 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103dc7:	83 ec 0c             	sub    $0xc,%esp
80103dca:	68 ae 7b 10 80       	push   $0x80107bae
80103dcf:	e8 cc c6 ff ff       	call   801004a0 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103dd4:	83 ec 0c             	sub    $0xc,%esp
80103dd7:	68 a2 7b 10 80       	push   $0x80107ba2
80103ddc:	e8 bf c6 ff ff       	call   801004a0 <panic>
80103de1:	eb 0d                	jmp    80103df0 <exit>
80103de3:	90                   	nop
80103de4:	90                   	nop
80103de5:	90                   	nop
80103de6:	90                   	nop
80103de7:	90                   	nop
80103de8:	90                   	nop
80103de9:	90                   	nop
80103dea:	90                   	nop
80103deb:	90                   	nop
80103dec:	90                   	nop
80103ded:	90                   	nop
80103dee:	90                   	nop
80103def:	90                   	nop

80103df0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	57                   	push   %edi
80103df4:	56                   	push   %esi
80103df5:	53                   	push   %ebx
80103df6:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103df9:	e8 c2 06 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103dfe:	e8 4d fb ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103e03:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e09:	e8 a2 07 00 00       	call   801045b0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103e0e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103e14:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e17:	8d 7e 68             	lea    0x68(%esi),%edi
80103e1a:	0f 84 e7 00 00 00    	je     80103f07 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103e20:	8b 03                	mov    (%ebx),%eax
80103e22:	85 c0                	test   %eax,%eax
80103e24:	74 12                	je     80103e38 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103e26:	83 ec 0c             	sub    $0xc,%esp
80103e29:	50                   	push   %eax
80103e2a:	e8 31 d1 ff ff       	call   80100f60 <fileclose>
      curproc->ofile[fd] = 0;
80103e2f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e35:	83 c4 10             	add    $0x10,%esp
80103e38:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103e3b:	39 df                	cmp    %ebx,%edi
80103e3d:	75 e1                	jne    80103e20 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103e3f:	e8 7c ef ff ff       	call   80102dc0 <begin_op>
  iput(curproc->cwd);
80103e44:	83 ec 0c             	sub    $0xc,%esp
80103e47:	ff 76 68             	pushl  0x68(%esi)
80103e4a:	e8 c1 db ff ff       	call   80101a10 <iput>
  end_op();
80103e4f:	e8 dc ef ff ff       	call   80102e30 <end_op>
  curproc->cwd = 0;
80103e54:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103e5b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e62:	e8 99 06 00 00       	call   80104500 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103e67:	8b 56 14             	mov    0x14(%esi),%edx
80103e6a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e6d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103e72:	eb 0e                	jmp    80103e82 <exit+0x92>
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e78:	83 c0 7c             	add    $0x7c,%eax
80103e7b:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103e80:	74 1c                	je     80103e9e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103e82:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e86:	75 f0                	jne    80103e78 <exit+0x88>
80103e88:	3b 50 20             	cmp    0x20(%eax),%edx
80103e8b:	75 eb                	jne    80103e78 <exit+0x88>
      p->state = RUNNABLE;
80103e8d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e94:	83 c0 7c             	add    $0x7c,%eax
80103e97:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103e9c:	75 e4                	jne    80103e82 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103e9e:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80103ea4:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103ea9:	eb 10                	jmp    80103ebb <exit+0xcb>
80103eab:	90                   	nop
80103eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb0:	83 c2 7c             	add    $0x7c,%edx
80103eb3:	81 fa 54 5c 11 80    	cmp    $0x80115c54,%edx
80103eb9:	74 33                	je     80103eee <exit+0xfe>
    if(p->parent == curproc){
80103ebb:	39 72 14             	cmp    %esi,0x14(%edx)
80103ebe:	75 f0                	jne    80103eb0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103ec0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103ec4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103ec7:	75 e7                	jne    80103eb0 <exit+0xc0>
80103ec9:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ece:	eb 0a                	jmp    80103eda <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed0:	83 c0 7c             	add    $0x7c,%eax
80103ed3:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80103ed8:	74 d6                	je     80103eb0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103eda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ede:	75 f0                	jne    80103ed0 <exit+0xe0>
80103ee0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ee3:	75 eb                	jne    80103ed0 <exit+0xe0>
      p->state = RUNNABLE;
80103ee5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103eec:	eb e2                	jmp    80103ed0 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103eee:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103ef5:	e8 36 fe ff ff       	call   80103d30 <sched>
  panic("zombie exit");
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 dd 7b 10 80       	push   $0x80107bdd
80103f02:	e8 99 c5 ff ff       	call   801004a0 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103f07:	83 ec 0c             	sub    $0xc,%esp
80103f0a:	68 d0 7b 10 80       	push   $0x80107bd0
80103f0f:	e8 8c c5 ff ff       	call   801004a0 <panic>
80103f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103f20 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f27:	68 20 3d 11 80       	push   $0x80113d20
80103f2c:	e8 cf 05 00 00       	call   80104500 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f31:	e8 8a 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103f36:	e8 15 fa ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103f3b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f41:	e8 6a 06 00 00       	call   801045b0 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103f46:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f4d:	e8 de fd ff ff       	call   80103d30 <sched>
  release(&ptable.lock);
80103f52:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f59:	e8 c2 06 00 00       	call   80104620 <release>
}
80103f5e:	83 c4 10             	add    $0x10,%esp
80103f61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f64:	c9                   	leave  
80103f65:	c3                   	ret    
80103f66:	8d 76 00             	lea    0x0(%esi),%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	57                   	push   %edi
80103f74:	56                   	push   %esi
80103f75:	53                   	push   %ebx
80103f76:	83 ec 0c             	sub    $0xc,%esp
80103f79:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f7c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103f7f:	e8 3c 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103f84:	e8 c7 f9 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80103f89:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f8f:	e8 1c 06 00 00       	call   801045b0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103f94:	85 db                	test   %ebx,%ebx
80103f96:	0f 84 87 00 00 00    	je     80104023 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103f9c:	85 f6                	test   %esi,%esi
80103f9e:	74 76                	je     80104016 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fa0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103fa6:	74 50                	je     80103ff8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fa8:	83 ec 0c             	sub    $0xc,%esp
80103fab:	68 20 3d 11 80       	push   $0x80113d20
80103fb0:	e8 4b 05 00 00       	call   80104500 <acquire>
    release(lk);
80103fb5:	89 34 24             	mov    %esi,(%esp)
80103fb8:	e8 63 06 00 00       	call   80104620 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103fbd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fc0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103fc7:	e8 64 fd ff ff       	call   80103d30 <sched>

  // Tidy up.
  p->chan = 0;
80103fcc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103fd3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103fda:	e8 41 06 00 00       	call   80104620 <release>
    acquire(lk);
80103fdf:	89 75 08             	mov    %esi,0x8(%ebp)
80103fe2:	83 c4 10             	add    $0x10,%esp
  }
}
80103fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe8:	5b                   	pop    %ebx
80103fe9:	5e                   	pop    %esi
80103fea:	5f                   	pop    %edi
80103feb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103fec:	e9 0f 05 00 00       	jmp    80104500 <acquire>
80103ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103ff8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ffb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104002:	e8 29 fd ff ff       	call   80103d30 <sched>

  // Tidy up.
  p->chan = 0;
80104007:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010400e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104011:	5b                   	pop    %ebx
80104012:	5e                   	pop    %esi
80104013:	5f                   	pop    %edi
80104014:	5d                   	pop    %ebp
80104015:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104016:	83 ec 0c             	sub    $0xc,%esp
80104019:	68 ef 7b 10 80       	push   $0x80107bef
8010401e:	e8 7d c4 ff ff       	call   801004a0 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104023:	83 ec 0c             	sub    $0xc,%esp
80104026:	68 e9 7b 10 80       	push   $0x80107be9
8010402b:	e8 70 c4 ff ff       	call   801004a0 <panic>

80104030 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	57                   	push   %edi
80104034:	56                   	push   %esi
80104035:	53                   	push   %ebx
80104036:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104039:	e8 82 04 00 00       	call   801044c0 <pushcli>
  c = mycpu();
8010403e:	e8 0d f9 ff ff       	call   80103950 <mycpu>
  p = c->proc;
80104043:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104049:	e8 62 05 00 00       	call   801045b0 <popcli>
  int havekids, pid;
  struct proc *curproc = myproc();
  pde_t *pgdir;

  
  acquire(&ptable.lock);
8010404e:	83 ec 0c             	sub    $0xc,%esp
80104051:	68 20 3d 11 80       	push   $0x80113d20
80104056:	e8 a5 04 00 00       	call   80104500 <acquire>
8010405b:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010405e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104060:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104065:	eb 14                	jmp    8010407b <wait+0x4b>
80104067:	89 f6                	mov    %esi,%esi
80104069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104070:	83 c3 7c             	add    $0x7c,%ebx
80104073:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80104079:	74 25                	je     801040a0 <wait+0x70>
      if(p->parent != curproc)
8010407b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010407e:	75 f0                	jne    80104070 <wait+0x40>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80104080:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104084:	74 38                	je     801040be <wait+0x8e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104086:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104089:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010408e:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80104094:	75 e5                	jne    8010407b <wait+0x4b>
80104096:	8d 76 00             	lea    0x0(%esi),%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801040a0:	85 c0                	test   %eax,%eax
801040a2:	74 7a                	je     8010411e <wait+0xee>
801040a4:	8b 46 24             	mov    0x24(%esi),%eax
801040a7:	85 c0                	test   %eax,%eax
801040a9:	75 73                	jne    8010411e <wait+0xee>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801040ab:	83 ec 08             	sub    $0x8,%esp
801040ae:	68 20 3d 11 80       	push   $0x80113d20
801040b3:	56                   	push   %esi
801040b4:	e8 b7 fe ff ff       	call   80103f70 <sleep>
  }
801040b9:	83 c4 10             	add    $0x10,%esp
801040bc:	eb a0                	jmp    8010405e <wait+0x2e>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
801040be:	83 ec 0c             	sub    $0xc,%esp
801040c1:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801040c4:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040c7:	e8 84 e4 ff ff       	call   80102550 <kfree>
        p->kstack = 0;
        pgdir = p->pgdir;
801040cc:	8b 7b 04             	mov    0x4(%ebx),%edi
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
801040cf:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801040d6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        pgdir = p->pgdir;
        p->pgdir = 0;
801040dd:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        p->pid = 0;
801040e4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040eb:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040f2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040f6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040fd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104104:	e8 17 05 00 00       	call   80104620 <release>
        freevm(pgdir);
80104109:	89 3c 24             	mov    %edi,(%esp)
8010410c:	e8 1f 30 00 00       	call   80107130 <freevm>
        return pid;
80104111:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104114:	8d 65 f4             	lea    -0xc(%ebp),%esp
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        freevm(pgdir);
        return pid;
80104117:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104119:	5b                   	pop    %ebx
8010411a:	5e                   	pop    %esi
8010411b:	5f                   	pop    %edi
8010411c:	5d                   	pop    %ebp
8010411d:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
8010411e:	83 ec 0c             	sub    $0xc,%esp
80104121:	68 20 3d 11 80       	push   $0x80113d20
80104126:	e8 f5 04 00 00       	call   80104620 <release>
      return -1;
8010412b:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010412e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80104131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104136:	5b                   	pop    %ebx
80104137:	5e                   	pop    %esi
80104138:	5f                   	pop    %edi
80104139:	5d                   	pop    %ebp
8010413a:	c3                   	ret    
8010413b:	90                   	nop
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104140 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 10             	sub    $0x10,%esp
80104147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010414a:	68 20 3d 11 80       	push   $0x80113d20
8010414f:	e8 ac 03 00 00       	call   80104500 <acquire>
80104154:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104157:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010415c:	eb 0c                	jmp    8010416a <wakeup+0x2a>
8010415e:	66 90                	xchg   %ax,%ax
80104160:	83 c0 7c             	add    $0x7c,%eax
80104163:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80104168:	74 1c                	je     80104186 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010416a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010416e:	75 f0                	jne    80104160 <wakeup+0x20>
80104170:	3b 58 20             	cmp    0x20(%eax),%ebx
80104173:	75 eb                	jne    80104160 <wakeup+0x20>
      p->state = RUNNABLE;
80104175:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010417c:	83 c0 7c             	add    $0x7c,%eax
8010417f:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
80104184:	75 e4                	jne    8010416a <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104186:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
8010418d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104190:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104191:	e9 8a 04 00 00       	jmp    80104620 <release>
80104196:	8d 76 00             	lea    0x0(%esi),%esi
80104199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 10             	sub    $0x10,%esp
801041a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801041aa:	68 20 3d 11 80       	push   $0x80113d20
801041af:	e8 4c 03 00 00       	call   80104500 <acquire>
801041b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041bc:	eb 0c                	jmp    801041ca <kill+0x2a>
801041be:	66 90                	xchg   %ax,%ax
801041c0:	83 c0 7c             	add    $0x7c,%eax
801041c3:	3d 54 5c 11 80       	cmp    $0x80115c54,%eax
801041c8:	74 3e                	je     80104208 <kill+0x68>
    if(p->pid == pid){
801041ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801041cd:	75 f1                	jne    801041c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801041d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041da:	74 1c                	je     801041f8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801041dc:	83 ec 0c             	sub    $0xc,%esp
801041df:	68 20 3d 11 80       	push   $0x80113d20
801041e4:	e8 37 04 00 00       	call   80104620 <release>
      return 0;
801041e9:	83 c4 10             	add    $0x10,%esp
801041ec:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801041ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041f1:	c9                   	leave  
801041f2:	c3                   	ret    
801041f3:	90                   	nop
801041f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801041f8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041ff:	eb db                	jmp    801041dc <kill+0x3c>
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	68 20 3d 11 80       	push   $0x80113d20
80104210:	e8 0b 04 00 00       	call   80104620 <release>
  return -1;
80104215:	83 c4 10             	add    $0x10,%esp
80104218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010421d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104220:	c9                   	leave  
80104221:	c3                   	ret    
80104222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104230 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	53                   	push   %ebx
80104236:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104239:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010423e:	83 ec 3c             	sub    $0x3c,%esp
80104241:	eb 24                	jmp    80104267 <procdump+0x37>
80104243:	90                   	nop
80104244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	68 f3 76 10 80       	push   $0x801076f3
80104250:	e8 3b c5 ff ff       	call   80100790 <cprintf>
80104255:	83 c4 10             	add    $0x10,%esp
80104258:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010425b:	81 fb c0 5c 11 80    	cmp    $0x80115cc0,%ebx
80104261:	0f 84 81 00 00 00    	je     801042e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104267:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010426a:	85 c0                	test   %eax,%eax
8010426c:	74 ea                	je     80104258 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010426e:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104271:	ba 00 7c 10 80       	mov    $0x80107c00,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104276:	77 11                	ja     80104289 <procdump+0x59>
80104278:	8b 14 85 60 7c 10 80 	mov    -0x7fef83a0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010427f:	b8 00 7c 10 80       	mov    $0x80107c00,%eax
80104284:	85 d2                	test   %edx,%edx
80104286:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104289:	53                   	push   %ebx
8010428a:	52                   	push   %edx
8010428b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010428e:	68 04 7c 10 80       	push   $0x80107c04
80104293:	e8 f8 c4 ff ff       	call   80100790 <cprintf>
    if(p->state == SLEEPING){
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010429f:	75 a7                	jne    80104248 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801042a1:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042a4:	83 ec 08             	sub    $0x8,%esp
801042a7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042aa:	50                   	push   %eax
801042ab:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042ae:	8b 40 0c             	mov    0xc(%eax),%eax
801042b1:	83 c0 08             	add    $0x8,%eax
801042b4:	50                   	push   %eax
801042b5:	e8 66 01 00 00       	call   80104420 <getcallerpcs>
801042ba:	83 c4 10             	add    $0x10,%esp
801042bd:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801042c0:	8b 17                	mov    (%edi),%edx
801042c2:	85 d2                	test   %edx,%edx
801042c4:	74 82                	je     80104248 <procdump+0x18>
        cprintf(" %p", pc[i]);
801042c6:	83 ec 08             	sub    $0x8,%esp
801042c9:	83 c7 04             	add    $0x4,%edi
801042cc:	52                   	push   %edx
801042cd:	68 fc 75 10 80       	push   $0x801075fc
801042d2:	e8 b9 c4 ff ff       	call   80100790 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801042d7:	83 c4 10             	add    $0x10,%esp
801042da:	39 f7                	cmp    %esi,%edi
801042dc:	75 e2                	jne    801042c0 <procdump+0x90>
801042de:	e9 65 ff ff ff       	jmp    80104248 <procdump+0x18>
801042e3:	90                   	nop
801042e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801042e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042eb:	5b                   	pop    %ebx
801042ec:	5e                   	pop    %esi
801042ed:	5f                   	pop    %edi
801042ee:	5d                   	pop    %ebp
801042ef:	c3                   	ret    

801042f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	53                   	push   %ebx
801042f4:	83 ec 0c             	sub    $0xc,%esp
801042f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801042fa:	68 78 7c 10 80       	push   $0x80107c78
801042ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104302:	50                   	push   %eax
80104303:	e8 f8 00 00 00       	call   80104400 <initlock>
  lk->name = name;
80104308:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010430b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104311:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104314:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010431b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010431e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104321:	c9                   	leave  
80104322:	c3                   	ret    
80104323:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104330 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
80104335:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	8d 73 04             	lea    0x4(%ebx),%esi
8010433e:	56                   	push   %esi
8010433f:	e8 bc 01 00 00       	call   80104500 <acquire>
  while (lk->locked) {
80104344:	8b 13                	mov    (%ebx),%edx
80104346:	83 c4 10             	add    $0x10,%esp
80104349:	85 d2                	test   %edx,%edx
8010434b:	74 16                	je     80104363 <acquiresleep+0x33>
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104350:	83 ec 08             	sub    $0x8,%esp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	e8 16 fc ff ff       	call   80103f70 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010435a:	8b 03                	mov    (%ebx),%eax
8010435c:	83 c4 10             	add    $0x10,%esp
8010435f:	85 c0                	test   %eax,%eax
80104361:	75 ed                	jne    80104350 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104363:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104369:	e8 82 f6 ff ff       	call   801039f0 <myproc>
8010436e:	8b 40 10             	mov    0x10(%eax),%eax
80104371:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104374:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104377:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010437a:	5b                   	pop    %ebx
8010437b:	5e                   	pop    %esi
8010437c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010437d:	e9 9e 02 00 00       	jmp    80104620 <release>
80104382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104390 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	53                   	push   %ebx
80104395:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104398:	83 ec 0c             	sub    $0xc,%esp
8010439b:	8d 73 04             	lea    0x4(%ebx),%esi
8010439e:	56                   	push   %esi
8010439f:	e8 5c 01 00 00       	call   80104500 <acquire>
  lk->locked = 0;
801043a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043b1:	89 1c 24             	mov    %ebx,(%esp)
801043b4:	e8 87 fd ff ff       	call   80104140 <wakeup>
  release(&lk->lk);
801043b9:	89 75 08             	mov    %esi,0x8(%ebp)
801043bc:	83 c4 10             	add    $0x10,%esp
}
801043bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c2:	5b                   	pop    %ebx
801043c3:	5e                   	pop    %esi
801043c4:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
801043c5:	e9 56 02 00 00       	jmp    80104620 <release>
801043ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043d0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
801043d5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	8d 5e 04             	lea    0x4(%esi),%ebx
801043de:	53                   	push   %ebx
801043df:	e8 1c 01 00 00       	call   80104500 <acquire>
  r = lk->locked;
801043e4:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
801043e6:	89 1c 24             	mov    %ebx,(%esp)
801043e9:	e8 32 02 00 00       	call   80104620 <release>
  return r;
}
801043ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043f1:	89 f0                	mov    %esi,%eax
801043f3:	5b                   	pop    %ebx
801043f4:	5e                   	pop    %esi
801043f5:	5d                   	pop    %ebp
801043f6:	c3                   	ret    
801043f7:	66 90                	xchg   %ax,%ax
801043f9:	66 90                	xchg   %ax,%ax
801043fb:	66 90                	xchg   %ax,%ax
801043fd:	66 90                	xchg   %ax,%ax
801043ff:	90                   	nop

80104400 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104406:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010440f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104412:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104419:	5d                   	pop    %ebp
8010441a:	c3                   	ret    
8010441b:	90                   	nop
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104420 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104424:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104427:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010442a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010442d:	31 c0                	xor    %eax,%eax
8010442f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104430:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104436:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010443c:	77 1a                	ja     80104458 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010443e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104441:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104444:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104447:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104449:	83 f8 0a             	cmp    $0xa,%eax
8010444c:	75 e2                	jne    80104430 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010444e:	5b                   	pop    %ebx
8010444f:	5d                   	pop    %ebp
80104450:	c3                   	ret    
80104451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104458:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010445f:	83 c0 01             	add    $0x1,%eax
80104462:	83 f8 0a             	cmp    $0xa,%eax
80104465:	74 e7                	je     8010444e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104467:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010446e:	83 c0 01             	add    $0x1,%eax
80104471:	83 f8 0a             	cmp    $0xa,%eax
80104474:	75 e2                	jne    80104458 <getcallerpcs+0x38>
80104476:	eb d6                	jmp    8010444e <getcallerpcs+0x2e>
80104478:	90                   	nop
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104480 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	53                   	push   %ebx
80104484:	83 ec 04             	sub    $0x4,%esp
80104487:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010448a:	8b 02                	mov    (%edx),%eax
8010448c:	85 c0                	test   %eax,%eax
8010448e:	75 10                	jne    801044a0 <holding+0x20>
}
80104490:	83 c4 04             	add    $0x4,%esp
80104493:	31 c0                	xor    %eax,%eax
80104495:	5b                   	pop    %ebx
80104496:	5d                   	pop    %ebp
80104497:	c3                   	ret    
80104498:	90                   	nop
80104499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801044a0:	8b 5a 08             	mov    0x8(%edx),%ebx
801044a3:	e8 a8 f4 ff ff       	call   80103950 <mycpu>
801044a8:	39 c3                	cmp    %eax,%ebx
801044aa:	0f 94 c0             	sete   %al
}
801044ad:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801044b0:	0f b6 c0             	movzbl %al,%eax
}
801044b3:	5b                   	pop    %ebx
801044b4:	5d                   	pop    %ebp
801044b5:	c3                   	ret    
801044b6:	8d 76 00             	lea    0x0(%esi),%esi
801044b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 04             	sub    $0x4,%esp
801044c7:	9c                   	pushf  
801044c8:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
801044c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044ca:	e8 81 f4 ff ff       	call   80103950 <mycpu>
801044cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044d5:	85 c0                	test   %eax,%eax
801044d7:	75 11                	jne    801044ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801044d9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044df:	e8 6c f4 ff ff       	call   80103950 <mycpu>
801044e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801044ea:	e8 61 f4 ff ff       	call   80103950 <mycpu>
801044ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044f6:	83 c4 04             	add    $0x4,%esp
801044f9:	5b                   	pop    %ebx
801044fa:	5d                   	pop    %ebp
801044fb:	c3                   	ret    
801044fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104500 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104505:	e8 b6 ff ff ff       	call   801044c0 <pushcli>
  if(holding(lk))
8010450a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010450d:	8b 03                	mov    (%ebx),%eax
8010450f:	85 c0                	test   %eax,%eax
80104511:	75 7d                	jne    80104590 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104513:	ba 01 00 00 00       	mov    $0x1,%edx
80104518:	eb 09                	jmp    80104523 <acquire+0x23>
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104520:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104523:	89 d0                	mov    %edx,%eax
80104525:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104528:	85 c0                	test   %eax,%eax
8010452a:	75 f4                	jne    80104520 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010452c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104531:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104534:	e8 17 f4 ff ff       	call   80103950 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104539:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010453b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010453e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104541:	31 c0                	xor    %eax,%eax
80104543:	90                   	nop
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104548:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
8010454e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104554:	77 1a                	ja     80104570 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104556:	8b 5a 04             	mov    0x4(%edx),%ebx
80104559:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010455c:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
8010455f:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104561:	83 f8 0a             	cmp    $0xa,%eax
80104564:	75 e2                	jne    80104548 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104566:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104569:	5b                   	pop    %ebx
8010456a:	5e                   	pop    %esi
8010456b:	5d                   	pop    %ebp
8010456c:	c3                   	ret    
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104570:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104577:	83 c0 01             	add    $0x1,%eax
8010457a:	83 f8 0a             	cmp    $0xa,%eax
8010457d:	74 e7                	je     80104566 <acquire+0x66>
    pcs[i] = 0;
8010457f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104586:	83 c0 01             	add    $0x1,%eax
80104589:	83 f8 0a             	cmp    $0xa,%eax
8010458c:	75 e2                	jne    80104570 <acquire+0x70>
8010458e:	eb d6                	jmp    80104566 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104590:	8b 73 08             	mov    0x8(%ebx),%esi
80104593:	e8 b8 f3 ff ff       	call   80103950 <mycpu>
80104598:	39 c6                	cmp    %eax,%esi
8010459a:	0f 85 73 ff ff ff    	jne    80104513 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801045a0:	83 ec 0c             	sub    $0xc,%esp
801045a3:	68 83 7c 10 80       	push   $0x80107c83
801045a8:	e8 f3 be ff ff       	call   801004a0 <panic>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi

801045b0 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045b6:	9c                   	pushf  
801045b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045b8:	f6 c4 02             	test   $0x2,%ah
801045bb:	75 52                	jne    8010460f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045bd:	e8 8e f3 ff ff       	call   80103950 <mycpu>
801045c2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801045c8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801045cb:	85 d2                	test   %edx,%edx
801045cd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801045d3:	78 2d                	js     80104602 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045d5:	e8 76 f3 ff ff       	call   80103950 <mycpu>
801045da:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045e0:	85 d2                	test   %edx,%edx
801045e2:	74 0c                	je     801045f0 <popcli+0x40>
    sti();
}
801045e4:	c9                   	leave  
801045e5:	c3                   	ret    
801045e6:	8d 76 00             	lea    0x0(%esi),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045f0:	e8 5b f3 ff ff       	call   80103950 <mycpu>
801045f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045fb:	85 c0                	test   %eax,%eax
801045fd:	74 e5                	je     801045e4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801045ff:	fb                   	sti    
    sti();
}
80104600:	c9                   	leave  
80104601:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104602:	83 ec 0c             	sub    $0xc,%esp
80104605:	68 a2 7c 10 80       	push   $0x80107ca2
8010460a:	e8 91 be ff ff       	call   801004a0 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010460f:	83 ec 0c             	sub    $0xc,%esp
80104612:	68 8b 7c 10 80       	push   $0x80107c8b
80104617:	e8 84 be ff ff       	call   801004a0 <panic>
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104620 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104628:	8b 03                	mov    (%ebx),%eax
8010462a:	85 c0                	test   %eax,%eax
8010462c:	75 12                	jne    80104640 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010462e:	83 ec 0c             	sub    $0xc,%esp
80104631:	68 a9 7c 10 80       	push   $0x80107ca9
80104636:	e8 65 be ff ff       	call   801004a0 <panic>
8010463b:	90                   	nop
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104640:	8b 73 08             	mov    0x8(%ebx),%esi
80104643:	e8 08 f3 ff ff       	call   80103950 <mycpu>
80104648:	39 c6                	cmp    %eax,%esi
8010464a:	75 e2                	jne    8010462e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
8010464c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104653:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
8010465a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010465f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104665:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104668:	5b                   	pop    %ebx
80104669:	5e                   	pop    %esi
8010466a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010466b:	e9 40 ff ff ff       	jmp    801045b0 <popcli>

80104670 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	53                   	push   %ebx
80104675:	8b 55 08             	mov    0x8(%ebp),%edx
80104678:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010467b:	f6 c2 03             	test   $0x3,%dl
8010467e:	75 05                	jne    80104685 <memset+0x15>
80104680:	f6 c1 03             	test   $0x3,%cl
80104683:	74 13                	je     80104698 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104685:	89 d7                	mov    %edx,%edi
80104687:	8b 45 0c             	mov    0xc(%ebp),%eax
8010468a:	fc                   	cld    
8010468b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010468d:	5b                   	pop    %ebx
8010468e:	89 d0                	mov    %edx,%eax
80104690:	5f                   	pop    %edi
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104698:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010469c:	c1 e9 02             	shr    $0x2,%ecx
8010469f:	89 fb                	mov    %edi,%ebx
801046a1:	89 f8                	mov    %edi,%eax
801046a3:	c1 e3 18             	shl    $0x18,%ebx
801046a6:	c1 e0 10             	shl    $0x10,%eax
801046a9:	09 d8                	or     %ebx,%eax
801046ab:	09 f8                	or     %edi,%eax
801046ad:	c1 e7 08             	shl    $0x8,%edi
801046b0:	09 f8                	or     %edi,%eax
801046b2:	89 d7                	mov    %edx,%edi
801046b4:	fc                   	cld    
801046b5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801046b7:	5b                   	pop    %ebx
801046b8:	89 d0                	mov    %edx,%eax
801046ba:	5f                   	pop    %edi
801046bb:	5d                   	pop    %ebp
801046bc:	c3                   	ret    
801046bd:	8d 76 00             	lea    0x0(%esi),%esi

801046c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	56                   	push   %esi
801046c5:	8b 45 10             	mov    0x10(%ebp),%eax
801046c8:	53                   	push   %ebx
801046c9:	8b 75 0c             	mov    0xc(%ebp),%esi
801046cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046cf:	85 c0                	test   %eax,%eax
801046d1:	74 29                	je     801046fc <memcmp+0x3c>
    if(*s1 != *s2)
801046d3:	0f b6 13             	movzbl (%ebx),%edx
801046d6:	0f b6 0e             	movzbl (%esi),%ecx
801046d9:	38 d1                	cmp    %dl,%cl
801046db:	75 2b                	jne    80104708 <memcmp+0x48>
801046dd:	8d 78 ff             	lea    -0x1(%eax),%edi
801046e0:	31 c0                	xor    %eax,%eax
801046e2:	eb 14                	jmp    801046f8 <memcmp+0x38>
801046e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046e8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801046ed:	83 c0 01             	add    $0x1,%eax
801046f0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801046f4:	38 ca                	cmp    %cl,%dl
801046f6:	75 10                	jne    80104708 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046f8:	39 f8                	cmp    %edi,%eax
801046fa:	75 ec                	jne    801046e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801046fc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801046fd:	31 c0                	xor    %eax,%eax
}
801046ff:	5e                   	pop    %esi
80104700:	5f                   	pop    %edi
80104701:	5d                   	pop    %ebp
80104702:	c3                   	ret    
80104703:	90                   	nop
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104708:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010470b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010470c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010470e:	5e                   	pop    %esi
8010470f:	5f                   	pop    %edi
80104710:	5d                   	pop    %ebp
80104711:	c3                   	ret    
80104712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104720 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
80104725:	8b 45 08             	mov    0x8(%ebp),%eax
80104728:	8b 75 0c             	mov    0xc(%ebp),%esi
8010472b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010472e:	39 c6                	cmp    %eax,%esi
80104730:	73 2e                	jae    80104760 <memmove+0x40>
80104732:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104735:	39 c8                	cmp    %ecx,%eax
80104737:	73 27                	jae    80104760 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104739:	85 db                	test   %ebx,%ebx
8010473b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010473e:	74 17                	je     80104757 <memmove+0x37>
      *--d = *--s;
80104740:	29 d9                	sub    %ebx,%ecx
80104742:	89 cb                	mov    %ecx,%ebx
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104748:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010474c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010474f:	83 ea 01             	sub    $0x1,%edx
80104752:	83 fa ff             	cmp    $0xffffffff,%edx
80104755:	75 f1                	jne    80104748 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104757:	5b                   	pop    %ebx
80104758:	5e                   	pop    %esi
80104759:	5d                   	pop    %ebp
8010475a:	c3                   	ret    
8010475b:	90                   	nop
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104760:	31 d2                	xor    %edx,%edx
80104762:	85 db                	test   %ebx,%ebx
80104764:	74 f1                	je     80104757 <memmove+0x37>
80104766:	8d 76 00             	lea    0x0(%esi),%esi
80104769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104770:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104774:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104777:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010477a:	39 d3                	cmp    %edx,%ebx
8010477c:	75 f2                	jne    80104770 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010477e:	5b                   	pop    %ebx
8010477f:	5e                   	pop    %esi
80104780:	5d                   	pop    %ebp
80104781:	c3                   	ret    
80104782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104793:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104794:	eb 8a                	jmp    80104720 <memmove>
80104796:	8d 76 00             	lea    0x0(%esi),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	56                   	push   %esi
801047a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047a8:	53                   	push   %ebx
801047a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801047ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801047af:	85 c9                	test   %ecx,%ecx
801047b1:	74 37                	je     801047ea <strncmp+0x4a>
801047b3:	0f b6 17             	movzbl (%edi),%edx
801047b6:	0f b6 1e             	movzbl (%esi),%ebx
801047b9:	84 d2                	test   %dl,%dl
801047bb:	74 3f                	je     801047fc <strncmp+0x5c>
801047bd:	38 d3                	cmp    %dl,%bl
801047bf:	75 3b                	jne    801047fc <strncmp+0x5c>
801047c1:	8d 47 01             	lea    0x1(%edi),%eax
801047c4:	01 cf                	add    %ecx,%edi
801047c6:	eb 1b                	jmp    801047e3 <strncmp+0x43>
801047c8:	90                   	nop
801047c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047d0:	0f b6 10             	movzbl (%eax),%edx
801047d3:	84 d2                	test   %dl,%dl
801047d5:	74 21                	je     801047f8 <strncmp+0x58>
801047d7:	0f b6 19             	movzbl (%ecx),%ebx
801047da:	83 c0 01             	add    $0x1,%eax
801047dd:	89 ce                	mov    %ecx,%esi
801047df:	38 da                	cmp    %bl,%dl
801047e1:	75 19                	jne    801047fc <strncmp+0x5c>
801047e3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801047e5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801047e8:	75 e6                	jne    801047d0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801047ea:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801047eb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801047ed:	5e                   	pop    %esi
801047ee:	5f                   	pop    %edi
801047ef:	5d                   	pop    %ebp
801047f0:	c3                   	ret    
801047f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801047fc:	0f b6 c2             	movzbl %dl,%eax
801047ff:	29 d8                	sub    %ebx,%eax
}
80104801:	5b                   	pop    %ebx
80104802:	5e                   	pop    %esi
80104803:	5f                   	pop    %edi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret    
80104806:	8d 76 00             	lea    0x0(%esi),%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 45 08             	mov    0x8(%ebp),%eax
80104818:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010481b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010481e:	89 c2                	mov    %eax,%edx
80104820:	eb 19                	jmp    8010483b <strncpy+0x2b>
80104822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104828:	83 c3 01             	add    $0x1,%ebx
8010482b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010482f:	83 c2 01             	add    $0x1,%edx
80104832:	84 c9                	test   %cl,%cl
80104834:	88 4a ff             	mov    %cl,-0x1(%edx)
80104837:	74 09                	je     80104842 <strncpy+0x32>
80104839:	89 f1                	mov    %esi,%ecx
8010483b:	85 c9                	test   %ecx,%ecx
8010483d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104840:	7f e6                	jg     80104828 <strncpy+0x18>
    ;
  while(n-- > 0)
80104842:	31 c9                	xor    %ecx,%ecx
80104844:	85 f6                	test   %esi,%esi
80104846:	7e 17                	jle    8010485f <strncpy+0x4f>
80104848:	90                   	nop
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104850:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104854:	89 f3                	mov    %esi,%ebx
80104856:	83 c1 01             	add    $0x1,%ecx
80104859:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010485b:	85 db                	test   %ebx,%ebx
8010485d:	7f f1                	jg     80104850 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010485f:	5b                   	pop    %ebx
80104860:	5e                   	pop    %esi
80104861:	5d                   	pop    %ebp
80104862:	c3                   	ret    
80104863:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104878:	8b 45 08             	mov    0x8(%ebp),%eax
8010487b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010487e:	85 c9                	test   %ecx,%ecx
80104880:	7e 26                	jle    801048a8 <safestrcpy+0x38>
80104882:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104886:	89 c1                	mov    %eax,%ecx
80104888:	eb 17                	jmp    801048a1 <safestrcpy+0x31>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104890:	83 c2 01             	add    $0x1,%edx
80104893:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104897:	83 c1 01             	add    $0x1,%ecx
8010489a:	84 db                	test   %bl,%bl
8010489c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010489f:	74 04                	je     801048a5 <safestrcpy+0x35>
801048a1:	39 f2                	cmp    %esi,%edx
801048a3:	75 eb                	jne    80104890 <safestrcpy+0x20>
    ;
  *s = 0;
801048a5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801048a8:	5b                   	pop    %ebx
801048a9:	5e                   	pop    %esi
801048aa:	5d                   	pop    %ebp
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048b0 <strlen>:

int
strlen(const char *s)
{
801048b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048b1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801048b3:	89 e5                	mov    %esp,%ebp
801048b5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801048b8:	80 3a 00             	cmpb   $0x0,(%edx)
801048bb:	74 0c                	je     801048c9 <strlen+0x19>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
801048c0:	83 c0 01             	add    $0x1,%eax
801048c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048c7:	75 f7                	jne    801048c0 <strlen+0x10>
    ;
  return n;
}
801048c9:	5d                   	pop    %ebp
801048ca:	c3                   	ret    

801048cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801048d3:	55                   	push   %ebp
  pushl %ebx
801048d4:	53                   	push   %ebx
  pushl %esi
801048d5:	56                   	push   %esi
  pushl %edi
801048d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048d9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801048db:	5f                   	pop    %edi
  popl %esi
801048dc:	5e                   	pop    %esi
  popl %ebx
801048dd:	5b                   	pop    %ebx
  popl %ebp
801048de:	5d                   	pop    %ebp
  ret
801048df:	c3                   	ret    

801048e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 04             	sub    $0x4,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048ea:	e8 01 f1 ff ff       	call   801039f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ef:	8b 00                	mov    (%eax),%eax
801048f1:	39 d8                	cmp    %ebx,%eax
801048f3:	76 1b                	jbe    80104910 <fetchint+0x30>
801048f5:	8d 53 04             	lea    0x4(%ebx),%edx
801048f8:	39 d0                	cmp    %edx,%eax
801048fa:	72 14                	jb     80104910 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ff:	8b 13                	mov    (%ebx),%edx
80104901:	89 10                	mov    %edx,(%eax)
  return 0;
80104903:	31 c0                	xor    %eax,%eax
}
80104905:	83 c4 04             	add    $0x4,%esp
80104908:	5b                   	pop    %ebx
80104909:	5d                   	pop    %ebp
8010490a:	c3                   	ret    
8010490b:	90                   	nop
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104915:	eb ee                	jmp    80104905 <fetchint+0x25>
80104917:	89 f6                	mov    %esi,%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 04             	sub    $0x4,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010492a:	e8 c1 f0 ff ff       	call   801039f0 <myproc>

  if(addr >= curproc->sz)
8010492f:	39 18                	cmp    %ebx,(%eax)
80104931:	76 29                	jbe    8010495c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104936:	89 da                	mov    %ebx,%edx
80104938:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010493a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010493c:	39 c3                	cmp    %eax,%ebx
8010493e:	73 1c                	jae    8010495c <fetchstr+0x3c>
    if(*s == 0)
80104940:	80 3b 00             	cmpb   $0x0,(%ebx)
80104943:	75 10                	jne    80104955 <fetchstr+0x35>
80104945:	eb 29                	jmp    80104970 <fetchstr+0x50>
80104947:	89 f6                	mov    %esi,%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104950:	80 3a 00             	cmpb   $0x0,(%edx)
80104953:	74 1b                	je     80104970 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104955:	83 c2 01             	add    $0x1,%edx
80104958:	39 d0                	cmp    %edx,%eax
8010495a:	77 f4                	ja     80104950 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010495c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010495f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104964:	5b                   	pop    %ebx
80104965:	5d                   	pop    %ebp
80104966:	c3                   	ret    
80104967:	89 f6                	mov    %esi,%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104970:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104973:	89 d0                	mov    %edx,%eax
80104975:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104977:	5b                   	pop    %ebx
80104978:	5d                   	pop    %ebp
80104979:	c3                   	ret    
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104985:	e8 66 f0 ff ff       	call   801039f0 <myproc>
8010498a:	8b 40 18             	mov    0x18(%eax),%eax
8010498d:	8b 55 08             	mov    0x8(%ebp),%edx
80104990:	8b 40 44             	mov    0x44(%eax),%eax
80104993:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104996:	e8 55 f0 ff ff       	call   801039f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010499b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010499d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049a0:	39 c6                	cmp    %eax,%esi
801049a2:	73 1c                	jae    801049c0 <argint+0x40>
801049a4:	8d 53 08             	lea    0x8(%ebx),%edx
801049a7:	39 d0                	cmp    %edx,%eax
801049a9:	72 15                	jb     801049c0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
801049ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801049ae:	8b 53 04             	mov    0x4(%ebx),%edx
801049b1:	89 10                	mov    %edx,(%eax)
  return 0;
801049b3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801049b5:	5b                   	pop    %ebx
801049b6:	5e                   	pop    %esi
801049b7:	5d                   	pop    %ebp
801049b8:	c3                   	ret    
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801049c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049c5:	eb ee                	jmp    801049b5 <argint+0x35>
801049c7:	89 f6                	mov    %esi,%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	83 ec 10             	sub    $0x10,%esp
801049d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801049db:	e8 10 f0 ff ff       	call   801039f0 <myproc>
801049e0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801049e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049e5:	83 ec 08             	sub    $0x8,%esp
801049e8:	50                   	push   %eax
801049e9:	ff 75 08             	pushl  0x8(%ebp)
801049ec:	e8 8f ff ff ff       	call   80104980 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801049f1:	c1 e8 1f             	shr    $0x1f,%eax
801049f4:	83 c4 10             	add    $0x10,%esp
801049f7:	84 c0                	test   %al,%al
801049f9:	75 2d                	jne    80104a28 <argptr+0x58>
801049fb:	89 d8                	mov    %ebx,%eax
801049fd:	c1 e8 1f             	shr    $0x1f,%eax
80104a00:	84 c0                	test   %al,%al
80104a02:	75 24                	jne    80104a28 <argptr+0x58>
80104a04:	8b 16                	mov    (%esi),%edx
80104a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a09:	39 c2                	cmp    %eax,%edx
80104a0b:	76 1b                	jbe    80104a28 <argptr+0x58>
80104a0d:	01 c3                	add    %eax,%ebx
80104a0f:	39 da                	cmp    %ebx,%edx
80104a11:	72 15                	jb     80104a28 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104a13:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a16:	89 02                	mov    %eax,(%edx)
  return 0;
80104a18:	31 c0                	xor    %eax,%eax
}
80104a1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a1d:	5b                   	pop    %ebx
80104a1e:	5e                   	pop    %esi
80104a1f:	5d                   	pop    %ebp
80104a20:	c3                   	ret    
80104a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a2d:	eb eb                	jmp    80104a1a <argptr+0x4a>
80104a2f:	90                   	nop

80104a30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a39:	50                   	push   %eax
80104a3a:	ff 75 08             	pushl  0x8(%ebp)
80104a3d:	e8 3e ff ff ff       	call   80104980 <argint>
80104a42:	83 c4 10             	add    $0x10,%esp
80104a45:	85 c0                	test   %eax,%eax
80104a47:	78 17                	js     80104a60 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a49:	83 ec 08             	sub    $0x8,%esp
80104a4c:	ff 75 0c             	pushl  0xc(%ebp)
80104a4f:	ff 75 f4             	pushl  -0xc(%ebp)
80104a52:	e8 c9 fe ff ff       	call   80104920 <fetchstr>
80104a57:	83 c4 10             	add    $0x10,%esp
}
80104a5a:	c9                   	leave  
80104a5b:	c3                   	ret    
80104a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104a65:	c9                   	leave  
80104a66:	c3                   	ret    
80104a67:	89 f6                	mov    %esi,%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a70 <syscall>:
[SYS_swap]    sys_swap,
};

void
syscall(void)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	56                   	push   %esi
80104a74:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104a75:	e8 76 ef ff ff       	call   801039f0 <myproc>

  num = curproc->tf->eax;
80104a7a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
80104a7d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a7f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a82:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a85:	83 fa 16             	cmp    $0x16,%edx
80104a88:	77 1e                	ja     80104aa8 <syscall+0x38>
80104a8a:	8b 14 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%edx
80104a91:	85 d2                	test   %edx,%edx
80104a93:	74 13                	je     80104aa8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104a95:	ff d2                	call   *%edx
80104a97:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a9d:	5b                   	pop    %ebx
80104a9e:	5e                   	pop    %esi
80104a9f:	5d                   	pop    %ebp
80104aa0:	c3                   	ret    
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104aa8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104aa9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104aac:	50                   	push   %eax
80104aad:	ff 73 10             	pushl  0x10(%ebx)
80104ab0:	68 b1 7c 10 80       	push   $0x80107cb1
80104ab5:	e8 d6 bc ff ff       	call   80100790 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104aba:	8b 43 18             	mov    0x18(%ebx),%eax
80104abd:	83 c4 10             	add    $0x10,%esp
80104ac0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aca:	5b                   	pop    %ebx
80104acb:	5e                   	pop    %esi
80104acc:	5d                   	pop    %ebp
80104acd:	c3                   	ret    
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	57                   	push   %edi
80104ad4:	56                   	push   %esi
80104ad5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ad6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ad9:	83 ec 44             	sub    $0x44,%esp
80104adc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104adf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ae2:	56                   	push   %esi
80104ae3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ae4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104ae7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104aea:	e8 61 d6 ff ff       	call   80102150 <nameiparent>
80104aef:	83 c4 10             	add    $0x10,%esp
80104af2:	85 c0                	test   %eax,%eax
80104af4:	0f 84 f6 00 00 00    	je     80104bf0 <create+0x120>
    return 0;
  ilock(dp);
80104afa:	83 ec 0c             	sub    $0xc,%esp
80104afd:	89 c7                	mov    %eax,%edi
80104aff:	50                   	push   %eax
80104b00:	e8 db cd ff ff       	call   801018e0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104b05:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b08:	83 c4 0c             	add    $0xc,%esp
80104b0b:	50                   	push   %eax
80104b0c:	56                   	push   %esi
80104b0d:	57                   	push   %edi
80104b0e:	e8 fd d2 ff ff       	call   80101e10 <dirlookup>
80104b13:	83 c4 10             	add    $0x10,%esp
80104b16:	85 c0                	test   %eax,%eax
80104b18:	89 c3                	mov    %eax,%ebx
80104b1a:	74 54                	je     80104b70 <create+0xa0>
    iunlockput(dp);
80104b1c:	83 ec 0c             	sub    $0xc,%esp
80104b1f:	57                   	push   %edi
80104b20:	e8 4b d0 ff ff       	call   80101b70 <iunlockput>
    ilock(ip);
80104b25:	89 1c 24             	mov    %ebx,(%esp)
80104b28:	e8 b3 cd ff ff       	call   801018e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b2d:	83 c4 10             	add    $0x10,%esp
80104b30:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104b35:	75 19                	jne    80104b50 <create+0x80>
80104b37:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104b3c:	89 d8                	mov    %ebx,%eax
80104b3e:	75 10                	jne    80104b50 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b43:	5b                   	pop    %ebx
80104b44:	5e                   	pop    %esi
80104b45:	5f                   	pop    %edi
80104b46:	5d                   	pop    %ebp
80104b47:	c3                   	ret    
80104b48:	90                   	nop
80104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104b50:	83 ec 0c             	sub    $0xc,%esp
80104b53:	53                   	push   %ebx
80104b54:	e8 17 d0 ff ff       	call   80101b70 <iunlockput>
    return 0;
80104b59:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
80104b5f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b61:	5b                   	pop    %ebx
80104b62:	5e                   	pop    %esi
80104b63:	5f                   	pop    %edi
80104b64:	5d                   	pop    %ebp
80104b65:	c3                   	ret    
80104b66:	8d 76 00             	lea    0x0(%esi),%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104b70:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b74:	83 ec 08             	sub    $0x8,%esp
80104b77:	50                   	push   %eax
80104b78:	ff 37                	pushl  (%edi)
80104b7a:	e8 f1 cb ff ff       	call   80101770 <ialloc>
80104b7f:	83 c4 10             	add    $0x10,%esp
80104b82:	85 c0                	test   %eax,%eax
80104b84:	89 c3                	mov    %eax,%ebx
80104b86:	0f 84 cc 00 00 00    	je     80104c58 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104b8c:	83 ec 0c             	sub    $0xc,%esp
80104b8f:	50                   	push   %eax
80104b90:	e8 4b cd ff ff       	call   801018e0 <ilock>
  ip->major = major;
80104b95:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b99:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104b9d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104ba1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104ba5:	b8 01 00 00 00       	mov    $0x1,%eax
80104baa:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104bae:	89 1c 24             	mov    %ebx,(%esp)
80104bb1:	e8 7a cc ff ff       	call   80101830 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104bb6:	83 c4 10             	add    $0x10,%esp
80104bb9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104bbe:	74 40                	je     80104c00 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104bc0:	83 ec 04             	sub    $0x4,%esp
80104bc3:	ff 73 04             	pushl  0x4(%ebx)
80104bc6:	56                   	push   %esi
80104bc7:	57                   	push   %edi
80104bc8:	e8 a3 d4 ff ff       	call   80102070 <dirlink>
80104bcd:	83 c4 10             	add    $0x10,%esp
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	78 77                	js     80104c4b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104bd4:	83 ec 0c             	sub    $0xc,%esp
80104bd7:	57                   	push   %edi
80104bd8:	e8 93 cf ff ff       	call   80101b70 <iunlockput>

  return ip;
80104bdd:	83 c4 10             	add    $0x10,%esp
}
80104be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104be3:	89 d8                	mov    %ebx,%eax
}
80104be5:	5b                   	pop    %ebx
80104be6:	5e                   	pop    %esi
80104be7:	5f                   	pop    %edi
80104be8:	5d                   	pop    %ebp
80104be9:	c3                   	ret    
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104bf0:	31 c0                	xor    %eax,%eax
80104bf2:	e9 49 ff ff ff       	jmp    80104b40 <create+0x70>
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104c00:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104c05:	83 ec 0c             	sub    $0xc,%esp
80104c08:	57                   	push   %edi
80104c09:	e8 22 cc ff ff       	call   80101830 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c0e:	83 c4 0c             	add    $0xc,%esp
80104c11:	ff 73 04             	pushl  0x4(%ebx)
80104c14:	68 5c 7d 10 80       	push   $0x80107d5c
80104c19:	53                   	push   %ebx
80104c1a:	e8 51 d4 ff ff       	call   80102070 <dirlink>
80104c1f:	83 c4 10             	add    $0x10,%esp
80104c22:	85 c0                	test   %eax,%eax
80104c24:	78 18                	js     80104c3e <create+0x16e>
80104c26:	83 ec 04             	sub    $0x4,%esp
80104c29:	ff 77 04             	pushl  0x4(%edi)
80104c2c:	68 5b 7d 10 80       	push   $0x80107d5b
80104c31:	53                   	push   %ebx
80104c32:	e8 39 d4 ff ff       	call   80102070 <dirlink>
80104c37:	83 c4 10             	add    $0x10,%esp
80104c3a:	85 c0                	test   %eax,%eax
80104c3c:	79 82                	jns    80104bc0 <create+0xf0>
      panic("create dots");
80104c3e:	83 ec 0c             	sub    $0xc,%esp
80104c41:	68 4f 7d 10 80       	push   $0x80107d4f
80104c46:	e8 55 b8 ff ff       	call   801004a0 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104c4b:	83 ec 0c             	sub    $0xc,%esp
80104c4e:	68 5e 7d 10 80       	push   $0x80107d5e
80104c53:	e8 48 b8 ff ff       	call   801004a0 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104c58:	83 ec 0c             	sub    $0xc,%esp
80104c5b:	68 40 7d 10 80       	push   $0x80107d40
80104c60:	e8 3b b8 ff ff       	call   801004a0 <panic>
80104c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <argfd.constprop.0>:
extern int numallocblocks;

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	56                   	push   %esi
80104c74:	53                   	push   %ebx
80104c75:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c77:	8d 45 f4             	lea    -0xc(%ebp),%eax
extern int numallocblocks;

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104c7a:	89 d3                	mov    %edx,%ebx
80104c7c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104c7f:	50                   	push   %eax
80104c80:	6a 00                	push   $0x0
80104c82:	e8 f9 fc ff ff       	call   80104980 <argint>
80104c87:	83 c4 10             	add    $0x10,%esp
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	78 32                	js     80104cc0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c8e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c92:	77 2c                	ja     80104cc0 <argfd.constprop.0+0x50>
80104c94:	e8 57 ed ff ff       	call   801039f0 <myproc>
80104c99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c9c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ca0:	85 c0                	test   %eax,%eax
80104ca2:	74 1c                	je     80104cc0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104ca4:	85 f6                	test   %esi,%esi
80104ca6:	74 02                	je     80104caa <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ca8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104caa:	85 db                	test   %ebx,%ebx
80104cac:	74 22                	je     80104cd0 <argfd.constprop.0+0x60>
    *pf = f;
80104cae:	89 03                	mov    %eax,(%ebx)
  return 0;
80104cb0:	31 c0                	xor    %eax,%eax
}
80104cb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb5:	5b                   	pop    %ebx
80104cb6:	5e                   	pop    %esi
80104cb7:	5d                   	pop    %ebp
80104cb8:	c3                   	ret    
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104cc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104cc8:	5b                   	pop    %ebx
80104cc9:	5e                   	pop    %esi
80104cca:	5d                   	pop    %ebp
80104ccb:	c3                   	ret    
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104cd0:	31 c0                	xor    %eax,%eax
80104cd2:	eb de                	jmp    80104cb2 <argfd.constprop.0+0x42>
80104cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ce0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104ce0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ce1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104ce3:	89 e5                	mov    %esp,%ebp
80104ce5:	56                   	push   %esi
80104ce6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ce7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104cea:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ced:	e8 7e ff ff ff       	call   80104c70 <argfd.constprop.0>
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	78 1a                	js     80104d10 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104cf6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104cf8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104cfb:	e8 f0 ec ff ff       	call   801039f0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104d00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d04:	85 d2                	test   %edx,%edx
80104d06:	74 18                	je     80104d20 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104d08:	83 c3 01             	add    $0x1,%ebx
80104d0b:	83 fb 10             	cmp    $0x10,%ebx
80104d0e:	75 f0                	jne    80104d00 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104d10:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104d13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104d18:	5b                   	pop    %ebx
80104d19:	5e                   	pop    %esi
80104d1a:	5d                   	pop    %ebp
80104d1b:	c3                   	ret    
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104d20:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104d24:	83 ec 0c             	sub    $0xc,%esp
80104d27:	ff 75 f4             	pushl  -0xc(%ebp)
80104d2a:	e8 e1 c1 ff ff       	call   80100f10 <filedup>
  return fd;
80104d2f:	83 c4 10             	add    $0x10,%esp
}
80104d32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104d35:	89 d8                	mov    %ebx,%eax
}
80104d37:	5b                   	pop    %ebx
80104d38:	5e                   	pop    %esi
80104d39:	5d                   	pop    %ebp
80104d3a:	c3                   	ret    
80104d3b:	90                   	nop
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d40 <sys_read>:

int
sys_read(void)
{
80104d40:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d41:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104d43:	89 e5                	mov    %esp,%ebp
80104d45:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d4b:	e8 20 ff ff ff       	call   80104c70 <argfd.constprop.0>
80104d50:	85 c0                	test   %eax,%eax
80104d52:	78 4c                	js     80104da0 <sys_read+0x60>
80104d54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d57:	83 ec 08             	sub    $0x8,%esp
80104d5a:	50                   	push   %eax
80104d5b:	6a 02                	push   $0x2
80104d5d:	e8 1e fc ff ff       	call   80104980 <argint>
80104d62:	83 c4 10             	add    $0x10,%esp
80104d65:	85 c0                	test   %eax,%eax
80104d67:	78 37                	js     80104da0 <sys_read+0x60>
80104d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d6c:	83 ec 04             	sub    $0x4,%esp
80104d6f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d72:	50                   	push   %eax
80104d73:	6a 01                	push   $0x1
80104d75:	e8 56 fc ff ff       	call   801049d0 <argptr>
80104d7a:	83 c4 10             	add    $0x10,%esp
80104d7d:	85 c0                	test   %eax,%eax
80104d7f:	78 1f                	js     80104da0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104d81:	83 ec 04             	sub    $0x4,%esp
80104d84:	ff 75 f0             	pushl  -0x10(%ebp)
80104d87:	ff 75 f4             	pushl  -0xc(%ebp)
80104d8a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d8d:	e8 ee c2 ff ff       	call   80101080 <fileread>
80104d92:	83 c4 10             	add    $0x10,%esp
}
80104d95:	c9                   	leave  
80104d96:	c3                   	ret    
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104da5:	c9                   	leave  
80104da6:	c3                   	ret    
80104da7:	89 f6                	mov    %esi,%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <sys_write>:

int
sys_write(void)
{
80104db0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104db1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104db3:	89 e5                	mov    %esp,%ebp
80104db5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104db8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dbb:	e8 b0 fe ff ff       	call   80104c70 <argfd.constprop.0>
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	78 4c                	js     80104e10 <sys_write+0x60>
80104dc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dc7:	83 ec 08             	sub    $0x8,%esp
80104dca:	50                   	push   %eax
80104dcb:	6a 02                	push   $0x2
80104dcd:	e8 ae fb ff ff       	call   80104980 <argint>
80104dd2:	83 c4 10             	add    $0x10,%esp
80104dd5:	85 c0                	test   %eax,%eax
80104dd7:	78 37                	js     80104e10 <sys_write+0x60>
80104dd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ddc:	83 ec 04             	sub    $0x4,%esp
80104ddf:	ff 75 f0             	pushl  -0x10(%ebp)
80104de2:	50                   	push   %eax
80104de3:	6a 01                	push   $0x1
80104de5:	e8 e6 fb ff ff       	call   801049d0 <argptr>
80104dea:	83 c4 10             	add    $0x10,%esp
80104ded:	85 c0                	test   %eax,%eax
80104def:	78 1f                	js     80104e10 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104df1:	83 ec 04             	sub    $0x4,%esp
80104df4:	ff 75 f0             	pushl  -0x10(%ebp)
80104df7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dfa:	ff 75 ec             	pushl  -0x14(%ebp)
80104dfd:	e8 0e c3 ff ff       	call   80101110 <filewrite>
80104e02:	83 c4 10             	add    $0x10,%esp
}
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104e15:	c9                   	leave  
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <sys_close>:

int
sys_close(void)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104e26:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e2c:	e8 3f fe ff ff       	call   80104c70 <argfd.constprop.0>
80104e31:	85 c0                	test   %eax,%eax
80104e33:	78 2b                	js     80104e60 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104e35:	e8 b6 eb ff ff       	call   801039f0 <myproc>
80104e3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e3d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104e40:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e47:	00 
  fileclose(f);
80104e48:	ff 75 f4             	pushl  -0xc(%ebp)
80104e4b:	e8 10 c1 ff ff       	call   80100f60 <fileclose>
  return 0;
80104e50:	83 c4 10             	add    $0x10,%esp
80104e53:	31 c0                	xor    %eax,%eax
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <sys_fstat>:

int
sys_fstat(void)
{
80104e70:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e71:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104e73:	89 e5                	mov    %esp,%ebp
80104e75:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e78:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e7b:	e8 f0 fd ff ff       	call   80104c70 <argfd.constprop.0>
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 2c                	js     80104eb0 <sys_fstat+0x40>
80104e84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e87:	83 ec 04             	sub    $0x4,%esp
80104e8a:	6a 14                	push   $0x14
80104e8c:	50                   	push   %eax
80104e8d:	6a 01                	push   $0x1
80104e8f:	e8 3c fb ff ff       	call   801049d0 <argptr>
80104e94:	83 c4 10             	add    $0x10,%esp
80104e97:	85 c0                	test   %eax,%eax
80104e99:	78 15                	js     80104eb0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104e9b:	83 ec 08             	sub    $0x8,%esp
80104e9e:	ff 75 f4             	pushl  -0xc(%ebp)
80104ea1:	ff 75 f0             	pushl  -0x10(%ebp)
80104ea4:	e8 87 c1 ff ff       	call   80101030 <filestat>
80104ea9:	83 c4 10             	add    $0x10,%esp
}
80104eac:	c9                   	leave  
80104ead:	c3                   	ret    
80104eae:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ec6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104ec9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ecc:	50                   	push   %eax
80104ecd:	6a 00                	push   $0x0
80104ecf:	e8 5c fb ff ff       	call   80104a30 <argstr>
80104ed4:	83 c4 10             	add    $0x10,%esp
80104ed7:	85 c0                	test   %eax,%eax
80104ed9:	0f 88 fb 00 00 00    	js     80104fda <sys_link+0x11a>
80104edf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ee2:	83 ec 08             	sub    $0x8,%esp
80104ee5:	50                   	push   %eax
80104ee6:	6a 01                	push   $0x1
80104ee8:	e8 43 fb ff ff       	call   80104a30 <argstr>
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	0f 88 e2 00 00 00    	js     80104fda <sys_link+0x11a>
    return -1;

  begin_op();
80104ef8:	e8 c3 de ff ff       	call   80102dc0 <begin_op>
  if((ip = namei(old)) == 0){
80104efd:	83 ec 0c             	sub    $0xc,%esp
80104f00:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f03:	e8 28 d2 ff ff       	call   80102130 <namei>
80104f08:	83 c4 10             	add    $0x10,%esp
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	89 c3                	mov    %eax,%ebx
80104f0f:	0f 84 f3 00 00 00    	je     80105008 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104f15:	83 ec 0c             	sub    $0xc,%esp
80104f18:	50                   	push   %eax
80104f19:	e8 c2 c9 ff ff       	call   801018e0 <ilock>
  if(ip->type == T_DIR){
80104f1e:	83 c4 10             	add    $0x10,%esp
80104f21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f26:	0f 84 c4 00 00 00    	je     80104ff0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104f2c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f31:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104f34:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104f37:	53                   	push   %ebx
80104f38:	e8 f3 c8 ff ff       	call   80101830 <iupdate>
  iunlock(ip);
80104f3d:	89 1c 24             	mov    %ebx,(%esp)
80104f40:	e8 7b ca ff ff       	call   801019c0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104f45:	58                   	pop    %eax
80104f46:	5a                   	pop    %edx
80104f47:	57                   	push   %edi
80104f48:	ff 75 d0             	pushl  -0x30(%ebp)
80104f4b:	e8 00 d2 ff ff       	call   80102150 <nameiparent>
80104f50:	83 c4 10             	add    $0x10,%esp
80104f53:	85 c0                	test   %eax,%eax
80104f55:	89 c6                	mov    %eax,%esi
80104f57:	74 5b                	je     80104fb4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104f59:	83 ec 0c             	sub    $0xc,%esp
80104f5c:	50                   	push   %eax
80104f5d:	e8 7e c9 ff ff       	call   801018e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f62:	83 c4 10             	add    $0x10,%esp
80104f65:	8b 03                	mov    (%ebx),%eax
80104f67:	39 06                	cmp    %eax,(%esi)
80104f69:	75 3d                	jne    80104fa8 <sys_link+0xe8>
80104f6b:	83 ec 04             	sub    $0x4,%esp
80104f6e:	ff 73 04             	pushl  0x4(%ebx)
80104f71:	57                   	push   %edi
80104f72:	56                   	push   %esi
80104f73:	e8 f8 d0 ff ff       	call   80102070 <dirlink>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	78 29                	js     80104fa8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	56                   	push   %esi
80104f83:	e8 e8 cb ff ff       	call   80101b70 <iunlockput>
  iput(ip);
80104f88:	89 1c 24             	mov    %ebx,(%esp)
80104f8b:	e8 80 ca ff ff       	call   80101a10 <iput>

  end_op();
80104f90:	e8 9b de ff ff       	call   80102e30 <end_op>

  return 0;
80104f95:	83 c4 10             	add    $0x10,%esp
80104f98:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f9d:	5b                   	pop    %ebx
80104f9e:	5e                   	pop    %esi
80104f9f:	5f                   	pop    %edi
80104fa0:	5d                   	pop    %ebp
80104fa1:	c3                   	ret    
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	56                   	push   %esi
80104fac:	e8 bf cb ff ff       	call   80101b70 <iunlockput>
    goto bad;
80104fb1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104fb4:	83 ec 0c             	sub    $0xc,%esp
80104fb7:	53                   	push   %ebx
80104fb8:	e8 23 c9 ff ff       	call   801018e0 <ilock>
  ip->nlink--;
80104fbd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fc2:	89 1c 24             	mov    %ebx,(%esp)
80104fc5:	e8 66 c8 ff ff       	call   80101830 <iupdate>
  iunlockput(ip);
80104fca:	89 1c 24             	mov    %ebx,(%esp)
80104fcd:	e8 9e cb ff ff       	call   80101b70 <iunlockput>
  end_op();
80104fd2:	e8 59 de ff ff       	call   80102e30 <end_op>
  return -1;
80104fd7:	83 c4 10             	add    $0x10,%esp
}
80104fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104fdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe2:	5b                   	pop    %ebx
80104fe3:	5e                   	pop    %esi
80104fe4:	5f                   	pop    %edi
80104fe5:	5d                   	pop    %ebp
80104fe6:	c3                   	ret    
80104fe7:	89 f6                	mov    %esi,%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104ff0:	83 ec 0c             	sub    $0xc,%esp
80104ff3:	53                   	push   %ebx
80104ff4:	e8 77 cb ff ff       	call   80101b70 <iunlockput>
    end_op();
80104ff9:	e8 32 de ff ff       	call   80102e30 <end_op>
    return -1;
80104ffe:	83 c4 10             	add    $0x10,%esp
80105001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105006:	eb 92                	jmp    80104f9a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105008:	e8 23 de ff ff       	call   80102e30 <end_op>
    return -1;
8010500d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105012:	eb 86                	jmp    80104f9a <sys_link+0xda>
80105014:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010501a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105020 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105026:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105029:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010502c:	50                   	push   %eax
8010502d:	6a 00                	push   $0x0
8010502f:	e8 fc f9 ff ff       	call   80104a30 <argstr>
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	85 c0                	test   %eax,%eax
80105039:	0f 88 82 01 00 00    	js     801051c1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010503f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105042:	e8 79 dd ff ff       	call   80102dc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105047:	83 ec 08             	sub    $0x8,%esp
8010504a:	53                   	push   %ebx
8010504b:	ff 75 c0             	pushl  -0x40(%ebp)
8010504e:	e8 fd d0 ff ff       	call   80102150 <nameiparent>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010505b:	0f 84 6a 01 00 00    	je     801051cb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80105061:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105064:	83 ec 0c             	sub    $0xc,%esp
80105067:	56                   	push   %esi
80105068:	e8 73 c8 ff ff       	call   801018e0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010506d:	58                   	pop    %eax
8010506e:	5a                   	pop    %edx
8010506f:	68 5c 7d 10 80       	push   $0x80107d5c
80105074:	53                   	push   %ebx
80105075:	e8 76 cd ff ff       	call   80101df0 <namecmp>
8010507a:	83 c4 10             	add    $0x10,%esp
8010507d:	85 c0                	test   %eax,%eax
8010507f:	0f 84 fc 00 00 00    	je     80105181 <sys_unlink+0x161>
80105085:	83 ec 08             	sub    $0x8,%esp
80105088:	68 5b 7d 10 80       	push   $0x80107d5b
8010508d:	53                   	push   %ebx
8010508e:	e8 5d cd ff ff       	call   80101df0 <namecmp>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	0f 84 e3 00 00 00    	je     80105181 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010509e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050a1:	83 ec 04             	sub    $0x4,%esp
801050a4:	50                   	push   %eax
801050a5:	53                   	push   %ebx
801050a6:	56                   	push   %esi
801050a7:	e8 64 cd ff ff       	call   80101e10 <dirlookup>
801050ac:	83 c4 10             	add    $0x10,%esp
801050af:	85 c0                	test   %eax,%eax
801050b1:	89 c3                	mov    %eax,%ebx
801050b3:	0f 84 c8 00 00 00    	je     80105181 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
801050b9:	83 ec 0c             	sub    $0xc,%esp
801050bc:	50                   	push   %eax
801050bd:	e8 1e c8 ff ff       	call   801018e0 <ilock>

  if(ip->nlink < 1)
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050ca:	0f 8e 24 01 00 00    	jle    801051f4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801050d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050d5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801050d8:	74 66                	je     80105140 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801050da:	83 ec 04             	sub    $0x4,%esp
801050dd:	6a 10                	push   $0x10
801050df:	6a 00                	push   $0x0
801050e1:	56                   	push   %esi
801050e2:	e8 89 f5 ff ff       	call   80104670 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050e7:	6a 10                	push   $0x10
801050e9:	ff 75 c4             	pushl  -0x3c(%ebp)
801050ec:	56                   	push   %esi
801050ed:	ff 75 b4             	pushl  -0x4c(%ebp)
801050f0:	e8 cb cb ff ff       	call   80101cc0 <writei>
801050f5:	83 c4 20             	add    $0x20,%esp
801050f8:	83 f8 10             	cmp    $0x10,%eax
801050fb:	0f 85 e6 00 00 00    	jne    801051e7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105101:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105106:	0f 84 9c 00 00 00    	je     801051a8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105112:	e8 59 ca ff ff       	call   80101b70 <iunlockput>

  ip->nlink--;
80105117:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010511c:	89 1c 24             	mov    %ebx,(%esp)
8010511f:	e8 0c c7 ff ff       	call   80101830 <iupdate>
  iunlockput(ip);
80105124:	89 1c 24             	mov    %ebx,(%esp)
80105127:	e8 44 ca ff ff       	call   80101b70 <iunlockput>

  end_op();
8010512c:	e8 ff dc ff ff       	call   80102e30 <end_op>

  return 0;
80105131:	83 c4 10             	add    $0x10,%esp
80105134:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105139:	5b                   	pop    %ebx
8010513a:	5e                   	pop    %esi
8010513b:	5f                   	pop    %edi
8010513c:	5d                   	pop    %ebp
8010513d:	c3                   	ret    
8010513e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105140:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105144:	76 94                	jbe    801050da <sys_unlink+0xba>
80105146:	bf 20 00 00 00       	mov    $0x20,%edi
8010514b:	eb 0f                	jmp    8010515c <sys_unlink+0x13c>
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
80105150:	83 c7 10             	add    $0x10,%edi
80105153:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105156:	0f 83 7e ff ff ff    	jae    801050da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010515c:	6a 10                	push   $0x10
8010515e:	57                   	push   %edi
8010515f:	56                   	push   %esi
80105160:	53                   	push   %ebx
80105161:	e8 5a ca ff ff       	call   80101bc0 <readi>
80105166:	83 c4 10             	add    $0x10,%esp
80105169:	83 f8 10             	cmp    $0x10,%eax
8010516c:	75 6c                	jne    801051da <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010516e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105173:	74 db                	je     80105150 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80105175:	83 ec 0c             	sub    $0xc,%esp
80105178:	53                   	push   %ebx
80105179:	e8 f2 c9 ff ff       	call   80101b70 <iunlockput>
    goto bad;
8010517e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105181:	83 ec 0c             	sub    $0xc,%esp
80105184:	ff 75 b4             	pushl  -0x4c(%ebp)
80105187:	e8 e4 c9 ff ff       	call   80101b70 <iunlockput>
  end_op();
8010518c:	e8 9f dc ff ff       	call   80102e30 <end_op>
  return -1;
80105191:	83 c4 10             	add    $0x10,%esp
}
80105194:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010519c:	5b                   	pop    %ebx
8010519d:	5e                   	pop    %esi
8010519e:	5f                   	pop    %edi
8010519f:	5d                   	pop    %ebp
801051a0:	c3                   	ret    
801051a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801051a8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801051ab:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801051ae:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801051b3:	50                   	push   %eax
801051b4:	e8 77 c6 ff ff       	call   80101830 <iupdate>
801051b9:	83 c4 10             	add    $0x10,%esp
801051bc:	e9 4b ff ff ff       	jmp    8010510c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
801051c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c6:	e9 6b ff ff ff       	jmp    80105136 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
801051cb:	e8 60 dc ff ff       	call   80102e30 <end_op>
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d5:	e9 5c ff ff ff       	jmp    80105136 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801051da:	83 ec 0c             	sub    $0xc,%esp
801051dd:	68 80 7d 10 80       	push   $0x80107d80
801051e2:	e8 b9 b2 ff ff       	call   801004a0 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801051e7:	83 ec 0c             	sub    $0xc,%esp
801051ea:	68 92 7d 10 80       	push   $0x80107d92
801051ef:	e8 ac b2 ff ff       	call   801004a0 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	68 6e 7d 10 80       	push   $0x80107d6e
801051fc:	e8 9f b2 ff ff       	call   801004a0 <panic>
80105201:	eb 0d                	jmp    80105210 <sys_open>
80105203:	90                   	nop
80105204:	90                   	nop
80105205:	90                   	nop
80105206:	90                   	nop
80105207:	90                   	nop
80105208:	90                   	nop
80105209:	90                   	nop
8010520a:	90                   	nop
8010520b:	90                   	nop
8010520c:	90                   	nop
8010520d:	90                   	nop
8010520e:	90                   	nop
8010520f:	90                   	nop

80105210 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
80105215:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105216:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105219:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010521c:	50                   	push   %eax
8010521d:	6a 00                	push   $0x0
8010521f:	e8 0c f8 ff ff       	call   80104a30 <argstr>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	0f 88 9e 00 00 00    	js     801052cd <sys_open+0xbd>
8010522f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105232:	83 ec 08             	sub    $0x8,%esp
80105235:	50                   	push   %eax
80105236:	6a 01                	push   $0x1
80105238:	e8 43 f7 ff ff       	call   80104980 <argint>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	85 c0                	test   %eax,%eax
80105242:	0f 88 85 00 00 00    	js     801052cd <sys_open+0xbd>
    return -1;

  begin_op();
80105248:	e8 73 db ff ff       	call   80102dc0 <begin_op>

  if(omode & O_CREATE){
8010524d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105251:	0f 85 89 00 00 00    	jne    801052e0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105257:	83 ec 0c             	sub    $0xc,%esp
8010525a:	ff 75 e0             	pushl  -0x20(%ebp)
8010525d:	e8 ce ce ff ff       	call   80102130 <namei>
80105262:	83 c4 10             	add    $0x10,%esp
80105265:	85 c0                	test   %eax,%eax
80105267:	89 c6                	mov    %eax,%esi
80105269:	0f 84 8e 00 00 00    	je     801052fd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010526f:	83 ec 0c             	sub    $0xc,%esp
80105272:	50                   	push   %eax
80105273:	e8 68 c6 ff ff       	call   801018e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105278:	83 c4 10             	add    $0x10,%esp
8010527b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105280:	0f 84 d2 00 00 00    	je     80105358 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105286:	e8 15 bc ff ff       	call   80100ea0 <filealloc>
8010528b:	85 c0                	test   %eax,%eax
8010528d:	89 c7                	mov    %eax,%edi
8010528f:	74 2b                	je     801052bc <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105291:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105293:	e8 58 e7 ff ff       	call   801039f0 <myproc>
80105298:	90                   	nop
80105299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801052a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052a4:	85 d2                	test   %edx,%edx
801052a6:	74 68                	je     80105310 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801052a8:	83 c3 01             	add    $0x1,%ebx
801052ab:	83 fb 10             	cmp    $0x10,%ebx
801052ae:	75 f0                	jne    801052a0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	57                   	push   %edi
801052b4:	e8 a7 bc ff ff       	call   80100f60 <fileclose>
801052b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052bc:	83 ec 0c             	sub    $0xc,%esp
801052bf:	56                   	push   %esi
801052c0:	e8 ab c8 ff ff       	call   80101b70 <iunlockput>
    end_op();
801052c5:	e8 66 db ff ff       	call   80102e30 <end_op>
    return -1;
801052ca:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801052cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801052d5:	5b                   	pop    %ebx
801052d6:	5e                   	pop    %esi
801052d7:	5f                   	pop    %edi
801052d8:	5d                   	pop    %ebp
801052d9:	c3                   	ret    
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052e6:	31 c9                	xor    %ecx,%ecx
801052e8:	6a 00                	push   $0x0
801052ea:	ba 02 00 00 00       	mov    $0x2,%edx
801052ef:	e8 dc f7 ff ff       	call   80104ad0 <create>
    if(ip == 0){
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801052f9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052fb:	75 89                	jne    80105286 <sys_open+0x76>
      end_op();
801052fd:	e8 2e db ff ff       	call   80102e30 <end_op>
      return -1;
80105302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105307:	eb 43                	jmp    8010534c <sys_open+0x13c>
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105310:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105313:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105317:	56                   	push   %esi
80105318:	e8 a3 c6 ff ff       	call   801019c0 <iunlock>
  end_op();
8010531d:	e8 0e db ff ff       	call   80102e30 <end_op>

  f->type = FD_INODE;
80105322:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105328:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010532b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010532e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105331:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105338:	89 d0                	mov    %edx,%eax
8010533a:	83 e0 01             	and    $0x1,%eax
8010533d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105340:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105343:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105346:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010534a:	89 d8                	mov    %ebx,%eax
}
8010534c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010534f:	5b                   	pop    %ebx
80105350:	5e                   	pop    %esi
80105351:	5f                   	pop    %edi
80105352:	5d                   	pop    %ebp
80105353:	c3                   	ret    
80105354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105358:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010535b:	85 c9                	test   %ecx,%ecx
8010535d:	0f 84 23 ff ff ff    	je     80105286 <sys_open+0x76>
80105363:	e9 54 ff ff ff       	jmp    801052bc <sys_open+0xac>
80105368:	90                   	nop
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105376:	e8 45 da ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010537b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010537e:	83 ec 08             	sub    $0x8,%esp
80105381:	50                   	push   %eax
80105382:	6a 00                	push   $0x0
80105384:	e8 a7 f6 ff ff       	call   80104a30 <argstr>
80105389:	83 c4 10             	add    $0x10,%esp
8010538c:	85 c0                	test   %eax,%eax
8010538e:	78 30                	js     801053c0 <sys_mkdir+0x50>
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105396:	31 c9                	xor    %ecx,%ecx
80105398:	6a 00                	push   $0x0
8010539a:	ba 01 00 00 00       	mov    $0x1,%edx
8010539f:	e8 2c f7 ff ff       	call   80104ad0 <create>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	74 15                	je     801053c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801053ab:	83 ec 0c             	sub    $0xc,%esp
801053ae:	50                   	push   %eax
801053af:	e8 bc c7 ff ff       	call   80101b70 <iunlockput>
  end_op();
801053b4:	e8 77 da ff ff       	call   80102e30 <end_op>
  return 0;
801053b9:	83 c4 10             	add    $0x10,%esp
801053bc:	31 c0                	xor    %eax,%eax
}
801053be:	c9                   	leave  
801053bf:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801053c0:	e8 6b da ff ff       	call   80102e30 <end_op>
    return -1;
801053c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801053ca:	c9                   	leave  
801053cb:	c3                   	ret    
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053d0 <sys_mknod>:

int
sys_mknod(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053d6:	e8 e5 d9 ff ff       	call   80102dc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053de:	83 ec 08             	sub    $0x8,%esp
801053e1:	50                   	push   %eax
801053e2:	6a 00                	push   $0x0
801053e4:	e8 47 f6 ff ff       	call   80104a30 <argstr>
801053e9:	83 c4 10             	add    $0x10,%esp
801053ec:	85 c0                	test   %eax,%eax
801053ee:	78 60                	js     80105450 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053f3:	83 ec 08             	sub    $0x8,%esp
801053f6:	50                   	push   %eax
801053f7:	6a 01                	push   $0x1
801053f9:	e8 82 f5 ff ff       	call   80104980 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	85 c0                	test   %eax,%eax
80105403:	78 4b                	js     80105450 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105405:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105408:	83 ec 08             	sub    $0x8,%esp
8010540b:	50                   	push   %eax
8010540c:	6a 02                	push   $0x2
8010540e:	e8 6d f5 ff ff       	call   80104980 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	78 36                	js     80105450 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010541a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010541e:	83 ec 0c             	sub    $0xc,%esp
80105421:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105425:	ba 03 00 00 00       	mov    $0x3,%edx
8010542a:	50                   	push   %eax
8010542b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010542e:	e8 9d f6 ff ff       	call   80104ad0 <create>
80105433:	83 c4 10             	add    $0x10,%esp
80105436:	85 c0                	test   %eax,%eax
80105438:	74 16                	je     80105450 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010543a:	83 ec 0c             	sub    $0xc,%esp
8010543d:	50                   	push   %eax
8010543e:	e8 2d c7 ff ff       	call   80101b70 <iunlockput>
  end_op();
80105443:	e8 e8 d9 ff ff       	call   80102e30 <end_op>
  return 0;
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	31 c0                	xor    %eax,%eax
}
8010544d:	c9                   	leave  
8010544e:	c3                   	ret    
8010544f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105450:	e8 db d9 ff ff       	call   80102e30 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010545a:	c9                   	leave  
8010545b:	c3                   	ret    
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_chdir>:

int
sys_chdir(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	53                   	push   %ebx
80105465:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105468:	e8 83 e5 ff ff       	call   801039f0 <myproc>
8010546d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010546f:	e8 4c d9 ff ff       	call   80102dc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105474:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105477:	83 ec 08             	sub    $0x8,%esp
8010547a:	50                   	push   %eax
8010547b:	6a 00                	push   $0x0
8010547d:	e8 ae f5 ff ff       	call   80104a30 <argstr>
80105482:	83 c4 10             	add    $0x10,%esp
80105485:	85 c0                	test   %eax,%eax
80105487:	78 77                	js     80105500 <sys_chdir+0xa0>
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	ff 75 f4             	pushl  -0xc(%ebp)
8010548f:	e8 9c cc ff ff       	call   80102130 <namei>
80105494:	83 c4 10             	add    $0x10,%esp
80105497:	85 c0                	test   %eax,%eax
80105499:	89 c3                	mov    %eax,%ebx
8010549b:	74 63                	je     80105500 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	50                   	push   %eax
801054a1:	e8 3a c4 ff ff       	call   801018e0 <ilock>
  if(ip->type != T_DIR){
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054ae:	75 30                	jne    801054e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	53                   	push   %ebx
801054b4:	e8 07 c5 ff ff       	call   801019c0 <iunlock>
  iput(curproc->cwd);
801054b9:	58                   	pop    %eax
801054ba:	ff 76 68             	pushl  0x68(%esi)
801054bd:	e8 4e c5 ff ff       	call   80101a10 <iput>
  end_op();
801054c2:	e8 69 d9 ff ff       	call   80102e30 <end_op>
  curproc->cwd = ip;
801054c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	31 c0                	xor    %eax,%eax
}
801054cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d2:	5b                   	pop    %ebx
801054d3:	5e                   	pop    %esi
801054d4:	5d                   	pop    %ebp
801054d5:	c3                   	ret    
801054d6:	8d 76 00             	lea    0x0(%esi),%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	53                   	push   %ebx
801054e4:	e8 87 c6 ff ff       	call   80101b70 <iunlockput>
    end_op();
801054e9:	e8 42 d9 ff ff       	call   80102e30 <end_op>
    return -1;
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f6:	eb d7                	jmp    801054cf <sys_chdir+0x6f>
801054f8:	90                   	nop
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105500:	e8 2b d9 ff ff       	call   80102e30 <end_op>
    return -1;
80105505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550a:	eb c3                	jmp    801054cf <sys_chdir+0x6f>
8010550c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105510 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105516:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010551c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105522:	50                   	push   %eax
80105523:	6a 00                	push   $0x0
80105525:	e8 06 f5 ff ff       	call   80104a30 <argstr>
8010552a:	83 c4 10             	add    $0x10,%esp
8010552d:	85 c0                	test   %eax,%eax
8010552f:	78 7f                	js     801055b0 <sys_exec+0xa0>
80105531:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105537:	83 ec 08             	sub    $0x8,%esp
8010553a:	50                   	push   %eax
8010553b:	6a 01                	push   $0x1
8010553d:	e8 3e f4 ff ff       	call   80104980 <argint>
80105542:	83 c4 10             	add    $0x10,%esp
80105545:	85 c0                	test   %eax,%eax
80105547:	78 67                	js     801055b0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105549:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010554f:	83 ec 04             	sub    $0x4,%esp
80105552:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105558:	68 80 00 00 00       	push   $0x80
8010555d:	6a 00                	push   $0x0
8010555f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105565:	50                   	push   %eax
80105566:	31 db                	xor    %ebx,%ebx
80105568:	e8 03 f1 ff ff       	call   80104670 <memset>
8010556d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105570:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105576:	83 ec 08             	sub    $0x8,%esp
80105579:	57                   	push   %edi
8010557a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010557d:	50                   	push   %eax
8010557e:	e8 5d f3 ff ff       	call   801048e0 <fetchint>
80105583:	83 c4 10             	add    $0x10,%esp
80105586:	85 c0                	test   %eax,%eax
80105588:	78 26                	js     801055b0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010558a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105590:	85 c0                	test   %eax,%eax
80105592:	74 2c                	je     801055c0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105594:	83 ec 08             	sub    $0x8,%esp
80105597:	56                   	push   %esi
80105598:	50                   	push   %eax
80105599:	e8 82 f3 ff ff       	call   80104920 <fetchstr>
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	85 c0                	test   %eax,%eax
801055a3:	78 0b                	js     801055b0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801055a5:	83 c3 01             	add    $0x1,%ebx
801055a8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801055ab:	83 fb 20             	cmp    $0x20,%ebx
801055ae:	75 c0                	jne    80105570 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801055b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801055b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801055b8:	5b                   	pop    %ebx
801055b9:	5e                   	pop    %esi
801055ba:	5f                   	pop    %edi
801055bb:	5d                   	pop    %ebp
801055bc:	c3                   	ret    
801055bd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801055c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055c6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801055c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055d0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801055d4:	50                   	push   %eax
801055d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801055db:	e8 40 b5 ff ff       	call   80100b20 <exec>
801055e0:	83 c4 10             	add    $0x10,%esp
}
801055e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055e6:	5b                   	pop    %ebx
801055e7:	5e                   	pop    %esi
801055e8:	5f                   	pop    %edi
801055e9:	5d                   	pop    %ebp
801055ea:	c3                   	ret    
801055eb:	90                   	nop
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055f0 <sys_pipe>:

int
sys_pipe(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	57                   	push   %edi
801055f4:	56                   	push   %esi
801055f5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055f6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801055f9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055fc:	6a 08                	push   $0x8
801055fe:	50                   	push   %eax
801055ff:	6a 00                	push   $0x0
80105601:	e8 ca f3 ff ff       	call   801049d0 <argptr>
80105606:	83 c4 10             	add    $0x10,%esp
80105609:	85 c0                	test   %eax,%eax
8010560b:	78 4a                	js     80105657 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010560d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105610:	83 ec 08             	sub    $0x8,%esp
80105613:	50                   	push   %eax
80105614:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105617:	50                   	push   %eax
80105618:	e8 43 de ff ff       	call   80103460 <pipealloc>
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	85 c0                	test   %eax,%eax
80105622:	78 33                	js     80105657 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105624:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105626:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105629:	e8 c2 e3 ff ff       	call   801039f0 <myproc>
8010562e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105630:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105634:	85 f6                	test   %esi,%esi
80105636:	74 30                	je     80105668 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105638:	83 c3 01             	add    $0x1,%ebx
8010563b:	83 fb 10             	cmp    $0x10,%ebx
8010563e:	75 f0                	jne    80105630 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	ff 75 e0             	pushl  -0x20(%ebp)
80105646:	e8 15 b9 ff ff       	call   80100f60 <fileclose>
    fileclose(wf);
8010564b:	58                   	pop    %eax
8010564c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010564f:	e8 0c b9 ff ff       	call   80100f60 <fileclose>
    return -1;
80105654:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105657:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010565a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010565f:	5b                   	pop    %ebx
80105660:	5e                   	pop    %esi
80105661:	5f                   	pop    %edi
80105662:	5d                   	pop    %ebp
80105663:	c3                   	ret    
80105664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105668:	8d 73 08             	lea    0x8(%ebx),%esi
8010566b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010566f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105672:	e8 79 e3 ff ff       	call   801039f0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105677:	31 d2                	xor    %edx,%edx
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105680:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105684:	85 c9                	test   %ecx,%ecx
80105686:	74 18                	je     801056a0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105688:	83 c2 01             	add    $0x1,%edx
8010568b:	83 fa 10             	cmp    $0x10,%edx
8010568e:	75 f0                	jne    80105680 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105690:	e8 5b e3 ff ff       	call   801039f0 <myproc>
80105695:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010569c:	00 
8010569d:	eb a1                	jmp    80105640 <sys_pipe+0x50>
8010569f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801056a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801056a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801056af:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801056b2:	31 c0                	xor    %eax,%eax
}
801056b4:	5b                   	pop    %ebx
801056b5:	5e                   	pop    %esi
801056b6:	5f                   	pop    %edi
801056b7:	5d                   	pop    %ebp
801056b8:	c3                   	ret    
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_bstat>:

/* returns the number of swapped pages
 */
int
sys_bstat(void)
{
801056c0:	55                   	push   %ebp
	return numallocblocks;
}
801056c1:	a1 5c b5 10 80       	mov    0x8010b55c,%eax

/* returns the number of swapped pages
 */
int
sys_bstat(void)
{
801056c6:	89 e5                	mov    %esp,%ebp
	return numallocblocks;
}
801056c8:	5d                   	pop    %ebp
801056c9:	c3                   	ret    
801056ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801056d0 <sys_swap>:

/* swap system call handler.
 */
int
sys_swap(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 20             	sub    $0x20,%esp
	uint addr;
  	if(argint(0, (int*)&addr) < 0)
801056d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d9:	50                   	push   %eax
801056da:	6a 00                	push   $0x0
801056dc:	e8 9f f2 ff ff       	call   80104980 <argint>
801056e1:	83 c4 10             	add    $0x10,%esp
801056e4:	85 c0                	test   %eax,%eax
801056e6:	78 20                	js     80105708 <sys_swap+0x38>
   		return -1;
	struct proc *curproc = myproc();
801056e8:	e8 03 e3 ff ff       	call   801039f0 <myproc>
	int b = swap_page(curproc->pgdir);
801056ed:	83 ec 0c             	sub    $0xc,%esp
801056f0:	ff 70 04             	pushl  0x4(%eax)
801056f3:	e8 b8 05 00 00       	call   80105cb0 <swap_page>
	if(b!=1)
801056f8:	83 c4 10             	add    $0x10,%esp
801056fb:	83 f8 01             	cmp    $0x1,%eax
801056fe:	75 0f                	jne    8010570f <sys_swap+0x3f>
		panic("panic");
	
  	return 0;
80105700:	31 c0                	xor    %eax,%eax
}
80105702:	c9                   	leave  
80105703:	c3                   	ret    
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
sys_swap(void)
{
	uint addr;
  	if(argint(0, (int*)&addr) < 0)
   		return -1;
80105708:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	int b = swap_page(curproc->pgdir);
	if(b!=1)
		panic("panic");
	
  	return 0;
}
8010570d:	c9                   	leave  
8010570e:	c3                   	ret    
  	if(argint(0, (int*)&addr) < 0)
   		return -1;
	struct proc *curproc = myproc();
	int b = swap_page(curproc->pgdir);
	if(b!=1)
		panic("panic");
8010570f:	83 ec 0c             	sub    $0xc,%esp
80105712:	68 a1 7d 10 80       	push   $0x80107da1
80105717:	e8 84 ad ff ff       	call   801004a0 <panic>
8010571c:	66 90                	xchg   %ax,%ax
8010571e:	66 90                	xchg   %ax,%ax

80105720 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105723:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105724:	e9 37 e4 ff ff       	jmp    80103b60 <fork>
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_exit>:
}

int
sys_exit(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 08             	sub    $0x8,%esp
  exit();
80105736:	e8 b5 e6 ff ff       	call   80103df0 <exit>
  return 0;  // not reached
}
8010573b:	31 c0                	xor    %eax,%eax
8010573d:	c9                   	leave  
8010573e:	c3                   	ret    
8010573f:	90                   	nop

80105740 <sys_wait>:

int
sys_wait(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105743:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105744:	e9 e7 e8 ff ff       	jmp    80104030 <wait>
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_kill>:
}

int
sys_kill(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105756:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105759:	50                   	push   %eax
8010575a:	6a 00                	push   $0x0
8010575c:	e8 1f f2 ff ff       	call   80104980 <argint>
80105761:	83 c4 10             	add    $0x10,%esp
80105764:	85 c0                	test   %eax,%eax
80105766:	78 18                	js     80105780 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	ff 75 f4             	pushl  -0xc(%ebp)
8010576e:	e8 2d ea ff ff       	call   801041a0 <kill>
80105773:	83 c4 10             	add    $0x10,%esp
}
80105776:	c9                   	leave  
80105777:	c3                   	ret    
80105778:	90                   	nop
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105785:	c9                   	leave  
80105786:	c3                   	ret    
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <sys_getpid>:

int
sys_getpid(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105796:	e8 55 e2 ff ff       	call   801039f0 <myproc>
8010579b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010579e:	c9                   	leave  
8010579f:	c3                   	ret    

801057a0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801057a7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057aa:	50                   	push   %eax
801057ab:	6a 00                	push   $0x0
801057ad:	e8 ce f1 ff ff       	call   80104980 <argint>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	85 c0                	test   %eax,%eax
801057b7:	78 27                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801057b9:	e8 32 e2 ff ff       	call   801039f0 <myproc>
  if(growproc(n) < 0)
801057be:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801057c1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801057c3:	ff 75 f4             	pushl  -0xc(%ebp)
801057c6:	e8 45 e3 ff ff       	call   80103b10 <growproc>
801057cb:	83 c4 10             	add    $0x10,%esp
801057ce:	85 c0                	test   %eax,%eax
801057d0:	78 0e                	js     801057e0 <sys_sbrk+0x40>
    return -1;
  return addr;
801057d2:	89 d8                	mov    %ebx,%eax
}
801057d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057d7:	c9                   	leave  
801057d8:	c3                   	ret    
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801057e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e5:	eb ed                	jmp    801057d4 <sys_sbrk+0x34>
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
801057f7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801057fa:	50                   	push   %eax
801057fb:	6a 00                	push   $0x0
801057fd:	e8 7e f1 ff ff       	call   80104980 <argint>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	85 c0                	test   %eax,%eax
80105807:	0f 88 8a 00 00 00    	js     80105897 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010580d:	83 ec 0c             	sub    $0xc,%esp
80105810:	68 60 5c 11 80       	push   $0x80115c60
80105815:	e8 e6 ec ff ff       	call   80104500 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010581a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010581d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105820:	8b 1d a0 64 11 80    	mov    0x801164a0,%ebx
  while(ticks - ticks0 < n){
80105826:	85 d2                	test   %edx,%edx
80105828:	75 27                	jne    80105851 <sys_sleep+0x61>
8010582a:	eb 54                	jmp    80105880 <sys_sleep+0x90>
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105830:	83 ec 08             	sub    $0x8,%esp
80105833:	68 60 5c 11 80       	push   $0x80115c60
80105838:	68 a0 64 11 80       	push   $0x801164a0
8010583d:	e8 2e e7 ff ff       	call   80103f70 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105842:	a1 a0 64 11 80       	mov    0x801164a0,%eax
80105847:	83 c4 10             	add    $0x10,%esp
8010584a:	29 d8                	sub    %ebx,%eax
8010584c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010584f:	73 2f                	jae    80105880 <sys_sleep+0x90>
    if(myproc()->killed){
80105851:	e8 9a e1 ff ff       	call   801039f0 <myproc>
80105856:	8b 40 24             	mov    0x24(%eax),%eax
80105859:	85 c0                	test   %eax,%eax
8010585b:	74 d3                	je     80105830 <sys_sleep+0x40>
      release(&tickslock);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	68 60 5c 11 80       	push   $0x80115c60
80105865:	e8 b6 ed ff ff       	call   80104620 <release>
      return -1;
8010586a:	83 c4 10             	add    $0x10,%esp
8010586d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105872:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105880:	83 ec 0c             	sub    $0xc,%esp
80105883:	68 60 5c 11 80       	push   $0x80115c60
80105888:	e8 93 ed ff ff       	call   80104620 <release>
  return 0;
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	31 c0                	xor    %eax,%eax
}
80105892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105895:	c9                   	leave  
80105896:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105897:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589c:	eb d4                	jmp    80105872 <sys_sleep+0x82>
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	53                   	push   %ebx
801058a4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058a7:	68 60 5c 11 80       	push   $0x80115c60
801058ac:	e8 4f ec ff ff       	call   80104500 <acquire>
  xticks = ticks;
801058b1:	8b 1d a0 64 11 80    	mov    0x801164a0,%ebx
  release(&tickslock);
801058b7:	c7 04 24 60 5c 11 80 	movl   $0x80115c60,(%esp)
801058be:	e8 5d ed ff ff       	call   80104620 <release>
  return xticks;
}
801058c3:	89 d8                	mov    %ebx,%eax
801058c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058c8:	c9                   	leave  
801058c9:	c3                   	ret    

801058ca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058ca:	1e                   	push   %ds
  pushl %es
801058cb:	06                   	push   %es
  pushl %fs
801058cc:	0f a0                	push   %fs
  pushl %gs
801058ce:	0f a8                	push   %gs
  pushal
801058d0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058d1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058d5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058d7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058d9:	54                   	push   %esp
  call trap
801058da:	e8 e1 00 00 00       	call   801059c0 <trap>
  addl $4, %esp
801058df:	83 c4 04             	add    $0x4,%esp

801058e2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058e2:	61                   	popa   
  popl %gs
801058e3:	0f a9                	pop    %gs
  popl %fs
801058e5:	0f a1                	pop    %fs
  popl %es
801058e7:	07                   	pop    %es
  popl %ds
801058e8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058e9:	83 c4 08             	add    $0x8,%esp
  iret
801058ec:	cf                   	iret   
801058ed:	66 90                	xchg   %ax,%ax
801058ef:	90                   	nop

801058f0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801058f0:	31 c0                	xor    %eax,%eax
801058f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801058f8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801058ff:	b9 08 00 00 00       	mov    $0x8,%ecx
80105904:	c6 04 c5 a4 5c 11 80 	movb   $0x0,-0x7feea35c(,%eax,8)
8010590b:	00 
8010590c:	66 89 0c c5 a2 5c 11 	mov    %cx,-0x7feea35e(,%eax,8)
80105913:	80 
80105914:	c6 04 c5 a5 5c 11 80 	movb   $0x8e,-0x7feea35b(,%eax,8)
8010591b:	8e 
8010591c:	66 89 14 c5 a0 5c 11 	mov    %dx,-0x7feea360(,%eax,8)
80105923:	80 
80105924:	c1 ea 10             	shr    $0x10,%edx
80105927:	66 89 14 c5 a6 5c 11 	mov    %dx,-0x7feea35a(,%eax,8)
8010592e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010592f:	83 c0 01             	add    $0x1,%eax
80105932:	3d 00 01 00 00       	cmp    $0x100,%eax
80105937:	75 bf                	jne    801058f8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105939:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010593a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010593f:	89 e5                	mov    %esp,%ebp
80105941:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105944:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105949:	68 a7 7d 10 80       	push   $0x80107da7
8010594e:	68 60 5c 11 80       	push   $0x80115c60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105953:	66 89 15 a2 5e 11 80 	mov    %dx,0x80115ea2
8010595a:	c6 05 a4 5e 11 80 00 	movb   $0x0,0x80115ea4
80105961:	66 a3 a0 5e 11 80    	mov    %ax,0x80115ea0
80105967:	c1 e8 10             	shr    $0x10,%eax
8010596a:	c6 05 a5 5e 11 80 ef 	movb   $0xef,0x80115ea5
80105971:	66 a3 a6 5e 11 80    	mov    %ax,0x80115ea6

  initlock(&tickslock, "time");
80105977:	e8 84 ea ff ff       	call   80104400 <initlock>
}
8010597c:	83 c4 10             	add    $0x10,%esp
8010597f:	c9                   	leave  
80105980:	c3                   	ret    
80105981:	eb 0d                	jmp    80105990 <idtinit>
80105983:	90                   	nop
80105984:	90                   	nop
80105985:	90                   	nop
80105986:	90                   	nop
80105987:	90                   	nop
80105988:	90                   	nop
80105989:	90                   	nop
8010598a:	90                   	nop
8010598b:	90                   	nop
8010598c:	90                   	nop
8010598d:	90                   	nop
8010598e:	90                   	nop
8010598f:	90                   	nop

80105990 <idtinit>:

void
idtinit(void)
{
80105990:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105991:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105996:	89 e5                	mov    %esp,%ebp
80105998:	83 ec 10             	sub    $0x10,%esp
8010599b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010599f:	b8 a0 5c 11 80       	mov    $0x80115ca0,%eax
801059a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059a8:	c1 e8 10             	shr    $0x10,%eax
801059ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801059af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059b5:	c9                   	leave  
801059b6:	c3                   	ret    
801059b7:	89 f6                	mov    %esi,%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	57                   	push   %edi
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
801059c6:	83 ec 1c             	sub    $0x1c,%esp
801059c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801059cc:	8b 47 30             	mov    0x30(%edi),%eax
801059cf:	83 f8 40             	cmp    $0x40,%eax
801059d2:	0f 84 98 01 00 00    	je     80105b70 <trap+0x1b0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059d8:	83 e8 0e             	sub    $0xe,%eax
801059db:	83 f8 31             	cmp    $0x31,%eax
801059de:	77 10                	ja     801059f0 <trap+0x30>
801059e0:	ff 24 85 50 7e 10 80 	jmp    *-0x7fef81b0(,%eax,4)
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801059f0:	e8 fb df ff ff       	call   801039f0 <myproc>
801059f5:	85 c0                	test   %eax,%eax
801059f7:	0f 84 e7 01 00 00    	je     80105be4 <trap+0x224>
801059fd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105a01:	0f 84 dd 01 00 00    	je     80105be4 <trap+0x224>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105a07:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a0a:	8b 57 38             	mov    0x38(%edi),%edx
80105a0d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105a10:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105a13:	e8 b8 df ff ff       	call   801039d0 <cpuid>
80105a18:	8b 77 34             	mov    0x34(%edi),%esi
80105a1b:	8b 5f 30             	mov    0x30(%edi),%ebx
80105a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a21:	e8 ca df ff ff       	call   801039f0 <myproc>
80105a26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a29:	e8 c2 df ff ff       	call   801039f0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a2e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a31:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a34:	51                   	push   %ecx
80105a35:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a36:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a39:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a3c:	56                   	push   %esi
80105a3d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a3e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a41:	52                   	push   %edx
80105a42:	ff 70 10             	pushl  0x10(%eax)
80105a45:	68 0c 7e 10 80       	push   $0x80107e0c
80105a4a:	e8 41 ad ff ff       	call   80100790 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a4f:	83 c4 20             	add    $0x20,%esp
80105a52:	e8 99 df ff ff       	call   801039f0 <myproc>
80105a57:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105a5e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a60:	e8 8b df ff ff       	call   801039f0 <myproc>
80105a65:	85 c0                	test   %eax,%eax
80105a67:	74 0c                	je     80105a75 <trap+0xb5>
80105a69:	e8 82 df ff ff       	call   801039f0 <myproc>
80105a6e:	8b 50 24             	mov    0x24(%eax),%edx
80105a71:	85 d2                	test   %edx,%edx
80105a73:	75 4b                	jne    80105ac0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a75:	e8 76 df ff ff       	call   801039f0 <myproc>
80105a7a:	85 c0                	test   %eax,%eax
80105a7c:	74 0b                	je     80105a89 <trap+0xc9>
80105a7e:	e8 6d df ff ff       	call   801039f0 <myproc>
80105a83:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a87:	74 4f                	je     80105ad8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a89:	e8 62 df ff ff       	call   801039f0 <myproc>
80105a8e:	85 c0                	test   %eax,%eax
80105a90:	74 1d                	je     80105aaf <trap+0xef>
80105a92:	e8 59 df ff ff       	call   801039f0 <myproc>
80105a97:	8b 40 24             	mov    0x24(%eax),%eax
80105a9a:	85 c0                	test   %eax,%eax
80105a9c:	74 11                	je     80105aaf <trap+0xef>
80105a9e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105aa2:	83 e0 03             	and    $0x3,%eax
80105aa5:	66 83 f8 03          	cmp    $0x3,%ax
80105aa9:	0f 84 ea 00 00 00    	je     80105b99 <trap+0x1d9>
    exit();
}
80105aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab2:	5b                   	pop    %ebx
80105ab3:	5e                   	pop    %esi
80105ab4:	5f                   	pop    %edi
80105ab5:	5d                   	pop    %ebp
80105ab6:	c3                   	ret    
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ac0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ac4:	83 e0 03             	and    $0x3,%eax
80105ac7:	66 83 f8 03          	cmp    $0x3,%ax
80105acb:	75 a8                	jne    80105a75 <trap+0xb5>
    exit();
80105acd:	e8 1e e3 ff ff       	call   80103df0 <exit>
80105ad2:	eb a1                	jmp    80105a75 <trap+0xb5>
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ad8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105adc:	75 ab                	jne    80105a89 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105ade:	e8 3d e4 ff ff       	call   80103f20 <yield>
80105ae3:	eb a4                	jmp    80105a89 <trap+0xc9>
80105ae5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_PGFLT:
  	handle_pgfault();
80105ae8:	e8 83 03 00 00       	call   80105e70 <handle_pgfault>
  	break;
80105aed:	e9 6e ff ff ff       	jmp    80105a60 <trap+0xa0>
80105af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105af8:	e8 d3 de ff ff       	call   801039d0 <cpuid>
80105afd:	85 c0                	test   %eax,%eax
80105aff:	0f 84 ab 00 00 00    	je     80105bb0 <trap+0x1f0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105b05:	e8 76 ce ff ff       	call   80102980 <lapiceoi>
    break;
80105b0a:	e9 51 ff ff ff       	jmp    80105a60 <trap+0xa0>
80105b0f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105b10:	e8 2b cd ff ff       	call   80102840 <kbdintr>
    lapiceoi();
80105b15:	e8 66 ce ff ff       	call   80102980 <lapiceoi>
    break;
80105b1a:	e9 41 ff ff ff       	jmp    80105a60 <trap+0xa0>
80105b1f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105b20:	e8 eb 04 00 00       	call   80106010 <uartintr>
    lapiceoi();
80105b25:	e8 56 ce ff ff       	call   80102980 <lapiceoi>
    break;
80105b2a:	e9 31 ff ff ff       	jmp    80105a60 <trap+0xa0>
80105b2f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b30:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105b34:	8b 77 38             	mov    0x38(%edi),%esi
80105b37:	e8 94 de ff ff       	call   801039d0 <cpuid>
80105b3c:	56                   	push   %esi
80105b3d:	53                   	push   %ebx
80105b3e:	50                   	push   %eax
80105b3f:	68 b4 7d 10 80       	push   $0x80107db4
80105b44:	e8 47 ac ff ff       	call   80100790 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105b49:	e8 32 ce ff ff       	call   80102980 <lapiceoi>
    break;
80105b4e:	83 c4 10             	add    $0x10,%esp
80105b51:	e9 0a ff ff ff       	jmp    80105a60 <trap+0xa0>
80105b56:	8d 76 00             	lea    0x0(%esi),%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105b60:	e8 5b c7 ff ff       	call   801022c0 <ideintr>
80105b65:	eb 9e                	jmp    80105b05 <trap+0x145>
80105b67:	89 f6                	mov    %esi,%esi
80105b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105b70:	e8 7b de ff ff       	call   801039f0 <myproc>
80105b75:	8b 58 24             	mov    0x24(%eax),%ebx
80105b78:	85 db                	test   %ebx,%ebx
80105b7a:	75 2c                	jne    80105ba8 <trap+0x1e8>
      exit();
    myproc()->tf = tf;
80105b7c:	e8 6f de ff ff       	call   801039f0 <myproc>
80105b81:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105b84:	e8 e7 ee ff ff       	call   80104a70 <syscall>
    if(myproc()->killed)
80105b89:	e8 62 de ff ff       	call   801039f0 <myproc>
80105b8e:	8b 48 24             	mov    0x24(%eax),%ecx
80105b91:	85 c9                	test   %ecx,%ecx
80105b93:	0f 84 16 ff ff ff    	je     80105aaf <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b9c:	5b                   	pop    %ebx
80105b9d:	5e                   	pop    %esi
80105b9e:	5f                   	pop    %edi
80105b9f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105ba0:	e9 4b e2 ff ff       	jmp    80103df0 <exit>
80105ba5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105ba8:	e8 43 e2 ff ff       	call   80103df0 <exit>
80105bad:	eb cd                	jmp    80105b7c <trap+0x1bc>
80105baf:	90                   	nop
  case T_PGFLT:
  	handle_pgfault();
  	break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105bb0:	83 ec 0c             	sub    $0xc,%esp
80105bb3:	68 60 5c 11 80       	push   $0x80115c60
80105bb8:	e8 43 e9 ff ff       	call   80104500 <acquire>
      ticks++;
      wakeup(&ticks);
80105bbd:	c7 04 24 a0 64 11 80 	movl   $0x801164a0,(%esp)
  	handle_pgfault();
  	break;
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105bc4:	83 05 a0 64 11 80 01 	addl   $0x1,0x801164a0
      wakeup(&ticks);
80105bcb:	e8 70 e5 ff ff       	call   80104140 <wakeup>
      release(&tickslock);
80105bd0:	c7 04 24 60 5c 11 80 	movl   $0x80115c60,(%esp)
80105bd7:	e8 44 ea ff ff       	call   80104620 <release>
80105bdc:	83 c4 10             	add    $0x10,%esp
80105bdf:	e9 21 ff ff ff       	jmp    80105b05 <trap+0x145>
80105be4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105be7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105bea:	e8 e1 dd ff ff       	call   801039d0 <cpuid>
80105bef:	83 ec 0c             	sub    $0xc,%esp
80105bf2:	56                   	push   %esi
80105bf3:	53                   	push   %ebx
80105bf4:	50                   	push   %eax
80105bf5:	ff 77 30             	pushl  0x30(%edi)
80105bf8:	68 d8 7d 10 80       	push   $0x80107dd8
80105bfd:	e8 8e ab ff ff       	call   80100790 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105c02:	83 c4 14             	add    $0x14,%esp
80105c05:	68 ac 7d 10 80       	push   $0x80107dac
80105c0a:	e8 91 a8 ff ff       	call   801004a0 <panic>
80105c0f:	90                   	nop

80105c10 <swap_page_from_pte>:
 */


void
swap_page_from_pte(pte_t *pte)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	57                   	push   %edi
80105c14:	56                   	push   %esi
80105c15:	53                   	push   %ebx
	//cprintf("Value of pte %d\n",*pte);
	uint mem=balloc_page(ROOTDEV);
	//cprintf("Value of mem before shifting%d\n",mem);
	char memo[PGSIZE]= "";
80105c16:	8d bd ec ef ff ff    	lea    -0x1014(%ebp),%edi
 */


void
swap_page_from_pte(pte_t *pte)
{
80105c1c:	81 ec 28 10 00 00    	sub    $0x1028,%esp
80105c22:	8b 75 08             	mov    0x8(%ebp),%esi
	//cprintf("Value of pte %d\n",*pte);
	uint mem=balloc_page(ROOTDEV);
80105c25:	6a 01                	push   $0x1
80105c27:	e8 64 b9 ff ff       	call   80101590 <balloc_page>
	//cprintf("Value of mem before shifting%d\n",mem);
	char memo[PGSIZE]= "";
80105c2c:	b9 ff 03 00 00       	mov    $0x3ff,%ecx

void
swap_page_from_pte(pte_t *pte)
{
	//cprintf("Value of pte %d\n",*pte);
	uint mem=balloc_page(ROOTDEV);
80105c31:	89 c3                	mov    %eax,%ebx
	//cprintf("Value of mem before shifting%d\n",mem);
	char memo[PGSIZE]= "";
80105c33:	31 c0                	xor    %eax,%eax
80105c35:	f3 ab                	rep stos %eax,%es:(%edi)
	uint pa = PTE_ADDR(*pte);
80105c37:	8b 3e                	mov    (%esi),%edi
	memmove(memo, (char*)pa, PGSIZE);
80105c39:	8d 95 e8 ef ff ff    	lea    -0x1018(%ebp),%edx
80105c3f:	83 c4 0c             	add    $0xc,%esp
80105c42:	68 00 10 00 00       	push   $0x1000
swap_page_from_pte(pte_t *pte)
{
	//cprintf("Value of pte %d\n",*pte);
	uint mem=balloc_page(ROOTDEV);
	//cprintf("Value of mem before shifting%d\n",mem);
	char memo[PGSIZE]= "";
80105c47:	c7 85 e8 ef ff ff 00 	movl   $0x0,-0x1018(%ebp)
80105c4e:	00 00 00 
	uint pa = PTE_ADDR(*pte);
	memmove(memo, (char*)pa, PGSIZE);
80105c51:	89 95 e4 ef ff ff    	mov    %edx,-0x101c(%ebp)
{
	//cprintf("Value of pte %d\n",*pte);
	uint mem=balloc_page(ROOTDEV);
	//cprintf("Value of mem before shifting%d\n",mem);
	char memo[PGSIZE]= "";
	uint pa = PTE_ADDR(*pte);
80105c57:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	memmove(memo, (char*)pa, PGSIZE);
80105c5d:	57                   	push   %edi
80105c5e:	52                   	push   %edx
80105c5f:	e8 bc ea ff ff       	call   80104720 <memmove>
	write_page_to_disk(ROOTDEV, memo,mem);
80105c64:	8b 95 e4 ef ff ff    	mov    -0x101c(%ebp),%edx
80105c6a:	83 c4 0c             	add    $0xc,%esp
80105c6d:	53                   	push   %ebx
	mem=mem<<12;
	//cprintf("Value of mem after shifting %d\n",mem);
	*pte = mem| PTE_PS ;
80105c6e:	c1 e3 0c             	shl    $0xc,%ebx
80105c71:	80 cb 80             	or     $0x80,%bl
	uint mem=balloc_page(ROOTDEV);
	//cprintf("Value of mem before shifting%d\n",mem);
	char memo[PGSIZE]= "";
	uint pa = PTE_ADDR(*pte);
	memmove(memo, (char*)pa, PGSIZE);
	write_page_to_disk(ROOTDEV, memo,mem);
80105c74:	52                   	push   %edx
80105c75:	6a 01                	push   $0x1
80105c77:	e8 f4 a5 ff ff       	call   80100270 <write_page_to_disk>
	mem=mem<<12;
	//cprintf("Value of mem after shifting %d\n",mem);
	*pte = mem| PTE_PS ;
80105c7c:	89 1e                	mov    %ebx,(%esi)
	asm volatile ( "invlpg (%0)" : : "b"((unsigned long)(P2V(pa))) : "memory" );
80105c7e:	8d 9f 00 00 00 80    	lea    -0x80000000(%edi),%ebx
80105c84:	0f 01 3b             	invlpg (%ebx)
	kfree((P2V(pa)));
80105c87:	89 1c 24             	mov    %ebx,(%esp)
80105c8a:	e8 c1 c8 ff ff       	call   80102550 <kfree>
	//cprintf("Value of pte afterswap  %d\n",*pte); 
	if(*pte & PTE_P)
80105c8f:	83 c4 10             	add    $0x10,%esp
80105c92:	f6 06 01             	testb  $0x1,(%esi)
80105c95:	75 08                	jne    80105c9f <swap_page_from_pte+0x8f>
			panic("Swap not done");
}
80105c97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c9a:	5b                   	pop    %ebx
80105c9b:	5e                   	pop    %esi
80105c9c:	5f                   	pop    %edi
80105c9d:	5d                   	pop    %ebp
80105c9e:	c3                   	ret    
	*pte = mem| PTE_PS ;
	asm volatile ( "invlpg (%0)" : : "b"((unsigned long)(P2V(pa))) : "memory" );
	kfree((P2V(pa)));
	//cprintf("Value of pte afterswap  %d\n",*pte); 
	if(*pte & PTE_P)
			panic("Swap not done");
80105c9f:	83 ec 0c             	sub    $0xc,%esp
80105ca2:	68 18 7f 10 80       	push   $0x80107f18
80105ca7:	e8 f4 a7 ff ff       	call   801004a0 <panic>
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <swap_page>:

/* Select a victim and swap the contents to the disk.			
 */
int
swap_page(pde_t *pgdir)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	56                   	push   %esi
80105cb4:	53                   	push   %ebx
80105cb5:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("inside swap_page\n");
80105cb8:	83 ec 0c             	sub    $0xc,%esp
80105cbb:	68 26 7f 10 80       	push   $0x80107f26
80105cc0:	e8 cb aa ff ff       	call   80100790 <cprintf>
	pte_t *pte = select_a_victim(pgdir);
80105cc5:	89 34 24             	mov    %esi,(%esp)
80105cc8:	e8 83 15 00 00       	call   80107250 <select_a_victim>
	//pte = select_a_victim(pgdir);
	cprintf("Value of pte after selecting victim%d\n",*pte);
80105ccd:	59                   	pop    %ecx
80105cce:	5a                   	pop    %edx
80105ccf:	ff 30                	pushl  (%eax)
80105cd1:	68 c4 7f 10 80       	push   $0x80107fc4
 */
int
swap_page(pde_t *pgdir)
{
	cprintf("inside swap_page\n");
	pte_t *pte = select_a_victim(pgdir);
80105cd6:	89 c3                	mov    %eax,%ebx
	//pte = select_a_victim(pgdir);
	cprintf("Value of pte after selecting victim%d\n",*pte);
80105cd8:	e8 b3 aa ff ff       	call   80100790 <cprintf>
	if(*pte==0)
80105cdd:	8b 03                	mov    (%ebx),%eax
80105cdf:	83 c4 10             	add    $0x10,%esp
80105ce2:	85 c0                	test   %eax,%eax
80105ce4:	75 18                	jne    80105cfe <swap_page+0x4e>
		{
		clearaccessbit(pgdir);
80105ce6:	83 ec 0c             	sub    $0xc,%esp
80105ce9:	56                   	push   %esi
80105cea:	e8 b1 15 00 00       	call   801072a0 <clearaccessbit>
		pte = select_a_victim(pgdir);
80105cef:	89 34 24             	mov    %esi,(%esp)
80105cf2:	e8 59 15 00 00       	call   80107250 <select_a_victim>
80105cf7:	89 c3                	mov    %eax,%ebx
80105cf9:	8b 00                	mov    (%eax),%eax
80105cfb:	83 c4 10             	add    $0x10,%esp
		}
	cprintf("Selecting a victim again %d\n",*pte);
80105cfe:	83 ec 08             	sub    $0x8,%esp
80105d01:	50                   	push   %eax
80105d02:	68 38 7f 10 80       	push   $0x80107f38
80105d07:	e8 84 aa ff ff       	call   80100790 <cprintf>
	swap_page_from_pte(pte);
80105d0c:	89 1c 24             	mov    %ebx,(%esp)
80105d0f:	e8 fc fe ff ff       	call   80105c10 <swap_page_from_pte>
	cprintf("Verfying value  %d\n",*pte);
80105d14:	58                   	pop    %eax
80105d15:	5a                   	pop    %edx
80105d16:	ff 33                	pushl  (%ebx)
80105d18:	68 55 7f 10 80       	push   $0x80107f55
80105d1d:	e8 6e aa ff ff       	call   80100790 <cprintf>
	return 1;
}
80105d22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d25:	b8 01 00 00 00       	mov    $0x1,%eax
80105d2a:	5b                   	pop    %ebx
80105d2b:	5e                   	pop    %esi
80105d2c:	5d                   	pop    %ebp
80105d2d:	c3                   	ret    
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <map_address>:
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	57                   	push   %edi
80105d34:	56                   	push   %esi
80105d35:	53                   	push   %ebx
80105d36:	83 ec 14             	sub    $0x14,%esp
80105d39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80105d3c:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("\nVA %d\n",addr);
80105d3f:	53                   	push   %ebx
80105d40:	68 69 7f 10 80       	push   $0x80107f69
80105d45:	e8 46 aa ff ff       	call   80100790 <cprintf>
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105d4a:	89 d8                	mov    %ebx,%eax
  if(*pde & PTE_P){
80105d4c:	83 c4 10             	add    $0x10,%esp
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105d4f:	c1 e8 16             	shr    $0x16,%eax
80105d52:	8d 3c 86             	lea    (%esi,%eax,4),%edi
  if(*pde & PTE_P){
80105d55:	f6 07 01             	testb  $0x1,(%edi)
80105d58:	75 0e                	jne    80105d68 <map_address+0x38>
map_address(pde_t *pgdir, uint addr)
{
	cprintf("\nVA %d\n",addr);
	pte_t *pte;
	pte = walkpgdir(pgdir, (char*)addr, 0);
	cprintf("pte value%d\n",*pte);
80105d5a:	a1 00 00 00 00       	mov    0x0,%eax
80105d5f:	0f 0b                	ud2    
80105d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
	cprintf("inside walkpgdir\n");
80105d68:	83 ec 0c             	sub    $0xc,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105d6b:	c1 eb 0a             	shr    $0xa,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
	cprintf("inside walkpgdir\n");
80105d6e:	68 71 7f 10 80       	push   $0x80107f71
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105d73:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
	cprintf("inside walkpgdir\n");
80105d79:	e8 12 aa ff ff       	call   80100790 <cprintf>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105d7e:	8b 07                	mov    (%edi),%eax
map_address(pde_t *pgdir, uint addr)
{
	cprintf("\nVA %d\n",addr);
	pte_t *pte;
	pte = walkpgdir(pgdir, (char*)addr, 0);
	cprintf("pte value%d\n",*pte);
80105d80:	59                   	pop    %ecx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105d81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105d86:	8d bc 18 00 00 00 80 	lea    -0x80000000(%eax,%ebx,1),%edi
map_address(pde_t *pgdir, uint addr)
{
	cprintf("\nVA %d\n",addr);
	pte_t *pte;
	pte = walkpgdir(pgdir, (char*)addr, 0);
	cprintf("pte value%d\n",*pte);
80105d8d:	5b                   	pop    %ebx
80105d8e:	ff 37                	pushl  (%edi)
80105d90:	68 83 7f 10 80       	push   $0x80107f83
80105d95:	e8 f6 a9 ff ff       	call   80100790 <cprintf>
	if(*pte & PTE_PS)
80105d9a:	83 c4 10             	add    $0x10,%esp
80105d9d:	f6 07 80             	testb  $0x80,(%edi)
80105da0:	0f 85 9c 00 00 00    	jne    80105e42 <map_address+0x112>
		}
	}
	else
	{
		char *kva;
		kva = kalloc();
80105da6:	e8 55 c9 ff ff       	call   80102700 <kalloc>
		if(kva==0)	
80105dab:	85 c0                	test   %eax,%eax
		}
	}
	else
	{
		char *kva;
		kva = kalloc();
80105dad:	89 c3                	mov    %eax,%ebx
		if(kva==0)	
80105daf:	74 37                	je     80105de8 <map_address+0xb8>
			cprintf("pte value%d\n",*pte);
			cprintf("New entry set\n");
		}
		else
		{
		memset(kva,0,PGSIZE);
80105db1:	83 ec 04             	sub    $0x4,%esp
		*pte = V2P(kva) | PTE_P | PTE_W | PTE_U ;
80105db4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
			cprintf("pte value%d\n",*pte);
			cprintf("New entry set\n");
		}
		else
		{
		memset(kva,0,PGSIZE);
80105dba:	68 00 10 00 00       	push   $0x1000
80105dbf:	6a 00                	push   $0x0
		*pte = V2P(kva) | PTE_P | PTE_W | PTE_U ;
80105dc1:	83 cb 07             	or     $0x7,%ebx
			cprintf("pte value%d\n",*pte);
			cprintf("New entry set\n");
		}
		else
		{
		memset(kva,0,PGSIZE);
80105dc4:	50                   	push   %eax
80105dc5:	e8 a6 e8 ff ff       	call   80104670 <memset>
		*pte = V2P(kva) | PTE_P | PTE_W | PTE_U ;
80105dca:	89 1f                	mov    %ebx,(%edi)
		cprintf("pte value%d\n",*pte);
80105dcc:	83 c4 10             	add    $0x10,%esp
80105dcf:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80105dd2:	c7 45 08 83 7f 10 80 	movl   $0x80107f83,0x8(%ebp)
		}
	}
	
}
80105dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ddc:	5b                   	pop    %ebx
80105ddd:	5e                   	pop    %esi
80105dde:	5f                   	pop    %edi
80105ddf:	5d                   	pop    %ebp
		}
		else
		{
		memset(kva,0,PGSIZE);
		*pte = V2P(kva) | PTE_P | PTE_W | PTE_U ;
		cprintf("pte value%d\n",*pte);
80105de0:	e9 ab a9 ff ff       	jmp    80100790 <cprintf>
80105de5:	8d 76 00             	lea    0x0(%esi),%esi
	{
		char *kva;
		kva = kalloc();
		if(kva==0)	
		{
			int b = swap_page(pgdir);
80105de8:	83 ec 0c             	sub    $0xc,%esp
80105deb:	56                   	push   %esi
80105dec:	e8 bf fe ff ff       	call   80105cb0 <swap_page>
			if(b!=1)
80105df1:	83 c4 10             	add    $0x10,%esp
80105df4:	83 f8 01             	cmp    $0x1,%eax
80105df7:	75 63                	jne    80105e5c <map_address+0x12c>
				panic("Sys_swap me gadbad");
			kva = kalloc();
80105df9:	e8 02 c9 ff ff       	call   80102700 <kalloc>
			if(kva == 0)
80105dfe:	85 c0                	test   %eax,%eax
		if(kva==0)	
		{
			int b = swap_page(pgdir);
			if(b!=1)
				panic("Sys_swap me gadbad");
			kva = kalloc();
80105e00:	89 c3                	mov    %eax,%ebx
			if(kva == 0)
80105e02:	74 4b                	je     80105e4f <map_address+0x11f>
				panic("PROBLEM"); 
			memset(kva,0,PGSIZE);
80105e04:	83 ec 04             	sub    $0x4,%esp
			*pte =  V2P(kva) | PTE_P | PTE_W | PTE_U ;
80105e07:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
			if(b!=1)
				panic("Sys_swap me gadbad");
			kva = kalloc();
			if(kva == 0)
				panic("PROBLEM"); 
			memset(kva,0,PGSIZE);
80105e0d:	68 00 10 00 00       	push   $0x1000
80105e12:	6a 00                	push   $0x0
			*pte =  V2P(kva) | PTE_P | PTE_W | PTE_U ;
80105e14:	83 cb 07             	or     $0x7,%ebx
			if(b!=1)
				panic("Sys_swap me gadbad");
			kva = kalloc();
			if(kva == 0)
				panic("PROBLEM"); 
			memset(kva,0,PGSIZE);
80105e17:	50                   	push   %eax
80105e18:	e8 53 e8 ff ff       	call   80104670 <memset>
			*pte =  V2P(kva) | PTE_P | PTE_W | PTE_U ;
80105e1d:	89 1f                	mov    %ebx,(%edi)
			cprintf("pte value%d\n",*pte);
80105e1f:	58                   	pop    %eax
80105e20:	5a                   	pop    %edx
80105e21:	53                   	push   %ebx
80105e22:	68 83 7f 10 80       	push   $0x80107f83
80105e27:	e8 64 a9 ff ff       	call   80100790 <cprintf>
			cprintf("New entry set\n");
80105e2c:	c7 45 08 b4 7f 10 80 	movl   $0x80107fb4,0x8(%ebp)
80105e33:	83 c4 10             	add    $0x10,%esp
		*pte = V2P(kva) | PTE_P | PTE_W | PTE_U ;
		cprintf("pte value%d\n",*pte);
		}
	}
	
}
80105e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e39:	5b                   	pop    %ebx
80105e3a:	5e                   	pop    %esi
80105e3b:	5f                   	pop    %edi
80105e3c:	5d                   	pop    %ebp
			if(kva == 0)
				panic("PROBLEM"); 
			memset(kva,0,PGSIZE);
			*pte =  V2P(kva) | PTE_P | PTE_W | PTE_U ;
			cprintf("pte value%d\n",*pte);
			cprintf("New entry set\n");
80105e3d:	e9 4e a9 ff ff       	jmp    80100790 <cprintf>
	pte_t *pte;
	pte = walkpgdir(pgdir, (char*)addr, 0);
	cprintf("pte value%d\n",*pte);
	if(*pte & PTE_PS)
	{
		panic("pte is 1");
80105e42:	83 ec 0c             	sub    $0xc,%esp
80105e45:	68 90 7f 10 80       	push   $0x80107f90
80105e4a:	e8 51 a6 ff ff       	call   801004a0 <panic>
			int b = swap_page(pgdir);
			if(b!=1)
				panic("Sys_swap me gadbad");
			kva = kalloc();
			if(kva == 0)
				panic("PROBLEM"); 
80105e4f:	83 ec 0c             	sub    $0xc,%esp
80105e52:	68 ac 7f 10 80       	push   $0x80107fac
80105e57:	e8 44 a6 ff ff       	call   801004a0 <panic>
		kva = kalloc();
		if(kva==0)	
		{
			int b = swap_page(pgdir);
			if(b!=1)
				panic("Sys_swap me gadbad");
80105e5c:	83 ec 0c             	sub    $0xc,%esp
80105e5f:	68 99 7f 10 80       	push   $0x80107f99
80105e64:	e8 37 a6 ff ff       	call   801004a0 <panic>
80105e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e70 <handle_pgfault>:
}

/* page fault handler */
void
handle_pgfault()
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
80105e73:	83 ec 08             	sub    $0x8,%esp
	unsigned addr;
	struct proc *curproc = myproc();
80105e76:	e8 75 db ff ff       	call   801039f0 <myproc>

	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
80105e7b:	0f 20 d2             	mov    %cr2,%edx
	addr &= ~0xfff;
	map_address(curproc->pgdir, addr);
80105e7e:	83 ec 08             	sub    $0x8,%esp
80105e81:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105e87:	52                   	push   %edx
80105e88:	ff 70 04             	pushl  0x4(%eax)
80105e8b:	e8 a0 fe ff ff       	call   80105d30 <map_address>
}
80105e90:	83 c4 10             	add    $0x10,%esp
80105e93:	c9                   	leave  
80105e94:	c3                   	ret    
80105e95:	66 90                	xchg   %ax,%ax
80105e97:	66 90                	xchg   %ax,%ax
80105e99:	66 90                	xchg   %ax,%ax
80105e9b:	66 90                	xchg   %ax,%ax
80105e9d:	66 90                	xchg   %ax,%ax
80105e9f:	90                   	nop

80105ea0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ea0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105ea5:	55                   	push   %ebp
80105ea6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ea8:	85 c0                	test   %eax,%eax
80105eaa:	74 1c                	je     80105ec8 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eac:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105eb1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105eb2:	a8 01                	test   $0x1,%al
80105eb4:	74 12                	je     80105ec8 <uartgetc+0x28>
80105eb6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ebb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ebc:	0f b6 c0             	movzbl %al,%eax
}
80105ebf:	5d                   	pop    %ebp
80105ec0:	c3                   	ret    
80105ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105ecd:	5d                   	pop    %ebp
80105ece:	c3                   	ret    
80105ecf:	90                   	nop

80105ed0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
80105ed6:	89 c7                	mov    %eax,%edi
80105ed8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105edd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ee2:	83 ec 0c             	sub    $0xc,%esp
80105ee5:	eb 1b                	jmp    80105f02 <uartputc.part.0+0x32>
80105ee7:	89 f6                	mov    %esi,%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	6a 0a                	push   $0xa
80105ef5:	e8 a6 ca ff ff       	call   801029a0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	83 eb 01             	sub    $0x1,%ebx
80105f00:	74 07                	je     80105f09 <uartputc.part.0+0x39>
80105f02:	89 f2                	mov    %esi,%edx
80105f04:	ec                   	in     (%dx),%al
80105f05:	a8 20                	test   $0x20,%al
80105f07:	74 e7                	je     80105ef0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f09:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f0e:	89 f8                	mov    %edi,%eax
80105f10:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105f11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f14:	5b                   	pop    %ebx
80105f15:	5e                   	pop    %esi
80105f16:	5f                   	pop    %edi
80105f17:	5d                   	pop    %ebp
80105f18:	c3                   	ret    
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105f20:	55                   	push   %ebp
80105f21:	31 c9                	xor    %ecx,%ecx
80105f23:	89 c8                	mov    %ecx,%eax
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	57                   	push   %edi
80105f28:	56                   	push   %esi
80105f29:	53                   	push   %ebx
80105f2a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105f2f:	89 da                	mov    %ebx,%edx
80105f31:	83 ec 0c             	sub    $0xc,%esp
80105f34:	ee                   	out    %al,(%dx)
80105f35:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105f3a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105f3f:	89 fa                	mov    %edi,%edx
80105f41:	ee                   	out    %al,(%dx)
80105f42:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f47:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f4c:	ee                   	out    %al,(%dx)
80105f4d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f52:	89 c8                	mov    %ecx,%eax
80105f54:	89 f2                	mov    %esi,%edx
80105f56:	ee                   	out    %al,(%dx)
80105f57:	b8 03 00 00 00       	mov    $0x3,%eax
80105f5c:	89 fa                	mov    %edi,%edx
80105f5e:	ee                   	out    %al,(%dx)
80105f5f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f64:	89 c8                	mov    %ecx,%eax
80105f66:	ee                   	out    %al,(%dx)
80105f67:	b8 01 00 00 00       	mov    $0x1,%eax
80105f6c:	89 f2                	mov    %esi,%edx
80105f6e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f6f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f74:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105f75:	3c ff                	cmp    $0xff,%al
80105f77:	74 5a                	je     80105fd3 <uartinit+0xb3>
    return;
  uart = 1;
80105f79:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80105f80:	00 00 00 
80105f83:	89 da                	mov    %ebx,%edx
80105f85:	ec                   	in     (%dx),%al
80105f86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f8b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105f8c:	83 ec 08             	sub    $0x8,%esp
80105f8f:	bb eb 7f 10 80       	mov    $0x80107feb,%ebx
80105f94:	6a 00                	push   $0x0
80105f96:	6a 04                	push   $0x4
80105f98:	e8 73 c5 ff ff       	call   80102510 <ioapicenable>
80105f9d:	83 c4 10             	add    $0x10,%esp
80105fa0:	b8 78 00 00 00       	mov    $0x78,%eax
80105fa5:	eb 13                	jmp    80105fba <uartinit+0x9a>
80105fa7:	89 f6                	mov    %esi,%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105fb0:	83 c3 01             	add    $0x1,%ebx
80105fb3:	0f be 03             	movsbl (%ebx),%eax
80105fb6:	84 c0                	test   %al,%al
80105fb8:	74 19                	je     80105fd3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105fba:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80105fc0:	85 d2                	test   %edx,%edx
80105fc2:	74 ec                	je     80105fb0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105fc4:	83 c3 01             	add    $0x1,%ebx
80105fc7:	e8 04 ff ff ff       	call   80105ed0 <uartputc.part.0>
80105fcc:	0f be 03             	movsbl (%ebx),%eax
80105fcf:	84 c0                	test   %al,%al
80105fd1:	75 e7                	jne    80105fba <uartinit+0x9a>
    uartputc(*p);
}
80105fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fd6:	5b                   	pop    %ebx
80105fd7:	5e                   	pop    %esi
80105fd8:	5f                   	pop    %edi
80105fd9:	5d                   	pop    %ebp
80105fda:	c3                   	ret    
80105fdb:	90                   	nop
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fe0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105fe0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105fe6:	55                   	push   %ebp
80105fe7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105fe9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105feb:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105fee:	74 10                	je     80106000 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105ff0:	5d                   	pop    %ebp
80105ff1:	e9 da fe ff ff       	jmp    80105ed0 <uartputc.part.0>
80105ff6:	8d 76 00             	lea    0x0(%esi),%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106000:	5d                   	pop    %ebp
80106001:	c3                   	ret    
80106002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106010 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106016:	68 a0 5e 10 80       	push   $0x80105ea0
8010601b:	e8 00 a9 ff ff       	call   80100920 <consoleintr>
}
80106020:	83 c4 10             	add    $0x10,%esp
80106023:	c9                   	leave  
80106024:	c3                   	ret    

80106025 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $0
80106027:	6a 00                	push   $0x0
  jmp alltraps
80106029:	e9 9c f8 ff ff       	jmp    801058ca <alltraps>

8010602e <vector1>:
.globl vector1
vector1:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $1
80106030:	6a 01                	push   $0x1
  jmp alltraps
80106032:	e9 93 f8 ff ff       	jmp    801058ca <alltraps>

80106037 <vector2>:
.globl vector2
vector2:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $2
80106039:	6a 02                	push   $0x2
  jmp alltraps
8010603b:	e9 8a f8 ff ff       	jmp    801058ca <alltraps>

80106040 <vector3>:
.globl vector3
vector3:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $3
80106042:	6a 03                	push   $0x3
  jmp alltraps
80106044:	e9 81 f8 ff ff       	jmp    801058ca <alltraps>

80106049 <vector4>:
.globl vector4
vector4:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $4
8010604b:	6a 04                	push   $0x4
  jmp alltraps
8010604d:	e9 78 f8 ff ff       	jmp    801058ca <alltraps>

80106052 <vector5>:
.globl vector5
vector5:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $5
80106054:	6a 05                	push   $0x5
  jmp alltraps
80106056:	e9 6f f8 ff ff       	jmp    801058ca <alltraps>

8010605b <vector6>:
.globl vector6
vector6:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $6
8010605d:	6a 06                	push   $0x6
  jmp alltraps
8010605f:	e9 66 f8 ff ff       	jmp    801058ca <alltraps>

80106064 <vector7>:
.globl vector7
vector7:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $7
80106066:	6a 07                	push   $0x7
  jmp alltraps
80106068:	e9 5d f8 ff ff       	jmp    801058ca <alltraps>

8010606d <vector8>:
.globl vector8
vector8:
  pushl $8
8010606d:	6a 08                	push   $0x8
  jmp alltraps
8010606f:	e9 56 f8 ff ff       	jmp    801058ca <alltraps>

80106074 <vector9>:
.globl vector9
vector9:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $9
80106076:	6a 09                	push   $0x9
  jmp alltraps
80106078:	e9 4d f8 ff ff       	jmp    801058ca <alltraps>

8010607d <vector10>:
.globl vector10
vector10:
  pushl $10
8010607d:	6a 0a                	push   $0xa
  jmp alltraps
8010607f:	e9 46 f8 ff ff       	jmp    801058ca <alltraps>

80106084 <vector11>:
.globl vector11
vector11:
  pushl $11
80106084:	6a 0b                	push   $0xb
  jmp alltraps
80106086:	e9 3f f8 ff ff       	jmp    801058ca <alltraps>

8010608b <vector12>:
.globl vector12
vector12:
  pushl $12
8010608b:	6a 0c                	push   $0xc
  jmp alltraps
8010608d:	e9 38 f8 ff ff       	jmp    801058ca <alltraps>

80106092 <vector13>:
.globl vector13
vector13:
  pushl $13
80106092:	6a 0d                	push   $0xd
  jmp alltraps
80106094:	e9 31 f8 ff ff       	jmp    801058ca <alltraps>

80106099 <vector14>:
.globl vector14
vector14:
  pushl $14
80106099:	6a 0e                	push   $0xe
  jmp alltraps
8010609b:	e9 2a f8 ff ff       	jmp    801058ca <alltraps>

801060a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $15
801060a2:	6a 0f                	push   $0xf
  jmp alltraps
801060a4:	e9 21 f8 ff ff       	jmp    801058ca <alltraps>

801060a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $16
801060ab:	6a 10                	push   $0x10
  jmp alltraps
801060ad:	e9 18 f8 ff ff       	jmp    801058ca <alltraps>

801060b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801060b2:	6a 11                	push   $0x11
  jmp alltraps
801060b4:	e9 11 f8 ff ff       	jmp    801058ca <alltraps>

801060b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $18
801060bb:	6a 12                	push   $0x12
  jmp alltraps
801060bd:	e9 08 f8 ff ff       	jmp    801058ca <alltraps>

801060c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $19
801060c4:	6a 13                	push   $0x13
  jmp alltraps
801060c6:	e9 ff f7 ff ff       	jmp    801058ca <alltraps>

801060cb <vector20>:
.globl vector20
vector20:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $20
801060cd:	6a 14                	push   $0x14
  jmp alltraps
801060cf:	e9 f6 f7 ff ff       	jmp    801058ca <alltraps>

801060d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $21
801060d6:	6a 15                	push   $0x15
  jmp alltraps
801060d8:	e9 ed f7 ff ff       	jmp    801058ca <alltraps>

801060dd <vector22>:
.globl vector22
vector22:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $22
801060df:	6a 16                	push   $0x16
  jmp alltraps
801060e1:	e9 e4 f7 ff ff       	jmp    801058ca <alltraps>

801060e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $23
801060e8:	6a 17                	push   $0x17
  jmp alltraps
801060ea:	e9 db f7 ff ff       	jmp    801058ca <alltraps>

801060ef <vector24>:
.globl vector24
vector24:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $24
801060f1:	6a 18                	push   $0x18
  jmp alltraps
801060f3:	e9 d2 f7 ff ff       	jmp    801058ca <alltraps>

801060f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $25
801060fa:	6a 19                	push   $0x19
  jmp alltraps
801060fc:	e9 c9 f7 ff ff       	jmp    801058ca <alltraps>

80106101 <vector26>:
.globl vector26
vector26:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $26
80106103:	6a 1a                	push   $0x1a
  jmp alltraps
80106105:	e9 c0 f7 ff ff       	jmp    801058ca <alltraps>

8010610a <vector27>:
.globl vector27
vector27:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $27
8010610c:	6a 1b                	push   $0x1b
  jmp alltraps
8010610e:	e9 b7 f7 ff ff       	jmp    801058ca <alltraps>

80106113 <vector28>:
.globl vector28
vector28:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $28
80106115:	6a 1c                	push   $0x1c
  jmp alltraps
80106117:	e9 ae f7 ff ff       	jmp    801058ca <alltraps>

8010611c <vector29>:
.globl vector29
vector29:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $29
8010611e:	6a 1d                	push   $0x1d
  jmp alltraps
80106120:	e9 a5 f7 ff ff       	jmp    801058ca <alltraps>

80106125 <vector30>:
.globl vector30
vector30:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $30
80106127:	6a 1e                	push   $0x1e
  jmp alltraps
80106129:	e9 9c f7 ff ff       	jmp    801058ca <alltraps>

8010612e <vector31>:
.globl vector31
vector31:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $31
80106130:	6a 1f                	push   $0x1f
  jmp alltraps
80106132:	e9 93 f7 ff ff       	jmp    801058ca <alltraps>

80106137 <vector32>:
.globl vector32
vector32:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $32
80106139:	6a 20                	push   $0x20
  jmp alltraps
8010613b:	e9 8a f7 ff ff       	jmp    801058ca <alltraps>

80106140 <vector33>:
.globl vector33
vector33:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $33
80106142:	6a 21                	push   $0x21
  jmp alltraps
80106144:	e9 81 f7 ff ff       	jmp    801058ca <alltraps>

80106149 <vector34>:
.globl vector34
vector34:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $34
8010614b:	6a 22                	push   $0x22
  jmp alltraps
8010614d:	e9 78 f7 ff ff       	jmp    801058ca <alltraps>

80106152 <vector35>:
.globl vector35
vector35:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $35
80106154:	6a 23                	push   $0x23
  jmp alltraps
80106156:	e9 6f f7 ff ff       	jmp    801058ca <alltraps>

8010615b <vector36>:
.globl vector36
vector36:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $36
8010615d:	6a 24                	push   $0x24
  jmp alltraps
8010615f:	e9 66 f7 ff ff       	jmp    801058ca <alltraps>

80106164 <vector37>:
.globl vector37
vector37:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $37
80106166:	6a 25                	push   $0x25
  jmp alltraps
80106168:	e9 5d f7 ff ff       	jmp    801058ca <alltraps>

8010616d <vector38>:
.globl vector38
vector38:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $38
8010616f:	6a 26                	push   $0x26
  jmp alltraps
80106171:	e9 54 f7 ff ff       	jmp    801058ca <alltraps>

80106176 <vector39>:
.globl vector39
vector39:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $39
80106178:	6a 27                	push   $0x27
  jmp alltraps
8010617a:	e9 4b f7 ff ff       	jmp    801058ca <alltraps>

8010617f <vector40>:
.globl vector40
vector40:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $40
80106181:	6a 28                	push   $0x28
  jmp alltraps
80106183:	e9 42 f7 ff ff       	jmp    801058ca <alltraps>

80106188 <vector41>:
.globl vector41
vector41:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $41
8010618a:	6a 29                	push   $0x29
  jmp alltraps
8010618c:	e9 39 f7 ff ff       	jmp    801058ca <alltraps>

80106191 <vector42>:
.globl vector42
vector42:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $42
80106193:	6a 2a                	push   $0x2a
  jmp alltraps
80106195:	e9 30 f7 ff ff       	jmp    801058ca <alltraps>

8010619a <vector43>:
.globl vector43
vector43:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $43
8010619c:	6a 2b                	push   $0x2b
  jmp alltraps
8010619e:	e9 27 f7 ff ff       	jmp    801058ca <alltraps>

801061a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $44
801061a5:	6a 2c                	push   $0x2c
  jmp alltraps
801061a7:	e9 1e f7 ff ff       	jmp    801058ca <alltraps>

801061ac <vector45>:
.globl vector45
vector45:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $45
801061ae:	6a 2d                	push   $0x2d
  jmp alltraps
801061b0:	e9 15 f7 ff ff       	jmp    801058ca <alltraps>

801061b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $46
801061b7:	6a 2e                	push   $0x2e
  jmp alltraps
801061b9:	e9 0c f7 ff ff       	jmp    801058ca <alltraps>

801061be <vector47>:
.globl vector47
vector47:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $47
801061c0:	6a 2f                	push   $0x2f
  jmp alltraps
801061c2:	e9 03 f7 ff ff       	jmp    801058ca <alltraps>

801061c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $48
801061c9:	6a 30                	push   $0x30
  jmp alltraps
801061cb:	e9 fa f6 ff ff       	jmp    801058ca <alltraps>

801061d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $49
801061d2:	6a 31                	push   $0x31
  jmp alltraps
801061d4:	e9 f1 f6 ff ff       	jmp    801058ca <alltraps>

801061d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $50
801061db:	6a 32                	push   $0x32
  jmp alltraps
801061dd:	e9 e8 f6 ff ff       	jmp    801058ca <alltraps>

801061e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $51
801061e4:	6a 33                	push   $0x33
  jmp alltraps
801061e6:	e9 df f6 ff ff       	jmp    801058ca <alltraps>

801061eb <vector52>:
.globl vector52
vector52:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $52
801061ed:	6a 34                	push   $0x34
  jmp alltraps
801061ef:	e9 d6 f6 ff ff       	jmp    801058ca <alltraps>

801061f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $53
801061f6:	6a 35                	push   $0x35
  jmp alltraps
801061f8:	e9 cd f6 ff ff       	jmp    801058ca <alltraps>

801061fd <vector54>:
.globl vector54
vector54:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $54
801061ff:	6a 36                	push   $0x36
  jmp alltraps
80106201:	e9 c4 f6 ff ff       	jmp    801058ca <alltraps>

80106206 <vector55>:
.globl vector55
vector55:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $55
80106208:	6a 37                	push   $0x37
  jmp alltraps
8010620a:	e9 bb f6 ff ff       	jmp    801058ca <alltraps>

8010620f <vector56>:
.globl vector56
vector56:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $56
80106211:	6a 38                	push   $0x38
  jmp alltraps
80106213:	e9 b2 f6 ff ff       	jmp    801058ca <alltraps>

80106218 <vector57>:
.globl vector57
vector57:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $57
8010621a:	6a 39                	push   $0x39
  jmp alltraps
8010621c:	e9 a9 f6 ff ff       	jmp    801058ca <alltraps>

80106221 <vector58>:
.globl vector58
vector58:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $58
80106223:	6a 3a                	push   $0x3a
  jmp alltraps
80106225:	e9 a0 f6 ff ff       	jmp    801058ca <alltraps>

8010622a <vector59>:
.globl vector59
vector59:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $59
8010622c:	6a 3b                	push   $0x3b
  jmp alltraps
8010622e:	e9 97 f6 ff ff       	jmp    801058ca <alltraps>

80106233 <vector60>:
.globl vector60
vector60:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $60
80106235:	6a 3c                	push   $0x3c
  jmp alltraps
80106237:	e9 8e f6 ff ff       	jmp    801058ca <alltraps>

8010623c <vector61>:
.globl vector61
vector61:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $61
8010623e:	6a 3d                	push   $0x3d
  jmp alltraps
80106240:	e9 85 f6 ff ff       	jmp    801058ca <alltraps>

80106245 <vector62>:
.globl vector62
vector62:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $62
80106247:	6a 3e                	push   $0x3e
  jmp alltraps
80106249:	e9 7c f6 ff ff       	jmp    801058ca <alltraps>

8010624e <vector63>:
.globl vector63
vector63:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $63
80106250:	6a 3f                	push   $0x3f
  jmp alltraps
80106252:	e9 73 f6 ff ff       	jmp    801058ca <alltraps>

80106257 <vector64>:
.globl vector64
vector64:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $64
80106259:	6a 40                	push   $0x40
  jmp alltraps
8010625b:	e9 6a f6 ff ff       	jmp    801058ca <alltraps>

80106260 <vector65>:
.globl vector65
vector65:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $65
80106262:	6a 41                	push   $0x41
  jmp alltraps
80106264:	e9 61 f6 ff ff       	jmp    801058ca <alltraps>

80106269 <vector66>:
.globl vector66
vector66:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $66
8010626b:	6a 42                	push   $0x42
  jmp alltraps
8010626d:	e9 58 f6 ff ff       	jmp    801058ca <alltraps>

80106272 <vector67>:
.globl vector67
vector67:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $67
80106274:	6a 43                	push   $0x43
  jmp alltraps
80106276:	e9 4f f6 ff ff       	jmp    801058ca <alltraps>

8010627b <vector68>:
.globl vector68
vector68:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $68
8010627d:	6a 44                	push   $0x44
  jmp alltraps
8010627f:	e9 46 f6 ff ff       	jmp    801058ca <alltraps>

80106284 <vector69>:
.globl vector69
vector69:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $69
80106286:	6a 45                	push   $0x45
  jmp alltraps
80106288:	e9 3d f6 ff ff       	jmp    801058ca <alltraps>

8010628d <vector70>:
.globl vector70
vector70:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $70
8010628f:	6a 46                	push   $0x46
  jmp alltraps
80106291:	e9 34 f6 ff ff       	jmp    801058ca <alltraps>

80106296 <vector71>:
.globl vector71
vector71:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $71
80106298:	6a 47                	push   $0x47
  jmp alltraps
8010629a:	e9 2b f6 ff ff       	jmp    801058ca <alltraps>

8010629f <vector72>:
.globl vector72
vector72:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $72
801062a1:	6a 48                	push   $0x48
  jmp alltraps
801062a3:	e9 22 f6 ff ff       	jmp    801058ca <alltraps>

801062a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $73
801062aa:	6a 49                	push   $0x49
  jmp alltraps
801062ac:	e9 19 f6 ff ff       	jmp    801058ca <alltraps>

801062b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $74
801062b3:	6a 4a                	push   $0x4a
  jmp alltraps
801062b5:	e9 10 f6 ff ff       	jmp    801058ca <alltraps>

801062ba <vector75>:
.globl vector75
vector75:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $75
801062bc:	6a 4b                	push   $0x4b
  jmp alltraps
801062be:	e9 07 f6 ff ff       	jmp    801058ca <alltraps>

801062c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $76
801062c5:	6a 4c                	push   $0x4c
  jmp alltraps
801062c7:	e9 fe f5 ff ff       	jmp    801058ca <alltraps>

801062cc <vector77>:
.globl vector77
vector77:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $77
801062ce:	6a 4d                	push   $0x4d
  jmp alltraps
801062d0:	e9 f5 f5 ff ff       	jmp    801058ca <alltraps>

801062d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $78
801062d7:	6a 4e                	push   $0x4e
  jmp alltraps
801062d9:	e9 ec f5 ff ff       	jmp    801058ca <alltraps>

801062de <vector79>:
.globl vector79
vector79:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $79
801062e0:	6a 4f                	push   $0x4f
  jmp alltraps
801062e2:	e9 e3 f5 ff ff       	jmp    801058ca <alltraps>

801062e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $80
801062e9:	6a 50                	push   $0x50
  jmp alltraps
801062eb:	e9 da f5 ff ff       	jmp    801058ca <alltraps>

801062f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $81
801062f2:	6a 51                	push   $0x51
  jmp alltraps
801062f4:	e9 d1 f5 ff ff       	jmp    801058ca <alltraps>

801062f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $82
801062fb:	6a 52                	push   $0x52
  jmp alltraps
801062fd:	e9 c8 f5 ff ff       	jmp    801058ca <alltraps>

80106302 <vector83>:
.globl vector83
vector83:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $83
80106304:	6a 53                	push   $0x53
  jmp alltraps
80106306:	e9 bf f5 ff ff       	jmp    801058ca <alltraps>

8010630b <vector84>:
.globl vector84
vector84:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $84
8010630d:	6a 54                	push   $0x54
  jmp alltraps
8010630f:	e9 b6 f5 ff ff       	jmp    801058ca <alltraps>

80106314 <vector85>:
.globl vector85
vector85:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $85
80106316:	6a 55                	push   $0x55
  jmp alltraps
80106318:	e9 ad f5 ff ff       	jmp    801058ca <alltraps>

8010631d <vector86>:
.globl vector86
vector86:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $86
8010631f:	6a 56                	push   $0x56
  jmp alltraps
80106321:	e9 a4 f5 ff ff       	jmp    801058ca <alltraps>

80106326 <vector87>:
.globl vector87
vector87:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $87
80106328:	6a 57                	push   $0x57
  jmp alltraps
8010632a:	e9 9b f5 ff ff       	jmp    801058ca <alltraps>

8010632f <vector88>:
.globl vector88
vector88:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $88
80106331:	6a 58                	push   $0x58
  jmp alltraps
80106333:	e9 92 f5 ff ff       	jmp    801058ca <alltraps>

80106338 <vector89>:
.globl vector89
vector89:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $89
8010633a:	6a 59                	push   $0x59
  jmp alltraps
8010633c:	e9 89 f5 ff ff       	jmp    801058ca <alltraps>

80106341 <vector90>:
.globl vector90
vector90:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $90
80106343:	6a 5a                	push   $0x5a
  jmp alltraps
80106345:	e9 80 f5 ff ff       	jmp    801058ca <alltraps>

8010634a <vector91>:
.globl vector91
vector91:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $91
8010634c:	6a 5b                	push   $0x5b
  jmp alltraps
8010634e:	e9 77 f5 ff ff       	jmp    801058ca <alltraps>

80106353 <vector92>:
.globl vector92
vector92:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $92
80106355:	6a 5c                	push   $0x5c
  jmp alltraps
80106357:	e9 6e f5 ff ff       	jmp    801058ca <alltraps>

8010635c <vector93>:
.globl vector93
vector93:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $93
8010635e:	6a 5d                	push   $0x5d
  jmp alltraps
80106360:	e9 65 f5 ff ff       	jmp    801058ca <alltraps>

80106365 <vector94>:
.globl vector94
vector94:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $94
80106367:	6a 5e                	push   $0x5e
  jmp alltraps
80106369:	e9 5c f5 ff ff       	jmp    801058ca <alltraps>

8010636e <vector95>:
.globl vector95
vector95:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $95
80106370:	6a 5f                	push   $0x5f
  jmp alltraps
80106372:	e9 53 f5 ff ff       	jmp    801058ca <alltraps>

80106377 <vector96>:
.globl vector96
vector96:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $96
80106379:	6a 60                	push   $0x60
  jmp alltraps
8010637b:	e9 4a f5 ff ff       	jmp    801058ca <alltraps>

80106380 <vector97>:
.globl vector97
vector97:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $97
80106382:	6a 61                	push   $0x61
  jmp alltraps
80106384:	e9 41 f5 ff ff       	jmp    801058ca <alltraps>

80106389 <vector98>:
.globl vector98
vector98:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $98
8010638b:	6a 62                	push   $0x62
  jmp alltraps
8010638d:	e9 38 f5 ff ff       	jmp    801058ca <alltraps>

80106392 <vector99>:
.globl vector99
vector99:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $99
80106394:	6a 63                	push   $0x63
  jmp alltraps
80106396:	e9 2f f5 ff ff       	jmp    801058ca <alltraps>

8010639b <vector100>:
.globl vector100
vector100:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $100
8010639d:	6a 64                	push   $0x64
  jmp alltraps
8010639f:	e9 26 f5 ff ff       	jmp    801058ca <alltraps>

801063a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $101
801063a6:	6a 65                	push   $0x65
  jmp alltraps
801063a8:	e9 1d f5 ff ff       	jmp    801058ca <alltraps>

801063ad <vector102>:
.globl vector102
vector102:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $102
801063af:	6a 66                	push   $0x66
  jmp alltraps
801063b1:	e9 14 f5 ff ff       	jmp    801058ca <alltraps>

801063b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $103
801063b8:	6a 67                	push   $0x67
  jmp alltraps
801063ba:	e9 0b f5 ff ff       	jmp    801058ca <alltraps>

801063bf <vector104>:
.globl vector104
vector104:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $104
801063c1:	6a 68                	push   $0x68
  jmp alltraps
801063c3:	e9 02 f5 ff ff       	jmp    801058ca <alltraps>

801063c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $105
801063ca:	6a 69                	push   $0x69
  jmp alltraps
801063cc:	e9 f9 f4 ff ff       	jmp    801058ca <alltraps>

801063d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $106
801063d3:	6a 6a                	push   $0x6a
  jmp alltraps
801063d5:	e9 f0 f4 ff ff       	jmp    801058ca <alltraps>

801063da <vector107>:
.globl vector107
vector107:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $107
801063dc:	6a 6b                	push   $0x6b
  jmp alltraps
801063de:	e9 e7 f4 ff ff       	jmp    801058ca <alltraps>

801063e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $108
801063e5:	6a 6c                	push   $0x6c
  jmp alltraps
801063e7:	e9 de f4 ff ff       	jmp    801058ca <alltraps>

801063ec <vector109>:
.globl vector109
vector109:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $109
801063ee:	6a 6d                	push   $0x6d
  jmp alltraps
801063f0:	e9 d5 f4 ff ff       	jmp    801058ca <alltraps>

801063f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $110
801063f7:	6a 6e                	push   $0x6e
  jmp alltraps
801063f9:	e9 cc f4 ff ff       	jmp    801058ca <alltraps>

801063fe <vector111>:
.globl vector111
vector111:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $111
80106400:	6a 6f                	push   $0x6f
  jmp alltraps
80106402:	e9 c3 f4 ff ff       	jmp    801058ca <alltraps>

80106407 <vector112>:
.globl vector112
vector112:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $112
80106409:	6a 70                	push   $0x70
  jmp alltraps
8010640b:	e9 ba f4 ff ff       	jmp    801058ca <alltraps>

80106410 <vector113>:
.globl vector113
vector113:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $113
80106412:	6a 71                	push   $0x71
  jmp alltraps
80106414:	e9 b1 f4 ff ff       	jmp    801058ca <alltraps>

80106419 <vector114>:
.globl vector114
vector114:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $114
8010641b:	6a 72                	push   $0x72
  jmp alltraps
8010641d:	e9 a8 f4 ff ff       	jmp    801058ca <alltraps>

80106422 <vector115>:
.globl vector115
vector115:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $115
80106424:	6a 73                	push   $0x73
  jmp alltraps
80106426:	e9 9f f4 ff ff       	jmp    801058ca <alltraps>

8010642b <vector116>:
.globl vector116
vector116:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $116
8010642d:	6a 74                	push   $0x74
  jmp alltraps
8010642f:	e9 96 f4 ff ff       	jmp    801058ca <alltraps>

80106434 <vector117>:
.globl vector117
vector117:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $117
80106436:	6a 75                	push   $0x75
  jmp alltraps
80106438:	e9 8d f4 ff ff       	jmp    801058ca <alltraps>

8010643d <vector118>:
.globl vector118
vector118:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $118
8010643f:	6a 76                	push   $0x76
  jmp alltraps
80106441:	e9 84 f4 ff ff       	jmp    801058ca <alltraps>

80106446 <vector119>:
.globl vector119
vector119:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $119
80106448:	6a 77                	push   $0x77
  jmp alltraps
8010644a:	e9 7b f4 ff ff       	jmp    801058ca <alltraps>

8010644f <vector120>:
.globl vector120
vector120:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $120
80106451:	6a 78                	push   $0x78
  jmp alltraps
80106453:	e9 72 f4 ff ff       	jmp    801058ca <alltraps>

80106458 <vector121>:
.globl vector121
vector121:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $121
8010645a:	6a 79                	push   $0x79
  jmp alltraps
8010645c:	e9 69 f4 ff ff       	jmp    801058ca <alltraps>

80106461 <vector122>:
.globl vector122
vector122:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $122
80106463:	6a 7a                	push   $0x7a
  jmp alltraps
80106465:	e9 60 f4 ff ff       	jmp    801058ca <alltraps>

8010646a <vector123>:
.globl vector123
vector123:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $123
8010646c:	6a 7b                	push   $0x7b
  jmp alltraps
8010646e:	e9 57 f4 ff ff       	jmp    801058ca <alltraps>

80106473 <vector124>:
.globl vector124
vector124:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $124
80106475:	6a 7c                	push   $0x7c
  jmp alltraps
80106477:	e9 4e f4 ff ff       	jmp    801058ca <alltraps>

8010647c <vector125>:
.globl vector125
vector125:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $125
8010647e:	6a 7d                	push   $0x7d
  jmp alltraps
80106480:	e9 45 f4 ff ff       	jmp    801058ca <alltraps>

80106485 <vector126>:
.globl vector126
vector126:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $126
80106487:	6a 7e                	push   $0x7e
  jmp alltraps
80106489:	e9 3c f4 ff ff       	jmp    801058ca <alltraps>

8010648e <vector127>:
.globl vector127
vector127:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $127
80106490:	6a 7f                	push   $0x7f
  jmp alltraps
80106492:	e9 33 f4 ff ff       	jmp    801058ca <alltraps>

80106497 <vector128>:
.globl vector128
vector128:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $128
80106499:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010649e:	e9 27 f4 ff ff       	jmp    801058ca <alltraps>

801064a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $129
801064a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801064aa:	e9 1b f4 ff ff       	jmp    801058ca <alltraps>

801064af <vector130>:
.globl vector130
vector130:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $130
801064b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801064b6:	e9 0f f4 ff ff       	jmp    801058ca <alltraps>

801064bb <vector131>:
.globl vector131
vector131:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $131
801064bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801064c2:	e9 03 f4 ff ff       	jmp    801058ca <alltraps>

801064c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $132
801064c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801064ce:	e9 f7 f3 ff ff       	jmp    801058ca <alltraps>

801064d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $133
801064d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801064da:	e9 eb f3 ff ff       	jmp    801058ca <alltraps>

801064df <vector134>:
.globl vector134
vector134:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $134
801064e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064e6:	e9 df f3 ff ff       	jmp    801058ca <alltraps>

801064eb <vector135>:
.globl vector135
vector135:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $135
801064ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064f2:	e9 d3 f3 ff ff       	jmp    801058ca <alltraps>

801064f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $136
801064f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064fe:	e9 c7 f3 ff ff       	jmp    801058ca <alltraps>

80106503 <vector137>:
.globl vector137
vector137:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $137
80106505:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010650a:	e9 bb f3 ff ff       	jmp    801058ca <alltraps>

8010650f <vector138>:
.globl vector138
vector138:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $138
80106511:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106516:	e9 af f3 ff ff       	jmp    801058ca <alltraps>

8010651b <vector139>:
.globl vector139
vector139:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $139
8010651d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106522:	e9 a3 f3 ff ff       	jmp    801058ca <alltraps>

80106527 <vector140>:
.globl vector140
vector140:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $140
80106529:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010652e:	e9 97 f3 ff ff       	jmp    801058ca <alltraps>

80106533 <vector141>:
.globl vector141
vector141:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $141
80106535:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010653a:	e9 8b f3 ff ff       	jmp    801058ca <alltraps>

8010653f <vector142>:
.globl vector142
vector142:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $142
80106541:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106546:	e9 7f f3 ff ff       	jmp    801058ca <alltraps>

8010654b <vector143>:
.globl vector143
vector143:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $143
8010654d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106552:	e9 73 f3 ff ff       	jmp    801058ca <alltraps>

80106557 <vector144>:
.globl vector144
vector144:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $144
80106559:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010655e:	e9 67 f3 ff ff       	jmp    801058ca <alltraps>

80106563 <vector145>:
.globl vector145
vector145:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $145
80106565:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010656a:	e9 5b f3 ff ff       	jmp    801058ca <alltraps>

8010656f <vector146>:
.globl vector146
vector146:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $146
80106571:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106576:	e9 4f f3 ff ff       	jmp    801058ca <alltraps>

8010657b <vector147>:
.globl vector147
vector147:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $147
8010657d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106582:	e9 43 f3 ff ff       	jmp    801058ca <alltraps>

80106587 <vector148>:
.globl vector148
vector148:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $148
80106589:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010658e:	e9 37 f3 ff ff       	jmp    801058ca <alltraps>

80106593 <vector149>:
.globl vector149
vector149:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $149
80106595:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010659a:	e9 2b f3 ff ff       	jmp    801058ca <alltraps>

8010659f <vector150>:
.globl vector150
vector150:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $150
801065a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801065a6:	e9 1f f3 ff ff       	jmp    801058ca <alltraps>

801065ab <vector151>:
.globl vector151
vector151:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $151
801065ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801065b2:	e9 13 f3 ff ff       	jmp    801058ca <alltraps>

801065b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $152
801065b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801065be:	e9 07 f3 ff ff       	jmp    801058ca <alltraps>

801065c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $153
801065c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801065ca:	e9 fb f2 ff ff       	jmp    801058ca <alltraps>

801065cf <vector154>:
.globl vector154
vector154:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $154
801065d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801065d6:	e9 ef f2 ff ff       	jmp    801058ca <alltraps>

801065db <vector155>:
.globl vector155
vector155:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $155
801065dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065e2:	e9 e3 f2 ff ff       	jmp    801058ca <alltraps>

801065e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $156
801065e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065ee:	e9 d7 f2 ff ff       	jmp    801058ca <alltraps>

801065f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $157
801065f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065fa:	e9 cb f2 ff ff       	jmp    801058ca <alltraps>

801065ff <vector158>:
.globl vector158
vector158:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $158
80106601:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106606:	e9 bf f2 ff ff       	jmp    801058ca <alltraps>

8010660b <vector159>:
.globl vector159
vector159:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $159
8010660d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106612:	e9 b3 f2 ff ff       	jmp    801058ca <alltraps>

80106617 <vector160>:
.globl vector160
vector160:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $160
80106619:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010661e:	e9 a7 f2 ff ff       	jmp    801058ca <alltraps>

80106623 <vector161>:
.globl vector161
vector161:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $161
80106625:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010662a:	e9 9b f2 ff ff       	jmp    801058ca <alltraps>

8010662f <vector162>:
.globl vector162
vector162:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $162
80106631:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106636:	e9 8f f2 ff ff       	jmp    801058ca <alltraps>

8010663b <vector163>:
.globl vector163
vector163:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $163
8010663d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106642:	e9 83 f2 ff ff       	jmp    801058ca <alltraps>

80106647 <vector164>:
.globl vector164
vector164:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $164
80106649:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010664e:	e9 77 f2 ff ff       	jmp    801058ca <alltraps>

80106653 <vector165>:
.globl vector165
vector165:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $165
80106655:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010665a:	e9 6b f2 ff ff       	jmp    801058ca <alltraps>

8010665f <vector166>:
.globl vector166
vector166:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $166
80106661:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106666:	e9 5f f2 ff ff       	jmp    801058ca <alltraps>

8010666b <vector167>:
.globl vector167
vector167:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $167
8010666d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106672:	e9 53 f2 ff ff       	jmp    801058ca <alltraps>

80106677 <vector168>:
.globl vector168
vector168:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $168
80106679:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010667e:	e9 47 f2 ff ff       	jmp    801058ca <alltraps>

80106683 <vector169>:
.globl vector169
vector169:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $169
80106685:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010668a:	e9 3b f2 ff ff       	jmp    801058ca <alltraps>

8010668f <vector170>:
.globl vector170
vector170:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $170
80106691:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106696:	e9 2f f2 ff ff       	jmp    801058ca <alltraps>

8010669b <vector171>:
.globl vector171
vector171:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $171
8010669d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801066a2:	e9 23 f2 ff ff       	jmp    801058ca <alltraps>

801066a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $172
801066a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801066ae:	e9 17 f2 ff ff       	jmp    801058ca <alltraps>

801066b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $173
801066b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801066ba:	e9 0b f2 ff ff       	jmp    801058ca <alltraps>

801066bf <vector174>:
.globl vector174
vector174:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $174
801066c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801066c6:	e9 ff f1 ff ff       	jmp    801058ca <alltraps>

801066cb <vector175>:
.globl vector175
vector175:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $175
801066cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801066d2:	e9 f3 f1 ff ff       	jmp    801058ca <alltraps>

801066d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $176
801066d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801066de:	e9 e7 f1 ff ff       	jmp    801058ca <alltraps>

801066e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $177
801066e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066ea:	e9 db f1 ff ff       	jmp    801058ca <alltraps>

801066ef <vector178>:
.globl vector178
vector178:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $178
801066f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066f6:	e9 cf f1 ff ff       	jmp    801058ca <alltraps>

801066fb <vector179>:
.globl vector179
vector179:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $179
801066fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106702:	e9 c3 f1 ff ff       	jmp    801058ca <alltraps>

80106707 <vector180>:
.globl vector180
vector180:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $180
80106709:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010670e:	e9 b7 f1 ff ff       	jmp    801058ca <alltraps>

80106713 <vector181>:
.globl vector181
vector181:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $181
80106715:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010671a:	e9 ab f1 ff ff       	jmp    801058ca <alltraps>

8010671f <vector182>:
.globl vector182
vector182:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $182
80106721:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106726:	e9 9f f1 ff ff       	jmp    801058ca <alltraps>

8010672b <vector183>:
.globl vector183
vector183:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $183
8010672d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106732:	e9 93 f1 ff ff       	jmp    801058ca <alltraps>

80106737 <vector184>:
.globl vector184
vector184:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $184
80106739:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010673e:	e9 87 f1 ff ff       	jmp    801058ca <alltraps>

80106743 <vector185>:
.globl vector185
vector185:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $185
80106745:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010674a:	e9 7b f1 ff ff       	jmp    801058ca <alltraps>

8010674f <vector186>:
.globl vector186
vector186:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $186
80106751:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106756:	e9 6f f1 ff ff       	jmp    801058ca <alltraps>

8010675b <vector187>:
.globl vector187
vector187:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $187
8010675d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106762:	e9 63 f1 ff ff       	jmp    801058ca <alltraps>

80106767 <vector188>:
.globl vector188
vector188:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $188
80106769:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010676e:	e9 57 f1 ff ff       	jmp    801058ca <alltraps>

80106773 <vector189>:
.globl vector189
vector189:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $189
80106775:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010677a:	e9 4b f1 ff ff       	jmp    801058ca <alltraps>

8010677f <vector190>:
.globl vector190
vector190:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $190
80106781:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106786:	e9 3f f1 ff ff       	jmp    801058ca <alltraps>

8010678b <vector191>:
.globl vector191
vector191:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $191
8010678d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106792:	e9 33 f1 ff ff       	jmp    801058ca <alltraps>

80106797 <vector192>:
.globl vector192
vector192:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $192
80106799:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010679e:	e9 27 f1 ff ff       	jmp    801058ca <alltraps>

801067a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $193
801067a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801067aa:	e9 1b f1 ff ff       	jmp    801058ca <alltraps>

801067af <vector194>:
.globl vector194
vector194:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $194
801067b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801067b6:	e9 0f f1 ff ff       	jmp    801058ca <alltraps>

801067bb <vector195>:
.globl vector195
vector195:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $195
801067bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801067c2:	e9 03 f1 ff ff       	jmp    801058ca <alltraps>

801067c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $196
801067c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801067ce:	e9 f7 f0 ff ff       	jmp    801058ca <alltraps>

801067d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $197
801067d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801067da:	e9 eb f0 ff ff       	jmp    801058ca <alltraps>

801067df <vector198>:
.globl vector198
vector198:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $198
801067e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067e6:	e9 df f0 ff ff       	jmp    801058ca <alltraps>

801067eb <vector199>:
.globl vector199
vector199:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $199
801067ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067f2:	e9 d3 f0 ff ff       	jmp    801058ca <alltraps>

801067f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $200
801067f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067fe:	e9 c7 f0 ff ff       	jmp    801058ca <alltraps>

80106803 <vector201>:
.globl vector201
vector201:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $201
80106805:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010680a:	e9 bb f0 ff ff       	jmp    801058ca <alltraps>

8010680f <vector202>:
.globl vector202
vector202:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $202
80106811:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106816:	e9 af f0 ff ff       	jmp    801058ca <alltraps>

8010681b <vector203>:
.globl vector203
vector203:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $203
8010681d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106822:	e9 a3 f0 ff ff       	jmp    801058ca <alltraps>

80106827 <vector204>:
.globl vector204
vector204:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $204
80106829:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010682e:	e9 97 f0 ff ff       	jmp    801058ca <alltraps>

80106833 <vector205>:
.globl vector205
vector205:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $205
80106835:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010683a:	e9 8b f0 ff ff       	jmp    801058ca <alltraps>

8010683f <vector206>:
.globl vector206
vector206:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $206
80106841:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106846:	e9 7f f0 ff ff       	jmp    801058ca <alltraps>

8010684b <vector207>:
.globl vector207
vector207:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $207
8010684d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106852:	e9 73 f0 ff ff       	jmp    801058ca <alltraps>

80106857 <vector208>:
.globl vector208
vector208:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $208
80106859:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010685e:	e9 67 f0 ff ff       	jmp    801058ca <alltraps>

80106863 <vector209>:
.globl vector209
vector209:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $209
80106865:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010686a:	e9 5b f0 ff ff       	jmp    801058ca <alltraps>

8010686f <vector210>:
.globl vector210
vector210:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $210
80106871:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106876:	e9 4f f0 ff ff       	jmp    801058ca <alltraps>

8010687b <vector211>:
.globl vector211
vector211:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $211
8010687d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106882:	e9 43 f0 ff ff       	jmp    801058ca <alltraps>

80106887 <vector212>:
.globl vector212
vector212:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $212
80106889:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010688e:	e9 37 f0 ff ff       	jmp    801058ca <alltraps>

80106893 <vector213>:
.globl vector213
vector213:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $213
80106895:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010689a:	e9 2b f0 ff ff       	jmp    801058ca <alltraps>

8010689f <vector214>:
.globl vector214
vector214:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $214
801068a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801068a6:	e9 1f f0 ff ff       	jmp    801058ca <alltraps>

801068ab <vector215>:
.globl vector215
vector215:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $215
801068ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801068b2:	e9 13 f0 ff ff       	jmp    801058ca <alltraps>

801068b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $216
801068b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801068be:	e9 07 f0 ff ff       	jmp    801058ca <alltraps>

801068c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $217
801068c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801068ca:	e9 fb ef ff ff       	jmp    801058ca <alltraps>

801068cf <vector218>:
.globl vector218
vector218:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $218
801068d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801068d6:	e9 ef ef ff ff       	jmp    801058ca <alltraps>

801068db <vector219>:
.globl vector219
vector219:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $219
801068dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068e2:	e9 e3 ef ff ff       	jmp    801058ca <alltraps>

801068e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $220
801068e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068ee:	e9 d7 ef ff ff       	jmp    801058ca <alltraps>

801068f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $221
801068f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068fa:	e9 cb ef ff ff       	jmp    801058ca <alltraps>

801068ff <vector222>:
.globl vector222
vector222:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $222
80106901:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106906:	e9 bf ef ff ff       	jmp    801058ca <alltraps>

8010690b <vector223>:
.globl vector223
vector223:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $223
8010690d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106912:	e9 b3 ef ff ff       	jmp    801058ca <alltraps>

80106917 <vector224>:
.globl vector224
vector224:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $224
80106919:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010691e:	e9 a7 ef ff ff       	jmp    801058ca <alltraps>

80106923 <vector225>:
.globl vector225
vector225:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $225
80106925:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010692a:	e9 9b ef ff ff       	jmp    801058ca <alltraps>

8010692f <vector226>:
.globl vector226
vector226:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $226
80106931:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106936:	e9 8f ef ff ff       	jmp    801058ca <alltraps>

8010693b <vector227>:
.globl vector227
vector227:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $227
8010693d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106942:	e9 83 ef ff ff       	jmp    801058ca <alltraps>

80106947 <vector228>:
.globl vector228
vector228:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $228
80106949:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010694e:	e9 77 ef ff ff       	jmp    801058ca <alltraps>

80106953 <vector229>:
.globl vector229
vector229:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $229
80106955:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010695a:	e9 6b ef ff ff       	jmp    801058ca <alltraps>

8010695f <vector230>:
.globl vector230
vector230:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $230
80106961:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106966:	e9 5f ef ff ff       	jmp    801058ca <alltraps>

8010696b <vector231>:
.globl vector231
vector231:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $231
8010696d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106972:	e9 53 ef ff ff       	jmp    801058ca <alltraps>

80106977 <vector232>:
.globl vector232
vector232:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $232
80106979:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010697e:	e9 47 ef ff ff       	jmp    801058ca <alltraps>

80106983 <vector233>:
.globl vector233
vector233:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $233
80106985:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010698a:	e9 3b ef ff ff       	jmp    801058ca <alltraps>

8010698f <vector234>:
.globl vector234
vector234:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $234
80106991:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106996:	e9 2f ef ff ff       	jmp    801058ca <alltraps>

8010699b <vector235>:
.globl vector235
vector235:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $235
8010699d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801069a2:	e9 23 ef ff ff       	jmp    801058ca <alltraps>

801069a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $236
801069a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801069ae:	e9 17 ef ff ff       	jmp    801058ca <alltraps>

801069b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $237
801069b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801069ba:	e9 0b ef ff ff       	jmp    801058ca <alltraps>

801069bf <vector238>:
.globl vector238
vector238:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $238
801069c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801069c6:	e9 ff ee ff ff       	jmp    801058ca <alltraps>

801069cb <vector239>:
.globl vector239
vector239:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $239
801069cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801069d2:	e9 f3 ee ff ff       	jmp    801058ca <alltraps>

801069d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $240
801069d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801069de:	e9 e7 ee ff ff       	jmp    801058ca <alltraps>

801069e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $241
801069e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069ea:	e9 db ee ff ff       	jmp    801058ca <alltraps>

801069ef <vector242>:
.globl vector242
vector242:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $242
801069f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069f6:	e9 cf ee ff ff       	jmp    801058ca <alltraps>

801069fb <vector243>:
.globl vector243
vector243:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $243
801069fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106a02:	e9 c3 ee ff ff       	jmp    801058ca <alltraps>

80106a07 <vector244>:
.globl vector244
vector244:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $244
80106a09:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106a0e:	e9 b7 ee ff ff       	jmp    801058ca <alltraps>

80106a13 <vector245>:
.globl vector245
vector245:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $245
80106a15:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106a1a:	e9 ab ee ff ff       	jmp    801058ca <alltraps>

80106a1f <vector246>:
.globl vector246
vector246:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $246
80106a21:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106a26:	e9 9f ee ff ff       	jmp    801058ca <alltraps>

80106a2b <vector247>:
.globl vector247
vector247:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $247
80106a2d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106a32:	e9 93 ee ff ff       	jmp    801058ca <alltraps>

80106a37 <vector248>:
.globl vector248
vector248:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $248
80106a39:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106a3e:	e9 87 ee ff ff       	jmp    801058ca <alltraps>

80106a43 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $249
80106a45:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a4a:	e9 7b ee ff ff       	jmp    801058ca <alltraps>

80106a4f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $250
80106a51:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a56:	e9 6f ee ff ff       	jmp    801058ca <alltraps>

80106a5b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $251
80106a5d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a62:	e9 63 ee ff ff       	jmp    801058ca <alltraps>

80106a67 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $252
80106a69:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a6e:	e9 57 ee ff ff       	jmp    801058ca <alltraps>

80106a73 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $253
80106a75:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a7a:	e9 4b ee ff ff       	jmp    801058ca <alltraps>

80106a7f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $254
80106a81:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a86:	e9 3f ee ff ff       	jmp    801058ca <alltraps>

80106a8b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $255
80106a8d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a92:	e9 33 ee ff ff       	jmp    801058ca <alltraps>
80106a97:	66 90                	xchg   %ax,%ax
80106a99:	66 90                	xchg   %ax,%ax
80106a9b:	66 90                	xchg   %ax,%ax
80106a9d:	66 90                	xchg   %ax,%ax
80106a9f:	90                   	nop

80106aa0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106aa8:	c1 ea 16             	shr    $0x16,%edx
80106aab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106aae:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106ab1:	8b 07                	mov    (%edi),%eax
80106ab3:	a8 01                	test   $0x1,%al
80106ab5:	74 29                	je     80106ae0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ab7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106abc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106ac2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ac5:	c1 eb 0a             	shr    $0xa,%ebx
80106ac8:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106ace:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106ad1:	5b                   	pop    %ebx
80106ad2:	5e                   	pop    %esi
80106ad3:	5f                   	pop    %edi
80106ad4:	5d                   	pop    %ebp
80106ad5:	c3                   	ret    
80106ad6:	8d 76 00             	lea    0x0(%esi),%esi
80106ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ae0:	85 c9                	test   %ecx,%ecx
80106ae2:	74 2c                	je     80106b10 <walkpgdir+0x70>
80106ae4:	e8 17 bc ff ff       	call   80102700 <kalloc>
80106ae9:	85 c0                	test   %eax,%eax
80106aeb:	89 c6                	mov    %eax,%esi
80106aed:	74 21                	je     80106b10 <walkpgdir+0x70>
      {
	 //cprintf("inside walkpgdir\n");
      return 0;
       }
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106aef:	83 ec 04             	sub    $0x4,%esp
80106af2:	68 00 10 00 00       	push   $0x1000
80106af7:	6a 00                	push   $0x0
80106af9:	50                   	push   %eax
80106afa:	e8 71 db ff ff       	call   80104670 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106aff:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b05:	83 c4 10             	add    $0x10,%esp
80106b08:	83 c8 07             	or     $0x7,%eax
80106b0b:	89 07                	mov    %eax,(%edi)
80106b0d:	eb b3                	jmp    80106ac2 <walkpgdir+0x22>
80106b0f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106b10:	8d 65 f4             	lea    -0xc(%ebp),%esp
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      {
	 //cprintf("inside walkpgdir\n");
      return 0;
80106b13:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106b15:	5b                   	pop    %ebx
80106b16:	5e                   	pop    %esi
80106b17:	5f                   	pop    %edi
80106b18:	5d                   	pop    %ebp
80106b19:	c3                   	ret    
80106b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b20 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106b26:	89 d3                	mov    %edx,%ebx
80106b28:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106b2e:	83 ec 1c             	sub    $0x1c,%esp
80106b31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106b34:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106b38:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b40:	89 45 e0             	mov    %eax,-0x20(%ebp)
      cprintf("walkpgdir gadbad kar raha hai\n");
      return -1;
      }
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b43:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b46:	29 df                	sub    %ebx,%edi
80106b48:	83 c8 01             	or     $0x1,%eax
80106b4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b4e:	eb 15                	jmp    80106b65 <mappages+0x45>
      {
     // cprintf((char *)pte);
      cprintf("walkpgdir gadbad kar raha hai\n");
      return -1;
      }
    if(*pte & PTE_P)
80106b50:	f6 00 01             	testb  $0x1,(%eax)
80106b53:	75 55                	jne    80106baa <mappages+0x8a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b55:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b58:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
      cprintf("walkpgdir gadbad kar raha hai\n");
      return -1;
      }
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b5b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b5d:	74 41                	je     80106ba0 <mappages+0x80>
      break;
    a += PGSIZE;
80106b5f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b68:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b6d:	89 da                	mov    %ebx,%edx
80106b6f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b72:	e8 29 ff ff ff       	call   80106aa0 <walkpgdir>
80106b77:	85 c0                	test   %eax,%eax
80106b79:	75 d5                	jne    80106b50 <mappages+0x30>
      {
     // cprintf((char *)pte);
      cprintf("walkpgdir gadbad kar raha hai\n");
80106b7b:	83 ec 0c             	sub    $0xc,%esp
80106b7e:	68 f4 7f 10 80       	push   $0x80107ff4
80106b83:	e8 08 9c ff ff       	call   80100790 <cprintf>
      return -1;
80106b88:	83 c4 10             	add    $0x10,%esp
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      {
     // cprintf((char *)pte);
      cprintf("walkpgdir gadbad kar raha hai\n");
      return -1;
80106b8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106b93:	5b                   	pop    %ebx
80106b94:	5e                   	pop    %esi
80106b95:	5f                   	pop    %edi
80106b96:	5d                   	pop    %ebp
80106b97:	c3                   	ret    
80106b98:	90                   	nop
80106b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106ba3:	31 c0                	xor    %eax,%eax
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret    
     // cprintf((char *)pte);
      cprintf("walkpgdir gadbad kar raha hai\n");
      return -1;
      }
    if(*pte & PTE_P)
      panic("remap");
80106baa:	83 ec 0c             	sub    $0xc,%esp
80106bad:	68 38 80 10 80       	push   $0x80108038
80106bb2:	e8 e9 98 ff ff       	call   801004a0 <panic>
80106bb7:	89 f6                	mov    %esi,%esi
80106bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bc0 <deallocuvm.part.0>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
// If the page was swapped free the corresponding disk block.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	57                   	push   %edi
80106bc4:	56                   	push   %esi
80106bc5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bc6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
// If the page was swapped free the corresponding disk block.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bcc:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106bce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
// If the page was swapped free the corresponding disk block.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106bd4:	83 ec 1c             	sub    $0x1c,%esp
80106bd7:	89 4d dc             	mov    %ecx,-0x24(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  	for(; a  < oldsz; a += PGSIZE)
80106bda:	39 d3                	cmp    %edx,%ebx
80106bdc:	73 71                	jae    80106c4f <deallocuvm.part.0+0x8f>
80106bde:	89 d6                	mov    %edx,%esi
80106be0:	eb 48                	jmp    80106c2a <deallocuvm.part.0+0x6a>
80106be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	{
   		 pte = walkpgdir(pgdir, (char*)a, 0);
   		 if(!pte)
     			 a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
   		 else if((*pte & PTE_P) != 0)
80106be8:	8b 10                	mov    (%eax),%edx
80106bea:	f6 c2 01             	test   $0x1,%dl
80106bed:	74 31                	je     80106c20 <deallocuvm.part.0+0x60>
		{
     			 pa = PTE_ADDR(*pte);
     			 if(pa == 0)
80106bef:	89 d1                	mov    %edx,%ecx
80106bf1:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80106bf7:	0f 84 82 00 00 00    	je     80106c7f <deallocuvm.part.0+0xbf>
        			panic("kfree");
			//freeing swapped disk blocks
			if(*pte & PTE_PS)
80106bfd:	f6 c2 80             	test   $0x80,%dl
80106c00:	75 5e                	jne    80106c60 <deallocuvm.part.0+0xa0>
				{
					uint blk = (*pte)>>12;
					bfree_page(ROOTDEV, blk);
				}
      			char *v = P2V(pa);
     			 kfree(v);
80106c02:	83 ec 0c             	sub    $0xc,%esp
80106c05:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80106c0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c0e:	51                   	push   %ecx
80106c0f:	e8 3c b9 ff ff       	call   80102550 <kfree>
      			*pte = 0;
80106c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c17:	83 c4 10             	add    $0x10,%esp
80106c1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  	for(; a  < oldsz; a += PGSIZE)
80106c20:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c26:	39 f3                	cmp    %esi,%ebx
80106c28:	73 25                	jae    80106c4f <deallocuvm.part.0+0x8f>
	{
   		 pte = walkpgdir(pgdir, (char*)a, 0);
80106c2a:	31 c9                	xor    %ecx,%ecx
80106c2c:	89 da                	mov    %ebx,%edx
80106c2e:	89 f8                	mov    %edi,%eax
80106c30:	e8 6b fe ff ff       	call   80106aa0 <walkpgdir>
   		 if(!pte)
80106c35:	85 c0                	test   %eax,%eax
80106c37:	75 af                	jne    80106be8 <deallocuvm.part.0+0x28>
     			 a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106c39:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106c3f:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  	for(; a  < oldsz; a += PGSIZE)
80106c45:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c4b:	39 f3                	cmp    %esi,%ebx
80106c4d:	72 db                	jb     80106c2a <deallocuvm.part.0+0x6a>
     			 kfree(v);
      			*pte = 0;
   		 }
  	}
  	return newsz;
}
80106c4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c55:	5b                   	pop    %ebx
80106c56:	5e                   	pop    %esi
80106c57:	5f                   	pop    %edi
80106c58:	5d                   	pop    %ebp
80106c59:	c3                   	ret    
80106c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        			panic("kfree");
			//freeing swapped disk blocks
			if(*pte & PTE_PS)
				{
					uint blk = (*pte)>>12;
					bfree_page(ROOTDEV, blk);
80106c60:	83 ec 08             	sub    $0x8,%esp
80106c63:	c1 ea 0c             	shr    $0xc,%edx
80106c66:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106c69:	52                   	push   %edx
80106c6a:	6a 01                	push   $0x1
80106c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c6f:	e8 2c aa ff ff       	call   801016a0 <bfree_page>
80106c74:	83 c4 10             	add    $0x10,%esp
80106c77:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c7d:	eb 83                	jmp    80106c02 <deallocuvm.part.0+0x42>
     			 a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
   		 else if((*pte & PTE_P) != 0)
		{
     			 pa = PTE_ADDR(*pte);
     			 if(pa == 0)
        			panic("kfree");
80106c7f:	83 ec 0c             	sub    $0xc,%esp
80106c82:	68 6a 78 10 80       	push   $0x8010786a
80106c87:	e8 14 98 ff ff       	call   801004a0 <panic>
80106c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c90 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106c96:	e8 35 cd ff ff       	call   801039d0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c9b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ca1:	31 c9                	xor    %ecx,%ecx
80106ca3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ca8:	66 89 90 f8 37 11 80 	mov    %dx,-0x7feec808(%eax)
80106caf:	66 89 88 fa 37 11 80 	mov    %cx,-0x7feec806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cb6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106cbb:	31 c9                	xor    %ecx,%ecx
80106cbd:	66 89 90 00 38 11 80 	mov    %dx,-0x7feec800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cc4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106cc9:	66 89 88 02 38 11 80 	mov    %cx,-0x7feec7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106cd0:	31 c9                	xor    %ecx,%ecx
80106cd2:	66 89 90 08 38 11 80 	mov    %dx,-0x7feec7f8(%eax)
80106cd9:	66 89 88 0a 38 11 80 	mov    %cx,-0x7feec7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ce0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106ce5:	31 c9                	xor    %ecx,%ecx
80106ce7:	66 89 90 10 38 11 80 	mov    %dx,-0x7feec7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106cee:	c6 80 fc 37 11 80 00 	movb   $0x0,-0x7feec804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106cf5:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106cfa:	c6 80 fd 37 11 80 9a 	movb   $0x9a,-0x7feec803(%eax)
80106d01:	c6 80 fe 37 11 80 cf 	movb   $0xcf,-0x7feec802(%eax)
80106d08:	c6 80 ff 37 11 80 00 	movb   $0x0,-0x7feec801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d0f:	c6 80 04 38 11 80 00 	movb   $0x0,-0x7feec7fc(%eax)
80106d16:	c6 80 05 38 11 80 92 	movb   $0x92,-0x7feec7fb(%eax)
80106d1d:	c6 80 06 38 11 80 cf 	movb   $0xcf,-0x7feec7fa(%eax)
80106d24:	c6 80 07 38 11 80 00 	movb   $0x0,-0x7feec7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d2b:	c6 80 0c 38 11 80 00 	movb   $0x0,-0x7feec7f4(%eax)
80106d32:	c6 80 0d 38 11 80 fa 	movb   $0xfa,-0x7feec7f3(%eax)
80106d39:	c6 80 0e 38 11 80 cf 	movb   $0xcf,-0x7feec7f2(%eax)
80106d40:	c6 80 0f 38 11 80 00 	movb   $0x0,-0x7feec7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d47:	66 89 88 12 38 11 80 	mov    %cx,-0x7feec7ee(%eax)
80106d4e:	c6 80 14 38 11 80 00 	movb   $0x0,-0x7feec7ec(%eax)
80106d55:	c6 80 15 38 11 80 f2 	movb   $0xf2,-0x7feec7eb(%eax)
80106d5c:	c6 80 16 38 11 80 cf 	movb   $0xcf,-0x7feec7ea(%eax)
80106d63:	c6 80 17 38 11 80 00 	movb   $0x0,-0x7feec7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106d6a:	05 f0 37 11 80       	add    $0x801137f0,%eax
80106d6f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106d73:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106d77:	c1 e8 10             	shr    $0x10,%eax
80106d7a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106d7e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106d81:	0f 01 10             	lgdtl  (%eax)
}
80106d84:	c9                   	leave  
80106d85:	c3                   	ret    
80106d86:	8d 76 00             	lea    0x0(%esi),%esi
80106d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d90 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d90:	a1 a4 64 11 80       	mov    0x801164a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106d95:	55                   	push   %ebp
80106d96:	89 e5                	mov    %esp,%ebp
80106d98:	05 00 00 00 80       	add    $0x80000000,%eax
80106d9d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106da0:	5d                   	pop    %ebp
80106da1:	c3                   	ret    
80106da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106db0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	57                   	push   %edi
80106db4:	56                   	push   %esi
80106db5:	53                   	push   %ebx
80106db6:	83 ec 1c             	sub    $0x1c,%esp
80106db9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106dbc:	85 f6                	test   %esi,%esi
80106dbe:	0f 84 cd 00 00 00    	je     80106e91 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106dc4:	8b 46 08             	mov    0x8(%esi),%eax
80106dc7:	85 c0                	test   %eax,%eax
80106dc9:	0f 84 dc 00 00 00    	je     80106eab <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106dcf:	8b 7e 04             	mov    0x4(%esi),%edi
80106dd2:	85 ff                	test   %edi,%edi
80106dd4:	0f 84 c4 00 00 00    	je     80106e9e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
80106dda:	e8 e1 d6 ff ff       	call   801044c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ddf:	e8 6c cb ff ff       	call   80103950 <mycpu>
80106de4:	89 c3                	mov    %eax,%ebx
80106de6:	e8 65 cb ff ff       	call   80103950 <mycpu>
80106deb:	89 c7                	mov    %eax,%edi
80106ded:	e8 5e cb ff ff       	call   80103950 <mycpu>
80106df2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106df5:	83 c7 08             	add    $0x8,%edi
80106df8:	e8 53 cb ff ff       	call   80103950 <mycpu>
80106dfd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e00:	83 c0 08             	add    $0x8,%eax
80106e03:	ba 67 00 00 00       	mov    $0x67,%edx
80106e08:	c1 e8 18             	shr    $0x18,%eax
80106e0b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106e12:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106e19:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106e20:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106e27:	83 c1 08             	add    $0x8,%ecx
80106e2a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106e30:	c1 e9 10             	shr    $0x10,%ecx
80106e33:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e39:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106e3e:	e8 0d cb ff ff       	call   80103950 <mycpu>
80106e43:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e4a:	e8 01 cb ff ff       	call   80103950 <mycpu>
80106e4f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106e54:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e58:	e8 f3 ca ff ff       	call   80103950 <mycpu>
80106e5d:	8b 56 08             	mov    0x8(%esi),%edx
80106e60:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106e66:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e69:	e8 e2 ca ff ff       	call   80103950 <mycpu>
80106e6e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106e72:	b8 28 00 00 00       	mov    $0x28,%eax
80106e77:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e7a:	8b 46 04             	mov    0x4(%esi),%eax
80106e7d:	05 00 00 00 80       	add    $0x80000000,%eax
80106e82:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e88:	5b                   	pop    %ebx
80106e89:	5e                   	pop    %esi
80106e8a:	5f                   	pop    %edi
80106e8b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106e8c:	e9 1f d7 ff ff       	jmp    801045b0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106e91:	83 ec 0c             	sub    $0xc,%esp
80106e94:	68 3e 80 10 80       	push   $0x8010803e
80106e99:	e8 02 96 ff ff       	call   801004a0 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106e9e:	83 ec 0c             	sub    $0xc,%esp
80106ea1:	68 69 80 10 80       	push   $0x80108069
80106ea6:	e8 f5 95 ff ff       	call   801004a0 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106eab:	83 ec 0c             	sub    $0xc,%esp
80106eae:	68 54 80 10 80       	push   $0x80108054
80106eb3:	e8 e8 95 ff ff       	call   801004a0 <panic>
80106eb8:	90                   	nop
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
80106ec9:	8b 75 10             	mov    0x10(%ebp),%esi
80106ecc:	8b 45 08             	mov    0x8(%ebp),%eax
80106ecf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106ed2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ed8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106edb:	77 49                	ja     80106f26 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106edd:	e8 1e b8 ff ff       	call   80102700 <kalloc>
  memset(mem, 0, PGSIZE);
80106ee2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106ee5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ee7:	68 00 10 00 00       	push   $0x1000
80106eec:	6a 00                	push   $0x0
80106eee:	50                   	push   %eax
80106eef:	e8 7c d7 ff ff       	call   80104670 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ef4:	58                   	pop    %eax
80106ef5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106efb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f00:	5a                   	pop    %edx
80106f01:	6a 06                	push   $0x6
80106f03:	50                   	push   %eax
80106f04:	31 d2                	xor    %edx,%edx
80106f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f09:	e8 12 fc ff ff       	call   80106b20 <mappages>
  memmove(mem, init, sz);
80106f0e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f11:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f14:	83 c4 10             	add    $0x10,%esp
80106f17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f1d:	5b                   	pop    %ebx
80106f1e:	5e                   	pop    %esi
80106f1f:	5f                   	pop    %edi
80106f20:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106f21:	e9 fa d7 ff ff       	jmp    80104720 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106f26:	83 ec 0c             	sub    $0xc,%esp
80106f29:	68 7d 80 10 80       	push   $0x8010807d
80106f2e:	e8 6d 95 ff ff       	call   801004a0 <panic>
80106f33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f40 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	57                   	push   %edi
80106f44:	56                   	push   %esi
80106f45:	53                   	push   %ebx
80106f46:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106f49:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106f50:	0f 85 91 00 00 00    	jne    80106fe7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106f56:	8b 75 18             	mov    0x18(%ebp),%esi
80106f59:	31 db                	xor    %ebx,%ebx
80106f5b:	85 f6                	test   %esi,%esi
80106f5d:	75 1a                	jne    80106f79 <loaduvm+0x39>
80106f5f:	eb 6f                	jmp    80106fd0 <loaduvm+0x90>
80106f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f6e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106f74:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106f77:	76 57                	jbe    80106fd0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106f79:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f7f:	31 c9                	xor    %ecx,%ecx
80106f81:	01 da                	add    %ebx,%edx
80106f83:	e8 18 fb ff ff       	call   80106aa0 <walkpgdir>
80106f88:	85 c0                	test   %eax,%eax
80106f8a:	74 4e                	je     80106fda <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106f8c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106f91:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106f96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106f9b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fa1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fa4:	01 d9                	add    %ebx,%ecx
80106fa6:	05 00 00 00 80       	add    $0x80000000,%eax
80106fab:	57                   	push   %edi
80106fac:	51                   	push   %ecx
80106fad:	50                   	push   %eax
80106fae:	ff 75 10             	pushl  0x10(%ebp)
80106fb1:	e8 0a ac ff ff       	call   80101bc0 <readi>
80106fb6:	83 c4 10             	add    $0x10,%esp
80106fb9:	39 c7                	cmp    %eax,%edi
80106fbb:	74 ab                	je     80106f68 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106fc5:	5b                   	pop    %ebx
80106fc6:	5e                   	pop    %esi
80106fc7:	5f                   	pop    %edi
80106fc8:	5d                   	pop    %ebp
80106fc9:	c3                   	ret    
80106fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106fd3:	31 c0                	xor    %eax,%eax
}
80106fd5:	5b                   	pop    %ebx
80106fd6:	5e                   	pop    %esi
80106fd7:	5f                   	pop    %edi
80106fd8:	5d                   	pop    %ebp
80106fd9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106fda:	83 ec 0c             	sub    $0xc,%esp
80106fdd:	68 97 80 10 80       	push   $0x80108097
80106fe2:	e8 b9 94 ff ff       	call   801004a0 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106fe7:	83 ec 0c             	sub    $0xc,%esp
80106fea:	68 14 80 10 80       	push   $0x80108014
80106fef:	e8 ac 94 ff ff       	call   801004a0 <panic>
80106ff4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ffa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107000 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
80107006:	83 ec 0c             	sub    $0xc,%esp
80107009:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010700c:	85 ff                	test   %edi,%edi
8010700e:	0f 88 ca 00 00 00    	js     801070de <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80107014:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107017:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
8010701a:	0f 82 82 00 00 00    	jb     801070a2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107020:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107026:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  
  for(; a < newsz; a += PGSIZE){
8010702c:	39 df                	cmp    %ebx,%edi
8010702e:	77 43                	ja     80107073 <allocuvm+0x73>
80107030:	e9 bb 00 00 00       	jmp    801070f0 <allocuvm+0xf0>
80107035:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107038:	83 ec 04             	sub    $0x4,%esp
8010703b:	68 00 10 00 00       	push   $0x1000
80107040:	6a 00                	push   $0x0
80107042:	50                   	push   %eax
80107043:	e8 28 d6 ff ff       	call   80104670 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107048:	58                   	pop    %eax
80107049:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010704f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107054:	5a                   	pop    %edx
80107055:	6a 06                	push   $0x6
80107057:	50                   	push   %eax
80107058:	89 da                	mov    %ebx,%edx
8010705a:	8b 45 08             	mov    0x8(%ebp),%eax
8010705d:	e8 be fa ff ff       	call   80106b20 <mappages>
80107062:	83 c4 10             	add    $0x10,%esp
80107065:	85 c0                	test   %eax,%eax
80107067:	78 47                	js     801070b0 <allocuvm+0xb0>
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  
  for(; a < newsz; a += PGSIZE){
80107069:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010706f:	39 df                	cmp    %ebx,%edi
80107071:	76 7d                	jbe    801070f0 <allocuvm+0xf0>
    mem = kalloc();
80107073:	e8 88 b6 ff ff       	call   80102700 <kalloc>
    if(mem == 0){
80107078:	85 c0                	test   %eax,%eax
    return oldsz;

  a = PGROUNDUP(oldsz);
  
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
8010707a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010707c:	75 ba                	jne    80107038 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
8010707e:	83 ec 0c             	sub    $0xc,%esp
80107081:	68 b5 80 10 80       	push   $0x801080b5
80107086:	e8 05 97 ff ff       	call   80100790 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010708b:	83 c4 10             	add    $0x10,%esp
8010708e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107091:	76 4b                	jbe    801070de <allocuvm+0xde>
80107093:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107096:	8b 45 08             	mov    0x8(%ebp),%eax
80107099:	89 fa                	mov    %edi,%edx
8010709b:	e8 20 fb ff ff       	call   80106bc0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
801070a0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801070a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070a5:	5b                   	pop    %ebx
801070a6:	5e                   	pop    %esi
801070a7:	5f                   	pop    %edi
801070a8:	5d                   	pop    %ebp
801070a9:	c3                   	ret    
801070aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
801070b0:	83 ec 0c             	sub    $0xc,%esp
801070b3:	68 cd 80 10 80       	push   $0x801080cd
801070b8:	e8 d3 96 ff ff       	call   80100790 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801070bd:	83 c4 10             	add    $0x10,%esp
801070c0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801070c3:	76 0d                	jbe    801070d2 <allocuvm+0xd2>
801070c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801070c8:	8b 45 08             	mov    0x8(%ebp),%eax
801070cb:	89 fa                	mov    %edi,%edx
801070cd:	e8 ee fa ff ff       	call   80106bc0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
801070d2:	83 ec 0c             	sub    $0xc,%esp
801070d5:	56                   	push   %esi
801070d6:	e8 75 b4 ff ff       	call   80102550 <kfree>
      return 0;
801070db:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
801070de:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
801070e1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
801070e3:	5b                   	pop    %ebx
801070e4:	5e                   	pop    %esi
801070e5:	5f                   	pop    %edi
801070e6:	5d                   	pop    %ebp
801070e7:	c3                   	ret    
801070e8:	90                   	nop
801070e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  
  for(; a < newsz; a += PGSIZE){
801070f3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
801070f5:	5b                   	pop    %ebx
801070f6:	5e                   	pop    %esi
801070f7:	5f                   	pop    %edi
801070f8:	5d                   	pop    %ebp
801070f9:	c3                   	ret    
801070fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107100 <deallocuvm>:
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
// If the page was swapped free the corresponding disk block.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	8b 55 0c             	mov    0xc(%ebp),%edx
80107106:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107109:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010710c:	39 d1                	cmp    %edx,%ecx
8010710e:	73 10                	jae    80107120 <deallocuvm+0x20>
     			 kfree(v);
      			*pte = 0;
   		 }
  	}
  	return newsz;
}
80107110:	5d                   	pop    %ebp
80107111:	e9 aa fa ff ff       	jmp    80106bc0 <deallocuvm.part.0>
80107116:	8d 76 00             	lea    0x0(%esi),%esi
80107119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107120:	89 d0                	mov    %edx,%eax
80107122:	5d                   	pop    %ebp
80107123:	c3                   	ret    
80107124:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010712a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107130 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	57                   	push   %edi
80107134:	56                   	push   %esi
80107135:	53                   	push   %ebx
80107136:	83 ec 0c             	sub    $0xc,%esp
80107139:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010713c:	85 f6                	test   %esi,%esi
8010713e:	74 59                	je     80107199 <freevm+0x69>
80107140:	31 c9                	xor    %ecx,%ecx
80107142:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107147:	89 f0                	mov    %esi,%eax
80107149:	e8 72 fa ff ff       	call   80106bc0 <deallocuvm.part.0>
8010714e:	89 f3                	mov    %esi,%ebx
80107150:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107156:	eb 0f                	jmp    80107167 <freevm+0x37>
80107158:	90                   	nop
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107160:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107163:	39 fb                	cmp    %edi,%ebx
80107165:	74 23                	je     8010718a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107167:	8b 03                	mov    (%ebx),%eax
80107169:	a8 01                	test   $0x1,%al
8010716b:	74 f3                	je     80107160 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010716d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107172:	83 ec 0c             	sub    $0xc,%esp
80107175:	83 c3 04             	add    $0x4,%ebx
80107178:	05 00 00 00 80       	add    $0x80000000,%eax
8010717d:	50                   	push   %eax
8010717e:	e8 cd b3 ff ff       	call   80102550 <kfree>
80107183:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107186:	39 fb                	cmp    %edi,%ebx
80107188:	75 dd                	jne    80107167 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010718a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010718d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107190:	5b                   	pop    %ebx
80107191:	5e                   	pop    %esi
80107192:	5f                   	pop    %edi
80107193:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107194:	e9 b7 b3 ff ff       	jmp    80102550 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107199:	83 ec 0c             	sub    $0xc,%esp
8010719c:	68 e9 80 10 80       	push   $0x801080e9
801071a1:	e8 fa 92 ff ff       	call   801004a0 <panic>
801071a6:	8d 76 00             	lea    0x0(%esi),%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071b0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	56                   	push   %esi
801071b4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801071b5:	e8 46 b5 ff ff       	call   80102700 <kalloc>
801071ba:	85 c0                	test   %eax,%eax
801071bc:	74 6a                	je     80107228 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
801071be:	83 ec 04             	sub    $0x4,%esp
801071c1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071c3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
801071c8:	68 00 10 00 00       	push   $0x1000
801071cd:	6a 00                	push   $0x0
801071cf:	50                   	push   %eax
801071d0:	e8 9b d4 ff ff       	call   80104670 <memset>
801071d5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801071d8:	8b 43 04             	mov    0x4(%ebx),%eax
801071db:	8b 4b 08             	mov    0x8(%ebx),%ecx
801071de:	83 ec 08             	sub    $0x8,%esp
801071e1:	8b 13                	mov    (%ebx),%edx
801071e3:	ff 73 0c             	pushl  0xc(%ebx)
801071e6:	50                   	push   %eax
801071e7:	29 c1                	sub    %eax,%ecx
801071e9:	89 f0                	mov    %esi,%eax
801071eb:	e8 30 f9 ff ff       	call   80106b20 <mappages>
801071f0:	83 c4 10             	add    $0x10,%esp
801071f3:	85 c0                	test   %eax,%eax
801071f5:	78 19                	js     80107210 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801071f7:	83 c3 10             	add    $0x10,%ebx
801071fa:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107200:	75 d6                	jne    801071d8 <setupkvm+0x28>
80107202:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107204:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107207:	5b                   	pop    %ebx
80107208:	5e                   	pop    %esi
80107209:	5d                   	pop    %ebp
8010720a:	c3                   	ret    
8010720b:	90                   	nop
8010720c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107210:	83 ec 0c             	sub    $0xc,%esp
80107213:	56                   	push   %esi
80107214:	e8 17 ff ff ff       	call   80107130 <freevm>
      return 0;
80107219:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010721c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010721f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107221:	5b                   	pop    %ebx
80107222:	5e                   	pop    %esi
80107223:	5d                   	pop    %ebp
80107224:	c3                   	ret    
80107225:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107228:	31 c0                	xor    %eax,%eax
8010722a:	eb d8                	jmp    80107204 <setupkvm+0x54>
8010722c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107230 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107236:	e8 75 ff ff ff       	call   801071b0 <setupkvm>
8010723b:	a3 a4 64 11 80       	mov    %eax,0x801164a4
80107240:	05 00 00 00 80       	add    $0x80000000,%eax
80107245:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107248:	c9                   	leave  
80107249:	c3                   	ret    
8010724a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107250 <select_a_victim>:
// Select a page-table entry which is mapped
// but not accessed. Notice that the user memory
// is mapped between 0...KERNBASE.
pte_t*
select_a_victim(pde_t *pgdir)
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	56                   	push   %esi
80107254:	53                   	push   %ebx
80107255:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("selecting victim\n");
  	int i=0;
	pte_t *pte;
	for(i = 0; i <= KERNBASE; i += PGSIZE)
80107258:	31 db                	xor    %ebx,%ebx
// but not accessed. Notice that the user memory
// is mapped between 0...KERNBASE.
pte_t*
select_a_victim(pde_t *pgdir)
{
	cprintf("selecting victim\n");
8010725a:	83 ec 0c             	sub    $0xc,%esp
8010725d:	68 fa 80 10 80       	push   $0x801080fa
80107262:	e8 29 95 ff ff       	call   80100790 <cprintf>
  	int i=0;
	pte_t *pte;
	for(i = 0; i <= KERNBASE; i += PGSIZE)
80107267:	83 c4 10             	add    $0x10,%esp
8010726a:	eb 14                	jmp    80107280 <select_a_victim+0x30>
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	{
    		if((pte = walkpgdir(pgdir, (char*)i, 0)) != 0)
		{
			if(*pte==0)
				return (pte_t*)(pte);
			if(*pte & PTE_P)
80107270:	f6 c2 01             	test   $0x1,%dl
80107273:	74 05                	je     8010727a <select_a_victim+0x2a>
				if(!(*pte & PTE_A))
80107275:	83 e2 20             	and    $0x20,%edx
80107278:	74 1b                	je     80107295 <select_a_victim+0x45>
select_a_victim(pde_t *pgdir)
{
	cprintf("selecting victim\n");
  	int i=0;
	pte_t *pte;
	for(i = 0; i <= KERNBASE; i += PGSIZE)
8010727a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	{
    		if((pte = walkpgdir(pgdir, (char*)i, 0)) != 0)
80107280:	31 c9                	xor    %ecx,%ecx
80107282:	89 da                	mov    %ebx,%edx
80107284:	89 f0                	mov    %esi,%eax
80107286:	e8 15 f8 ff ff       	call   80106aa0 <walkpgdir>
8010728b:	85 c0                	test   %eax,%eax
8010728d:	74 eb                	je     8010727a <select_a_victim+0x2a>
		{
			if(*pte==0)
8010728f:	8b 10                	mov    (%eax),%edx
80107291:	85 d2                	test   %edx,%edx
80107293:	75 db                	jne    80107270 <select_a_victim+0x20>
					return (pte_t*)(pte);
		}
	}
	cprintf("bad victim\n");
	return 0;
}
80107295:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107298:	5b                   	pop    %ebx
80107299:	5e                   	pop    %esi
8010729a:	5d                   	pop    %ebp
8010729b:	c3                   	ret    
8010729c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072a0 <clearaccessbit>:

// Clear access bit of a random pte.
void
clearaccessbit(pde_t *pgdir)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
	cprintf("clearing access bit\n");
801072a6:	31 ff                	xor    %edi,%edi
801072a8:	31 db                	xor    %ebx,%ebx
}

// Clear access bit of a random pte.
void
clearaccessbit(pde_t *pgdir)
{
801072aa:	83 ec 18             	sub    $0x18,%esp
801072ad:	8b 75 08             	mov    0x8(%ebp),%esi
	cprintf("clearing access bit\n");
801072b0:	68 0c 81 10 80       	push   $0x8010810c
801072b5:	e8 d6 94 ff ff       	call   80100790 <cprintf>
801072ba:	83 c4 10             	add    $0x10,%esp
801072bd:	eb 07                	jmp    801072c6 <clearaccessbit+0x26>
801072bf:	90                   	nop
  	int i=0;
	pte_t *pte;
	int count = 0;
	for(i = 0; i <= KERNBASE; i += PGSIZE)
801072c0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	{
		i =(i+25765)%KERNBASE;
801072c6:	81 c3 a5 64 00 00    	add    $0x64a5,%ebx
    		if((pte = walkpgdir(pgdir, (char*)i, 0)) != 0)
801072cc:	31 c9                	xor    %ecx,%ecx
801072ce:	89 f0                	mov    %esi,%eax
  	int i=0;
	pte_t *pte;
	int count = 0;
	for(i = 0; i <= KERNBASE; i += PGSIZE)
	{
		i =(i+25765)%KERNBASE;
801072d0:	81 e3 ff ff ff 7f    	and    $0x7fffffff,%ebx
    		if((pte = walkpgdir(pgdir, (char*)i, 0)) != 0)
801072d6:	89 da                	mov    %ebx,%edx
801072d8:	e8 c3 f7 ff ff       	call   80106aa0 <walkpgdir>
801072dd:	85 c0                	test   %eax,%eax
801072df:	74 df                	je     801072c0 <clearaccessbit+0x20>
		{
			if(*pte & PTE_P)
801072e1:	8b 10                	mov    (%eax),%edx
801072e3:	f6 c2 01             	test   $0x1,%dl
801072e6:	74 d8                	je     801072c0 <clearaccessbit+0x20>
			{
				//cprintf("Value of pte before clearing access bit %d\n",*pte);
				*pte &= ~PTE_A;
				//cprintf("Value of pte after clearing access bit %d\n",*pte);
				cprintf("Found a victim\n");
801072e8:	83 ec 0c             	sub    $0xc,%esp
    		if((pte = walkpgdir(pgdir, (char*)i, 0)) != 0)
		{
			if(*pte & PTE_P)
			{
				//cprintf("Value of pte before clearing access bit %d\n",*pte);
				*pte &= ~PTE_A;
801072eb:	83 e2 df             	and    $0xffffffdf,%edx
				//cprintf("Value of pte after clearing access bit %d\n",*pte);
				cprintf("Found a victim\n");
				count +=1;
801072ee:	83 c7 01             	add    $0x1,%edi
    		if((pte = walkpgdir(pgdir, (char*)i, 0)) != 0)
		{
			if(*pte & PTE_P)
			{
				//cprintf("Value of pte before clearing access bit %d\n",*pte);
				*pte &= ~PTE_A;
801072f1:	89 10                	mov    %edx,(%eax)
				//cprintf("Value of pte after clearing access bit %d\n",*pte);
				cprintf("Found a victim\n");
801072f3:	68 21 81 10 80       	push   $0x80108121
801072f8:	e8 93 94 ff ff       	call   80100790 <cprintf>
				count +=1;
				if(count>102)
801072fd:	83 c4 10             	add    $0x10,%esp
80107300:	83 ff 66             	cmp    $0x66,%edi
80107303:	7e bb                	jle    801072c0 <clearaccessbit+0x20>
			}
					
		}
	}
	return;
}
80107305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107308:	5b                   	pop    %ebx
80107309:	5e                   	pop    %esi
8010730a:	5f                   	pop    %edi
8010730b:	5d                   	pop    %ebp
8010730c:	c3                   	ret    
8010730d:	8d 76 00             	lea    0x0(%esi),%esi

80107310 <getswappedblk>:

// return the disk block-id, if the virtual address
// was swapped, -1 otherwise.
int
getswappedblk(pde_t *pgdir, uint va)
{
80107310:	55                   	push   %ebp
	pte_t *pte;
	pte = walkpgdir(pgdir, (char*)va, 0);
80107311:	31 c9                	xor    %ecx,%ecx

// return the disk block-id, if the virtual address
// was swapped, -1 otherwise.
int
getswappedblk(pde_t *pgdir, uint va)
{
80107313:	89 e5                	mov    %esp,%ebp
80107315:	83 ec 08             	sub    $0x8,%esp
	pte_t *pte;
	pte = walkpgdir(pgdir, (char*)va, 0);
80107318:	8b 55 0c             	mov    0xc(%ebp),%edx
8010731b:	8b 45 08             	mov    0x8(%ebp),%eax
8010731e:	e8 7d f7 ff ff       	call   80106aa0 <walkpgdir>
	if(pte==0)
80107323:	85 c0                	test   %eax,%eax
80107325:	74 17                	je     8010733e <getswappedblk+0x2e>
    		panic("clearpteu");
	if(*pte & PTE_PS)
80107327:	8b 10                	mov    (%eax),%edx
		return (*pte)>>12;
	else
		return -1;
	
}
80107329:	c9                   	leave  
	pte_t *pte;
	pte = walkpgdir(pgdir, (char*)va, 0);
	if(pte==0)
    		panic("clearpteu");
	if(*pte & PTE_PS)
		return (*pte)>>12;
8010732a:	89 d0                	mov    %edx,%eax
8010732c:	c1 e8 0c             	shr    $0xc,%eax
8010732f:	81 e2 80 00 00 00    	and    $0x80,%edx
80107335:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010733a:	0f 44 c2             	cmove  %edx,%eax
	else
		return -1;
	
}
8010733d:	c3                   	ret    
getswappedblk(pde_t *pgdir, uint va)
{
	pte_t *pte;
	pte = walkpgdir(pgdir, (char*)va, 0);
	if(pte==0)
    		panic("clearpteu");
8010733e:	83 ec 0c             	sub    $0xc,%esp
80107341:	68 31 81 10 80       	push   $0x80108131
80107346:	e8 55 91 ff ff       	call   801004a0 <panic>
8010734b:	90                   	nop
8010734c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107350 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107350:	55                   	push   %ebp
	pte_t *pte;
	pte = walkpgdir(pgdir, uva, 0);
80107351:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107353:	89 e5                	mov    %esp,%ebp
80107355:	83 ec 08             	sub    $0x8,%esp
	pte_t *pte;
	pte = walkpgdir(pgdir, uva, 0);
80107358:	8b 55 0c             	mov    0xc(%ebp),%edx
8010735b:	8b 45 08             	mov    0x8(%ebp),%eax
8010735e:	e8 3d f7 ff ff       	call   80106aa0 <walkpgdir>
  	if(pte == 0)
80107363:	85 c0                	test   %eax,%eax
80107365:	74 05                	je     8010736c <clearpteu+0x1c>
    		panic("clearpteu");
  	*pte &= ~PTE_U;
80107367:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010736a:	c9                   	leave  
8010736b:	c3                   	ret    
clearpteu(pde_t *pgdir, char *uva)
{
	pte_t *pte;
	pte = walkpgdir(pgdir, uva, 0);
  	if(pte == 0)
    		panic("clearpteu");
8010736c:	83 ec 0c             	sub    $0xc,%esp
8010736f:	68 31 81 10 80       	push   $0x80108131
80107374:	e8 27 91 ff ff       	call   801004a0 <panic>
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107380 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	57                   	push   %edi
80107384:	56                   	push   %esi
80107385:	53                   	push   %ebx
80107386:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107389:	e8 22 fe ff ff       	call   801071b0 <setupkvm>
8010738e:	85 c0                	test   %eax,%eax
80107390:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107393:	0f 84 b2 00 00 00    	je     8010744b <copyuvm+0xcb>
    return 0;

  	for(i = 0; i < sz; i += PGSIZE)
80107399:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010739c:	85 c9                	test   %ecx,%ecx
8010739e:	0f 84 9c 00 00 00    	je     80107440 <copyuvm+0xc0>
801073a4:	31 f6                	xor    %esi,%esi
801073a6:	eb 4a                	jmp    801073f2 <copyuvm+0x72>
801073a8:	90                   	nop
801073a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			mem = kalloc();
			if(mem==0)*/
     				 goto bad;
		  }

   		 memmove(mem, (char*)P2V(pa), PGSIZE);
801073b0:	83 ec 04             	sub    $0x4,%esp
801073b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801073b9:	68 00 10 00 00       	push   $0x1000
801073be:	57                   	push   %edi
801073bf:	50                   	push   %eax
801073c0:	e8 5b d3 ff ff       	call   80104720 <memmove>
   		 if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801073c5:	58                   	pop    %eax
801073c6:	5a                   	pop    %edx
801073c7:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
801073cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073d0:	ff 75 e4             	pushl  -0x1c(%ebp)
801073d3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073d8:	52                   	push   %edx
801073d9:	89 f2                	mov    %esi,%edx
801073db:	e8 40 f7 ff ff       	call   80106b20 <mappages>
801073e0:	83 c4 10             	add    $0x10,%esp
801073e3:	85 c0                	test   %eax,%eax
801073e5:	78 3e                	js     80107425 <copyuvm+0xa5>
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;

  	for(i = 0; i < sz; i += PGSIZE)
801073e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073ed:	39 75 0c             	cmp    %esi,0xc(%ebp)
801073f0:	76 4e                	jbe    80107440 <copyuvm+0xc0>
	{
    		if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801073f2:	8b 45 08             	mov    0x8(%ebp),%eax
801073f5:	31 c9                	xor    %ecx,%ecx
801073f7:	89 f2                	mov    %esi,%edx
801073f9:	e8 a2 f6 ff ff       	call   80106aa0 <walkpgdir>
801073fe:	85 c0                	test   %eax,%eax
80107400:	74 5a                	je     8010745c <copyuvm+0xdc>
     			 panic("copyuvm: pte should exist");
   		if(!(*pte & PTE_P))
80107402:	8b 18                	mov    (%eax),%ebx
80107404:	f6 c3 01             	test   $0x1,%bl
80107407:	74 46                	je     8010744f <copyuvm+0xcf>
      			 panic("copyuvm: page not present");
   		 pa = PTE_ADDR(*pte);
80107409:	89 df                	mov    %ebx,%edi
   		 flags = PTE_FLAGS(*pte);
8010740b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107411:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	{
    		if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
     			 panic("copyuvm: pte should exist");
   		if(!(*pte & PTE_P))
      			 panic("copyuvm: page not present");
   		 pa = PTE_ADDR(*pte);
80107414:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
   		 flags = PTE_FLAGS(*pte);
    		  if((mem = kalloc()) == 0)
8010741a:	e8 e1 b2 ff ff       	call   80102700 <kalloc>
8010741f:	85 c0                	test   %eax,%eax
80107421:	89 c3                	mov    %eax,%ebx
80107423:	75 8b                	jne    801073b0 <copyuvm+0x30>
    			  goto bad;
	  }
	  return d;

	bad:
 	 freevm(d);
80107425:	83 ec 0c             	sub    $0xc,%esp
80107428:	ff 75 e0             	pushl  -0x20(%ebp)
8010742b:	e8 00 fd ff ff       	call   80107130 <freevm>
  	return 0;
80107430:	83 c4 10             	add    $0x10,%esp
80107433:	31 c0                	xor    %eax,%eax
}
80107435:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107438:	5b                   	pop    %ebx
80107439:	5e                   	pop    %esi
8010743a:	5f                   	pop    %edi
8010743b:	5d                   	pop    %ebp
8010743c:	c3                   	ret    
8010743d:	8d 76 00             	lea    0x0(%esi),%esi
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;

  	for(i = 0; i < sz; i += PGSIZE)
80107440:	8b 45 e0             	mov    -0x20(%ebp),%eax
	  return d;

	bad:
 	 freevm(d);
  	return 0;
}
80107443:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107446:	5b                   	pop    %ebx
80107447:	5e                   	pop    %esi
80107448:	5f                   	pop    %edi
80107449:	5d                   	pop    %ebp
8010744a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
8010744b:	31 c0                	xor    %eax,%eax
8010744d:	eb e6                	jmp    80107435 <copyuvm+0xb5>
  	for(i = 0; i < sz; i += PGSIZE)
	{
    		if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
     			 panic("copyuvm: pte should exist");
   		if(!(*pte & PTE_P))
      			 panic("copyuvm: page not present");
8010744f:	83 ec 0c             	sub    $0xc,%esp
80107452:	68 55 81 10 80       	push   $0x80108155
80107457:	e8 44 90 ff ff       	call   801004a0 <panic>
    return 0;

  	for(i = 0; i < sz; i += PGSIZE)
	{
    		if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
     			 panic("copyuvm: pte should exist");
8010745c:	83 ec 0c             	sub    $0xc,%esp
8010745f:	68 3b 81 10 80       	push   $0x8010813b
80107464:	e8 37 90 ff ff       	call   801004a0 <panic>
80107469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107470 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107470:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107471:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107473:	89 e5                	mov    %esp,%ebp
80107475:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107478:	8b 55 0c             	mov    0xc(%ebp),%edx
8010747b:	8b 45 08             	mov    0x8(%ebp),%eax
8010747e:	e8 1d f6 ff ff       	call   80106aa0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107483:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107485:	89 c2                	mov    %eax,%edx
80107487:	83 e2 05             	and    $0x5,%edx
8010748a:	83 fa 05             	cmp    $0x5,%edx
8010748d:	75 11                	jne    801074a0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010748f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107494:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107495:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010749a:	c3                   	ret    
8010749b:	90                   	nop
8010749c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801074a0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801074a2:	c9                   	leave  
801074a3:	c3                   	ret    
801074a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801074b0 <uva2pte>:

// returns the page table entry corresponding
// to a virtual address.
pte_t*
uva2pte(pde_t *pgdir, uint uva)
{
801074b0:	55                   	push   %ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801074b1:	31 c9                	xor    %ecx,%ecx

// returns the page table entry corresponding
// to a virtual address.
pte_t*
uva2pte(pde_t *pgdir, uint uva)
{
801074b3:	89 e5                	mov    %esp,%ebp
  return walkpgdir(pgdir, (void*)uva, 0);
801074b5:	8b 55 0c             	mov    0xc(%ebp),%edx
801074b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
801074bb:	5d                   	pop    %ebp
// returns the page table entry corresponding
// to a virtual address.
pte_t*
uva2pte(pde_t *pgdir, uint uva)
{
  return walkpgdir(pgdir, (void*)uva, 0);
801074bc:	e9 df f5 ff ff       	jmp    80106aa0 <walkpgdir>
801074c1:	eb 0d                	jmp    801074d0 <copyout>
801074c3:	90                   	nop
801074c4:	90                   	nop
801074c5:	90                   	nop
801074c6:	90                   	nop
801074c7:	90                   	nop
801074c8:	90                   	nop
801074c9:	90                   	nop
801074ca:	90                   	nop
801074cb:	90                   	nop
801074cc:	90                   	nop
801074cd:	90                   	nop
801074ce:	90                   	nop
801074cf:	90                   	nop

801074d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
801074d6:	83 ec 1c             	sub    $0x1c,%esp
801074d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801074dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801074df:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801074e2:	85 db                	test   %ebx,%ebx
801074e4:	75 40                	jne    80107526 <copyout+0x56>
801074e6:	eb 70                	jmp    80107558 <copyout+0x88>
801074e8:	90                   	nop
801074e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801074f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074f3:	89 f1                	mov    %esi,%ecx
801074f5:	29 d1                	sub    %edx,%ecx
801074f7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801074fd:	39 d9                	cmp    %ebx,%ecx
801074ff:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107502:	29 f2                	sub    %esi,%edx
80107504:	83 ec 04             	sub    $0x4,%esp
80107507:	01 d0                	add    %edx,%eax
80107509:	51                   	push   %ecx
8010750a:	57                   	push   %edi
8010750b:	50                   	push   %eax
8010750c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010750f:	e8 0c d2 ff ff       	call   80104720 <memmove>
    len -= n;
    buf += n;
80107514:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107517:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010751a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107520:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107522:	29 cb                	sub    %ecx,%ebx
80107524:	74 32                	je     80107558 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107526:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107528:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010752b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010752e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107534:	56                   	push   %esi
80107535:	ff 75 08             	pushl  0x8(%ebp)
80107538:	e8 33 ff ff ff       	call   80107470 <uva2ka>
    if(pa0 == 0)
8010753d:	83 c4 10             	add    $0x10,%esp
80107540:	85 c0                	test   %eax,%eax
80107542:	75 ac                	jne    801074f0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107544:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010754c:	5b                   	pop    %ebx
8010754d:	5e                   	pop    %esi
8010754e:	5f                   	pop    %edi
8010754f:	5d                   	pop    %ebp
80107550:	c3                   	ret    
80107551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107558:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010755b:	31 c0                	xor    %eax,%eax
}
8010755d:	5b                   	pop    %ebx
8010755e:	5e                   	pop    %esi
8010755f:	5f                   	pop    %edi
80107560:	5d                   	pop    %ebp
80107561:	c3                   	ret    
