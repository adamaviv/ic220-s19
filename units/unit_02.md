# MIPS and Assembly Programming

Readings: Chapter 2.1-2.3, 2.5-2.10 and 2.12 

> These unit notes are **not** designed to replace readings from the book! They
> are to provide structure to material covered in class and provide you an
> outline for using the book. **You are still required to do the course
> readings** in which you will find much more detail, and those details will be
> evaluated in quizzes, homework, and exams.

## What are assembly languages? And why MIPS?


Assembly languages are called *assembly* languages because they are *assembled*
into the binary machine code that directly runs on your processor.
For example, in the compilation process with C++,
when we use `g++` to compile a program it goes through a multi-step
process. First, compilation, converting the C++ code into assembly, and then
that assembly is assembled into a binary program containing the *machine
instructions*. Assembly language forms a human readable, intermediary language
that we can use to do basic programming that has a one-to-one mapping to machine
instructions.

There are many kinds of assembly languages and variations thereof. Some include,
x86, nasm, gas, spark, etc. We will be using MIPS in this class because it
contains an expressive but restrictive set of operations that lends itself to
teaching. More modern assembly languages/machine instructions such as ARM are
based on the same principles as MIPS,
and once you understand the basics of one such language, you can
learn more.

## Instruction Format

All instructions in MIPS have three operands. For example, the C code 

    A =  B + C

Can be translated to the MIPS instruction

    add $s0, $s1, $s2
    
Here the register `$s0` gets the result of adding the values stored in register
`$s1` and `$s2`, which in this example have the values preloaded for variables
`B` and `C`.

> Design Principle 1: Simplicity favors regularity

The rigidity of MIPS is a benefit --- it's natural that the sum of two numbers
requires three registers, two for the inputs and one to store the result.  It
makes for more simple instructions, and this will have big consequences when we
cover how instructions are loaded and
executed on the computer processing unit.  

However, rigidity means that there is not a one-to-one mapping between MIPS
instructions and lines of a program. For example, the C code

    A = B + C + D
    E = F - A
    
Would be translated to multiple lines of MIPS, including the use of temporary
storage in registers. For example (assuming the values of `B`, `C`,
`D`, and `F` are preloaded into `$s1`, `$s2`, `$s3`, and `$s5`):

    add $t0, $s1, $s2
    add $s0, $t0, $s3
    sub $s4, $s5, $s0
    
We could avoid the temporary variable/register (`$t0`) here (how might we do
that?), but _the increased complexity of multiple instructions is unavoidable_.

### Registers and Memory and Disk

*Registers* are special storage units that live *very close* to the processing
unit data path. 

![computer-arch](/imgs/computer-arch.png)

Registers are typically 32 or 64 bits in size, depending on the architecture of the
computer, e.g., 64-bit machines. Performing operations on registers is *very
fast*, and so it is natural that this is favored. This leads to the second principle

> Design Principle 2: Smaller is Faster

Performing operations with the smallest set of registers tends to produce faster
code, but this is not a hard-and-fast rule. The number of registers is
architecture specific. MIPS uses 32 registers. x86/x86_64 has 8 (plus some
flags). LLVM has an infinite number of registers! But, the core idea of keeping the
complexity of registers and operations low is a key to efficient design.

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
organization. Nominally, we consider memory as an array of bytes.

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
this is referred to as a stack diagram. For example, if the array `A` begins
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

Moving data between memory and registers is called *loading*; placing data back
in memory from a register is called *storing*. This is best seen through
example. Consider the following C code.

    A[8] = h + A[8]
    
This is translated with a load-word (`lw`) and a store-word (`sw`) in MIPS,
assuming the address of the first element in the array is stored in `s3`.

    lw $t0, 32($s3)
    add $t0, $s2, $t0
    sw $t0, 32($s3)
    
You may wonder, aren't `lw` and `sw` taking 2 arguments? I thought everything
takes 3 arguments. It does, we just formatted it differently to make it more
readable. The middle argument is an offset.

    destination
            |   .--offset
            v   v
        lw $t0, 32($s3) <-- address
                
                
Why 32 for the offset? If `A` stores words, 4-byte values, then index 8 of the
array `A` is at address `s3+32` where `32=8*4`. 

