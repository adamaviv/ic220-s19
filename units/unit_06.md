# Performance 

Readings: Chapter 1.6, 1.9-1.11

> These unit notes are **not** design to replace readings from the book! There
> are to provide structure to material covered in class and provide you an
> outline for using the book. **You are still required to do the course
> readings** in which you will find much more detail, and those details will be
> evaluated in quizzes, homework, and exams.


## Performance Matters

The performance of architectures matters because they can lead us towards making
intelligent choices. For example, why we might want to use different
instructions over others, or which kind of hardware best fits a given problem.

In this unit we will try and answer some key underlying questions

- *Why is some hardware better than others for different programs?*

- *What factors of system performance are hardware related? (e.g., Do we need a
  new machine or a new operating system?)*
  
- *How does the machine's instruction set affect performance?*

## Computer Performance

The most important performance metric that end users care about is time. Simply
put, how long does it take to complete a given tasks. The time measurements can
be divided into two metrics

* **Latency**: Execution or Response Time
  - How long does it take for my job to run?
  - How long does it take to execute a job?
  - How long must I wait for the database query?
* **Throughput**: Rate of completion
  - How many jobs can machine run at once?
  - What is the average execution rate?
  - How much  work is getting done?
  
Given these two metrics, if we were to upgrade a machine with a new processor,
what do we improve? Both response time and throughput. We can speed boost from a
faster processor which also means we can process more tasks. 

Alternatively, if we were too add a new machine to the lab/cluster what do we
improve? Just throughput, as we now have yet another machine to handle the
jobs. It is possible to also improve latency, depending on the setting, but must
likely, just throughput.

## Execution Time

How do we actually measure execution time? There could be a number of factors,
such as how many other jobs are running. We could also consider the clock cycles
or real time.

We described **elapsed time** or the "walk-clock time" as the number of seconds
it takes from starting to the job to completion. This is useful from an end user
perspective, but it is not a very good metric for the purpose of comparisons
because there could be too many contributing factors, such as other tasks,
humidity, power availability, etc. 

**CPU time** however is a bit more fundamental. It only counts how much time the
job itself is executing on the CPU, not counting I/O or time when other programs
are executing. This can further be broken into system and user time; when the
O.S. is running verses user-level directives.

We will mostly focus on User CPU time as our performance measure, and in general
we will express this in times-faster, saying things like "X is n times faster
than Y". For example, if machine A runs a program in 20 seconds (CPU time) and
machine B runs a program in 25 seconds (CPU time), then how much faster is A
than B?  It is not 5 seconds faster, but rather 25/20 = 1.25 faster. 

## Clock Cycles and CPU Time

Clock cycles is another way to report execution time. Every CPU maintains it's
own clock which ticks at a given rate. The *clock rate* is expressed in Hertz,
or number of ticks per second. So a 400 MHz CPU performs 400 Million clock ticks
per second. 

This allows us to re-write seconds in terms seconds per cycle, leading to 
the following formula:

```
  seconds      cycles       seconds
  -------  =   ------  X   --------
  program     program        cycle

```

Or put another way, via rearranging the arguments `seconds = cycles *
seconds/cycle`. The seconds per cycle, is the inverse of clock rate which is in
cycles per second (or Hz). Thus we can calculate the CPU time by knowing how
many clock cycles the program took and the clock rate. Or put another way,
`seconds = cycles/clockrate`. 

For example, if some program requires 10x10^6 cycles. CPU A runs at 2.0 GHz and
CPU B runs at 3.0 GHz, what is the execution time for CPU A and B?
* Time A: 10x10^6 / 2x10^9 = 1x10^7/2x10^9 = 1/2 x 10^-2 = 0.05 s
* Time B: 10x10^6 / 3x10^9 = 1x10^7/3x10^9 = 1/3 x 10^-2 = 0.033 s

Increase the clock rate speeds up the program because more instructions can
execute per second. Alternatively, if a program were compiled more efficiently,
it may require less cycles to execute, this would also increase
performance. There is an inverse relationship between the number of cycles and
clock rate, so either decreasing the requisite cycles or increasing the clock
rate will lead to better performance.

## Cycles Per Instruction (CPI)

