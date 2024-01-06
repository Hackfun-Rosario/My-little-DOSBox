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

# Chapter 5: The Keyboard (p.41)



## Keyboard basics

When you **press a key**, the keyboard generates a **unique 1-byte scan code** that identifies the key. **Bit 7** (the leftmost bit) of the scan code **is always 0**. 

When you release the key another unique scan code is generated. For any key, the **release scan** code is the press **scan code with bit 7 set to 1**.

In addition to the corresponding scan code, the keyboard also generates a **call to Int 09H** (the keyboard interrupt) **each time the user presses or releases a key**. Execution passes to the ROM BIOS keyboard interrupt service routine, which reads the scan code from the keyboard.

![](/home/user/DOS/docs/img/keycodes.png)

​               ^--- ¿Códigos correctos?



## Keyboard Input

When using MS-DOS services for keyboard input, you have a choice between the **Int 21H DOS kernel services** and the Int **16H BIOS services**. The main difference between these two groups is that the **Int 21H services are sensitive to input redirection and the Int 16H services are not**.



### Ctrl-C and Ctrl-Break

When you press **Ctrl-C**, 03H (**the ASCII code for Ctrl-C**) **is placed in the keyboard buffer** like any other character. When MS-DOS reads Ctrl-C from the buffer, it **calls Int 23H**. The **default handler** for Int 23H **terminates the active process and returns control** to the parent process—usually, the program then terminates, and the MS-DOS prompt returns.

Strictly speaking, the response to a Ctrl-Break (or Ctrl-C) keystroke is **not always immediate**. MS-DOS maintains a **break flag** for which the **default setting is 0**, which means that MS-**DOS checks for a Ctrl-Break only during certain input/output (I/O) operations**. If you use C or Basic I/O functions or statements when the break flag is set to 0, Ctrl-Break is detected only when your program does either of the following:
• Sends data to the screen, printer, or communications port
• Reads data from the keyboard or communications port
**If the break flag is set to 1**, MS-DOS checks for a Ctrl-Break **every time an MS-DOS service is called**—including not only the I/O operations mentioned above but also disk operations, memory allocation, and so on. With the break flag set, therefore, users are able to interrupt a program's operation more readily by pressing Ctrl-Break (for example, if execution becomes stuck in a program loop that doesn't involve any I/O operations).



### Int 21H character input services

You can access **four character input services** via **Int 21H**:

![](/home/user/DOS/docs/img/char-input.png)

When using any of these four MS-DOS input services, keep in mind that **these services all return the corresponding ASCIIvalue for standard characters**. If the user has entered an **extended character** (for example, a function key or an Alt-[letter] key combination), the services **return the value 0**. You must then **read the next character in the keyboard buffer** to obtain the extended character's scan code.



### Int 16H Function 00H—BIOS character input

Because **Int 16H Function 00H** is **not sensitive to redirection** of input, using it for character input means that **input will come from the keyboard at all times**. You can use this service to ensure that responses to error messages come from the user.

Int 16H Function 00H has this advantage: **With a single call, it returns both the ASCII character code and the scan code**. This capability enables the program to **read extended keys using a single call**, rather than the two calls required with the Int 21H character input services.



### Line input

MS-DOS includes only one service—Int 21H Function OAH—that reads a single line of input from stdin and places it in a user-defined buffer. This service is not used often because it lacks flexibility. For example, it does not enablea program to respond to an extended key while a line is being input.



### Checking input status

At times, you might want to **find out whether a character is available in the buffer** of the input device yet **not want to remove the character from the buffer**. You can do so by using **Int 21H Function OBH**.

This service **does not wait for a character to be input** but instead **returns immediately** to the calling program, letting it know whether a character is in the buffer. You can use this service to implement a **simple form of multitasking**. By using Int 21H Function OBH, you can **check for a character** and, when **a character is available, process it**. **Other wise, the program can be doing other tasks**.



### Flushing the Input Buffer

When a program is querying the user about an important task you don't want an old keystroke left over in the buffer to be misinterpreted as the response. You should **empty the buffer first** to ensure that the program gets the correct response—the one that was **entered after the program's prompt**.

**Int 21H Function OCH flushes the input buffer** and then **calls one of the input services**.



### The Keyboard Flags

The **ROM BIOS** maintains a **set of keyboard flags** that reflect the **status of the Ctrl, Shift, Alt, and "lock" keys**.

The BIOS uses the keyboard flags when processing keystrokes because **the keyboard scan codes do not take into account whether any of these special keys are pressed**.

Your program can **read the keyboard flags** by calling Int **16H Function 02H** or **Int 16H Function 12H**. The difference between these two services is that Function 02H works with all keyboards, but Function 12H works only with enhanced keyboards.



## Keyboard Service Reference (p.74)

(Ver tablas en el libro)

