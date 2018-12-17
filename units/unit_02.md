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
flagS). LLVM has an infinite number of registers! But, the core of keeping the
complexity of registers and operations thereover is a key design.

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
at address `196`, we may line it out in memory like soL

    
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
`32=10000(binary)`. The registers are numbered for reference in the machine
code. `$t0` is 8=0100 (binary), `$s1` is 17= 10001 (binary), and `$s3` is
18=10010 (binary)  (you can see a full layout description of this in the book).

This is all well and fine, but we run into a problem with loading and
storing. Recall these operations look like the following.

    lw $t0, 32($s3)

Surely, we can map this into the field layout above, but what if we have an
offset into array of size 20, or 100, or 500? There is a porblem because the
largest field is 6-bits wide, and the operand fields are only 5-bits wide, which
means they can only count up to 32! 

> Design Principle 3: Good design demand good compromises

We have to a few places where we buck the rules for the purpose of supporting
our operations. For loading and storing offset, since they are very specific we
can realign our fields to the following:


     <6-bits><5-bits><5-bits><------16-bits---------->
    .-------------------------------------------------.
    | opcode |  rs   |   rt  |    const or addr       |
    '-------------------------------------------------'


We call this an *I-format* or "immediate format" while the prior format is an
`R-format` or a register format.


## Data nd Program Memory Layout