For `sw`, note that that the storage location (or the destination of the
operation) is the second (and third) operand, while the first operand is the
value to be stored.

Finally, you might wonder why can't we just do

    add $t0, 32($s3), $t0
    
The answer is that this is actually two operations. It violates the simplicity
principality that add/sub should occur only on registers. And moreover the
loading/storing of memory should be separated from adding. 

 
## Assembly to Machine Code

The human readable assembly language needs to be stored in a format that a
machine can read. That means bits. There must be some organization of this data.

In MIPS all instructions, like registers and words of data, are 32-bits long,
broken into 6 *fields* of either 6- or 5-bits wide. For example we can translate
the following MIPS code


    add $t0, $s1, $s2
    
into the following layout 

     <6-bits> <5-bits><5-bits><5-bits><5-bits><6-bits>
    .-------------------------------------------------.
    | 000000 | 10001 | 10010 | 01000 | 00000 | 100000 |
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
`32=100000 (binary)`. The registers are numbered for reference in the
machine code. `$t0` is 8=01000 (binary), `$s1` is 17= 10001 (binary),
and `$s3` is 18=10010 (binary). Here is the mapping of registers to
their numeric labeling. 

![registers](/imgs/registers.png "Copyright © 2014 Elsevier Inc. All rights reserved.")


This is all well and fine, but we run into a problem with loading and
storing. Recall these operations look like the following.

    lw $t0, 16($s3)

Surely, we can map this into the field layout above, but what about this instruction?

    lw $t0, 128($s3)
    
Then, the bits to represent the offset 128 is 10000000
(binary). That's 8 bits long, longer than the 5-bits reserved for
register/operand values. Moreover, the offset 128 is not from a
register! This is still simple and valid MIPS, leading to another
design principle.

> Design Principle 3: Good design demands good compromises

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
`lw` is 35 or 100011, `$t0` is register 8, and `$s3` is
register 18. Leading to the following bit layout for I-type

       lw       $s3     $t0        128
    .-------------------------------------------.
    | 100011 | 10010 | 01000 | 0000000010000000 |
    '-------------------------------------------'
       op      src      dest      offset

More information on this conversation and other op-codes are found in
the book.

## Other Immediate Instructions

It's not just loads and stores that use the immediate formats, but
also our more common operations, like add and sub, have an immediate
version. For these operations, what make them immediate is that they
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

* Big Endian: Most significant byte first
* Little Endian: Least significant byte first

Dividing the bits here into 4 bytes

      0-byte  1-byte   2-byte   3-byte
    10101010 10101010 00000000 00111111

With Big Endian, this is how we natural read numbers, like 526, is five
hundred, and twenty, and six. Then this number would be interpreted as
2863267903 or (-1431699393 ... more on that later!).

In Little Endian, the 0-byte is the least significant byte and the
3-byte is the most significant, leading to the following decimal
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
affect control, but are rather points by which we can jump from other
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
    mov $s2, $s1

But we don't have a move instruction. Instead we can use an `add` to do the same

    add $s2, $s1, $zero
    
Why not have all of these instructions? They would add complexity to the
language, especially for encoding, and so we choose to simplify. However, we may
refer to the pseudo-instructions to help clarify some of our discussion, and you
could even program using pseudo-instructions in our MIPS simulator.

## Procedures and Functions

To do function calls, these are a lot like jumps, but there will be additional
state, such as arguments, variables, and return values that must also be
maintained, not to mention, keeping track of which prior instruction to return
to following this one. In MIPS we use the term *procedure* and *function*
interchangeably, but both refer to the same general thing you'd be familiar with in
C/C++.

For the purpose of examples, we will refer to the following functions


    void func1(){
        int a,b,c,d;
        //...
        a = func2(b,c,d);
        //...
        return;
    }


    int func2(int b, int c, int d){
        int x,y,z;
        //...
        return x;
     
    }

To execute these procedures, a few things have to happen between the caller
procedure (`func1`) and the callee (`func2`).

* (STEP 1) Caller must place parameters where the callee procedure can access them

* (STEP 2) Caller transfer control to the callee

* (STEP 3) Callee allocates memory for its procedures 

* (STEP 4) Callee does the tasks (body of function)

* (STEP 5) Callee places the results somewhere for the caller procedure can access the return value

