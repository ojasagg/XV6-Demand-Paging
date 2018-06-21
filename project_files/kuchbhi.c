#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"

void
mem(void)
{
	void *m1 = 0;
	printf(1, "mem test\n");

	m1 = malloc(4096);
	if (m1 == 0)
		goto failed;
	printf(1, "mem ok %d\n", bstat());
	exit();
failed:
	printf(1, "test failed!\n");
	exit();
}

int
main(int argc, char *argv[])
{
	printf(1, "memtest starting\n");
	mem();
	return 0;
}
