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
example, the S-R latch has three valid inputs for (S,R): (0,0), (1,0),
and (0,1) and two states of output (1,0) or (0,1). Since the two output states
or inversions, we can just focus on `Q` either having state 1 or 0. The circuit
is undefined at (1,1), leading to a race condition. 

Consider the valid input states and possible output states, we can view this a
state machine. Given an input state, what is the output state. 

* On input (S,R) = (1,0): the circuit's state Q is set to asserted, 1
* On input (S,R) = (0,1): the circuit's state Q is set to de-asserted, 0
* On input (S,R) = (0,0): the circuit maintains its prior state, either asserted (1) or
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
transition is based on the level of the clock (i.e, either it is 0 or 1). 

Like before, we can consider the states of input and output of the
D-latch. There exist two wires for input, `C` for the clock and `D` for the
data. The data, `D`, can be in two states, 0 or 1, as well as `C`, either
asserted 1 or de-asserted 0. This is a latch, so when the clock is asserted (1),
the latch is **open** and thus the output `Q` takes on the state of the input `D`. 

![d-latch](/imgs/seq-logic/d-latch.gif)

Thus, we can describe the states of the D-Latch in much the same way as the S-R
latch, except the clock plays the role of opening the output. 

* On input (D,C) = (1,1) : `Q` is set to 1
* On input (D,C) = (0,1) : `Q` is set to 0
* On input (D,C) = (X,0) : `Q` keeps the prior state, where X can be either 0 or 1 for `D`.

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

* (1,1->0): set output `Q` to 1
* (0,1->0): set output `Q` to 0
* (X,0->1): hold output `Q` to whatever was its prior state
* (X,0): hold output `Q` to whatever was its prior state 
* (X,1): hold output `Q` to whatever was its prior state 

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

The notion of a *state machine* was described in the previous description to
think about the output state of the circuit based on its input. We can take that
notion a bit further to think about any basic computation. 

State machines are typically modeled as graphs with each node describing a state
and transitions between states as edges. The labels on the node can describe an
output state, and the label on an edge an input state transition to a new
(output) state.

To see an example, consider the sequential counting D-flip-flops from above. We
can draw a state diagram for that like so. 

![sff-state-diagram](/imgs/seq-logic/sff-state-diagram.png)

Note that each transition is a clock tick, either rising or falling edge. The
state in the node is the state of the D-Flip-Flops. The "Data Input", not
pictured, is the inverse of the second bit of the node (as the output of the
second D-Flip-Flop is notted as the "Data Input").

This is a fairly simple state diagram for a known circuit. Where this becomes
more interesting is when we use a state diagram to describe some behavior and
then translate that into a sequential logic circuit.

## The Candy Machine Example

Suppose we wanted to write a sequential logic circuit to mimic a candy
machine. Candy costs 15 cents, and the machine accepts two types of input, a
nickel or dime. If the total inputted is less then 15 cents, there is no output,
if it is 15 cents, the output is a piece of candy, and if it is 20 cents, then
the output is candy and 5 cents change. 

What are the states of this machine? It's the total count of change
inputted. The input state of the machine is just if the user provided a nickel
or dime.  The output states of the machine is three-fold: do you provide candy
(y/n), do you provide change (y/n), and what is the next state?

We can model this in the following table:


| Current State | Input | Output Change | Output Candy | Next State |
|---------------|-------|---------------|--------------|------------|
| 0             | N     | 0             | 0            | 5          |
| 0             | D     | 0             | 0            | 10         |
| 5             | N     | 0             | 0            | 10         |
| 5             | D     | 0             | 1            | 0          |
| 10            | N     | 0             | 1            | 0          |
| 10            | D     | 1             | 1            | 0          |


We can represent this visually like so. 

![candy machine](/imgs/seq-logic/candy.png)

Each node label represents the current state, or the number of cents previously
inputted. The transition labels is the input coin, either `N` for nickel or `D`
for dime, plus the two output states (`Change`/`Candy`).

## Next State Truth Table

The candy machine above can further be modeled as a **next state** truth table
based on the input states and the output states. Consider that the input set of
the machine are the current state and the coin. The output set are the change,
candy, and the next state of the machine. In order to represent this as a truth
table, we need to rewrite these input and output sets in terms of the number of
bits needed to represent them.

