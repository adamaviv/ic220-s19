# LogiSim Lab

There are 4 parts to this lab:

1. Part 0 (pre-lab) : basic AND circuit --- 10 points
2. Part 1: boolean circuit -- 20 points
3. Part 2: Less than circuit -- 30 points 
4. Part 3: 2-bit reverse counter -- 40 points


All parts have a digital and hard copy submission requirement. Use the [lab
coversheet](/rsc/lab_coversheet.pdf) for your hard copy submission. Digital
submission via the submit server.

1. Pre-Lab due on 22 Feb 2019
2. Lab due on 27 Feb 2019

## Part 0: Pre-lab : basic AND circuit

1. Install [logisim](http://www.cburch.com/logisim/index.html) on your machine, either your Windows or Linux VM.  
2. Read the entirety of this lab carefully!

3. Create a well labeled AND circuit, which you will print out and bring to
   class at the start of the lab. 
   
   
### Your first circuit: AND

Logisim is very intuitive circuit drawing and testing tool, but it does require
a bit of practice to get going. If you every need more details, the built in
help guides for Logisim are amazing! But, most of what we will do, will be quite
simple and straightforward.

To start, let's consider building a basic AND circuit.  Open up Logisim, where
you'll see the main drawing pane:

![logisim-init](/imgs/logisim/logisim-init.png)

Along the left bar, there are a many options for different gates and built in
circuits. Feel free to explore some of the items here. You'll see a lot of
familiar items.

![circuit-pane](/imgs/logisim/circuit-pane.png)

And along the top bar, there are some common ones that are easier to access. 

![top-bar](/imgs/logisim/top-bar.png)

This includes pins ![](/imgs/logisim/pins) and NOT, AND, and OR gates
![](/imgs/logis/notandor.png). Since we are building a simple AND circuit, select
the AND gate option from the top bar. Once selected, you can see the outline of
it on the circuit pane, drop it down somewhere in the center portion. 

![and-circ1](/imgs/logisim/and-circ1.png)

You'll notice that the side pane has also changed to highlight options for this
and gate. By default, an AND gate in LogiSim can accept 5 inputs, let's change
it to 2 inputs for the purposes of this circuit.

![and-options](/imgs/logisim/and-options.pn)

Now we can draw the input and output wires by selecting the "pointer" symbol
![](/imgs/logisim/pointer.png) in the top bar. Then drag the wires.


![and-circ2](/imgs/logisim/and-circ2.png)

At this point, the output wire is red because there are no inputs. This is an
ERROR state. To provide inputs, and to read wire values, we use the pins. 

A pin can either be an input or output pin. The square pins are for providing
input, the circle pins are for providing outputs. Select these and drop them
onto the circuit.

![and-circ3](/imgs/logisim/and-circ3.png)

You'll notice if they are aligned with the wires, they'll display a 0 or 1. If
you need to reoriented a pin, you can edit in the side pane to face
east/west/north/south.

Now, to see the AND gate in action, select the finger value
![finger](/imgs/logisim/finger.png). This allows you to interact with the
circuit. Click on the two input pins, and you'll see that when both are set to
1, the output pin also displays 1.


![and-circ4](/imgs/logisim/and-circ4.png)

![and-circ5](/imgs/logisim/and-circ5.png)


This is great, but we really need to comment our circuit, like we do our
code. Use the ![A](/imgs/logisim/A.png) button now to add text to our circuit. 


![and-circ6](/imgs/logisim/and-circ6.png)

Once you finish. Save your circuit as `part0.circ`, and the select to print the
circuit or export as an image.

![](/imgs/logisim/and-circ.png)


### Requirement

1. Install logisim
2. Do the AND Circuit and print out the final circuit
3. Bring it to the start of class

## Part 1: Implement Boolean Logic

Using Logisim, implement and test a circuit for the following Boolean expression:

```
z = (!W*X + W*!X) * Y
```

You must use binary pins for inputs `W`, `X`, `Y` and an output pin to read the value `z`. 

### Requirements

1. Save this file as `part1.circ`
2. All inputs must be labeled and have pins attached
3. The output must have pins attached
4. You should print out the circuit, either using print or exporting to an
   image. This should match the submission you provide.

### Submission

1. Digitally: Submit `part1.circ` on the submission server
2. Hard Copy: Print out of the circuit with proper labels

## Part 2: Implement Logic for 2-bit `slt` 

In this part of the lab you will implement a 2-bit comparison operator for the
`slt` operator. You will output a 1 or 0 if `X<Y`

1. Inputs: Two 2-bit values, `X` and `Y`, with bit values `X1`,`X0` and
   `Y1`,`Y0`, where `X1` and `Y1` represent the higher order bit and `X0` and
   `Y0` represent the lower order bit. For example if `X=2` then `X1=1` and
   `X0=0`, and `Y=1` means `Y1=0` and `Y0=1`.
   
2. Output: `Q` where `Q=1` if `X<Y` else `Q=0`


### Requirements

1. Draw a truth table for this logic with inputs `X1 X0 Y1 Y0` and output `Q`. 

2. Use a K-map to minimize this formula

3. Implement and minimize the circuit in logisim, save the file as `part2.circ`


### Submission

1. Digitally: Submit `part2.circ` on the submission server

2. Hard copy: Your truth table, k-map and minmization work. A printout of the circuit. 


## Part 3: Two bit reverse counter


In this part of the lab, you will implement a clock oriented two-bit reverse
counter. Consider input `X` whose two bit values or `X1` and `X0` (higher and
lower bit, respectively), and the next state `X'` whose two bit values are `X'1`
and `X'0` (higher and lower, bit respectively).

We can form a truth table to describe the counting

| `X1` | `X0` | `X'1` | `X'0` | `X - 1 = X'` |
|------|------|-------|-------|--------------|
| 0    | 0    | 1     | 1     | 0 - 1 = 3    |
| 0    | 1    | 0     | 0     | 1 - 1 = 0    |
| 1    | 0    | 0     | 1     | 2 - 1 = 1    |
| 1    | 1    | 1     | 0     | 3 - 1 = 2    |


### Requirements

1. Find two formulas, one for `X'1` and one for `X'0`, based on current state `X0` and `X1`

2. Implement the logic circuit in logisim that given the input state `X` computes the output `X'`

3. Use two D-Flip-Flops to save your current state and a pin input for the clock, such that you can
   cycle clock and see your counter count in reverse.
   
   
### Submission

1. Digitally: Submit `part3.circ` on the submission server


2. Hard Copy: Your boolean formula for `X'0` and `X'1`, print out of the circuit


### Hint

Check out this video of two bit forward counter we did in class. 

![two-bit-counter](/imgs/logisim/two-bit-counter.gif)

If you replace the logic with a reverse counter and the clock element with a pin
input, you are most of the way there! 



