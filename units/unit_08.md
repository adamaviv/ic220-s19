# Pipelines and Hazards

Consider our Single-Cycle CPU design from the previous unit. The big idea behind
is that an instruction will be loaded, decoded, and executed, with results
stored back in a single cycle. That cycle (even if broken down into smaller
clock ticks) must take the full cycle to complete. 

However, what if we were to explicitly break up the execution, so that each
component doesn't have to run fully. Instead, it can be staged; while a
instruction is decoded, the next instruction could be loaded. This idea is
called a *pipeline* (not to be confused with the pipeline in your Systems
Programming class).

In this unit, we will explore how pipelines work, and how to convert the single
cycle CPU model discussed previously into a multi-cycle, pipeline CPU. There
will be big benefits from this design change, but this will also introduce
hazards, which must be corrected.


## Doing Laundry

The classic example to demonstrate a pipeline is doing laundry. The procedure
for laundry is:

1. Wash (W)
2. Dry (D)
3. Fold (F)
4. Replace (R)

In our single cycle model, all four stages must be completed before the next
load of laundry completes. For example, if we look at this as cycle diagram,
where each action takes 1 cycle of time (maybe an hour?), we would have eh
following diagram for completed four loads of laundry:


```
              Cycles/Hours
|    | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 | 11 | 12 | 13 | 14 | 15 | 16  |
|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|-----|
| A: | W  | D  | F  | R  |    |    |    |    |    |    |    |    |    |    |    |     |
| B: |    |    |    |    | W  | F  | D  | R  |    |    |    |    |    |    |    |     |
| C: |    |    |    |    |    |    |    |    | W  | F  | D  | R  |    |    |    |     |
| D: |    |    |    |    |    |    |    |    |    |    |    |    | W  | F  | D  | R   |
```

To do four loads, takes 16 hours! That's a lot of time. But we know that once we
engage the dryer, the washer is empty. Why can't we stage the next load, so once
the drier becomes free, we can move the washer to dryer, then we can fold the
previous load, and so on. This is a pipeline, and it changes our timing diagram
dramatically.


```
              Cycles/Hours
|    | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|----|
| A: | W  | D  | F  | R  |    |    |    |    |    |    |    |    |    |    |    |    |
| B: |    | W  | D  | F  | R  | F  |    |    |    |    |    |    |    |    |    |    |
| C: |    |    | W  | D  | F  | R  |    |    |    |    |    |    |    |    |    |    |
| D: |    |    |    | W  | D  | F  | R  |    |    |    |    |    |    |    |    |    |
```


This time it takes 7 hours to complete the same work! That is a substantial
improvement. It's important to note, however, the same amount of work was done
but the *throughput* has increased! The same resources had to work just as hard,
we just didn't let it stay vacant.

## Pipelines for Instructions

The same can be done with laundry with the stages of executing an
instruction. Consider that the major portions of the single-cycle CPU model are:


1. **Instruction Fetch** (IF): The PC is loaded into the Instruction Memory unit,
   where the bits of that instruction, at the PC address are loaded.
2. **Instruction Decode** (ID): In this stage of execution, the bits of the
   instruction are decoded, passed to the control unit, and the appropriate
   registers are read.
3. **Execution** (EX): This stage contains the ALU component, which will either
   execute the arithmetic of an R-Type instruction, an equality test
   (subtraction) for a beq instruction or the address calculation for a memory
   instruction.
4. **Memory** (MM): If the instruction is a load or store, in this stage, the
   memory is either read (load) or written (store).
5. **Write Back** (WB): The last stage of the pipeline is writing back the
   result to the register. Of course, not ever instruction does this (e.g., a
   load), but we have to partition to the worst case.
   

For Memory and Instructing Decode, we will assume that the memory or register
file is read in the 2nd half of the clock cycle, while the memory or registers
are written in the 1st half of the clock cycle. 


## Dependency Hazards and Forwarding

Let's consider the pile for the following instruction sequence:


```
                       1      2      3      4      5     6       7       8      
                      .--.   .--.   .--.   .--.   .--.
1. sub $s0, $s1, $s2  |IF|---|ID|---|EX|---|MM|---|WB|
                      '--'   '--'   '--'   '--'   '--'
                      
                             .--.   .--.   .--.   .--.   .--.
2. and $a1, $s0, $a3         |IF|---|ID|---|EX|---|MM|---|WB|    
                             '--'   '--'   '--'   '--'   '--'
                             
                                     .--.   .--.   .--.   .--.   .--.
3. add $t0, $t1, $s0                 |IF|---|ID|---|EX|---|MM|---|WB|    
                                     '--'   '--'   '--'   '--'   '--'
                                     
                                            .--.   .--.   .--.   .--.   .--.
4. or  $t2, $s0, $s0                        |IF|---|ID|---|EX|---|MM|---|WB|
                                            '--'   '--'   '--'   '--'   '--'
```

