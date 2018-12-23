# MIPS and Assembly Programming

Readings: Chapter 2.1-2.3, 2.5-2.10 and 2.12 

> These unit notes are **not** design to replace readings from the book! There
> are to provide structure to material covered in class and provide you an
> outline for using the book. **You are still required to do the course
> readings** in which you will find much more detail, and those details will be
> evaluated in quizzes, homework, and exams.

## What are assembly languages? And why MIPS?


Assembly languages are called *assembly* languages because they are *assembled*
from higher level languages. For example, in the compilation process with C++,
when we use `g++` to compile a program it goes through a multi-step
process. First, compilation, converting the C++ code into assembly, and then
that assembly is assembled into a binary program containing the *machine
instructions*. Assembly language forms a human readable, intermediary language
that we can use to do basic programming that has a one-to-one mapping to machine
instructions.

There are many kinds of assembly languages and variations thereof. Some include,
x86, nasm, gas, spark, etc. We will be using MIPS in this class because it
contains an expressive but restrictive set of operations that lends itself to
teaching. More modern assembly languages/machine instructions such as ARM is
based on MIPS, and once you understand the basics of one such language, you can
learn more.

## Instruction Format

All instructions in MIPS have three operands. For example, the C code 

    A =  B + C

Can be translated to the MIPS instruction

    add $s0, $s1, $s2
    
Here the register `$s0` gets the result of adding the values stored in register
`$s1` and `$s2`, which in this example have the values preloaded for variables
`A`, `B`, and `C`.

> Design Principle 1: Simplicity favors regularity

The rigidity of MIPS is a benefit --- it's natural that the sum of two numbers
requires three registers, two for the inputs and one to store the result.  It
makes for more simple instructions, and this will have big consequences when we
cover how instructions are loaded and
executed on the compute processing unit.  

However, rigidity means that there is not a one-to-one mapping between MIPS
instructions and lines of a program. For example, the C code

    A = B + C + D
    E = F - A
    
Would be translated to multiple lines of MIPS, including the use of temporary
storage in registers.

    add $t0, $s1, $s2
    add $s0, $50, $s3
    sub $s4, $s5, $s0
    
