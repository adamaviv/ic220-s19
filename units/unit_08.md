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
where each action takes 1 cyle of time (maybe an hour?), we would have eh
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
| D: |    |    |    | W  | D  | F  | R   |    |    |    |    |    |    |    |    |    |
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
durring the stall, `sub` is still in ID. That delay enables the write-back in
cycle 5 to occur so that there is no need for a forward for the `add`.


## Structural Hazards


## Control Hazards


## Dynamic Pipeline Scheduling


## Pipeline Control 


## Implementing a Pipeline