One might assume, wrongly, that each instruction runs for one cycle. But this is
not the case because not all instructions require the same amount of work. For
example, consider that multiplication is essentially successive addition, and
that for floating point operations, this requires a completely different
arithmetic unit. In that scenario, it makes sense that different operations
should take different amounts of time. Instead, we need a metric that can
accommodate the inequality of the number cycles each instruction may take.

**Cycles per instruction** is a way to estimate how long a program will run
based on the number of instructions required to execute it. If we have the
average number of cycles per instruction (CPI), then we can get the expected
number of cycles by multiplying by the total number of instructions or `IC`. Or
put another way, `cycles = CPI*IC`. To get CPU time, we now have now 

```
CPUtime = CPI * IC * ClockCycleTime = CPU*IC/ClockRate
```


For example, suppose we have two implementations of the same instructions set
architecture (ISA). We have

* Machine A has a clock cycle time of 10 ns and a CPI of 2.0
* Machine B has a clock cycle time of 20 ns and a CPI of 1.2

Which machine is faster? 

* Time A = IC * 2.0 * 10 ns = IC * 20
* Time B = IC * 1.2 * 20 ns = IC * 24
* Performance: Time B / Time A : IC * 24 / IC * 20 = 24/20 = 1.2x  A is faster.

So even with different clock cycles, with a CPI, we can do a decent comparison
between these two machines. 


## Number of Instructions

We can also consider the problem from a different angle, the number of
instructions in the program, which may be compiler dependent. For example, if we
had three classes of instructions Class A, Class B, and Class C and they require
on, two, and three cycles (respectively), you could compare different sequences
of instructions for performance. Like in:

* First code sequence has 5 instructions: 2 of A, 1 of B, and 2 of C
* Second code sequence has 6 instructions: 4 of a, 1 of B, and 1 of C

Which sequence will be faster and by how much? That can be calculate that by
multiplying out the number of cycles by the instructions available

* Seq. 1 : `2*1 + 1*2 + 2*3 = 10`
* Seq. 2 : `4*1 + 1*2 + 1*3 = 9`

Despite having fewer instructions, Sequence 2, should be faster by 1.1x =
10/9. We can then follow that up by calculating the CPI:

* CPI 1: 10/5 = 2
* CPI 2: 9/6 = 1.5

Which also confirms that the number of cycles per instruction is lower as
well.

## Benchmarks

With all these metrics in place, we still need a standard to compare everything
by. **Benchmarks** are a set of programs that provide expected workloads across
a wide variety of scenarios and enable good apples-to-apples comparisons. Even
under a benchmark, we often consider a wide variety of the metrics we described
above, and looking at it from multiple angles (and using the standard) should
avoid abuse and cheating in the measurement.

There are many different kinds of benchmarks available. A common one is the
[SPEC](http://ww.specbench.og) (System Performance Evaluation Cooperative). 

## Amdahl's Law

No matter how hard you push to make things faster, there is always a point of
diminishing returns. For example, increasing the clock speed may at some point
mean that some of the instructions can no longer complete in a clock cycle. 

This notion was codify by Amdahl in the following equation:

```
Execution Time After Improvement =

 Execution Time Unaffected + (Execution Time Affected / Amount of Improvement)
```

For example, suppose a program runs in 100 seconds on a machine, with multiply
instruction responsible for 80 seconds of this time. How much do we have to
improve the speed of multiplication if we want the program to run 4 times
faster?

In this scenario, 20(s) are for other instructions, and 80(s) are for
multiply. To make it 4 times faster requires the program to complete in
25(s). So the Amount of Improvement is calculated by

```
25s = 20s + 80s/x
5s = 80s/x
x = 80/5 = 16
```

That would require improving multiplication by 14x. It's not impossible, but
quite ambitious. However, to see where diminishing returns comes into play: can
we make this 5 times faster? That would mean running in 20s

```
20s = 20s + 80s/x
0 =  80s/x
x = 80/0 <--- ERROR
```

We are left with a lower bound on possible improvement because we can't divide
by 0, or for that matter have a negative factor in improvement. Amdahl's law
provides both a way to identify how much improvement we need and also where the
limits of that improvement come from.










