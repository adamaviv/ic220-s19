# Project 2: Donut Dilemma

(Note: to download .circ files, view them in "raw" format, then save as, and
remove the .txt extension)

## The Mysterious Benefactor ...

A Mysterious Benefactor (M.B.) has heard that you are now an expert in designing
important logic circuits and has requested your help to construct the important
"Donut Bonus Machine".

**Your task**: The M.B., apparently a donut manufacturer of some kind, has
decided to launch a new *Customer Appreciation Month.* During this promotion:

* The M.B. will install a display above the cash register, showing a number
  between 0 and 12. However, a 0 (zero) is only displayed (by the "machine" you
  will build) when the machine is first turned on (or reset).
     
* Every time a customer makes a purchase, an employee will press the “CLOCK”
  button, which will cause a new number (call this "D") to appear on the display
  (the new number will always be between 1 and 12).
     
* The lucky customer will then receive "D" donuts free!

* Every number (between 1 and 12) will appear on the display exactly once, in
  some fixed order, before the whole sequence repeats.

* The benefactor owns many donut stores. Each store’s machine will use a
  different sequence of numbers.

* Each midshipman is to be assigned to one particular store. Your alpha will
  determine the specific sequence that you must generate.


## Simpler Examples

### Two Bit Donut Sequence

Consider the Logisim file for a [two-bit donut sequence](/proj/02/ex-two-bit-seq.circ). Video below

![](/proj/02/ex-two-bit-seq.gif)

This sequence cycles through 0, 2, 1, 3, 0, ... for each cycle of the clock
button. You can reset the counter back to 0 by hitting the reset button. Note
that `Q_1` is the higher order bit and `Q_0` is the lower order bit.


### Four Bit Donut Sequence

Now for a slightly larger example for [four-bit donut sequence](/proj/02/ex-four-bit-seq.circ). Video below

![](/proj/02/ex-four-bit-seq.gif)

This sequence uses some new logisim tech, a hex display and a splitter, that
takes the four-bit sequence plugging it into the hex-display. However, the
nature of this circuit and the two-bit one are pretty much the same, except for
a more complex logic dictating the sequence and four D-flip-flops to store the
current 4-bit state.

The sequence of this four bit counter is 1, 5, b, 4, 3, a, c, 7, 8, 6, 9, 2, 1,
... The counter is only zero when the reset pin is hit. Note that `Q3`,`Q2`,`Q1`
and `Q0` display the bit values (most to least significant). The prime values,
`Q3'`, `Q2'`, `Q1'` and `Q0'` display the next state given the current state,
but that is only achieved once the clock is cycled, opening up the D-Flip-Flops. 


## Your Sequence

You will be implementing your own, unique 4-bit Donut sequence for the MB. Use
the following link to get your sequence.

https://www.usna.edu/Users/cs/lmcdowel/courses/ic220/projGen/index.html

Read the instructions for your sequence carefully, and note how *zero is handled*. 

You should proceed by:

1. Creating a *next state* truth table for your sequence based on input values
   `Q3`,`Q2`,`Q1` and `Q0`. You should convert your sequence to binary to make
   this easier!
   
2. Create a K-map *for each* of the output states to create a minimized
   two-level logic. You will need to **turn in this work**, so do it neatly! Be
   sure your circuit is properly minimized.
   
3. Use the [starter-template.circ](/proj/02/proj-template.circ) to start your
   project. Leave all the pin and hex displays in the same place. You will add
   appropriate gates for your sequence.
   
4. Once it is wired up, hit the reset button to clear your flip flops, then
   cycle your clock to test your logic. **Make sure it cycles through ALL the
   required states.**

You should NOT use adders, registers, or other more advanced logisim circuits

You should:
* Label all your inputs and outputs
* Keep the hex display and the four-bit pin displays
* Put your name and date of completion on your circuit


## What to submit

* Digitally, via the submission server: 
  * One file, called `proj02.circ` to the submission server that is the working
    version of your submission with proper labels, including your name and date.
  
* Hard Copy, in class:
  * A properly filled out [project coversheet](/rsc/proj_coversheet.pdf)
  * Your neat next-state truth table and k-map reductions
  * A print out of your circuit from logisim, either via print or export to image
  


