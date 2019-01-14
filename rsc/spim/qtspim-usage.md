# Using QT-SPIM 

## What is QT-Spim?
The qtspim is spim implementation using the qt development kit. This just means
it has nice windowing and buttons. 

## Initials
When you first open it, the default settings will look like the following (Note
that these images were taken on a Mac).

![qtspim-init](/rsc/spim/imgs/qtspim-init.png)

There is also a console window

![console-init](/rsc/spim/imgs/console-init.png)

Note if you don't see the console. You can select the "Window" file menu and
click for it to appear, as well as make other windows to appear.

The important tabs and windows within the qtspim interface are

* `Int Regs [16]` : This shows you the value of the standard registers. This is
  displayed in hexadecimal. To change it to decimal, select the "Register" file
  menu and select "Decimal". The header will then change to `Int Regs [10]` to
  indicate that it is now in decimal. 
  
* `Fp Regs` : This is the current values of the floating point registers. They are displayed as expected.

* `Text` : This is the memory segment used for your instructions. Currently, it
  is dipslaying startup and intitial code that will always be present. When we
  load our own instructions, they will appear here.
  
* `Data` : This is the value of the various storage segments, including `user
  data segment`, `stack`, `kernel data segment`. 
  
When errors appear, check the bottom feedback window that is at the bottom of the main qtspim window. 
  
## Executing a simple program

Consider the [very-simple-spim.asm](/rsc/spim/very-simple-spim.asm) program from
the resources. You will edit and write this program in a standard text editor,
and then to load it into qt-spim. Click the ![Reinitialize and Load
File](reinit-load.png) to load a file and reinitialize the simulator. You can
also do this from the "File" menu option.

After which, you can see that the code for that program was loaded into the Text
segment.

![qtspim-init](/rsc/spim/imgs/qtspim-init.png)

You can now run the program by clicking ![run](/rsc/spim/imgs/run.png) (F5), where you'll see that
that grayed box of which line of code that executed is at the end of our instructions,

![qtspim-end](/rsc/spim/imgs/qtspim-end.png)

and the console now displays the results.


![console-result](/rsc/spim/imgs/console-result.png)

To run your program again, select ![Reinitilize](/rsc/spim/imgs/clear.png) to reinitialize the
registers, and then click the run button. Or, reinitialize and load the file.

## Debugging, Stepping Through the Program

If you want to step through the program, instruction by instruction, select the
Single Step button ![Single Step](/rsc/spim/imgs/step.png) (F10). This will highlight the
an instruction in the User Text Segment. 


![qtspim-step-1](/rsc/spim/imgs/qtspim-step-1.png)

Continue to hit the single step button to move forward in the code, until after
the initial `li` instructions at line 0x0040030 (in memory). Watch each of the
associated registers being updated.

![qtspim-step-2](/rsc/spim/imgs/qtspim-step-2.png)


You can also change register values by "right clicking" on the register and
selecting "Change Registers Contents"

![qtspim-reg](/rsc/spim/imgs/qtspim-reg.png)


This is also a handy way to jump ahead in your code by changing the `PC` register.

![qtspim-pc](/rsc/spim/imgs/qtspim-pc.png)

At any point, you can then run the program to the end by clicking the run button
![run](/rsc/spim/imgs/run.png), or reset with the reinitialize button ![Reinitilize](/rsc/spim/imgs/clear.png)
