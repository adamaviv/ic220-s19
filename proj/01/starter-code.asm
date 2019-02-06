# Starter code AND demonstration of how to call a function as part of
# a complete SPIM program.
       
        .data
str_1:  .asciiz "Welcome to my adding program. Enter a number=> "
str_2:  .asciiz "Result=> "
 
        .text
        .globl main
main:   
        # Print the prompt
        la      $a0, str_1              # 'load address' of string to print
        li      $v0, 4                  # syscall #4 = print string
        syscall         
        
        # Read an integer from the user
        li      $v0, 5                  # syscall #5 = read integer
        syscall                         # read int, result goes in $v0

        # Call a function to add that number together with 13
        addi $a0, $zero, 13             # Set up first argument to function  (13)
        move $a1, $v0                   # Set up second argument (the number entered by user)
        jal doAdd                       # do add, result now in $v0
        move $s0, $v0                   # save result for later (b/c v0 clobbered below)
        
        # Print string announcing the result 
        la      $a0, str_2              # 'load address' of string to print
        li      $v0, 4                 
        syscall   
              
        # Print actual result
        li      $v0, 1                  # syscall #1 = print integer
        move    $a0, $s0                # tell syscall what # to print
        syscall
        
        # terminate the program
        li $v0, 10
        syscall

# Define the (very simple) function we use
# Notice that this goes OUTSIDE of main
doAdd:  
		add $v0, $a0, $a1               # add two arguments
		jr $ra                          # return
				