* (STEP 6) Return control back to the caller


### STEP 1: Parameter passing


The caller is responsible for passing parameters to the callee procedures, i.e.,
the function arguments. This is done by setting the `$a0`, `$a1`, `$a2` and `$a3`
registers, or the *argument registers*.  


What happens if there are more than 4 arguments? Well, we can use the *stack*
... but more on that later.


What happens if the callee changes the registers? Well, that can happen, so if
the caller needs those values later, it is the responsibility of the caller to
preserve that information.


### STEP 2: Transferring Control 

Consider a function call in abstraction. When you make such a call, once the
called function finishes, control of the program returns the point in which the
call occurred. We need to do the same thing, but in assembly. We will need to
not only *jump to the procedure* but also *remember where we jumped from*.

The `jal` instruction, *jump and link*, does just that. It will jump to an
address and save the *return address* (the place to jump after the procedure
finishes on return) in the special register `$ra` (*return address registers*).

How is the return address calculated? This is actually quite easy, consider the
following snippet of MIPS

    jal Func1     # <- PC
    add $s1,$s2,$s3 # <- PC+4
    
Clearly, after the Func1 finishes, we want to execute the add instruction. At
the `jal` instruction, the *program counter* or *PC* references the `jal`
instruction. A jump just changes the PC to point somewhere else in the code, but
since every instruction is exactly 4 bytes wide, we know the return address is
exactly 4-bytes more than the current program counter.

Where is the program counter stored? Well, of course, it's in another register!
It's not a register you can set directly, but instead, its value changes after
each instruction completes, e.g., by adding 4, or via branching or jumping
instructions, based on the provided label or address.

However, as we will see, just having the return address stored in a register is
not going to be enough because we can have nested procedures, so we'll need to
also eventually save it lest it get overwritten by another `jal` instruction.

### STEP 3: Storage for the Callee on the Stack

The local storage for a function, as you might recall from C/C++, is scoped for
just that function. Operations that occur on those local variables should have
no impact on variables outside of that function. 

There is a similar notion for procedures in MIPS where if a procedure wants to
use *stable registers*, e.g., registers that begin `$s*` like `$s0-$s9`, it is
the responsibility of the callee procedures to *preserve the previous values of
those registers and restore them before return*. 

To do this, we use something called the *stack* which is used for runtime
storage and procedure/function management. The current address of the *bottom of
the stack* is stored in a special register called `$sp`.

We can think of this memory like an array, but a bit counter-intuitive, from the
address of `$sp` moving upwards towards higher addresses is already used memory,
maybe from other procedures. Moving towards lower address, subtracting from the
stack pointer, is unallocated memory


    :              :  (higher addresses)
    |  other       |
    |   funcs      |  <- $sp+12
    |    data      |  <- $sp+8
    |     ...      |  <- $sp+4
    '--------------'  <- $sp (bottom of the stack)          
           |          <- $sp-4
           v          <- $sp-8
                      <- $sp-12
                      
                      
                      (lower addresses)

So we can *subtract from the stack pointer* to allocate more memory, and then
use that newly allocated memory to store the stable registers before use.

    addi $sp, $sp, -12   #allocated 12/4= 3 4-byte values on the stack
    sw   $s1, 8($sp)
    sw   $s2, 4($sp)
    sw   $s3, 0($sp)
    

