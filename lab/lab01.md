# SPIM Lab

## Part 0: Pre-lab -- due at the start of class Jan 30

1. Read the entirety of this lab carefully
2. Read the QtSPIM Overview and [additional resources](/rsc/spim)
3. Execute a sample program simple-spim.asm
4. Create and turn-in: Use a drawing tool or Microsoft Word or a simple text
   file or etc. to construct pseudocode OR a flow chart for the “Program objective”
   for parts 1-2 described below. This can be at a high-level – you shouldn't
   need more than 10-20 lines of "pseudocode" (does NOT need to be actual MIPS
   code – just describe the key steps using words, math, or instructions). Print
   two copies – one to turn in and one to use in lab.
   
## Program Objective for Parts 1 & 2

Write a program that first prints your name and lab identification in a "welcome
message" to the console, followed by a newline. The program then prompts the
user for a number, adds 5 to the original number, adds the number to itself, and
multiplies the original number by 8. Your program will output each answer
individually, with text preceding the answer, such as "x+5 is", "8*x is",
etc. Each line of output must appear on a separate line. To perform
multiplication: this can be done in a single instruction that you should have
seen while reading the textbook, but there are several ways to accomplish this.

```
Welcome to MIDN Smith's lab #1
Please enter the x:12
x + 5 is 17
x + x is 24
8 * x is 96
Thank you for using Midn. Smith's Lab #1
```

## Part 1: Getting started with SPIM (do this in lab)

Go to the URL in Part 0, and follow the instructions in the "PCSpim-HowTo: Installing and Starting SPIM" document. Look carefully at and step through (using F10) the sample program (this is a longer program that reads two numbers as input, not the same program demonstrated in class).

## Part 2: Simple Program

Write an `asm` file that implements the program above.

Tips:

* Your program must be commented! So add comments as you go.
* Understand the sample program discussed above. It is probably easiest if you
  start with that sample program and modify it slowly to do what you want.
* Tackle and test one part at a time – don’t write the whole program before you
  try running it in SPIM.
* Do NOT try to edit your program from within QtSpim. Instead, edit it with
  Crimson Editor or a similar program. Keep this program open while you run
  QtSpim.
* Don’t forget to reload your program into QtSpim after you make changes (File
  menu → Reinitialize and Load File)

## Part 3: Interactive Program

Suggestion — save a backup copy of part 2's program before you begin part 3.

At the beginning of your program, ask the user how many times he would like to
repeat the program (call this ‘N’ times). Then, N times, ask for an x and do the
calculations and output. However, you should only print the welcome and farewell
message once. Turn in only one copy of your program (the improved, Part 3,
version).

## Deliverables

This lab is due Feb 1st

On the submission system: 
 - upload your .asm file from part 3

In class/hardcopy, stapled together:
  - [Lab cover-page](https://github.com/adamaviv/ic220-s19/blob/master/rsc/lab_coversheet.pdf)
  - Printout of your part 3 .asm file using codeprint (or equivalent)
  - **Three** screenshot of your code executing for N=3
    - x=12
    - x=17
    - x=20
