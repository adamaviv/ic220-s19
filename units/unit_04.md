# Sequential Logic

    Readings: Chapter  B.7-B.10, B.12

> These unit notes are **not** designed to replace readings from the book! They
> are to provide structure to material covered in class and provide you an
> outline for using the book. **You are still required to do the course
> readings** in which you will find much more detail, and those details will be
> evaluated in quizzes, homework, and exams.

## Sequential Logic 

So far, we've only consider logic circuits that are *combinational* as they only
compute based on the current input. However, you can imagine computation that is
*sequential*, where the logic takes into account current inputs and previous
inputs. 

A previous input element will be stored in *state elements*, which is updated
based on clock cycle. This requires *feedback circuits* which cannot occur in
combinational circuits. 

Given prior state, we can now construct circuits that consider logic computing
in stages, or sequentially. Consider the implications of this within the context
of the CPU and instructions from before. Each cycle, we calculate a result and
store it in state elements. In the next cycle, we use that result to compute the
next result, and store that in state elements, and so on.

## S R Latches

For state elements, we start small; just storing a single bit of
information. The simplest of the state elements, but one that is used to build
more complex elements is the **S-R Latch**, which stands for Set and Reset
Latch. The wiring for an S-R latch is detailed in the GIF below.

![s-r-latch-gif](/imgs/seq-logic/s-r-latch.gif)

The circuit consists of two inputs, two NOR gates, and two outputs. The outputs
are inversions of each other, so we can just focus on Q. The goal of the latch
is to maintain the signal, either asserted (1) or de-asserted (0), which can be
set by toggling the asserting the S or R input, respectively. 

We can describe these cases using a *next state* table, which considers the
prior state of the circuit when consider the current state of the circuit. For
example, the S-R latch has three valid states of input for (S,R): (0,0), (1,0),
and (0,1) and two states of output (1,0) or (0,1). Since the two output states
or inversions, we can just focus on `Q` either having state 1 or 0. The circuit
is undefined at (1,1), leading to a race condition. 

Consider the valid input states and possible output states, we can view this a
state machine. Given an input state, what is the output state. 

* In state (1,0): the circuit's output is set to asserted, 1
* In state (0,1): the circuit's output is set to de-asserted, 0
* In state (0,0): the circuit maintains its prior state, either asserted (1) or
  de-asserted (0)

You can see this behavior in the gif. You may notice, that once the `S` input is
asserted (1) producing the state (1,0), even when de-asserted to state (0,0),
the output remains asserted (1). That is what makes it a latch. It keeps that
state even when the input changes. To de-assert the output (`Q`), the R input is
asserted to produce state (0,1), which is also maintained when entering state
(0,0).



## Clock Cycles

An S-R latch is a state element that does not use a clock to maintain state, but
the remaining elements do require a clock. A clock is just a signal that
oscillates between asserted and de-asserted at some frequency. 

![clock](/imgs/seq-logic/clock.png)

## D Flip Flops

![d-latch](/imgs/seq-logic/d-latch.gif)

![d-flip-flop-falling](/imgs/seq-logic/d-flip-flop-falling.gif)

![d-flip-flop-rising](/imgs/seq-logic/d-flip-flop-rising.gif)

![seq-flip-flop](/imgs/seq-logic/seq-flip-flop.gif)


**_IN PROGRESS_**
