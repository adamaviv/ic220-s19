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

## Numeric Representations