The first instruction `sub` will write the result to `$s0`, but `$s0` is
required for *all* the following instructions. Naively, looking at the diagram,
the new value of `$s0` will not be ready until cycle 5, but it is needed
following cycle 3 (after ID) as an input to the EX stage of the and instruction.

But! It's not exactly the case that the value of `$s0` from the is not known by
cycle 4, as needed for the EX stage of the `and`. It is known, it's the output
of EX of `sub`, but it just hasn't been written back yet. 


So, we can **forward* that value to the next execution, and all forward in time
pipelines that need the value of `$s0` before it can be written back



```
                       1      2      3      4      5     6       7       8      
                      .--.   .--.   .--.   .--.   .--.
1. sub $s0, $s1, $s2  |IF|---|ID|---|EX|-*-|MM|---|WB|
                      '--'   '--'   '--' | '--'   '--'
                                         '--v---.
                             .--.   .--.   .--. | .--.   .--.
2. and $a1, $s0, $a3         |IF|---|ID|---|EX|-+-|MM|---|WB|    
                             '--'   '--'   '--' | '--'   '--'
                                                '---v
                                    .--.   .--.   .--.   .--.   .--.
3. add $t0, $t1, $s0                |IF|---|ID|---|EX|---|MM|---|WB|    
                                    '--'   '--'   '--'   '--'   '--'
                                     
                                           .--.   .--.   .--.   .--.   .--.
4. or  $t2, $s0, $s0                       |IF|---|ID|---|EX|---|MM|---|WB|
                                           '--'   '--'   '--'   '--'   '--'
```

In cycle 5, the new value of `$s0` is written back, and since we assume that
write back occurs in concert (first stage of cycle) with the read (second stage
of cycle), the ID (instruction decode) of the last instruction (`or`) will have
the latest value of $s0.


## Stalls

In general, we can use forwarding to solve decencies, as long as they go forward
in time. But, that may not always be the case. For example, consider the
sequence below. The value of `$t0` is not available until the MM stage
completes, our solution for forwarding would instead ... be a backwards?!?



```
                       1      2      3      4      5     6       7       8      
                      .--.   .--.   .--.   .--.   .--.
1. lw $t0, 0($s1)     |IF|---|ID|---|EX|---|MM|-*-|WB|
                      '--'   '--'   '--'   '--' | '--'
                                            v---'      
                             .--.   .--.   .--.   .--.   .--.
2. sub $a1, $t0, $a3         |IF|---|ID|---|EX|---|MM|---|WB|    
                             '--'   '--'   '--'   '--'   '--'
                                                 
                                    .--.   .--.   .--.   .--.   .--.
3. add $a2, $t0, $s2                |IF|---|ID|---|EX|---|MM|---|WB|    
                                    '--'   '--'   '--'   '--'   '--'
```                                    


As compared to the forwarding before, we were using the output of a stage, going
forward in time, to use that result in another stage. We can't do that here,
instead we have to **stall** execution and wait for the result to finish. This
results in the following pipeline.



```
                       1      2      3      4      5     6       7       8      
                      .--.   .--.   .--.   .--.   .--.
1. lw $t0, 0($s1)     |IF|---|ID|---|EX|---|MM|-*-|WB|
                      '--'   '--'   '--'   '--' | '--'
                                                '-v
                             .--.   .--.          .--.   .--.   .--.
2. sub $a1, $t0, $a3         |IF|---|ID|---XXXX---|EX|---|MM|---|WB|    
                             '--'   '--'          '--'   '--'   '--'
                                                 
                                    .--.          .--.   .--.   .--.   .--.
3. add $a2, $t0, $s2                |IF|---XXXX---|ID|---|EX|---|MM|---|WB|    
                                    '--'          '--'   '--'   '--'   '--'
```                                    

The XXXX's are a stall. These instructions need to way for the memory operation
to complete so that the result can be *forwarded* to the execute in the later
instruction. The stall also pushes the `add` to execute its ID stage because
during the stall, `sub` is still in ID. That delay enables the write-back in
cycle 5 to occur so that there is no need for a forward for the `add`.


## Control Hazards