* Input: 3 possible current states can be represented using 2 bits, and we need
  one bit to represent which coin was supplied.
  
* Output: 1 bit for the change, 1 bit for the candy, and 2 bits to represent the
  next state.
  
So there are 3 bits of input and 4 bits of output. We can write this truth table
like so.

[Q_0]: https://latex.codecogs.com/gif.latex?Q_0
[Q_1]: https://latex.codecogs.com/gif.latex?Q_1
[I]: https://latex.codecogs.com/gif.latex?I
[O_0]: https://latex.codecogs.com/gif.latex?O_0
[O_1]: https://latex.codecogs.com/gif.latex?O_1
[Q_1']: https://latex.codecogs.com/gif.latex?Q_1%27
[Q_0']: https://latex.codecogs.com/gif.latex?Q_0%27


| ![][Q_0] | ![][Q_1] | ![][I] | ![][O_0] | ![][O_1] | ![][Q_0'] | ![][Q_1'] |
|----------|----------|--------|----------|----------|-----------|-----------|
| 0        | 0        | 0      | 0        | 0        | 0         | 1         |
| 0        | 0        | 1      | 0        | 0        | 1         | 0         |
| 0        | 1        | 0      | 0        | 0        | 1         | 0         |
| 0        | 1        | 1      | 0        | 1        | 0         | 0         |
| 1        | 0        | 0      | 0        | 1        | 0         | 0         |
| 1        | 0        | 1      | 1        | 1        | 0         | 0         |


To see how this works, consider that ![][Q_0] ![][Q_1] combined represent the
state, so `00` is 0 cent, `01` is 5 cents, `10` is 10 cents. The input state ![][I]
is either 0 or 1 for nickel or dime. The output states ![][O_0] and ![][O_1]
represent the change and candy dispensing conditions, respectively. And
![][Q_0'] combined with ![][Q_1'] represent the next state in the transition,
either to `00` `01` or `10`.


## Building Circuits at of State Machines

The last step in this process is to construct a circuit that has the sequential
logic of the candy machine. This begins by solving the truth table for all the
input conditions for each output condition. 

### Solving for ![][O_0]

Let's solve for ![][O_0] first, resulting in the following simple truth table.

| ![][Q_0] | ![][Q_1] | ![][I] | ![][O_0] |
|----------|----------|----------|----------|
| 0        | 0        | 0        | 0        |
| 0        | 0        | 1        | 0        |
| 0        | 1        | 0        | 0        |
| 0        | 1        | 1        | 0        |
| 1        | 0        | 0        | 0        |
| 1        | 0        | 1        | 1        |

We can write the normal form simply as 

[O_0-eq]: https://latex.codecogs.com/gif.latex?O_0%3DQ_0%5Coverline%7BQ_1%7DI

![][O_0-eq]

### Solving for ![][O_1]

The next truth table for output state ![][O_1] is more complicated

| ![][Q_0] | ![][Q_1] | ![][I] | ![][O_1] |
|----------|----------|----------|----------|
| 0        | 0        | 0        | 0        |
| 0        | 0        | 1        | 0        |
| 0        | 1        | 0        | 0        |
| 0        | 1        | 1        | 1        |
| 1        | 0        | 0        | 1        |
| 1        | 0        | 1        | 1        |

We can either minimize this by hand or convert it into a K-map

[not-I]: https://latex.codecogs.com/gif.latex?%5Coverline%7BI%7D
[not-Q_0-not-Q_1]: https://latex.codecogs.com/gif.latex?%5Coverline%7BQ_0%7D%5Coverline%7BQ_1%7D
[not-Q_0-Q_1]: https://latex.codecogs.com/gif.latex?%5Coverline%7BQ_0%7DQ_1
[Q_0-not-Q_1]: https://latex.codecogs.com/gif.latex?Q_0%5Coverline%7BQ_1%7D
[Q_0-Q_1]: https://latex.codecogs.com/gif.latex?Q_0Q_1

|            | ![][not-Q_0-not-Q_1] | ![][Q_0-not-Q_1] | ![][Q_0-Q_1] | ![][not-Q_0-Q_1] |
|------------|----------------------|------------------|--------------|------------------|
| ![][I]     | 0                    | 1                | X            | 1                |
| ![][not-I] | 0                    | 1                | X            | 0                |

Two states have X's since ![][Q_0-Q_1] does not produce an output. Covering this
K-map, we find the formula: 

[O_1-eq]: https://latex.codecogs.com/gif.latex?O_1%20%3D%20Q_0%5Coverline%7BQ_1%7D%20&plus;%20IQ_1

![][O_1-eq]

### Solving for ![][Q_0']

We have the following truth table

| ![][Q_0] | ![][Q_1] | ![][I] | ![][Q_0'] |
|----------|----------|----------|----------|
| 0        | 0        | 0        | 0        |
| 0        | 0        | 1        | 1        |
| 0        | 1        | 0        | 1        |
| 0        | 1        | 1        | 0        |
| 1        | 0        | 0        | 0        |
| 1        | 0        | 1        | 0        |


which we can transform into a K-Map

|            | ![][not-Q_0-not-Q_1] | ![][Q_0-not-Q_1] | ![][Q_0-Q_1] | ![][not-Q_0-Q_1] |
|------------|----------------------|------------------|--------------|------------------|
| ![][I]     | 1                    | 0                | X            | 0                |
| ![][not-I] | 0                    | 0                | X            | 1                |

Which has the following minimized formula

[Q_0'-eq]: https://latex.codecogs.com/gif.latex?Q_0%27%3D%5Coverline%7BQ_0%7D%5Coverline%7BQ_1%7DI%20&plus;%20Q_1%5Coverline%7BI%7D

![][Q_0'-eq] 

### Solving for ![][Q_1']

We have the following truth table


| ![][Q_0] | ![][Q_1] | ![][I] | ![][Q_1'] |
|----------|----------|--------|-----------|
| 0        | 0        | 0      | 1         |
| 0        | 0        | 1      | 0         |
| 0        | 1        | 0      | 0         |
| 0        | 1        | 1      | 0         |
| 1        | 0        | 0      | 0         |
| 1        | 0        | 1      | 0         |

Which has the formula

[Q_1'-eq]: https://latex.codecogs.com/gif.latex?Q_1%27%20%3D%20%5Coverline%7BQ_0Q_1I%7D

![][Q_1'-eq]

### Candy Machine: Digital Logic Circuit

Now that we have a boolean formula for each output of the machine based on the
inputs, we can map these into a digital circuit. Here's
[one](/rsc/logisim/ex/candy-state-1.circ) in LogiSim that you can play with,
animated below:

![candy-state-1](/imgs/seq-logic/candy-state-1.gif)

Note that in each of the input states produces the proper asserted output
states. 

### Candy Machine: Sequential Logic Circuit

To make this a sequential logic circuit that fully mimics the state machine, we
need to use a state elements to store the current state that get updates based
on the input and compute an output. We will need four D-Flip-Flops as our state
elements, one for each output wire of the circuit. Each click of the clock
(rising edge), based on the input wire (either a Nickel or a Dime), the state
elements will update. 

You can play around with this [circuit](/rsc/logisim/ex/candy-state-2.circ) in
LogiSim, and view the animation below. In the animation, it cycles through
adding three nickels, two dimes, and then one nickel and one dime. 

![candy-state-2](/imgs/seq-logic/candy-state-2.gif)

Note that the prime labels, such as `O'_0` `O'_1` `Q'_0` `Q'_1` indicate would
be future output states based on the input bit `I`. It's only once the clock
ticks, do the output states `O_0` `O_1` are set and the current state `Q_0` and
`Q_1` set in their respective D-Flip-Flop state elements. 


### Candy Machine to the CPU

Putting this all together, it should be clear how state elements enable
sequential logic. With sequential logic, we can model computation as a state
machine, like the candy machine. Of course, this is a small, contrived example,
but as we move towards CPU design, the same principles of state machines
apply. The digital logic to compute each state and the number of states (and
outputs) will increase, but the basic building blocks are clear




