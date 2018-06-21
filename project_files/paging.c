#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
#include "paging.h"
#include "fs.h"

static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
	cprintf("inside walkpgdir\n");
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      {
	 //cprintf("inside walkpgdir\n");
      return 0;
       }
    // Make sure all those PTE_P bits are zero.
	cprintf("set all 0\n");
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

/* Allocate eight consecutive disk blocks.
 * Save the content of the physical page in the pte
 * to the disk blocks and save the block-id into the
 * pte.
 */


void
swap_page_from_pte(pte_t *pte)
{
	//cprintf("Value of pte %d\n",*pte);
	uint mem=balloc_page(ROOTDEV);
	//cprintf("Value of mem before shifting%d\n",mem);
	char memo[PGSIZE]= "";
	uint pa = PTE_ADDR(*pte);
	memmove(memo, (char*)P2V(pa), PGSIZE);
	write_page_to_disk(ROOTDEV, memo,mem);
	mem=mem<<12;
	//cprintf("Value of mem after shifting %d\n",mem);
	*pte = mem| PTE_PS ;
	asm volatile ( "invlpg (%0)" : : "b"((unsigned long)(P2V(pa))) : "memory" );
	kfree((P2V(pa)));
	//cprintf("Value of pte afterswap  %d\n",*pte); 
	if(*pte & PTE_P)
			panic("Swap not done");
}

/* Select a victim and swap the contents to the disk.			
 */
int
swap_page(pde_t *pgdir)
{
	cprintf("inside swap_page\n");
	pte_t *pte = select_a_victim(pgdir);
	//pte = select_a_victim(pgdir);
	cprintf("Value of pte after selecting victim%d\n",*pte);
	if(*pte==0)
		{
		clearaccessbit(pgdir);
		pte = select_a_victim(pgdir);
		}
	cprintf("Selecting a victim again %d\n",*pte);
	swap_page_from_pte(pte);
	cprintf("Verfying value  %d\n",*pte);
	return 1;
}

/* Map a physical page to the virtual address addr.
 * If the page table entry points to a swapped block
 * restore the content of the page from the swapped
 * block and free the swapped block.
 */
void
map_address(pde_t *pgdir, uint addr)
{
	cprintf("\nVA %d\n",addr);
	pte_t *pte;
	pte = walkpgdir(pgdir, (char*)addr, 1);
	cprintf("pte value%d\n",*pte);
	if((*pte & PTE_PS)==1 && (*pte & PTE_P)==0)
	{
		//panic("pte is 1");
		int blk = getswappedblk(pgdir, addr);
		char buffer[PGSIZE]="";
		cprintf("BLK %d\n", blk);
		read_page_from_disk(ROOTDEV, buffer, blk);
		char *kva;
		kva = kalloc();
		if(kva==0)	
		{
			int b = swap_page(pgdir);
			if(b!=1)
				panic("Problem in swapping");
			kva = kalloc();
			if(kva == 0)
				panic("PROBLEM"); 
			memmove(kva , buffer, PGSIZE);
			*pte =  V2P(kva) | PTE_P | PTE_W | PTE_U ;
			bfree_page(ROOTDEV, blk);
		}
		else
		{
			memmove(kva , buffer, PGSIZE);
			*pte =  V2P(kva) | PTE_P | PTE_W | PTE_U ;
			bfree_page(ROOTDEV, blk);
			return ;
		}
	}
	else
	{
		char *kva;
		kva = kalloc();
		if(kva==0)	
		{
			int b = swap_page(pgdir);
			if(b!=1)
				panic("Sys_swap me gadbad");
			kva = kalloc();
			if(kva == 0)
				panic("PROBLEM"); 
			memset(kva,0,PGSIZE);
			*pte =  V2P(kva) | PTE_P | PTE_W | PTE_U ;
			cprintf("pte value%d\n",*pte);
			cprintf("New entry set\n");
		}
		else
		{
		memset(kva,0,PGSIZE);
		*pte = V2P(kva) | PTE_P | PTE_W | PTE_U ;
		cprintf("pte value%d\n",*pte);
		}
	}
	
}

/* page fault handler */
void
handle_pgfault()
{
	unsigned addr;
	struct proc *curproc = myproc();

	asm volatile ("movl %%cr2, %0 \n\t" : "=r" (addr));
	addr &= ~0xfff;
	map_address(curproc->pgdir, addr);
}
