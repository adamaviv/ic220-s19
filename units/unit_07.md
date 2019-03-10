# Processor Design

Readings: Chapter 4.1-4.4

> These unit notes are **not** design to replace readings from the book! There
> are to provide structure to material covered in class and provide you an
> outline for using the book. **You are still required to do the course
> readings** in which you will find much more detail, and those details will be
> evaluated in quizzes, homework, and exams.

Images from *Computer Organization and Design* used here under fair-use for
educational purposes. Not intended for reproduction or redistribution, and
subject to the copyright owners of *Computer Organization and Design*. 

## Single-Cycle CPU

In this unit, we will explore how to build a *single-cycle CPU* that can
implement a subset of the MIPS language. A single-cycle CPU assumes that we
execute one instruction at a time, with as many clock cycles as needed to finish
that instruction before moving on to the next instruction. To put it another
way, one instruction at a time, and the performance of the CPU is how many
cycles of the clock it takes to complete that instruction (or any instruction,
on average). 

This is not how CPU's are built today. Single-Cycle CPU design is slow, and we
have a number of ways to improve the performance. Notably, pipeline (or
multi-cycle CPU) design will allow for multiple instructions to be in the
process of executing, at the same time. We will explore this in a later unit. 

## Simplified Model

As we proceed, we will assume a simplified model of MIPS. This includes

* Memory-References: `lw`, `sw`
* Arithmetic: `add`, `sub`, `and`, `or`, `slt`
* Control: `beq`, `j`

While clearly a subset of the MIPS instructions, this is a very expressive
subset that will allow us to reason about a number of programs. As we understand
the design better, we will explore what new components would be needed to add
additional instructions.

Additionally, as part of our generic implementation, we will assume we have
access to other data/control components:

* Program Counter: `pc` register that supplies the address of the next
  instruction to be executed.
  
* Read/Write Registers: we will have access to the standard 32-bit registers of
  MIPS, including `$a`, `$s`, `$v`, and `$t` registers. Typically, we will refer
  by number, but these are the same register types

* ALU: We have the existing circuitry of an arithmetic-logic-unit. Refer to prior
  units for information.

* Mux'es: Control components that will allow us to select between different
  inputs based on signal wires.

## Timing Methodology

In the single-cycle design, we will use an abstraction to simplify the
presentation. Each box/rectangle will represent a state element (plus some other
logic) and transitions between elements will occur at clock edges. One full
cycle of the clock takes us from one sate element to the next, passing through
some combination logic describing which state element receives the signal from
the previous element.


```
  .--------.                             .--------.
  | state  |                             | state  |
  | element| -> ( combination logic ) -> | element|
  |   1    |                             |   2    |
  '--------'                             '--------'
    .-------------------.                  .---------
    |                   |                  |  
----'                   '------------------'
clock cycle

```

For example, *state element 1* may refer to logic that reads from an instruction
from memory and stores in the state-memory. After which, the bits of that
instructions are processed in the digital, combination logic, leading to the
next state element which may be associated with some form of executing that
instruction. After a series of clock cycles, linking state elements together
through some logic, we will eventually execute a instruction to produce a
result.

## Data Path 


Below is our simplified view of the data path of a single-cycle CPU. Note, much
of the control elements are not present, and instead we only concern ourselves
with where data is flowing to.


![simple-data-path](/imgs/cpu/simple-data-path.png "Copyright © 2014 Elsevier Inc. All rights reserved.")


From this diagram, we can start to see the various major components of the data
path.


1. (**PC**) Managing the PC: the program counter feeds into loading
   instructions, will be incremented (by 4), and also be used to determine
   branching/jumping. 
   
1. (**Instruction Memory**) Fetching Instructions: Using the PC address, load
   the next instruction that is to be executed.
   
1. (**Registers**) Loading data from registers: Breaking apart the data of the
   instructions, loading/reading/writing of the appropriate registers as
   referred by their numbers in the instructions, and using these as output to
   the ALU or the data storage elements.
   
1. (**Data Memory**) Storing/Loading from Memory: This unit processes
   loading/storing instructions that have to go out to main memory, separate
   from loading instructions.

As we zoom into each of these pieces, we will de-abstract some of the components
and expand on the procedures therein to see how all these parts connect together. 

### Fetching Instructions

First, let's take a closer look at the **instruction memory** component and the
role of the PC.

![fetching](/imgs/cpu/fetching.png "Copyright © 2014 Elsevier Inc. All rights reserved.")

