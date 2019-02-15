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

Data is the bits, but it's how we interpret it and the encodings that
matters. In this unit, we will explore different arithmetic encodings of data,
how to manipulate (e.g., add/sub/mul) those encodings using boolean logic, and
how this is accomplished as part of the CPU. 

## Integer Numeric Representations

As shown, bits by themselves have no inherit meaning. It's up to us to interpret
them based on an agreed upon convention. We shoudld already have a pretty good
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

This make sense. With 4-bits, we can represent 16 values, couting from
0-to-15. We described this as our **unisigned** interpretation. But, what if we
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
to do the one's complement inversion, and then add 1 to that to get the negative
value.

So for example, -2 is

```

 -(  2   )
 -( 0010 ) = 1101 + 1 = 1110 
```

Or, in the table, we shift the interpretation more negative by one. 

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
represent 16 in 4-bits, so we would loose the most signficant bit, becoming 0000
or 0.

## Overflow

Even with two's complement representation of negative numbers, we still have
some issues due to overflow. Overflow occurs when we add numbers together that
affect the parity bit, the leading bit taht dictates if a binary number is
positive or negative.

For example, consider adding the following positive 4-bit numbers together under
two's complement:


```
    0101 (5)
 +  0100 (4)
 -------  
    1001 (-7)
    ^
    '--- overflow! 
```

In this case, since 5+4 = 9 (unsigned), but 9 (unsigned) in two's complement is
-7, we end up with an incorrect result. We describe this as **overflow**. The
positive addition overflows into the parity bit, making the result negative.

**Overflow is a real and pervasive bug in programming!** It can cause all sorts
of mischievous and security vulnerabilities, and in a lot of architectures,
rather than allowing overflow, this causes an exception and an error. So
detecting overflow is important.

Let's consider then the situations in which overflow can occur... it's only when
ever we add two positive numebrs together.