Pipelines make a strong assumption about which of the instructions are going to
execute next, so that we can do the overlapping. But, when you add branching and
other control instructions, this assumption can no longer be made. For example,
consider the following set of instructions.

```
      beq $a0, $a1, Else
      lw $v0, 0($s1)
      sw $v0, 4($s1)
Else: add, $a1, $a2, $a3
```

We could pipeline the next instruction, `lw`, but it may not actually be the
correct instruction to execute next. Instead it could be the `add` instruction
of the `$a0 == $a1`. 

There are a few choices we can make regarding branches. The challenge is that
when we are wrong, the processor has started to execute a set of instructions
which need to be flushed prior to commitment. Fortunately, that's not hard to do
because we'll learn of a bad branch prediction following the EX phase, but this
still means the prior work in the pipeline of loading and decoding the
instructions was for naught.

In the world of branch prediction, there are a few choices we can make:

1. **Predict not taken**: In this setting, we just assume the branch is usually
   *not* taken and continue to execute the next instruction. This is the
   simplest strategy, but most likely leads to the most failed branch
   predictions.
   
2. **Static Prediction**: In this mode, we always predict the same way, as in
   the predictions are pre-baked in and based on a static view of the code, not
   based on running it. For example a static policy could be to assume the
   branch is *not* taken unless it is a backwards branch. This could be a good
   strategy because backward branching tends to imply loops, and in a loop, most
   branches are taken, except when existing the loop. But, we could do better if
   we take into the account context from the running program.
   
3. **Dynamic Prediction**: This is the strategy actually used by CPUs and it
   keeps track of the context of when a failed branch prediction occurred,
   adjusting in the future. The dynamic part of the prediction comes from
   tracking branching in the running program. 

A good dynamic prediction algorithm is the key to performance with pipelines. A
lot of code has branching, and if we are constantly wrong in our branches, the
benefit of pipelines diminishes. Fortunately, most code is very predictable, and
a good branch predictor can predict the branch with 90-95% accuracy.

As an example, here's a basic algorithm that uses a 2-bit branch predictor based
on a state machine. We have four states:

* Strong Predict Taken (ST) (00)
* Predict Taken (T) (01) 
* Predict Not Taken (N) (10)
* Strong Predict Not Taken (SN) (11)


```
   Taken                                                    Not Taken
     .--.                                                   .--.
     |  |                                                   |  |
     v  |    Not Taken       Not Taken         Not Taken    |  V
    ( ST ) ----------> ( T ) ---------->( N ) -----------> ( SN )
       ^                | ^              | ^                |
       '----------------' '--------------' '----------------'
              Taken            Taken            Taken

```

In this model, if we are in a "strong" state, like we would be in the loop, it
takes *two* bad predictions to change, but in the middle states, we just do what
happened the last time. This is a very simple branching model, but it gives a
sense of what is possible.

## Dynamic Pipeline Scheduling

Another strategy deployed to enable pipelines is *dynamic pipeline
scheduling*. In this model, the hardware looks ahead for the next set of
instructions to execute and try to remove an obvious hazard. For example,
consider the following set of instructions.

```
1. lw $t0, 0($t1)
2. add $t2, $t0, $t2
3. lw $t3, 4($t1)
4. add $t4, $t3, $t4
```

If we were to swap the order of inst 2 and 3, then we would avoid a stall
waiting for the load to finish in order to forward that result to the
add. However, the second load, line 3, is independent of line 2 and line 1, so
it can run, avoiding the stall, and moreover, avoid the later stall with line 4.

Identifying these reordering can occur in multiple places. Foremost, the
compiler can recognize inefficiencies and remove such dependencies via
reordering. More often, though, the hardware of the CPU can find such reordering
and smartly choose the next instruction that can run independently.

Furthermore, hardware reordering can take other aspects into account. For
example, it may be aware that there is a looming cache miss on a load, meaning
that the cycle time required for reading from memory will be a lot
slower. Additionally, if you arrange loads/stores, there may be address
collisions for where in memory an action is to take place. Hardware can predict
these events and handle it a lot better than a compiler.

## Pipeline Control Signals

The last piece of the pipeline puzzle we will address here is the notion of
control signals. Simply breaking up the execution into stages abstracts away the
fact that at decode stage, all the control signals are set. How then can there
be different control signals at each stage of the pipeline?

The solution is to also stage the control signals at each part of the
pipeline. Just like with the data, which is staged and stored in some sort of
state element, the control values must also be passed in the same way. However,
as data/information flows to the right in the diagram, the control signals are
used up, until when we reach the WB stage, there should only be one signal left.

*Refer to the book for detailed diagrams of this*

