# Computer Abstraction and Technology

 Readings: Chapter 1 

> These unit notes are **not** design to replace readings from the book! There
> are to provide structure to material covered in class and provide you an
> outline for using the book. **You are still required to do the course
> readings** in which you will find much more detail, and those details will be
> evaluated in quizzes, homework, and exams.

## What we will learn in this class

* How do computers (processors) really work?

* How to analyze performance 

* Issues affecting modern processors (caches, pipelines, wire delay, parallelism,
  power mobile devices)
  
* Constant Tradeoffs: Spped vs. Capacity vs. Cost vs. Power

* Key concepts for improving performance and using parallelism

This is a lot of stuff! One student commented in prior years

> A great deal. One of those classes where you don't realize how much you
> learned- you just come out understanding a lot of things that nobody else
> does.


## What is a Computer and a Computer Processor?

A computer, of course computes, but we also consider computers more broadly. It
not only is composed of its processing unit (which we will focus a lot on in
this class) but also its applications, software, interfaces, storage, and much
more. 


Classically we consider 4 major components of a computer 
1. Input/Output Interface
2. Memory/Storage
3. Datapath 
4. Control

In this class we will touch on all of these components, particularly from the
datapath and control perspecitve. These components reside in the CPU (central
processing unit). Additionally, as both datapath and controls must be stored
somewhere, we will also cover concepts of memory. 

To understand the CPU completely is impossible, so we will need to provide some
abstractions. An *abstraction* helps us reduce complexity by omitting unneeded
details. We've seen abstractions before, such as your intro class, where *how* a
compiler works was not important, other than the fact that it takes high-level
C++ code and outputs executable files. 

Similarly, a CPU is composed of transistors, circuits, gates, cache, and a whole
lot of stuff! We will provide some useful abstracts of how these components work
together to get a larger understanding without loosing ourselves in the details.

## What is Computer Architecture?

We can also break the computer into the following components:

![Computer Components](imgs/computer-architecture.png "Components")

Above the break is the software components, and below the break are machine
components. In the way we can have the same software run on many different kinds
of machines, we have an abstraction that enables re-usability: the instruction
set architecture (ISA).

There are many types of ISA's, x86, spark, powerPC, x86_64, arm, etc. We will
use MIPS which is an ISA specifically designed for education.

The machine organization is also an abstraction. Again, these components are
hardware specific, but we can define them in general terms. 

Combined, the chosen ISA and machine organization abstraction for our notion of
**Computer Architecture**. 


## Moore's Law and Multi Processing

When thinking of the CPU and processing power, the speed of computing has
dramatically increased over time. This exponential increase was identified by
Gordon Moore in 1965 based on the density of transistors. Mapping this to a
log-scale, he predicted that computer processing power would double every 18
months.

![Moore's Curve](imgs/moores-curve.jpg "Moore's Curve")

Looking towards the end of the curve, there is a marked slow down. This is
because the size of transistors is reaching scales where they are loosing
reliability due to quantum effects. Additionally, as CPU get smaller and clock
speeds (the rate instructions are processed) increase, computer draw more and
more power (see book for more details).

To compensate, the community has moved towards mutli-core systems, with multiple
CPU on a single chip. This requires programming and designing for
parallelism. This is hard to do in general, and we will cover a lot of
interesting design challenges later in the semester.


## Where are we headed?

* Unit 1: Computer Abstractions & Technology (Chapter 1)
* Unit 2: A specific instruction set architecture (Chapter 2)
* Unit 3: Performance issues (back to Chapter 1)   
* Unit 4: Logic Design (Appendix C)
* Unit 5: Arithmetic and how to build an ALU (Chapter 3)
* Unit 6: Constructing a processor to execute our instructions (Chapter 4)
* Unit 7: Memory:  caches and virtual memory (Chapter 5)
* Unit 8: I/O (various sections)
* Unit 9: Pipelining to improve performance (more Chapter 4)
* Unit 10: Multiprocessors and advanced topics (Chapter 6)









