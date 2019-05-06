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

Why is that? If we line this up using long addition, we see that we lose the
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


### One's Complement

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



This may seem bizarre at first, but it actually has a few advantages. For one,
inverting bits is cheap and fast on computers. Also, when you add a positive to a
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
   
    1 <-- carry
    1100
 +  1110
 -------
  1(1110)
  ^
  '--- bit lost due to 4-bit numbers
```


Further, 0 is a bit weird. There are two of them! All in all, one's complement
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

The advantage of this representation slowly start to become clear when you
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

The two's complement has the nice property that if there is a n-bit
representation, then a number `x` and its negation `~x` is defined by the
formula below. (This is also where the name "two's complement" comes from.)

```
2^n - x = ~x

x + ~x = 2^n
```

So, if we were to define the number -2 using 4-bit, two's complement, we would have

```
 16   -  2   =  14 (unsigned)
 
10000 - 0010 = 1110 (binary)

 0    -  2   =  -2  (two's complement)
 
```

The reason in the above formula we can treat 16 as 0, is that we cannot
represent 16 in 4-bits, so we would lose the most significant bit, becoming 0000
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
      1<-- carry
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
negative, causing the parity bit to flip from 1-to-0. Case (2) can never cause
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
are unsigned. We've been using the signed version, but if we want to **not**
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
 multiplicand (x)
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
can see that the multiplier's bits shows up in the final summation. 

Thinking this through, we can follow multiplication as an algorithm (or state
machine) that builds on an ALU.

![mult-flow-chart](/imgs/arithmetic/mult-flow-chart.png "Copyright © 2014 Elsevier Inc. All rights reserved.")


There's a couple of things you should take away from this process.

1. Multiplication is a less efficient routine than adding because requires at
   least `n` adds and shifts, where `n` is the bit width

2. The output will be `2n` bits in size because we do a shift of `n` bits on a
   `n` bit number.

Both of these points are useful when considering when to use certain
instructions; for example, shifting is cheap, so doing multiplication by 2
should be reserved for the shifting circuit rather than the multiplication
unit. Additionally, we have to consider that the output of a multiplication will
be bigger than the inputs. That last point affects how we program multiplication
in assembly.

(And if you're wondering, division using a similar logic, but with a series of
subtractions instead of additions.)

## Multiplication in MIPS

In the SPIM simulator for MIPS, there's an additional pseudo-instruction,
R-type, for generic multiplication:

```
mul $rd, $rs, $rt	    # Multiply (without overflow)
mulo $rd, $rs, $rt	    # Multiply (with overflow)
mulou $rd, $rs, $rt     # Multiply unsigned (with overflow)
```

And you can happily use these as you would expect, but these are
pseudo-instructions because of the observation (2) above, that the due to the
nature of multiplication, the result is `2n`. MIPS uses 32-bit registers, so how
does these seemingly R-Type registers function?

The real instruction for multiplication in MIPS is `mult` (notice the 't' at the
end.) It takes two registers:

```
mult  $rs, $rt  # multiply $rs and $rt and put result in {hi,lo}
multu $rs, $rt  # multiply (unsigned) $rs and $rt and put result in {hi,lo}
```

Note that there is no destination register (`$rd`), that's because there is no
64-bit registers. Instead, MIPS has a special two 32 bit registers, a `hi`
(high) and `lo` (low) register, that you can't access directly, but get set on
`mult` (and other large operators). 

The `hi` and `lo` register can be retrieved and moved into user variables using
two other instructions

```
mfhi $rd    # move hi into $rd
mflo $rd    # move lo into $rd
```

## Floating Points

We now have a handle on integer values and the operations over them, but we need
to consider floating point values. These are crucial arithmetic units used in
graphics and other operators, but we have to develop a better sense of what
kinds of numbers are represented by "floats"

* Fractions: 3.1416 
* Small numbers: 0.000000001 (or as 1e-10)
* Large numbers: 3.1416e23 (note the 'e` means do the following 3.1417x10^23 )
* Negatives: -1.2 

A 32-bit float is described a single-precision, and a 64-bit float is a double
precision under the IEEE-754 standard, which describes the encoding of floating
points. Of course, with more bits, we can have higher precision, more
significant bits shown.


The IEEE-754  32-bit encoding is as follows

```
   .- sign (1 bit)                     .- fraction (23 bits)
   v                                   v 
  .---------------------------------------------------------------------.
b | 0 | 0 1 1 1 1 1 1 0 | 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 |
  '---------------------------------------------------------------------'
   31  30             23 22                                           0  <-bit numbers, b[i]
           ^                                                               where i between [0..31]
           '- exponent (8-bit) (sometimes referred to as simply e
```

The value of this floating point number is:

```
 sign--.                             .-- base 2, but on other side of decimal point
       v                             v
  (-1)^b[31] *  2^( e - 01111111) * 1.b[22]b[21]...[b0]
                           ^
                           '-- 127 in base 2
```

Converting the number above, we have 0 in the sign bit so, `-1^b[31]` is 1 (x^0
is defined as 1). 

The exponent (e) is 01111110 in binary, or 126. When we subtract 127 (or
01111111 in binary) gives us, -00000001, or simply -1.

The fraction part, to the right of the decimal point, we need to consider how
positional numbers work to the left. In base 10, the number

```
  342 = 3 * 10^2 + 4*10^1 + 2*10^0
```

If we add in a decimal, we get

```
  3.42 = 3*10^0 + 4*10^-1 + 2*10^-2
```

So moving to the right of the decimal point moves the exponent in the base
conversion negative. So the number from above, in binary

```
 f = 1.0100000000000000000000
   = 1 + 0*2^-1 + 1*2^-2 + 0*2^-3 ...
   = 1 + 2^-2 = 1+1/4
   = 1.25 (base 10)
```

Putting it all together, we have


```
   = 1 * 2^-1 * (1+2^-2)
   = 2^-1 * (1+2^-2)
   = 2^-1 + 2^-1 * 2^-2
   = 2^-1 + 2^-3
   = .5 + .125
   = .625
```

### Conversion Examples

Let's try and go the other direction. Suppose we wish to describe the number
2.25 in floating point, what would it's encoding be? To start, consider that we
can encode the left and right side of the decimal in binary

```
 2.25 = 2 + .25
      = 2 + (2^-2)
      = 10.01
      = 2^1 * 1.001 (shift the decimal!)
``` 

We need the exponent to be 128 so that e=128-127=1, and we have the remaining
bits, leading to the following layout.

```
  .---------------------------------------------------------------------.
b | 0 | 1 0 0 0 0 0 0 0 | 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 |
  '---------------------------------------------------------------------'
```
  
Here's another example, this time with 14.5, but using a slight different
technique. Instead, we consider how many times we need to divided by 2 to get a
format with leading 1 in the decimal.

```
14.5 = 2 * 7.25
      = 2 * 2 * 3.625
      = 2 * 2 * 2 * 1.8125
      = 2^3  * (1 + .8125)
```

Now we need to find a binary fraction that matches 0.8125. To do that let's look
at the negative values of base 2.

```
2^-1 = .5
2^-2 = .25
2^-3 = .125
2^-4 = .0625
...
```

If we add up 2^-1 and 2^-2 we get `.75` and if we add `2^3` we get `.875` which
is higher than `.775`. But, if we add in 2^4 (`.8125`). So the encoding of 14.5
is:

```
  2^3 * (1.1101)
  
  .---------------------------------------------------------------------.
b | 0 | 1 0 0 0 0 0 1 0 | 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 |
  '---------------------------------------------------------------------'
         ^
         '-- 130 (-127 = 3)
```

And finally, here's yet another example, this time with a negative number, but
using the first technique. 

```
 -9.75 =   -1 * (   9    +    .75  )
       =   -1 * (   9    +   .5 + .25)
       =   -1 * (  1001  +   0.11)
       =  -1001.11 (binary)
```

Let's rearrange this so there is a leading 1 on the left of the decimal point

``` 
      =  -1001.11
      =  -100.111 * 2^1
      =  -10.0111 * 2^2
      =  -1.00111 * 2^3
```

Now we have all the parts to do our encoding. We need e=130 so that 130-127=3,
and we know the placement of the remaining bits.


```
   -1 * 2^23 * (1.00111)
  
  .---------------------------------------------------------------------.
b | 1 | 1 0 0 0 0 0 1 0 | 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 |
  '---------------------------------------------------------------------'
         ^
         '-- 130 (-127 = 3)
```

### Special Cases

There are few special cases of floating point representations. First consider
representing 0. This cannot be done directly because the formula for floating
points is: `-1^s 2^(e-127) * (1.f)` where `s` is the sign-bit, `e` is the
exponent, and `f` is the fraction. There is no direct way for us to get a 0 in
that formula because the exponentiation cannot produce a 0 and the fraction
always has a leading 1. This is the normalized form of single-precision floating
point.

To accommodate some special cases. The IEEE 754 standard allows for a
*denormalized* form where the exponent bits are all 0. This special cases alters
the equation to:

```
 -1^s * 2^-126 0.f
```

Note that there is no longer a leading. This allows for the precision to reach
even smaller fractional numbers. 

Now, to represent 0, we have a special case of the denormalized form where all
the fractional bits are also 0. Essentially, all 0's are 0. Weirdly, in floating
point, we can also have a -0 if the sign bit is 1. These are typically
determined to represent the same thing and should be evaluated to false and
equal each other.