So after this, we have the following picture of our stack



    :              :  (higher addresses)
    |  other       |
    |   funcs      |  <- $sp+20
    |    data      |  <- $sp+16
    |     ...      |  <- $sp+12 (old bottom of the stack)
    |     $s3      |  <- $sp+8
    |     $s2      |  <- $sp+4
    |     $s1      |  <- $sp    (new bottom of the stack
    '--------------'  <- $sp-4 
           |
           v
                      (lower addresses)


### STEP 4: Callee Execution/Function Body

At this point, the PC references the callee's instructions. The callee can
access the arguments in `$a0-$a3` and/or any additional information that the
caller set on the stack. During the execution procedure, the callee can use all
the registers available to it, including stable ones if they were saved. 

What if the callee needs more local variables, perhaps more than the number of
registers? Well then it can use the stack. Assembly languages that do not have
as many registers as MIPS --- x86/x86_64 make due with 6! --- allocate space on
the stack by subtracting from the stack pointer and then load/store data back
and forth from the registers and the stack. We won't do that too much here, but
you should know it is possible. 

### STEP 5: Return Values

Just as most arguments are going to be passed via registers, so will return
values. The registers `$v0` and `$v1` are used to return a value from a
procedure. If it is a 32-bit value, then only `$v0` is used, otherwise if it is
a 64-bit value, then `$v1` stores the higher order bits while `$v0` stores the
lower order bits.

You should also know that you can return values via the stack, but this is not
standard on MIPS. Other assembly languages use this design decision.

### STEP 6: Returning Control to Caller

With the return value set in the `$v0-$v1` registers, the last step is to reload
the stable registers, de-allocate on the stack, and jump back to the caller.

Returning to the example from above, where we stored stable registers `$s1-$s3`
we can reload them prior to return, as well as de-allocate the stack space by
*adding* to the stack pointer.

    lw $s3, 0($sp)     #restore register $s3
    lw $s2, 4($sp)     #restore register $s2
    lw $s1, 8($sp)     #restore register $s1
    addi $sp, $sp, 12  #de-allocate 12/4=3 4-byte memory from stack
    
With that done, we can now `jr` (*jump-register*) to the caller based on the
return address saved in `$ra`

    jr $ra
    
## Nested Procedures

What happens when one function calls another function and another function and
so on. There are a few things that might get clobbered that we would need to be
careful about.

* Return Address: `$ra` would be set to a *new* return address and so the
  calling function will need to save and restore the `$ra`before calling the
  next function.
  
* Temporary Registers:  `$t0-$t7` could be changed by the callee but contain
  relevant data for the caller, and so would need to be saved and restored once
  the callee returns.
  
  
* Argument Registers: `$a0-$a3` would need to be changed so the caller function
  can pass arguments to the callee, but maybe the caller is using them?
  
All of this can be preserved easily by using the stack. So the caller would need
to allocate and store all registers that would need to persist onto the stack
and then restore them when the callee returns.

In MIPS that we describe this region of stack space as the *activation record*
of the *function frame*. The *function frame* is all the stack data associated
with the current executing function, and the *activation record* of the frame is
the portion used to restore the stack and registers back to the state prior to
calling this function so that control can be returned to the caller. 

We use another special registers `$fp`, the *frame pointer*, to track function-
or stack-frames. While the stack pointer points to the bottom of the stack, the
frame pointer indicates the top of the frame pointer. By adjusting the stack and
frame pointers, you can track function calls, saving and restoring state as
functions are called and returned.

For example, visually, the caller function's frame might look like this.


    :             :
    |             |
    |-------------| <-- $fp
    |  caller     |
    |    stack    |
    |      frame  |
    |-------------| <-- $sp 
    
Following, the function call:
    
    
    
    :             :
    |             |
    |-------------| 
    |  caller     | 
    |    stack    | 
    |      frame  | 
    |-------------| <-- $fp
    |  saved regs |
    |.............|
    | saved ret   |
    |    address  |
    |.............|    (callee's stack frame)
    | saved       |
    |   registers |
    |.............|
    | local func  |
    |    data     | 
    |-------------| <-- $sp

Once the procedure ends, we can reset the register state, including `$sp` and
`$fp`, which would give us the original state prior to the call. 

### Nested Function Example

To see this in action, let's convert the following function procedure into
assembly:

    int cloak(int n){
        if( n < 1 ) return 1;
        else return n * dagger(n-1);
    }


Note first that `cloak` takes one argument, an int, and returns an
argument. Additionally, we have a conditional branch with the if/else, and a
procedure call to `dagger`. Further, there are two return points. There's more
than a few things happening here that we need to track. 


To start, let's establish the stack frame for `cloak`. I'm *not* going to use
the frame pointer as a reference for the stack frame, but some examples in MIPS
may do so. This one is simple enough we won't need that. 

    cloak:
        
        #ACTIVITY RECORD SETUP
        addi $sp, $sp -8    #allocate 2 words of stack space
        sw $ra, 4($sp)      #save old return address
        sw $a0, 0($sp)      #save argument 0

        #PROCEDURE BODY
        slti $t0, $a0, 1    # test if $a0 < 1
        beq $t0, $zero, L1  # if so, branch to L1
        
        addi $v0, $zero, 1  # otherwise set return value to 1
        addi $sp,$sp, 8     # deallocate on the stack
        jr $ra              # jump back to the return address

        
    L1:
        addi $a0, $a0, -1   # decrement the argument
        jal dagger          # call dagger procedure
        
        lw $a0, 0($sp)      # restore $a0 from stack
        
        mul $v0, $a0, $v0   # multiply return value of dagger
                            # with argument, storing in 
                            # return value of this procedure

        lw $ra, 4($sp)      # restore the return address
        addi $sp, $sp, 8    # deallocate memory
        jr $ra              # jump back to the return address
        

Notice that there are two different return points! A smart compiler may simplify
this further by jumping to a return point, labeled `cloack_return` below.

    cloak:
        
        #ACTIVITY RECORD SETUP
        addi $sp, $sp -8    #allocate 2 words of stack space
        sw $ra, 4($sp)      #save old return address
        sw $a0, 0($sp)      #save argument 0

        #PROCEDURE BODY
        slti $t0, $a0, 1    # test if $a0 < 1
        beq $t0, $zero, L1  # if so, branch to L1
        

        addi $v0, $zero, 1  # otherwise set return value to 1
        
        j cloack_return     # do the return
        
    L1:
        addi $a0, $a0, -1   # decrement the argument
        jal dagger          # call dagger procedure
        
        lw $a0, 0($sp)      # restore $a0 from stack
        
        mul $v0, $a0, $v0   # multiply return value of dagger
                            # with argument, storing in 
                            # return value of this procedure

    cloack_return:
        lw $ra, 4($sp)      # restore the return address
        addi $sp, $sp, 8    # deallocate memory
        jr $ra              # jump back to the return address
        

Now let's consider `dagger`. What if we were to replace `dagger` with `cloak`,
like in C:

    int cloak(int n){
        if( n < 1 ) return 1;
        else return n * cloack(n-1); //the dagger is the cloak!
    }

This results in the factorial function! If were to modify our code above to call
`cloak` 

    cloak:
        
        #ACTIVITY RECORD SETUP
        addi $sp, $sp -8    #allocate 2 words of stack space
        sw $ra, 4($sp)      #save old return address
        sw $a0, 0($sp)      #save argument 0

        #PROCEDURE BODY
        slti $t0, $a0, 1    # test if $a0 < 1
        beq $t0, $zero, L1  # if so, branch to L1
        

        addi $v0, $zero, 1  # otherwise set return value to 1
        
        j cloack_return     # do the return
        
    L1:
        addi $a0, $a0, -1   # decrement the argumnet
        jal cloak           # call cloak <----!!!!
        
        lw $a0, 0($sp)      # restore $a0 from stack
        
        mul $v0, $a0, $v0   # multiply return value of dagger
                            # with argument, storing in 
                            # return value of this procedure

    cloack_return:
        lw $ra, 4($sp)      # restore the return address
        addi $sp, $sp, 8    # deallocate memory
        jr $ra              # jump back to the return address
        

Everything would be fine, even if the procedure is calling itself. That's
because we used good practice to preserve and restore registers through
procedure calls.


## Alternative Architectures

MIPS is far from the single architecture nor is it a dominant architecture. Some
you may have heard of are Intel, ARM, AMD, SPARC. 

One defining characteristic of architectures is if there are RISC or CISC:
Regular or Complex instruction sets. MIPS is a regular instruction set (all
instructions are 32-bits wide), as well as ARM, but Intel instructions set tend
to be complex, the width of instructions can vary.

The most dominant architecture is Intel's 80x86 (or x86) and the AMD 64-bit
extension. This architecture is CISC, and instructions can be from 1-byte to
17-bytes wide. However, at the PC, they are translated into RISC instructions
using proprietary micro-instructions. x86 is dominant in
laptops/desktops/servers, but on mobile devices and IoT ARM is dominant. ARM is
a RISC ISA, and due to its simplicity and plethora of chips that support it, it
has proliferated on mobile and embedded devices. It is not as fast as x86
variants, but it's fast enough for nearly all settings.

Here, we only covered a subset of the MIPs ISA, and you will need to refer to
the book and the green card to understand the fuller picture. Additionally, more
info on other ISA's is found in the book.



