# Digital Logic 

    Readings: Chapter B.1-B.3, B.5, B.7-B.10, B.12

> These unit notes are **not** designed to replace readings from the book! They
> are to provide structure to material covered in class and provide you an
> outline for using the book. **You are still required to do the course
> readings** in which you will find much more detail, and those details will be
> evaluated in quizzes, homework, and exams.

## Digital Logic Basics

In this unit, we will develop a basic understanding of boolean arithmetic and
circuit design, which combined, form the foundation of *digital logic*. Building
from this logic, we will see that the circuit design leads directly to the
computation logic built into processing units, or CPUs. 

In this framework, we consider two states:

* a high asserted signal or true state represented by 1,
* and a low asserted signal or false state represented by 0.

Typically, but not always, high asserted (True) is represented by high voltage
settings, while low asserted (False) is represented by low voltage. We typically
consider these voltages carried over wires and manipulated by gates, but we can
also describe this logic using equations.

Below are the standard boolean logic, both in terms of gates and formulas. In
the formulas, the output value is `x` and the first input value is `A` and the
second input value is `B`. We can also describe a **truth table*, which
describes the output based on the two inputs.

### Not

![not-gate](/imgs/logic/not.png)

![not-equation](https://latex.codecogs.com/gif.latex?x&space;=&space;\overline{A})

| A | x |
|---|---|
| 0 | 1 |
| 1 | 0 |

### And 
![and-gate](/imgs/logic/and.png)

![and-equation](https://latex.codecogs.com/gif.latex?x&space;=&space;A&space;\bullet&space;B=AB)

| A | B | x |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |


### Or

![or-gate](/imgs/logic/or.png)

![or-equation](https://latex.codecogs.com/gif.latex?x&space;=&space;A&space;&plus;&space;B)


| A | B | x |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

### Xor

![xor-gate](/imgs/logic/xor.png)

![xor-equation](https://latex.codecogs.com/gif.latex?x&space;=&space;A&space;\oplus&space;B)


| A | B | x |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

### Nand

![nand-gate](/imgs//logic/nand.png)

![nand-equation](https://latex.codecogs.com/gif.latex?x&space;=&space;\overline{A&space;\bullet&space;B}&space;=&space;\overline{AB})


| A | B | x |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

### Nor

![nor-gate](/imgs/logic/nor.png)

![nor-equation](https://latex.codecogs.com/gif.latex?x&space;=&space;\overline{A&space;&plus;&space;B})

| A | B | x |
|---|---|---|
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 0 |


## More Complex Circuits and Truth Tables

The above examples consider just a single gate in a circuit, but we can express
more complex boolean logic with multiple inputs/outputs using circuits. For
example, the following circuit and its truth table.

![circuit1](/imgs/logic/circuit1.png)

| A | B | C | x | y |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 | 1 |
| 0 | 1 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 1 | 1 |
| 1 | 1 | 1 | 1 | 1 |

We can further describe these results using boolean logic, in two equations

![curuit1 formula](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20x%20%3D%26%20A%20%5Cbullet%20B%20%5C%5C%20y%20%3D%26%20A%20%5Cbullet%20B%20&plus;%20C%20%5Cend%7Balign*%7D)

## Simplifying Not Gates

As not gates have a single input and output, we often will compress them down to
a simple circle on the input to the next gate. For example, the following
circuit.

![not-and](/imgs/logic/not-and.png)



May also be written this way. 

![not-and-collapsed](/imgs/logic/not-and-collapsed.png)


With the following truth table

| A | B | x |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 0 |
| 1 | 1 | 0 |


The same logic of pushing the circles, can be collapsed in the output direction,
which explains the NAND and NOR gates and their truth tables.


![not-and](/imgs/logic/nand.png)

![not-and](/imgs/logic/nor.png)



## Laws of Boolean Logic 

Just like in normal arithmetic/algebra, boolean logic has a set of identities,
properties, and methods of distributing and rearranging factors in
equations. These typically take the form of traditional arithmetic/algebra, but
not always quite the same way.

### Order of Operations

1. Parenthesis
2. Not/Inverse
3. And
4. OR

### Identity Law

![identity law](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20%26%20A%20&plus;%200%20%3D%20A%20%5C%5C%20%26%20A%20%5Cbullet%201%20%3D%20A%20%5Cend%7Balign*%7D)

### Zero and One Law

![zero and one law](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20%26%20A%20&plus;%201%20%3D%201%20%5C%5C%20%26%20A%20%5Cbullet%200%20%3D%200%20%5Cend%7Balign*%7D)

### Inverse Law

![inverse law](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20%26%20A%20&plus;%20%5Coverline%7BA%7D%20%3D%201%20%5C%5C%20%26%20A%20%5Cbullet%20%5Coverline%7BA%7D%3D%200%20%5Cend%7Balign*%7D)

### Commutative Law

![commutative law](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20A%20&plus;%20B%20%26%3D%20B%20&plus;%20A%5C%5C%20A%20%5Cbullet%20B%20%26%3D%20B%20%5Cbullet%20A%20%5Cend%7Balign*%7D)

### Associative Law

![associative law](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20A%20&plus;%20%28B%20&plus;%20C%29%20%26%3D%20%28A&plus;%20B%29%20&plus;%20C%5C%5C%20A%20%5Cbullet%20%28B%20%5Cbullet%20C%29%20%26%3D%20%28A%20%5Cbullet%20B%29%20%5Cbullet%20C%20%5C%5C%20%5Cend%7Balign*%7D)

### Distributive Law

![distributive law](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20A%20%5Cbullet%20%28B%20&plus;%20C%29%20%26%3D%20%28A%20%5Cbullet%20B%29%20&plus;%20%28A%20%5Cbullet%20C%29%5C%5C%20A%20&plus;%20%28B%20%5Cbullet%20C%29%20%26%3D%20%28A%20&plus;%20B%29%20%5Cbullet%20%28A%20&plus;%20C%29%20%5C%5C%20%5Cend%7Balign*%7D)

## DeMorgan's Law 

We also have a very important rule in digital logic **DeMorgan's Law**, which
describes how to distribute the not operator.

![DeMorgan's Law](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20%5Coverline%7BA&plus;B%7D%20%26%3D%20%5Coverline%7BA%7D%20%5Cbullet%20%5Coverline%7BB%7D%5C%5C%20%5Coverline%7BA%20%5Cbullet%20B%7D%20%26%3D%20%5Coverline%7BA%7D%20&plus;%20%5Coverline%7BB%7D%5C%5C%20%5Cend%7Balign*%7D)

Essentially, it flips the operator, from and to or (or in reverse). This allows
us to simplify some of our gate design. For example, consider that the following
AND gate with two inverted inputs

![not-and](/imgs/logic/notted-and.png)

That can be written as the formula

![not-a-or-not-b](https://latex.codecogs.com/gif.latex?%5Coverline%7BA%7D%20%5Cbullet%20%5Coverline%7BB%7D)

And by, DeMorgan's Law, thats the same as

![not-a-or--b](https://latex.codecogs.com/gif.latex?%5Coverline%7BA%20&plus;%20B%7D)

The inverse (notting) of the result of an OR, is the same as a NOR gate.

![not-and](/imgs/logic/nor.png)

And, then using similar logic, the following gate

![not-and](/imgs/logic/notted-or.png)

Is the same as a NAND gate

![not-and](/imgs/logic/nand.png)

## Bubble Pushing

This process of applying DeMorgan's Law to gates is called **bubble pushing**,
and in the two above examples, we were pushing the bubbles from the input side
to the output side by swapping the gate between and/or. But, we can also push
the bubble from the output of a NAND or NOR gate to the next input.

Let's consider the following more complex circuit. 

![bubble0](/imgs/logic/bubble0.png)

Note that we have two inputs that are inverted, and we can then apply DeMorgan's
law to flip the gates and *push the bubble* to the output.

![bubble1](/imgs/logic/bubble1.png)

Continuing, we can push the bubble further from the outputs to the inputs of the
next gate.

![bubble2](/imgs/logic/bubble2.png)

This means we can flip the gate, and push the bubble to the final output,
resulting in the following circuit.

![bubble3](/imgs/logic/bubble3.png)

## 2-Level Logic and Minimization 

Despite the plethora of gate types, it's the case that we really only need two
gates and inversion to express any kind of logical statement: AND, OR, and
NOT. We call this *2-level Logic* because it requires just two gates (assuming
inversion is free). 

What this means is that for any truth table, with a single output and any number
of inputs, we can represent that truth table using a boolean logical expression
of AND, OR, and NOT. There are two canonical forms *sum of products* and
*product of sums*. We will use sum of products. 

For example, consider the following Truth Table

| A | B | C | x |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

We can take each line of the truth table that results in a true output, and just
consider which inputs produce those outputs.

| A | B | C | x |
|---|---|---|---|
| 0 | 0 | 1 | 1 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 1 | 1 |

![eq](https://latex.codecogs.com/gif.latex?%28%5Coverline%7BA%7D%5Cbullet%5Coverline%7BB%7D%5Cbullet%20C%29%20&plus;%20%28A%20%5Cbullet%20%5Coverline%7BB%7D%20%5Cbullet%20%5Coverline%7BC%7D%29%20&plus;%20%28A%20%5Cbullet%20%5Coverline%7BB%7D%20%5Cbullet%20C%29%20&plus;%20%28A%20%5Cbullet%20B%20%5Cbullet%20C%29%20%3D%20x)

The equation above is in canonical form, but it is important to minimize
it. Writing out this circuit would require more gates than we probably need,
costing more money, power, and making the chip more inefficient. 

We can minimize this equation by hand using the some of the rules above, plus
the fact that we can duplicate any values. That's because in boolean logic,
`E+E=E`. It's the same as saying either `E` or `E` is true is equivalent of just
testing if `E` is true.

The minimization precedes by duplicating 

![eq](https://latex.codecogs.com/gif.latex?%28A%20%5Cbullet%20%5Coverline%7BB%7D%20%5Cbullet%20C%29)

twice more, and then rearranging to apply the distributed rule


![eq](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20%28%5Coverline%7BA%7D%5Cbullet%5Coverline%7BB%7D%5Cbullet%20C%29%20&plus;%20%28A%20%5Cbullet%20%5Coverline%7BB%7D%20%5Cbullet%20%5Coverline%7BC%7D%29%20&plus;%20%28A%20%5Cbullet%20%5Coverline%7BB%7D%20%5Cbullet%20C%29%20&plus;%20%28A%20%5Cbullet%20B%20%5Cbullet%20C%29%20%26%3D%20x%20%5C%5C%20%28%28%5Coverline%7BA%7D%5Cbullet%5Coverline%7BB%7D%5Cbullet%20C%29%20&plus;%20%28A%20%5Cbullet%20%5Coverline%7BB%7D%20%5Cbullet%20C%29%29%20&plus;%20%28%28A%20%5Cbullet%20%5Coverline%7BB%7D%20%5Cbullet%20%5Coverline%7BC%7D%29%20&plus;%20%28A%20%5Cbullet%20%5Coverline%7BB%7D%20%5Cbullet%20C%29%29%20&plus;%20%28%28A%20%5Cbullet%20%5Coverline%7BB%7D%20%5Cbullet%20C%29%20&plus;%20%28A%20%5Cbullet%20B%20%5Cbullet%20C%29%29%20%26%3D%20x%20%5C%5C%20%5Coverline%7BB%7D%5Cbullet%20C%20%5Cbullet%28%5Coverline%7BA%7D%20&plus;%20A%20%29%20&plus;%20A%5Cbullet%5Coverline%7BB%7D%5Cbullet%28%5Coverline%7BC%7D%20&plus;%20C%29%20&plus;%20A%5Cbullet%20C%20%5Cbullet%28%5Coverline%7BB%7D%20&plus;%20B%29%29%20%26%3D%20x%20%5C%5C%20%5Coverline%7BB%7D%5Cbullet%20C%20%5Cbullet%281%29%20&plus;%20A%5Cbullet%5Coverline%7BB%7D%5Cbullet%281%29%20&plus;%20A%5Cbullet%20C%20%5Cbullet%281%29%20%26%3D%20x%20%5C%5C%20%5Coverline%7BB%7D%5Cbullet%20C%20&plus;%20A%5Cbullet%5Coverline%7BB%7D%20&plus;%20A%5Cbullet%20C%20%26%3D%20x%20%5C%5C%20%5Cend%7Balign*%7D)

The final formula is

![eq](https://latex.codecogs.com/gif.latex?%5Coverline%7BB%7D%5Cbullet%20C%20&plus;%20A%5Cbullet%5Coverline%7BB%7D%20&plus;%20A%5Cbullet%20C%20%26%3D%20x)

## Karnaugh Maps (K-Maps) 

Minimizing by hand can be cumbersome, but there are more automated ways to do
this. Karnaugh Maps (K-Maps) are one way to do this. It procedes by building a
truth-table with groupings of variables, which helps to minimize the results
when forming a sum of products.

For example, we can rewrite the truth table from above as follows

|            | ![][not-B-not-C] | ![][not-B-C] | ![][B-C]) | ![][B-not-C] |
|------------|------------------|--------------|-----------|--------------|
| ![][A]     | 1                | 0            | 1         | 1            |
| ![][not-A] | 0                | 1            | 0         | 0            |


[not-B-not-C]: https://latex.codecogs.com/gif.latex?%5Coverline%7BB%7D%5Cbullet%5Coverline%7BC%7D
[not-B-C]: https://latex.codecogs.com/gif.latex?%5Coverline%7BB%7D%5Cbullet%20C
[B-C]: https://latex.codecogs.com/gif.latex?B%5Cbullet%20C
[B-not-C]: https://latex.codecogs.com/gif.latex?B%5Cbullet%20%5Coverline%7BC%7D
[A]: https://latex.codecogs.com/gif.latex?A
[not-A]: https://latex.codecogs.com/gif.latex?%5Coverline%7BA%7D