We could avoid the temporary variable/register (`$t0`)here (how might we do
that?_, but the increased complexity of multiple instructions is unavoidable.

### Registers and Memory and Disk

*Registers* are special storage units that live *very close* to the processing
unit data path. 

![computer-arch](/imgs/computer-arch.png)

Registers are typically 32-bits in size, depending on the architecture of the
computer, e.g., 64-bit machines. Performing operations on registers is *very
fast*, and so it is natural then this is favored. This leads to the second principle

> Design Principle 2: Smaller is Faster

Performing operations with the smallest set of registers tends to produce faster
code, but this is not a hard-and-fast rule. The number of registers is
architecture specific. MIPS uses 32 registers. x86/x86_64 has 8 (plus some
flags). LLVM has an infinite number of registers! But, the core of keeping the
complexity of registers and operations there-over is a key design.

So then, how does data get into these registers? It is loaded from
*memory*. This is one step further away from the processing unit, so memory
loads are slower, but once loaded into a register, operations become fast.

But memory is still faster than the next level data, because even data in memory
must be loaded from somewhere. This is *disk*. So a program executing, must
first be loaded from disk into memory, where data is loaded into registers for
operations. We will not focus much on disk in this class -- that's for OS and
systems.

## Memory Addressing

To make memory manageable, we have to apply an abstraction to its
organization. Nominally, we consider memory as a an array of bytes.

    <addr>  <data>
    0    | 8-bits |
    1    | 8-bits |
    2    | 8-bits |
    3    | 8-bits |
    .      ...


While bytes are nice, *words* are better. A word is a grouping of bytes that is
architecture dependent. In MIPS a word is 4-bytes. So we typically think of an
address in memory referencing both the byte or the word of data, depending on
the context.


    <addr>  <data>
    0    | 32-bits/word |
    4    | 32-bits/word |
    8    | 32-bits/word |
    12   | 32-bits/word |
    .      ...


There is also this funky thing about addressing for memory layout. We typically
draw higher addresses at the top and lower addresses at the bottom. Sometimes
this is referred to as a stack diagram. For example, if the array `A` who began
at address `196`, we may line it out in memory like below:

    
    C/C++ Code
      int A[4] = {42,68,7,22}

    <higher addresses>
     ^
     |              
     :    :          :
    208   |    22    |  A[3] 
    204   |    7     |  A[2]
    200   |    68    |  A[1]
    196   |    42    |  A[0]
     :    :          :
     |
     v
    <lower adddresses>


## Loading and Storing

Moving data between memory and registers is called *loading*, placing data back
in memory from a register is called *storing*. This is best seen through
example. Consider the following C code.

    A[8] = h + A[8]
    
This is translated with a load-word (`lw`) and a store-word (`sw`) in MIPS,
assuming the address of the first element in the array is stored in `s3`.

    lw $t0, 32($s3)
    add $t0, $s2, $t0
    sw $t0, 32($s3)
    
You may wonder, isn't `lw` and `sw` taking 2 arguments? I thought everything
takes 3 arguments. It does, we just formatted it differently to make it more
readable. The middle argument is an offset.

    desitnation
            |   .--offset
            v   v
        lw $t0, 32($s3) <-- address
                
                
Why 32 for the offset? If `A` stores words, 4-byte values, then index 8 of the
array `A` is at address `s3+32` where `32=8*4`. 

For `sw`, note that that the storage location (or the destination of the
operation) is the second (and third) operand. While the first operand is the
value to be stored.

Finally, you might wonder why can't we just do?

    add $t0, 32($s3), $t0
    
Because this is actually many operations. It violates the simplicity
principality that add/sub should occur only on registers. And moreover the
loading of memory should be separated from adding. 

 
## Assembly to Machine Code

The human readable assembly language needs to be stored in a format that a
machine can read. That means bits. There must be some organization of this data.

In MIPs all instructions, like registers and words of data, are 32-bits long,
broken into 6 *fields* of either 6- or 5-bits wide. For example we can translate
the following MIPS code


    add $t0, $s1, $s2
    
into a following layout 

     <6-bits><5-bits><5-bits><5-bits><5-bits><6-bits>
    .-------------------------------------------------.
    | 000000 | 10001 | 10010 | 01000  | 0000 | 100000 |
    '-------------------------------------------------'
      opcode     rs      rt     rd     shamt   funct

Note that we are storing bits and represent this in binary. Each fields is
described as

* `op` : the basic operation
* `rs` : first register source operand
* `rt` : second register source operation
* `rd` : register destination operand
* `shamt` : amount to shift data in register (cover this later)
* `funct` : variant of the operand since some operations come in different flavors


In the above example opcode of `add` is 0 and it's `funct` is
`32=10000(binary)`. The registers are numbered for reference in the
machine code. `$t0` is 8=0100 (binary), `$s1` is 17= 10001 (binary),
and `$s3` is 18=10010 (binary). Here is the mapping of registers to
their numeric labeling. 

![registers](/imgs/registers.png "Copyright © 2014 Elsevier Inc. All rights reserved.")


This is all well and fine, but we run into a problem with loading and
storing. Recall these operations look like the following.

    lw $t0, 32($s3)

Surely, we can map this into the field layout above, but what about this instruction?

    lw $t0, 128($s3)
    
Then, the bits to represent the offset 128 is 10000000
(binary). That's 7 bits long, longer than the 5-bits reserved for
register/operand values. Moreover, the offset 128 is not from a
register! This is still simple and valid MIPS, leading to another
design principle.

> Design Principle 3: Good design demand good compromises

We have to a few places where we buck the rules for the purpose of supporting
our operations. For loading and storing offset, since they are very specific we
can realign our fields to the following:


     <6-bits><5-bits><5-bits><------16-bits---------->
    .-------------------------------------------------.
    | opcode |  rs   |   rt  |    const or addr       |
    '-------------------------------------------------'
      op.      source  dest   offset

We call this an *I-format* or "immediate format" while the prior
format is an `R-format` or a register format. In the immediate format,
we can use the 16-bit field to represent the value. The op-code for
`lw` is 39 or 100011, `$t0` is register 8, and `$s3` is
register 18. Leading to the following bit layout for I-type

       lw       $s3     $t0        128
    .-------------------------------------------.
    | 100011 | 10010 | 01000 | 0000000001000000 |
    '-------------------------------------------'
       op      src      dest      offset

More information on this conversation and other op-codes are found in
the book.

## Other Immediate Instructions

It's not just loads and stores that use the immediate formats, but
also our more common operations, like add and sub, have an immediate
version. In these version, what make them immediate, is that they
use constants. For example, 

    I = J + 10
    
The constant 10 should able to be immediately applied rather than first
loaded into the register.

    addi $s0,$s1,10
    
See the *green sheet* or the book for more examples. 
 
## Immediate Large Constants

Our immediate format only handles 16-bit numbered constants, but what
if we want larger constants, say up to 32-bits? If we had the address
of that constant, say stored in memory, we can issue a `lw`, but if
not, we would like to immediately place that value in memory.

This requires two steps, and we need to break the value into two
16-bit segments. For example, to store the 32-bit sequence
10101010101010100000000000111111 in a register immediately, we need to
break it into two 16-bit segments and load/set them into a register in
two instructions

    lui $t0 1010101010101010
    ori $t0 $t0 0000000000111111
    
The `lui` instructions places the 16-bits into the upper half of the
32-bit register, zeroing out the remaining lower half bits. 

    $t0
    <upper-16-bits>  <lower-16-bits>
    1010101010101010 0000000000000000

We can then or immediately with the lower half bits, whose upper half is considered zeros


       1010101010101010 0000000000000000
    or 0000000000000000 0000000000111111
    ------------------------------------
       1010101010101010 0000000000111111 -> $t0
       
Note that or of 0 is the identify, so 1 or 0 is 1 and 0 or 0 is 0. 


## Big vs. Little Endian

Continuing with the constant above, what decimal number is it?

    10101010101010100000000000111111
           
That might depend on the byte ordering. Each machine does this
differently, and there are two standards:

* Big Endian: Most signficant byte first
* Little Endian: Least signficant byte first

Dividing the bits here into 4 bytes

      0-byte  1-byte   2-byte   3-byte
    10101010 10101010 00000000 00111111

With Big Endian, this is how we natural read numbers, like 526, is five
hundred, and twenty, and six. Then this number would be interpreted as
2863267903 or (-1431699393 ... more on that later!).

In Little Endian, the 0-byte is the least significant byte and the
3-byte is the most signficant, leading to the following decimal
number 1057008298. Most computers use Little Endian because it is more
efficient for most operations since they occur on the least
significant bytes. 


## Conditionals and Branching

A program needs to also be able to execute different code
dependent on state information. For example, while-loops and
if/else statements. The machine instructions that do this are called
*conditional branching instructions* and when combined with jumping,
you can get all the control flow features of higher level programming.

For example, the following C/C++ code

    if(i == j)
        h = i + j
    //remainder of code
    
is written in MIPS like

    bne $s0, $s1, L1
    add $s3, $s0, $s1
    L1: //remainder of code
    
The `bne` instruction stands for "branch *if* not equal", and so it
performs a test on its two operands `$s1` and `$s2` to determine
equivalence. If they *are* equal, it *does not* branch, or *jump* to
the label, and the add instruction executes. Otherwise, it jumps to
the label `L1` and executes the remainder of the code. 

> Check out the book for other branching instructions!

To do more complex branching, say for a if/else we need a new
instruction called the *jump* instruction. For example, the following
C code

    if ( i != j)
        h = i + j
    else
        h = i - j
    //remainder of code
    
to the following MIPS where `beq` stands for *branch when equal*.

    beq $s4, $s5, L1
    add $s3, $s4, $s5
    j L2
    L1: sub $s3, $s4, $s5
    L2: //remainder of code
    
The jump instruction `j` will jump-over the instruction `sub` to label
`L2`, essentially avoiding the else-branch of the code. Also note,
that a labeled instructions, like `L2`, is executed in sequence with
the one above it. If the else-branch is taken, then we execute the
`sub` instruction followed by the remainder of the code. Labels do not
effect control, but are rather points by which we can jump from other
instructions. Labeled instructions still execute in sequence.

Another item to notice with a jump instruction is that it is yet
another machine code format, this time with only one operand. The
machine layout of this instruction is called a *j-type*.

    < 6-bits><------------26-bits--------------->
    .--------.-----------------------------------.
    | opcode |            address                | 
    '--------'-----------------------------------'
    
The address is the address of an instruction, as stored in memory. The
labels are the human readable portion we use when we write the
code. When the MIPS is assembled, and the addresses are known, then
they get filled in with the true values. 


## Looping 

The last control flow instructions we need are loops. But, we actually
already have that embedded within branching instructions we already
have. For example, consider the C/C++ code

    do {
        g = g + A[i]
        i = i+j;
    }while( i != h );


We can use a branch instruction to jump backwards in the instructions, forming a loop

    L1: add $t1, $s3, $s3  # t1 = i+i = 2i
    add $t1, $t1, $t1      # t1 = 2i + 2i = 4i
    add $t1, $t1, $s5      # t1 = &A[i] (& <- address of operator in C/C++)
    lw $t0, 0($t1)         # t0 = A[i] (dereference pointer of t1 toget the value)
    add $s1, $s1, $t0      # g = g + A[i]
    add $s3, $s3, $s4      # i = i + j
    bne $s3, $s2, L1       # go to L1 if i != h (h stored in $s2)

## Pseudoinstructions

There are some instructions which are easier for us to write, but
actually should be translated into multiple machine instructions. As
such, they are not actually part of the core MIPS, but we might write
the down anyway, where at compilation/assembly they get converted.

A good example is the `blt` instruction, or "branch less than". We can
write this down, but in reality, we actually use `slt` instruction, or
"set less than". For example

    blt $s1, $s2, L2

Can be written like

    slt $t0, $s1, $s2
    bne $t0, $zero, L2

The `slt` instruction sets the register `$t0` to 0 or 1 depending on
the comarison of `$s1` and `$s2` -- 1 if less than. So we can use the
the `bne` instruction to see if the result is not zero (using the
special `$zero` register).

We can similarly do the same of a "move" instruction which
historically moves one register to another, like in C.

    A = B
    -----
    mov $s2,s1

But we don't have a move instruction. Instead we can use an `add` to do the same

    add $s2, $s1, $zero
    
Why not have all of these instructions? They would add complexity to
the language, especially for encoding, and so we choose to
simplify. However, we may refer to the pseudo-instructions to help
clarify some of our discussion.










    