# Chapter 7 - Screen Display (p.153)



### Screens, Pixels, and Video Adapters

All PC display adapters are **memory mapped**, which means that they have a **section of random access memory** (RAM) that is **devoted to the screen display**. This memory has various names: **video RAM**, **video buffer**, **refresh buffer**, and **display buffer**.

Dedicated hardware on the display adapter **scans the video RAM continually** and **converts the data in the memory into the appropriate pixel pattern**, which it then **sends to the monitor**. To display an image, therefore, a program must write the appropriate data to video RAM.



### Text modes

In text modes, the screen is divided into a **matrix of character cells**. Most display adapters offer two text modes: one with a matrix of **40 columns by 25 rows** and the other (the default) with a matrix of **80 columns by 25 rows**.

Each cell is identified by its row and column coordinates; **the coordinates of the upper left cell are (0, 0)**. On a screen that has 80 columns by 25 rows, therefore, the coordinates of the lower right cell are (79, 24).

In text modes, each character cell on the screen is represented by **2 adjacent bytes** of memory in video RAM. **The first**, or low-order, byte specifies **the character to display**. **The second byte**, called the **attribute byte**, specifies the attributes—how the character is displayed. Bit fields in the attribute byte control such aspects as **color and intensity**.

![](/home/user/DOS/docs/img/char-attrib.png)

(Más tablas de atributos en p.157)



### Graphics modes

In graphics modes your program has **control over each individual pixel on the screen**.

As with text modes, a **graphics mode screen display is memory mapped**. Each pixel on the screen is controlled by the contents of **one or more bits in video RAM**. How many pixels and colors are available on the screen **depends on the display adapter** and the **screen display mode** being used.

![](/home/user/DOS/docs/img/display-modes.png)

You can **set the current display mode** using the service **Int 10H Function OOH**. To **read the current display mode**, use **Int 10H Function OFH**.



### Display pages

Most display adapters have **more installed video RAM than is needed** to hold a full screen of information. The video RAM, therefore, is **divided into a number of display pages**, each of which can hold the data required for a full screen display. The number of pages available depends on the display adapter and the current display mode.

At any given moment, **the screen displays the data in a single display page**, called the **active display page**. By default, this is **display page 0**. Your program can **change the active display** page by calling **Int 10H Function 05H**.

When you change display pages, the screen **switches immediately** to display the data in the newly active page.

To determine **which display page is active**, use **Int 10H Function OFH**.

Your program can **write text to an inactive display page** without affecting the active display and then **display the new text immediately** by calling **Int 10H Function 05H**.



### Cursor Control in Text Mode Display Pages

**Every text mode display page has a cursor**. 

Note that **a cursor exists for every valid display page**, even when that page is **not the active one**. You can **modify the location** of the cursor on **inactive display pages**, but **you cannot modify the cursor's appearance**.

To **modify the appearance** of the cursor on the **active display page**, use **Int 10H Function OIH**. You can change **only the rectangular cursor's size and its position** in the character cell. You do this by specifying the **start and stop scan lines** that the cursor uses. A character cell contains a certain number of scan lines: The top scan line is number 0, and the bottom scan line is number 7. If you specified 6 for the start scan line and 7 for the stop scan line, the cursor would be an underline character.

To **change the position** of the cursor on any display page, use **Int 10H Function 02H**. To **get the position** and scan lines of the cursor on any display page, use **Int 10H Function 03H**.



## Screen Output Using MS-DOS and BIOS Display Services

When using **operating system services** to **write text to the screen** display, you have **two choices**. 

The **MS-DOS display services**, which you access via **Int 21H**, operate correctly on **any system that runs MS-DOS**, regardless of the level of IBM hardware compatibility. These services, however, execute **relatively slowly**.

The **BIOS display services**, which you access via **Int 10H**, are **much more efficient** than the MS-DOS services. They do, however, **require IBM hardware compatibility**.

Note that the **MS-DOS display services do not let you control the value of the attribute byte**. If output goes to the screen (it is not redirected), the text is **displayed using whatever attributes the corresponding character cells already have**. In contrast, **some of the BIOS display services provide control of the attribute byte**.

After an **MS-DOS service** displays one or more characters, the screen cursor is **positioned immediately after the last character**. When the output **reaches the right edge of the screen**, it **wraps to the start of the next line**. In most cases, the **BIOS display services** provide **no cursor updating**—your program must update the cursor position explicitly.



### MS-DOS display services

To use **MS-DOS services** to display a string of one or more characters on the screen, use **Int 21H Function 40H**. This is one of MS-DOS's **handle services**.

A **handle** is a **numeric identifier** that MS-DOS assigns to an **input or output** (I/O) **device**. MS-DOS can associate a handle with a disk file, the keyboard, a serial port, the display screen, and so on.