Floating point can also represent +inf and -inf, although this is not true
infinity, of course. These are used to represent values that go outside of the
range of precision. Infinity occurs when all the exponents bits are 1 and all
the fraction bits are 0. The sign of the infinity is determined by the fraction bit. 

Finally, floating points have a Not-a-Number (NaN) representation, which can
occur when math occurs that doesn't represent a real number. NaNs are symbolized
by all the exponents bits set to 1 and at  non zero fraction. 
 


### Floating Points and Accuracy

Floating points can be quite complex for processors. For example, operators will
be quite a bit more complicated (see below), but also we have issues of
precision. There are some decimal numbers that are not well represented by
fractions of powers of 2, so we have to do some rounding. There are also some
really large numbers (and small ones), so we can have notions of "inf" (see
above) --- but not really infinity. In general, this is tricky, but incredibly
useful.

## Floating Points in MIPS

*Note that these notes below assume instructions in the SPIM simulator that may
not be available strictly in MIPS as described in the book. You should use these
version, which are more expressive, than the strict MIPS version found in the
book*

MIPS implements double-precision floating points. There are 32 floating point
registers, $f0...$f31, and to get double-precision, they are used in pairs,
($f0,$f1), ($f2,$f3), ... ($f30,$f31). We typically use the even register value
for the name. (Note that $f0 is not always zero!)

For function passing, we use $f12,$f14, etc. to pass floating point values, and
$f0 to return a floating point value. We still use $a0..$a3 for passing
non-floating point values, such as addresses of arrays and numbers.

For loading and storing, we have both single and double precision version. Below
are the single precision loads and stores.

```
lwc1  $f2, 4($sp)  # load from stack, offset 4, into $f2 (single precision)
swc1  $f4, 0($t0)  # store to address in $t0, offset 0, $f4 (single precision)

ldc1  $f2, 4($sp)  # load from stack, offset 4, into $f2,$f3 (double precision)
sdc1  $f4, 0($t0)  # store to address in $t0, offset 0, $f4,$f5 (double precision)

```

For arithmetic operations, we also have single and double precision, 

```
add.s $f1, $f2, $f4   #single precision
mul.s $f2, $f0, $f6
div.s $f4, $f8, $f2 

add.d $f1, $f2, $f4   #double precision
mul.d $f2, $f0, $f6
div.d $f4, $f8, $f2 
```

We also have similar notation for comparisons (change s to d for double precision)

```
c.eq.s $f2, $f4  # set on equality (single precision)
c.lt.s $f2, $f4  # set less than (single precision)
c.gt.s $f2, $f4  # set greater than (single precision)
c.ge.s $f2, $f4  # set greater than or equal (single precision)
c.le.s $f2, $f4  # set less than or equal (single precision)
```

You may notice that there is no label, instead, a flag is set that you can test
directly with the following instructions:

```
bc1t label   #branch if previous comparison true
bc1f label   #branch if previous comparison false
```

Dealing with floating constants in MIPS can be a bit cumbersome, so in the SPIM
simulator, we can use the following pseudo-instructions

```
li.s $f0, <const>  #load immediate single-precision float
li.d $f2, <const>  #load immediate double-precision float
```

And, we can also do some conversion between floats and integers to get
constants. For example, to produce a zero float, we can do the following

```
li      $t0, 32     #load 32 into #t0
mtc1    $t0, $f0    #move the 32 in $f0 (but is not technically floating point yet)
cvt.w.s $f2, $f0    #covert $f0 into floating point, store in f2 
```

Finally, we have the ability to move between registers

```
mov.s $f0, $f2   #load $f0 with the value from $f2 (single)
mov.d $f0, $f2   #load $f0 with the value from $f2 (double)
```

### Programming Examples 

Let's do a few example, we can assume single precision. Convert the following C-style code into MIPS

```
// set the array to the new value, returning the old
float setArray(float F[], int index, float val){
   float old = F[index];
   F[index] = val;
   return old;
}

```

First, the non-float arguments are passed using `$a0` (F) and `$a1` (index) ,
and the float arguments are passed using `$f12`.

```
setArray:
    sll $t0,$a1,4      # calculate offset in bytes
    add $t0,$a1,$t0    # add it to the base (F+4*i)
    lwc1 $f0, 0($t0)   # old =  F[i]
    swc1 $f12, 0($t0)  # F[i] = val
    jr $ra             # return

```


Here's one more example

```
float max(float A, Float B){
   if (A >= B) return A;
   else return B;
}
```

This time the single-precision floating arguments are passed in using `$f12` and
`$f14` per convention.

```
max:
   li.s $f0,0.0         # initialize to zer0
   c.ge.s $f12,$f14     # A>=B
   bc1f else            # jump to else if false
   add.s $f0, $f0, $f12 # move $f12 into $f0
   j exit
else:
   add.s $f0, $f0, $f14 # set $f13 into $f0
exit:
   jr $ra
```



