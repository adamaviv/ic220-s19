# Arithmetic Logic and Data Representation

    Readings: Chapter  2.4, 3.1-3.4, (skim 3.5), pgs. 259-262

> These unit notes are **not** designed to replace readings from the book! They
> are to provide structure to material covered in class and provide you an
> outline for using the book. **You are still required to do the course
> readings** in which you will find much more detail, and those details will be
> evaluated in quizzes, homework, and exams.


## What is data?

Consider the bit sequence:

```

  0100 1111 0110 0001 0111 0110 0111 1001 

```

What does this data represent? It is a 32-bit number, so we can interpret as
such. It's the number 1,331,787,385, or we can write it out as the series of hex
values: 0x4f, 0x61, 0x76, 0x79. If we interpret this a little-endian encoding,
then it's the number 0x7976614f, which is 2,037,801,295. 

But, we can also interpret this is an array of chars. Look at the ascii-table

![ascii-table](http://www.asciitable.com/index/asciifull.gif)

We find that this series of bits is "Navy."

Data is the bits, but it's how we interpret it and the encoding that
matters. In this unit, we will explore different arithmetic encoding of data,
how to manipulate (e.g., add/sub/mul) those encoding using Boolean logic, and
how this is accomplished as part of the CPU. 

## Integer Numeric Representations

As shown, bits by themselves have no inherit meaning. It's up to us to interpret
them based on an agreed upon convention. We should already have a pretty good
sense of how to represent positive numbers in binary, or better, how to
interpret binary as positive numbers.

To keep it simple, let's assume we are only working with 4-bit numbers. Then we
can easily interpret the following values as:

```
binary  decimal    binary    decimal
0000     0          1000      8
0001     1          1001      9
0010     2          1010      10
0011     3          1011      11
0100     4          1100      12
0101     5          1101      13
0110     6          1110      14
0111     7          1111      15
```

This make sense. With 4-bits, we can represent 16 values, counting from
0-to-15. We described this as our **unsigned** interpretation. But, what if we
wanted to have a negative representation?

### Sign and Magnitude

We have a few choices. The most natural choice is to use the leading bit as a
parity bit, indicating if the value is positive or negative. This representation
is called **sign and magnitude**, leading to the following table:


```
binary  decimal    binary    decimal
0000     0          1000      -0
0001     1          1001      -1
0010     2          1010      -2
0011     3          1011      -3
0100     4          1100      -4
0101     5          1101      -5
0110     6          1110      -6
0111     7          1111      -7
```

In some sense, this representation is nice in the sense that if you add to
positive numbers together, you get the normal binary addition. For example,

```
 2   +  1   =   3
0010 + 0001 = 0011
```

But the same is NOT true if we add to negative numbers together


```
 -2   +  -1   = 3   <--- !?!
1010 + 1001  = 0011
```

Why is that? If we line this up using long addition, we see that we loose the
carry of the last addition.

```
    1010
 +  1001
 --------
  1(0011)
  ^
  '--- this carry bit is lost b/c only 4-bit numbers!
```

Thus the addition of two negative numbers under sign and magnitude do create a
*more* negative number, as we would hope.


### One's Compliment

Another representation of negative numbers is to keep the notion of the leading
bit parity by inverting (flipping 0's to 1's, and vice-versa). Our table would
like the following


```
binary  decimal    binary    decimal
0000     0          1000      -7
0001     1          1001      -6
0010     2          1010      -5
0011     3          1011      -4
0100     4          1100      -3
0101     5          1101      -2
0110     6          1110      -1
0111     7          1111      -0
```



This may seem bizzare at first, but it actually has a few advantages. For one,
inverting bits is cheap and fast on computers. Also, when you add a postive to a
negative number, and the result is negative, things work out pretty well.


```
   1   +  -4  =  -3
  0001 + 1011 = 1100


   3   +  -3  =  -0 (but that's also a zero)
  0011 + 1100 = 1111   
```

But there are some additions where this fails:


```
  5   +  -2   =  2
 0101 +  1101 = 0010
 
    1<-- carry
    0101
 +  1101
 --------
  1(0010)
  ^
  '--- bit lost due to 4-bit numbers

 -3  +  -1   =  -1
 1100 + 1110  = 1110
   
    1 <-- cary
    1100
 +  1110
 -------
  1(1110)
  ^
  '--- bit lost due to 4-bit numbers
```


Further, 0 is a bit weird. There are two of them! All in all, one's compliment
is getting us closer, and of course we can design our adder units to handle
these cases, but it would be greater if there was another representation that 



### Two's Complement

At first, this encoding seems odd, but it has a lot of advantages. The idea is
to do the **one's complement inversion and then add 1 to that** to get the
negation.

So for example, -2 is

```

 -(  2   )
 -( 0010 ) = 1101 + 1 = 1110 
```

This even works in reverse

```
 -(-2)
 -(1110) = 0001 + 1 = 00010
```


And, in the table, we could also see this as shifting the interpretation more
negative by one.

```
binary  decimal    binary    decimal   
0000     0          1000      -8       
0001     1          1001      -7       
0010     2          1010      -6       
0011     3          1011      -5     
0100     4          1100      -4     
0101     5          1101      -3     
0110     6          1110      -2     
0111     7          1111      -1     
```

The advantage of this representation slowly start to be come clear when you
start adding values together. For example, 

```

  2   +  -2   =  0
 0010 + 1110  = 0000 
 
   11  <-- carry bits
   0010
 + 1110
 ------
 1(0000)


  -2    +  -1     -3
 1110     1111 =  1101
  
   11  <-- carry bits
   1110
 + 1111
 ------
 1(1101)
 
 
   3   +  -4   =  -1
 0011  + 1100  = 1111


   0011
 + 1100
 ------
  (1111)
 
```

The two's compliment has the nice property that if there is a n-bit
representation, then a number `x` and its negation `~x` is defined by the
formula below. (This is also where ther name "two's complement" comes from.)

```
2^n - x = ~x

x + ~x = 2^n
```

So, if we were to define the number -2 using 4-bit, two's complement, we would have

```
 16   -  2   =  14 (unisgned)
 
10000 - 0010 = 1110 (binary)

 0    -  2   =  -2  (two's complement)
 
```

The reason in the above formula we can treat 16 as 0, is that we cannot
represent 16 in 4-bits, so we would loose the most significant bit, becoming 0000
or 0.

## Overflow

Even with two's complement representation of negative numbers, we still have
some issues due to overflow. Overflow occurs when we add numbers together that
affect the parity bit, the leading bit that dictates if a binary number is
positive or negative.

For example, consider adding the following positive 4-bit numbers together under
two's complement:


```
    0101 (5)
 +  0100 (4)
 -------  
    1001 (-7)
    ^
    '--- overflow causes it to go negative! 
```

In this case, since 5+4 = 9 (unsigned), but 9 (unsigned) in two's complement is
-7, we end up with an incorrect result. We describe this as **overflow**. The
positive addition overflows into the parity bit, making the result negative.

**Overflow is a real and pervasive bug in programming!** It can cause all sorts
of mischievous and security vulnerabilities, and in a lot of architectures,
rather than allowing overflow, this causes an exception and an error. So
detecting overflow is important.

Overflow can occur both in a positive and negative direction. For example,
consider the following addition:



```
      1<-- cary
    1001 (-7)
 +  1101 (-3)
 -----------
  1(0110) (6)
```

How can we detect overflow? Consider the different cases for positive and negative addition:

1. positive + positive = positive
2. positive + negative = positive or negative
3. negative + negative = negative

In case (1) and (3) we can have overflow. When adding two positive numbers, if
something becomes too positive causing the parity bit to flip from 0-to-1,
that's an overflow. Similar, adding two negative numbers, can become too
negative, causing the parity bit to flip form 1-to-0. Case (2) can never cause
overflow because for all additions of positive numbers and negative numbers, it
will always stay in the range.

These cases give us a mechanisms for detection just based on the parity bit, the
leading bit that determines the sign.

1. if 0 and 0, then after add it should still be 0
2. if 1 and 1, then after add it should still be 1
3. if 0 and 1 (or 1 and 0), then after add it could be either -- no overflow
   possible.
   

## Subtraction with Two's Complement

Now that we have a good sense of addition, let's turn our attention to
subtraction. Fortunately, this is EASY! That's because subtraction is the same
as addition where the second term is negated. And, we know how to do negation
under two's complement.

For example, consider

```
                   1
    0101 (5)       0101 (5)
 -  0100 (4)  =  + 1100 (-4)
 -----------     -----------
                 1(0001) (1)
```

But, in the same way we can have overflow with addition, we can also overflow
with subtraction once we do the inversion and convert the subtraction into
addition.

## Sign Extension 

The prior examples were in 4 bits, but what if we want to take a two's
complement 4-bit number and store it in 8-bits? That is, we want to preserve
it's meaning when we extend the number of bits.

If we had a positive number, this is relatively straight forward.

```
0101 (5) -> 0000 0101 (5)
```

But if we do this for a negative number, it doesn't quite work

```
1011 (-5) -> 0000 1011 (11) !?!?
```

That's because the parity bit, the leading bit, needs to also translate to the
larger bit space. However, we can't just naively flip it. For example,


```
1011 (-5) -> 1000 1011 =
           -(0111 0100 + 1) = -(01110101) = -117 
```

Consider that in two's complement, when a value is negative, leading bits are 1
for larger negative values (values closer to 0). So for the example above, -5 is 

```
-5 = -(0000 0101) = 1111 1010 + 1 = 1111 1011
```

Since 5 is small, it has a lot of leading 0's. When inverted, those leading 0's
become 1's. Thus to do **sign extension** where if the value is negative, we add
1's to the front for each extension, instead of 0's.

```
1011 (-5) -> 1111 10111
```

Taking this further, since MIPS uses 32-bit values, if you have a smaller 8-bit
negative value (a `char`), this can get cast to 32-bit negative value via a sign
extension.

In MIPS there are some operations that will do the sign extension and some that
are unisgned. We've been using the signed version, but if we want to **not**
sign extend, there are *unsigned* version of most arithmetic operations:

* `add` vs. `addu`
* `addi` vs. `addiu`
* `slt` vs. `sltu`

and etc. When you are programming or thinking about data representation, you
have to be aware of the sign and how that affects operations. You may get a
result that is totally unexpected if you don't.


## Adding as Digital Logic

### Adding two, one-bits together w/carry

With a better sense of data representation, let's turn our attention to how we
perform addition (and subtraction) in digital logic. To begin, let's consider
adding two, one-bit numbers.

```
A + B = x
```

where A and B are one bis, leads to the following truth table

| A | B | x |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |


All these cases should be clear, 0+0=0, 0+1=1, 1+0=1, but 1+1=0! That's because
of **carry** 1+1=10 (2), but we are doing 1-bit addition, so the carry bit is
lost. This means 1+1=0, but we also want to keep track of the carry bit and know
when it occurs.

Solving for this truth table, it becomes clear that this is the formula for

![AxorB](https://latex.codecogs.com/gif.latex?%5Coverline%7BA%7DB%20&plus;%20A%5Coverline%7BB%7D%20%3D%20A%20%5Coplus%20B)

That is, addition is the XOR operator. And, we can also find the operator for
the carry bit: that occurs when over both A **and** B are 1. The circuit for
addition, in one-bit, is simply:

![one-bit-adder](/imgs/arithmetic/one-bit-adder.png)


### Adding three, one-bits together w/carry

Taking this forward, let's consider adding *three* one-bit values. In this truth
table, `x0` is the 0-bit of the result, and `x1` is the 1-bit (higher order bit of
the result).


| `A` | `B` | `C` | `x1` | `x0` |
|-----|-----|-----|------|------|
| 0   | 0   | 0   | 0    | 0    |
| 0   | 0   | 1   | 0    | 1    |
| 0   | 1   | 0   | 0    | 1    |
| 0   | 1   | 1   | 1    | 0    |
| 1   | 0   | 0   | 0    | 1    |
| 1   | 0   | 1   | 1    | 0    |
| 1   | 1   | 0   | 1    | 0    |
| 1   | 1   | 1   | 1    | 1    |


With three bits of input, our output can be the two bits (`x1`,`x0`) of 00, 01, 10,
and 11. Since we are doing one-bit math, the x1 bit becomes our carry bit. 

Can we write a formula for three bit add, with a carry? Treating this like our
state-machine, we can build two k-maps for this calculation.

Consider that `x0` is one whenever the sum is 11 or 01. That occurs whenever one
of OR all of `A`, `B` or `C` is true/1.

```
x0 = ABC + !A!BC + !AB!C + A!B!C
```

But we can use the properties of XOR to make this a bit simpler. 

```
x0 = (A (+) B (+) C)
```

We can see the equivalency via a truth table


| `A` | `B` | `C` | `y=A (+) B` | `x0=y (+) C` | `x0` |
|-----|-----|-----|-------------|--------------|------|
| 0   | 0   | 0   | 0           | 0            | 0    |
| 0   | 0   | 1   | 0           | 1            | 1    |
| 0   | 1   | 0   | 1           | 1            | 1    |
| 0   | 1   | 1   | 1           | 0            | 0    |
| 1   | 0   | 0   | 1           | 1            | 1    |
| 1   | 0   | 1   | 1           | 0            | 0    |
| 1   | 1   | 0   | 0           | 0            | 0    |
| 1   | 1   | 1   | 0           | 1            | 1    |


To determine `x1`, the carry bit of our adder, we have the following truth table
to solve:


| `A` | `B` | `C` | `x1`  |
|-----|-----|-----|-------|
| 0   | 0   | 0   | 0     |
| 0   | 0   | 1   | 0     |
| 0   | 1   | 0   | 0     |
| 0   | 1   | 1   | 1     |
| 1   | 0   | 0   | 0     |
| 1   | 0   | 1   | 1     |
| 1   | 1   | 0   | 1     |
| 1   | 1   | 1   | 1     |


Converting this to a K-map we find

|      | `!B!C` | `!BC` | `BC` | `B!C` |
|------|--------|-------|------|-------|
| `!A` | 0      | 0     | 1    | 0     |
| `A`  | 0      | 1     | 1    | 1     |

From this we can reduce to:

```
   x1 = BC + AC + AB 
```

Using these two formulae we can produce the following, three-way, one-bit adder
with a carry.

![one-bit-three-way-adder](/imgs/arithmetic/one-bit-three-way-adder.png)

### Four-Bit Addition

With our three-way, one-bit adder, we can do arbitrary bit addition by
duplicating the circuit and tracking caries. Let's look at the some different ways we
can add two bits together

```

          1      1   11  <-- one-bit carries
  00  01  01  10  10  11
+ 00  00  01  01  10  11 
-----------------------------
  00  01  10  11 100 110
                 ^   ^
                 |   |
                 '---'--- two-bit carries
```

The operation is simply applying our three-wide, one-bit adder, to each bit in
the two-bit output, with the carry. This gives us the following circuit. 

![twor-bit-adder](/imgs/arithmetic/two-bit-adder.png)

With this circuit in mind, we can just simplify it to an "adder" circuit. For
example, this circuit is built into LogiSim. 

![twor-bit-adder-built-in](/imgs/arithmetic/two-bit-adder-built-in.png)

And we can also imagine expanding it to arbitrary bit-widths, just by adding in
more smaller adder circuits.

## Arithmetic Logic Unit

With an understanding of the addition circuit, we can now imagine and build
different circuits for the basic arithmetic circuits. In the CPU, these are
combined into a single logic circuit described at the ALU or **Arithmetic Logic
Unit**. 

An ALU, typically drawn as concave trapezoids, with the following inputs and outputs (please excuse my bad ascii art)

```
       ALU Operation
       |
       v
      .--.
  a-> |   \
      |    \ 
      '     \
       \     |-> overflow
       /     |-> result
      '     /
      |    /
  b-> |   / 
      '../
        |
        v
        carry out
      
```


The ALU operations are 4-bit values:

* 0000: AND
* 0001: OR
* 0010: ADD
* 0110: Subtract
* 0111: Set Less Than
* 1100: NOR

And the ALU can come in 32-bit and 64-bit varieties. So given a 32-bit (or
64-bit) `a` and `b`, it will compute the 32-bit (or 64-bit) `result` based on
the 4-bit `operation` input, indicate if `overflow` occurred and if there is a
`carry out`.

This handy bit of circuitry forms the bases for other kinds of operators, like
multiplication and division.

## Multiplication 

Multiplication is addition, but repeated. For example, recall that 4*6 means we
add 4 6-times. We can use that logical understanding to build up a
multiplication circuit using ALUs.

Consider long, multiplication ... in decimal. You may have been taught the
following method to solve this by hand


```
               2          1
     214      214        214
  x   36  = x   6   +  x  30
  ------    -----       ----
    1294     1294       6420 
  + 6420
  ------
    7714
```

That is, we can break up multiplication based on the digit placement, producing
a sum of two multiplications.

```
214*36 = 214*(30+6) = 214*30 + 214*6
  
```

Let's take the same idea to binary. Consider multiplying the two, unsigned numbers

```
      0010  = 2
   x  1011  = 11
   -------  
      0010  (   1 * 0010)  = 2
     00100  (  10 * 0010)  = 4
    000000  ( 000 * 0010)  = 0
+  0010000  (1000 * 0010)  = 16
 ---------
  00010110   = 22
```

The second operand `1011` dictates how many times to add the first operand and
to shift. For example, consider rewriting this multiplication using
shifting. 

```
 multiplcand (x)
   |
   v
  0010 * 1011 =  0010*1 << 3 +
           ^     0010*0 << 2 +
           |     0010*1 << 1 +
multiplier-'     0010*1 << 0 =  0010110 <- product (z)
(y)
```

The `<<` operator is left-shift's the left input by the number of the right
input by the number. So `11 << 1` is `110`. Looking down the operators input, we
can see that the multipier's bits shows up in the final summation. 

Thinking this through, we can follow multiplication as an algorithm (or state
machine) that builds on an ALU.

![mult-flow-chart](/imgs/arithmetic/mult-flow-chart.png "Copyright © 2014 Elsevier Inc. All rights reserved.")






