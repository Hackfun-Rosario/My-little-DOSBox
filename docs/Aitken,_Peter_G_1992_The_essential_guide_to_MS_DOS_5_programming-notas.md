# Chapter 2 (p.15)

## Memory Addressing (p.18)

Memory in a PC consists of a large number of **individual storage locations**. **Each location**, which **can hold 1 byte (8 bits) of data**, **has a unique numeric address** that distinguishes it from all other memory locations. All memory in a PC is organized in sequential order, starting at address 0 and extending to 17-1 (in a computer with n bytes of memory installed).

To **access a particular memory location** in an IBM PC with an 8088 micro processor (the CPU chip used by the original IBM PC), **the CPU specifies the location's address as a 20-bit binary value**. The computer's memory circuits interpret this 20-bit value and make the corresponding memory location available to the CPU, which can then either read data from or write data to that memory address. Note that **a 20-bit binary number can specify 2^20, or 1,048,576, different addresses**. This amount of memory is called **1 megabyte**, or 1 MB. Note also that **each address in 1 MB of memory can be specified conveniently in hexadecimal notation in the range 00000H through FFFFFH**.

The memory between 00000H and FFFFFH is used for many tasks; it contains both the BIOS and the DOS kernel, as well as application programs and program data.

The CPU manipulates memory addresses by using **registers**. A register is a **data storage location** that is **internal to the CPU** chip. **Each register is 16 bits**, which means that it can specify 216, or 65,536 (64 KB), memory addresses.

How, then, can 20-bit addresses up to 1 MB be manipulated? The solution to this problem is the use of **segmented memory addressing**, which uses two registers to hold an address. Here's how it works.

One register is called the **segment register**. The 16-bit value in the segment register is **multiplied automatically by 16**. The original range of 0 through 65,535 (0 to 64 KB) is thereby expanded to 0 through 1,048,575 (0 to 1 MB).
**The resulting addresses are limited to 16-byte increments**, of course, but as you'll see, this is OK.

The second register is called the **offset register**. **The value in this register is not changed but is used to create the 20-bit address by simply adding it to the value obtained by multiplying the segment register by 16**, as shown schematically here (all values are in hexadecimal notation):

Segment register value          2BFCH
Multiplied by 16                      2BFC0H
Offset register value               01C2H
Final 20-bit address               2C182H

Another way to look at the segmented memory addressing scheme is:
The **segment register points to the base of a 64-KB segment of memory**, and the **offset register points to a specific address within that 64-KB segment**.

Any way you look at it, the result is an **address that can be used to access any location in the processor's1 MB of address space**.

A **segmented address** is typically written in the form **segment:offset**. for example: **2BFCH:01C2H**

## CPU Registers (p.21)

Every 80x86 CPU contains **14 separate registers**, **each of which is 16 bits in size** (that is, each register can hold a 16-bit binary value). The registers fall into **four categories**: **general purpose**, **segment**, **offset**, and **flags**. 

**Each register** (except **the flags register**) is referred to by a **two-letter code**.

![image-20231207110734426](/home/user/DOS/docs/img/cpu-reg-1.png)

![image-20231207110806572](/home/user/DOS/docs/img/cpu-reg-2.png)



### General purpose registers

The general-purpose registers are the registers you deal with most when accessing **MS-DOS services**. You **place values in one or more registers before calling the service**. In some cases, you also **retrieve results from one or more registers** after the service has completed its task.

**Each of the four general-purpose registers—AX, BX, CX, and DX—contains 16 bits, or 2 bytes**. **The right 8 bits of a register are called the low byte**. **The left 8 bits are the high byte**. At times, you need to access these two bytes individually. **The low and high bytes of the AX register can be accessed as two 8-bit registers named AL and AH** (Lfor low, H for high). The 8-bit registers for the **other general-purpose registers can be similarly accessed with BL and BH, CL and CH, and DL and DH.**

![image-20231207111904294](/home/user/DOS/docs/img/general-purpose-reg.png)



### Segment registers

The segment registers are used in **memory addressing**. 

**Because MS-DOS uses four segment registers, four distinct memory segments can be accessed at once.**

• **CS** is the **code segment register**. It contains the address of the memory segment that holds the **currently executing program code**.

• **DS** is the **data segment register**. It contains the address of the memory segment that holds the **program's data**.

• **SS** is the **stack segment register**. It contains the address of the stack segment, which is used for **temporary data storage**—for example, when programs pass **arguments to functions**.

• **ES** is the **extra segment register**. It contains the address of the extra segment, which is used for **various purposes**, most frequently to hold **additional data**.



### Offset registers

MS-DOS uses **five offset registers** used in addressing memory. **Each offset register is paired with one of the four**
**segment registers**.

• **BP** is the **base pointer register** and is **paired with the** **SS** (stack segment) register. It is most often used to **access data on the stack**.

• **SP** is the **stack pointer register** and is **also paired with the SS** (stack segment) register. It contains the **address of the current location in the stack**.

• **SI** is the **source index register** and is **paired with the DS segment register**. It is often used to **point to the source address during data transfers**.

• **DI** is the **destination index register** and is **paired with the ES segment register**. It is often used to **point to the destination address during data transfers**.

• **IP** is the **instruction pointer register** and is **paired with the CS segment register**. It contains the **address of the statement that will be executed next**.

**Every time it accesses memory, the CPU uses one of the segment:offset pairs.**



### Flags register

Although it **contains two bytes of data**, the flags register is **used as a collection of single bits, or flags**. **Each of the flags**, which **can be set to either 0 or 1**, conveys specific information. 

**Only nine of the register's sixteen bits are used in the 80x86 processors**. **Six of these bits are status flags** that report on the internal status of the CPU, and **three are control flags** that are used to control certain aspects of the way the CPU functions.

Of these flags, you need be concerned with only the **carry flag**. This is the **first bit** (that is, at **position 0**) **in the flags register**. The CPU uses the carry flag during **arithmetic operations** to signal whether an **addition operation has produced a carry**, or a **subtraction operation has produced a borrow**.

This flag is also used by many MS-DOS services to **signal an error**. **If the service executes without an error, it sets the flag to 0; if an error has occurred, it sets the flag to 1.** When your program **calls an MS-DOS service that uses the carry flag** to signal an error, **the flag must be checked**.



### Interrupts

An interruptis a **special signal** to the CPU that **causes it to suspend temporarily whatever it is doing and transfer control to an interrupt handler, or interrupt service routine** (sometimes called an "**ISR**"). The interrupt handler is a routine that takes appropriate action based on the cause of the interrupt and then returns control to the original suspended process. PCs have **256 available interrupts**, numbered **from 00H through FFH**.

One of the **main purposes of interrupts** is to allow the CPU to **respond to external events**, such as keyboard input.

**PCs have three categories of interrupts:**

• An **internal interrupt** is generated internally by the CPU when **certain conditions or errors occur during operation**. For example, attempting to divide by 0 generates an internal interrupt. Internal interrupts are of little concern to programmers.

• An **external hardware interrupt** is generated by a **peripheral hardware device**, such as the keyboard, serial port, or disk drive. This type of interrupt is used almost every time the computer interacts with a peripheral device. Programmers can manipulate external hardware interrupts to maximize control over peripheral devices, but doing so is not the subject of this book.

• A **software interrupt** is generated by a **program**, and not by hardware. Most programming languages allow you to issue software interrupts. It is by means of **software interrupts** that your programs can **gain access to MS-DOS services**, and making use of such access is the focus of this book.