Following the diagram, the PC component is read into the *read address* logic of
the **instruction memory**. This logic will load the bits of the instruction
into the state element, which will write out as *instruction* on the end of this
clock cycle.

The PC, which is an address/number, will also feed into an *add* ALU unit, with
fixed input of 4. Why 4? Well, the width of a MIPs instruction is 4-bytes, so
the next instructions is 4 bytes more than the current instruction. The result
of the add loops around and gets stored back in the PC register.

Note, that if the instructing is a jump (`j`), then the offset from the current
PC address (+4) *plus* the address encoded in the j-type instruction is the next
PC. Looking back in the larger diagram (previous subsection), you can see this
data flow as part of the output from *instruction* leading to a second ALU that
can calculate the next PC in cases of a jump.

### R-Type Instructions

As part of the **Register** portion of the diagram, let's consider if the
incoming *instruction* is an R-Type instruction. Recall that R-Type instructions
have the following format

```
ins $rd, $rs, $rt
```

That is, an R-Type instruction `ins` has three parameters: destination register
`$rd`, source registers `$rs`, and second source registers `$rt`. In the diagram
below, we see these get mapped into *read register 1* (`$rs`), *read register 2*
(`$rt`), and *write register* (`$rd`).

![r-type](/imgs/cpu/r-type.png "Copyright © 2014 Elsevier Inc. All rights reserved.")


Coming out of the component, we have two primary outputs. The two read registers
map to an ALU unit, where the control bits of the instruction, e.g., is an add,
or, and, sub, etc., dictate the operation. The output of ALU is fed back into
the **Register** unit as part of *write data*, so that the destination register
can be updated with the result.

In this diagram, we also see for the first time control flow. The black lines
represent data flow, but the orange lines represent control flow. The control
flow dictates the kinds of operations that should occur. The first one *ALU
Operation* is a 3-bit value describing the operation for the ALU, which we
already discussed. The second control flow is the *RegWrite* which is a 1 bit
value dictate if the *write register* should actually be written. Note that not
all R-Type instructions write the destination register.


### Load and Store

Now, let's consider an extension of the **Register** portion of the diagram for
I-type instructions load and store. Recall that these have the following format.

```
 lw $rt, i($rs)
 sw $rt, i($rs)
```

There are two registers and also an immediate value, which is an offset from
`$rt` for where to store `$rs`. The immediate value `i` is 16 bits.  Mapping
this to our diagram, we get the following.


![load-store](/imgs/cpu/load-store.png "Copyright © 2014 Elsevier Inc. All rights reserved.")

Lets first focus on the black, data-flow lines. As before, the *read register 1*
and *read register 2* receive the 5-bit (0-31 number) for the two source
registers, but this time, the *write register* receives a 16-bit number for the
immediate value. This does not refer to a valid register, so instead, the
immediate value is passed around the **Register** unit, sign extended from
16-bits to 32-bits, and directed toward the ALU unit.

To understand this *pass around* consider that the immediate value is an offset
from an address stored in `$rs`. The immediate value can either be positive or
negative, and as the register value is 32-bits, we need to sign-extend the
immediate value from 16-bits to 32-bits before processing in the ALU, where we
add the sign-extend immediate to the register value. The result is the *address*
in the **Data Memory** unit.

The second input to the **Data Memory** unit is the *write data*, this is passed
through directly from the **Register** unit's *read data 2* (`$rt`). This unit
actually does the reading and writing to main memory.

Consider now the control flow of this diagram. As before, we have the 3-bit ALU
Operation, which is clearly an `add`, but we also have *RegWrite*, *MemWrite*,
and *MemRead*. These are set differently depending on the instruction. 

* `lw`: `RegWrite` is 1, *MemWrite* is 0, and *MemRead* is 1. That's because we
  write to register `$rt` and perform a memory read, but do not write to memory.
  
* `sw`: `RegWrite` is 0, *MemWrite* is 1, and *MemRead* is 0. That's because we
  read from register `$rt` to learn what to write to memory, but do not write to
  a register nor read from memory.
  
  
### Branching 

In our simplified instruction set, we have a single branch instruction, `beq`.

```
beq $rs, $rt, label
```

Recall that `beq` is an I-Type instruction, so we get the two register read into
`read register 1` and `read register 2` are the values being compared. The
immediate value is the `label`, and is again, a 16-bit value, word-length offset
from the current instruction (+4). This gives us the following diagram.

