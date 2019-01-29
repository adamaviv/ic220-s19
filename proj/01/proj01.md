# Project 1: Password Paradox?

* This project is due digitally at Sun. 10 Feb. at 2359.
* This project is due in hard copy during class on Monday, Mon. 11 Feb. 

## Honor/Collaboration

This project must be completed independently (unlike regular assignments). This
means collaboration between students is not permitted. **Online sources (aside
from IC220’s website) are also prohibited.** You may consult your notes, textbook,
the MGSP Leader, and your instructor. See the instructor for help or clarification.

Note: you ARE permitted to discuss solutions to the homework exercises with
other students, but not to discuss any functions from their project or your
project.

## Your Task

You will translate a given recursive C++ program into MIPS, and test it
thoroughly (in SPIM) to ensure that it is fully correct. The C++ program takes
as input two numbers, a “seed” and a "PIN", then uses a recursive computation to
compute a password. When run, the program _might_ look like this:

```
Welcome MIDN Smith's Password Generator!
Enter seed value (in range 0..10): 9
Enter PIN value (in range 0..10): 8
Your password: 3707
```

To help ensure the security of this super-fancy-sophisticated algorithm, each
student will be translating a different C++ program (each one producing
different passwords – so your results will probably not match that screenshot
above). 

Use this link to get your specific assigned program and sample outputs:
http://www.usna.edu/Users/cs/lmcdowel/courses/ic220/spimGen/index.html 

You will be graded on the version you get for entering your lastname and alpha,
correctly. Do not enter nicknames. **Be sure to print this page, for reference
and to turn in with your final assignment.**

You should NOT modify this code — translate it, as given, into MIPS. You must
keep the recursion.

## Specifics

Download [starter-code.asm](/proj/01/starter-code.asm). 

1. Read over the starter code (see link above and/or last page). Make sure you
   understand where the function is defined and how it is called. NOTE: The
   provided `doAdd()` function is so simple that it does not need to use the
   stack. Think carefully about your functions – *they WILL need the stack!*
   
2. Modify the main function to:
   1. Print a welcome message (follow sample input given to you)
   2. Read the "seed" and "PIN" from the user
   3. Translate this test into MIPS 
      ```
         if(seed <= 10 && pin <10){
            //call-specified-function
            //print password that results
         else
            //print erorr message ... see your code
       ```
   4. Exit main (syscall #10)
   
3. Your given C++ code will have two provided “helper” functions, one that takes
   one argument and another that takes two arguments.
   1. First write the helper function that uses only one argument, and test it thoroughly!
   2. Next, write the other helper function and test it.
   3. Test the whole program (with main() calling your two helper functions).
   4. **You do not have to write these functions from scratch – translate the given C++ code!**
   
4. Make sure all the code you write is commented!

5. Test your code using QtSPIM or SPIM

## Additional Requirements

1. You must follow the normal procedure call conventions as discussed in class,
   such as preserving `s` registers.
2. Your code must be commented
3. You must properly use the stack. A solution that somehow computes the "right"
   answer without answer register and stack usage is **_not_** correct.

## Tips

1. Start early! Recursion can be tricky. Allow time to get help from the
   instructor if needed.
   
2. But don’t make this harder than it needs to be! Your primary task is to
   simply translate the C++ code to MIPS. While this involves recursion, really
   this is just another example of a nested procedure – follow the rules for
   nested procedures and recursion will take care of itself.
   
3. You will need to use the stack. Before you begin, make sure you understand how to do this and what will need to be saved and restored with the stack. IMPORTANT NOTE: All stack manipulation should be done only by your helper functions. main() should NOT use the stack or modify $sp in any way.

4. *WARNING WARNING*: executing “syscall” may change the value of registers like
   `a0`, `a1`, etc. and `v0`, `v1` etc. So after a syscall, you must assume that
   all those registers have changed values.

5. This assignment requires you to write only about 50-100 carefully chosen
   assembly instructions. If you have many more than that, you probably are
   misunderstanding what should be done.

6. *TESTING*: if you are unsure of how your program should behave, start by
   looking at the sample output provided for your specific program. Test with
   the smaller values of “seed” and “PIN” first. Remember, with SPIM you can
   “single step” through the code to see what is happening! If you need more
   “test cases”, then you can simply compile the given C++ code and run it for
   comparison.

7. Lot of extra [SPIM reference material](/rsc/spim) is available 

8. Use the starter code!

9. In SPIM,
   * The value of the registers might be displayed by default in hex. You can
     change this to decimal via the menu option: “Registers→Decimal"
   * If you run your program and nothing happens, try selectin “Window→Console”
     from the menu to re-display the console.
   
10. There is no “subi” instruction – use “addi” with negative constant instead.

## Deliverables

* *Hardcopy* all stapled together
  1. A [project coversheet](/rsc/proj_coversheet.pdf) (10 pts)
  2. Screenshot showing your programm running with seed-9, Pin-8 (10pts)
  3. Your C++ code generated from http://www.usna.edu/Users/cs/lmcdowel/courses/ic220/spimGen/index.html
  4. Printout (using code-print) of your correct, commented, and recursive assembly code (50 pts)

* *Electronc* via submit.cs.usna.edu
  1. Your `.asm` of your correct, commented, and recursive assembly code (20 pts)

## Grading Notes

1. 10 point deduction for non-commented code

2. Most of the points earned will come from a solution that actually works. A
   late submission that works will be worth more than an “on-time” submission
   that does not!