**When a program runs**, MS-DOS assigns handles for the **standard devices**. **Standard output** (stdout) is assigned **handle 1**, and **standard error** (stderr) is assigned **handle 2**.

**Standard output can be redirected** and is by default **the screen**. **Standard error cannot be redirected** and is **always the screen**.

When you call **Int 21H Function 40H**, you pass to it the **handle of the device** that will accept the output, the **number of characters** to output, and the **address of the program buffer** that holds the characters. If the service **succeeds**, it returns with the **carry flag clear** and the **number of bytes transferred in AX**. If the service **fails**, it **sets the carry flag** and returns an **error code in AX**.

MS-DOS also has **two services** that write a **single character to the standard output** (and are therefore sensitive to output redirection). They differ in how they handle Ctrl-C. **Int 21H Function 02H** writes **one character to standard output** and **responds to Ctrl-C**. If the keyboard **detects a Ctrl-C** after this service completes, it **issues Int 23H**. **Int 21H Function 06H**, however, **does not respond to Ctrl-C**.



### BIOS display services

You can choose from three BIOS display services, each of which outputs a single character to the screen.

• **Int 10H Function 09H** writes a **character-and-attribute pair** to the screen and **does not update the cursor position**.
• **Int 10H Function OAH** writes a **character to the screen** using the **existing attributes** and **does not update the cursor position**.
• **Int 10H Function OEH** writes a **character to the screen** and **updates the cursor position**. In **text modes**, the service uses the **existing attributes**. In **graphics modes**, the service can **specify the foreground color**.



## Miscellaneous Video Functions



### Reading data from video RAM

Programs can **read data from video RAM**. By reading the data in video RAM, a program can **determine the character and the attributes** at a **specific location** on **any display page**. The **BIOS** provides a service to do this task: **Int 10H Function 08H**.



### Scrolling and clearing windows

**Two BIOS services** enable a program to **scroll or clear** a **text mode window**. 

**Int 10H Function 06H** scrolls the window **up**, and **Int 10H Function 07H** scrolls it **down**. Either service can be used to **clear a window**.



## Display Service Reference (p.194)

(Ver tablas en el libro)



# Chapter 12 - Memory Management (p.337)



## Types of memory



### Conventional memory

**All PCs** and all **versions of MS-DOS** can manage **at least 1 megabyte of memory**. This memory **starts at address 00000H** and **extends to FFFFFH** and is called **conventional memory**.

**Only a part of conventional memory**—the **640 KB that** **starts at 00000H** and **extends to 9FFFFH**—is **available for use by MS-DOS and your application programs**. This portion of conventional memory is often called **user memory**. The **memory above 640 KB** (between 9FFFFH and FFFFFH) is **reserved** for video display memory, ROM hardware drivers, and the like.

The **operating system** occupies the **lowest part of user memory**, which starts at address 00000H.

The **remainder of user memory** is called the **transient program area**, or **TPA** (sometimes called the memory arena). Application **programs are loaded in the TPA** when they are executed.

The size of the TPA is equal to the total amount of user memory in your system (typically 640 KB) minus the memory that the operating system occupies.

![](/home/user/DOS/docs/img/conventional-memory.png)



### Extended memory

Memory at addresses **above 1 megabyte** (100000H) is called **extended memory**. Extended memory is available **only on systems that use an 80286, 80386, or 80486 processor**. As much as **15 megabytes of extended memory** can be installed on **80286 systems**, and **4095 megabytes** on **80386 and 80486 processors**.

To understand extended memory, you must be familiar with the **two CPU operating modes**—**real mode** and **protected mode**—in which the 80286 (and higher) processors can operate.

**Real mode**, an 80286 (and higher) processor is, in effect, a **faster version of the 8088/8086 processor** used in the original PC. These processors have **full access to conventional memory in real mode** but only **limited access to extended memory**. In **protected mode**, the **full power** of these processors is unleashed because they have the ability to **access both conventional and extended memory.**

The **mode** in which a processor can operate is a function of the **operating system in use**.

**MS-DOS**, however, **runs in real mode**. Under MS-DOS, **you cannot ordinarily use extended memory to hold program code or data**; for the most part, only conventional memory is available to programs.

**Two ROM BIOS services**, however, give a **real mode program limited access to extended memory**. These services—**Int 15H Functions 87H and 88H**— **switch** the processor **from real mode to protected mode**, **perform a task**, and then **switch the processor back again**.



### Expanded memory

Expandedmemory is a type ofmemory that can be addedto PCsto increase
the amount of available memory. Unlike extended memory, expanded memory is not limited to PCs
that have 80286 (and higher) processors. You canuse expanded memory on
any PC, no matter what processor it uses.

Expanded memory is officially
defined in the Lotus/Intel/Microsoft Expanded Memory Specification, or
LIM EMS for short.

Programs cannot make use of expanded memory unless they're written
specifically to do so.