![branching](/imgs/cpu/branching.png "Copyright © 2014 Elsevier Inc. All rights reserved.")

Following the data flow, we can see again the sign-extension on the `label` to
32-bits because the label offset can be both positive (branch forwards) or
negative (branch backwards). Additionally, labels are offset in word-length, and
a word is 4-byes wide. This makes sense because all instructions are 4-bytes
aligned, so there we can more compactly store offsets in word-length. But, to
calculate the *branch target* we must first multiply by 4 (or shift left by 2)
to calculate the true offset. This is all fed into the top ALU unit performing
an add.

Interestingly, in MIPS we calculate the offset from the next instruction
following the branch, which is 4 more than the PC of the `beq` instruction. This
is also represented in the diagram, but this fact has another effect which we
will discuss in more detail in multi-cycle, pipeline design. That being, the
next instruction that executes, regardless of the branch comparison is the
instruction where the comparison fails, that is, you don't branch.

This is because *branches are delayed* in MIPS. There is a performance gain from
doing this because if the branch is false, then execution occurs like
normal. But only when the branch is true, will we take the hit. So, weirdly, it
takes two full instruction cycles for a true branch to execute. The reasoning
and impact of this design decision will become more apparent when discussing
pipelines.


Returning to the diagram, lets now consider how we determine if a the branch is
true or false. Given the two *read data* outputs, we can check equality by
subtracting the two values and checking the *zero* output of the ALU. That 1-bit
zero output would then lead to some control output would be used to determine
which next, next instruction would execute. For the other control lines,
*RegWrite* would be 0 since we are not writing any registers, and the *ALU
operation* is subtraction, as discussed before.


## Unified Data Path

With each of the components individually understood, we can turn our attention
to how to merge them into a single, unified data path for the single-cycle
CPU. The glue points are where decisions points occur based on either computer
results (e.g., from a branch) or from control flow from the instruction bits. In
both cases, we need multiplexers, or MUX'es to bind the circuits.

![unified-datapath](/imgs/cpu/unified-datapath.png "Copyright © 2014 Elsevier Inc. All rights reserved.")

In this diagram, we have the complete data path, in black, and the various
control path, in light-blue. Three MUX'es have been placed as our glue, as well
as three additional control bits to switch the MUX'es.

* *ALUsrc* MUX: This MUX switches the input to the ALU following the
  **Registers* state and can be thought of as multiplexing between R-Type and
  I-Type instructions. Recall, that in R-Type instructions, the it's the value
  of the *read data 2* that provides the second input to the ALU to complete an
  `add`, `and`, etc. operation. However, with an I-type instruction, it may
  instead be the immediate value, passed around from the *write register*
  through the sign extension, say for a *lw* or *sw* instruction. 
  
  
* *MemtoReg* MUX: This MUX switches on the **data memory* output, which connects
  back to the *write data* input of the **registers** unit. The two choices
  being multiplexed is either the output of the ALU operation or the output of
  the *read data* operation of the **data memory**. Again, the signal for this
  MUX will be determined by the instruction type. For any R-Type instructing, we
  have a destination register that needs to be updated, so we choose the output
  of the ALU operation to pass back to the *write data* input of
  **registers*. In the case of `lw` instruction, we want the *read data* output
  to connect back to the *write data*. In the case of a `sw` instruction, it
  could be either choice because there is no write register, so control bit
  *RegWrite* would be 0.
  

* *PCSrc* MUX: This MUX switches based on the branch or jump instruction. In the
  case where the branch is true or the instruction is a jump, the new PC should
  be selected from the ALU output, otherwise, it's simply PC+4. The selector
  control signal, *PCSrc* is 1 when the branch is true or a jump
  instruction. Setting this to true for the jump instructing is based on the
  data encoded within the instruction, but setting for a true branch is more
  complicated because it will be related to the ALU output that follows
  **registers**. There will need to be a crossover between the data flow and the
  control flow in this case, and we will discuss this later when discussing the
  control flow more generally.
  
Also pictured in this diagram is other control paths discussed
previously. This includes:

* *RegWrite*: determining if the *write data* is written back to the *write register*

* *ALU operation*: determining the operation of the ALU based on the
  *registers* state.
  
* *MemWrite* : determining if **data memory** performs a write using *write data*

* *MemRead* : determining if **data memory** performs a read outputting to *read data*

## Determining Control Path from Instructions


![control-path](/imgs/cpu/control-path.png "Copyright © 2014 Elsevier Inc. All rights reserved.")
