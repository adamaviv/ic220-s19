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

| A | B | C | x | Y |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 | 1 |
| 0 | 1 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 1 | 1 |
| 1 | 1 | 1 | 1 | 1 |


## Laws of Boolean Logic 

Just like in normal arithmetic/algebra, boolean logic has a set of identities,
properties, and methods of distributing and rearranging factors in
equations. These typically take the form of traditional arithmetic/algebra, but
not always quite the same way.

### Identity Law

![identity law](https://latex.codecogs.com/gif.latex?A&space;&plus;&space;0&space;=&space;A&space;\quad&space;A&space;\bullet&space;1&space;=&space;A)

### Zero and One Law

![zero and one law](https://latex.codecogs.com/gif.latex?A&space;&plus;&space;1&space;=&space;1&space;\quad&space;A&space;\bullet&space;0&space;=&space;0)

### Inverse Law

![inverse law](https://latex.codecogs.com/gif.latex?A&space;&plus;&space;\overline{A}&space;=&space;1&space;\quad&space;A&space;\bullet&space;\overline{A}&space;=&space;0)

### Commutative Law

![commutative law](https://latex.codecogs.com/gif.latex?A&space;&plus;&space;B&space;=&space;B&space;&plus;&space;A&space;\quad&space;A&space;\bullet&space;B&space;=&space;B&space;\bullet&space;A)

### Associative Law

![associative law](https://latex.codecogs.com/gif.latex?\begin{align*}&space;A&space;&plus;&space;(B&space;&plus;C)&space;&=&space;(A&plus;B)&space;&plus;&space;C&space;\\&space;A&space;\bullet(B&space;\bullet&space;C)&space;&=&space;(A&space;\bullet&space;B)&space;\bullet&space;C&space;\end{align*})

### Distributive Law

![distributive law](https://latex.codecogs.com/gif.latex?\begin{align*}&space;A&space;\bullet&space;(B&space;&plus;C)&space;&=&space;(A\bullet&space;B)&space;&plus;&space;(A\bullet&space;C)&space;\\&space;A&space;&plus;&space;(B&space;\bullet&space;C)&space;&=&space;(A&space;&plus;&space;B)&space;\bullet&space;(A&space;&plus;&space;C)&space;\end{align*})

### DeMorgan's Law

![DeMorgan's Law](https://latex.codecogs.com/gif.latex?\begin{align*}&space;\overline{A&plus;B}&space;=&space;\overline{A}&space;\bullet&space;\overline{B}\\&space;\overline{A&space;\bullet&space;B}&space;=&space;\overline{A}&space;&plus;&space;\overline{B}&space;\end{align*})
