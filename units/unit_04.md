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

The transition between a 0 or 1 (or a 1 or 0), is called the *rising edge* when
transitioning between a 0 to 1 and a *falling edge* when transitioning between a
1 to 0. Different state elements change their output state either on the rising
or falling edge. Below, we will look at a bit of both. 

## D Latch

The first state element is a *D Latch*, which has many of the same properties of
a S-R Latch (in fact its built out of an S-R latch!), except that its output
transition is based on the edges of the clock. 

Like before, we can consider the states of input and output of the
D-latch. There exist two wires for input, `C` for the clock and `D` for the
data. The data, `D`, can be in two states, 0 or 1, as well as `C`, either
asserted 1 or de-asserted 0. This is a latch, so when the clock is asserted (1),
the latch is **open** and thus the output `Q` takes on the state of the input `D`. 

![d-latch](/imgs/seq-logic/d-latch.gif)

Thus, we can describe the states of the D-Latch in much the same way as the S-R
latch, except the clock plays the role of opening the output. 

* In state (1,1) : `Q` is set to 1
* In state (0,1) : `Q` is set to 0
* In state (X,0) : `Q` keeps the prior state, where X can be either 0 or 1 for `D`.

You should also notice the importance of the S-R-Latch in the D-Latch. The two
leading AND gates use the input states to switch between a Set and Reset in the
S-R-latch, which is what is saving the state. 

## D Flip Flops

The D-latch is still a *transparent* because it doesn't act on the transitions
of the clock, just on the values. A flip-flop, however, is designed to change
state at transitions, either rising or falling edges, of the clock. 

In this model, we can consider the clock having four states, two steady states
of 0 and 1, and two transition states that are either rising (0->1) or falling
(1->0).

A D-flip-flop is the first state element that is not transparent, and the
example below is a **falling edge** flip-flop, which means that the output state
is *set* on the falling edge and *held* on the rising edge as well as the two
steady states..

Below, is a animation of a D-Flip-Flop which is composed of two D-latches, which
in turn are composed of S-R-Latches.

![d-flip-flop-falling](/imgs/seq-logic/d-flip-flop-falling.gif)

To understand the behavior, like before, if we consider the states (`D`,`C`), we
can describe the operations of the D-Flip-Flop like:

* In state (1,1->0): set output `Q` to 1
* In state (0,1->0): set output `Q` to 0
* In state (X,0->1): hold output `Q` to whatever was its prior state
* In state (X,0): hold output `Q` to whatever was its prior state 
* In state (X,1): hold output `Q` to whatever was its prior state 

Looking at the animation. The output `Q` is unaffected as `D` changes from 0
to 1. It is only when a falling edge occurs, C goes 1->0, does the output `Q`
change state. 

In Logisim, the simulator we will use *rising edge* D-Flip-Flops and mostly
abstract away the underlying circuitry. However, the basic principal applies,
just in this case, the output `Q` only transitions when the clock has a rising
edge from 0->1.


![d-flip-flop-rising](/imgs/seq-logic/d-flip-flop-rising.gif)


Finally, to put this all together and see sequential logic at work, consider the
circuit below which places two rising-edge D-Flip-Flops in sequence with an
alternating clock (note the AND gate along the top), and a feedback loop.

![seq-flip-flop](/imgs/seq-logic/seq-flip-flop.gif)

This small circuit counts, based on the value of the flip flops, 00, 10, 11, 01,
00, ... It's not perfect counting, but it's most of the way there! 

## State Machines


**_IN PROGRESS_**
