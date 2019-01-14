
###################
# The data segment
###################		
.data

# Create some null terminated strings to use
strPromptFirst:	 .asciiz "Enter the first operand:" 
strPromptSecond: .asciiz "Enter the second operand:" 
strResultAdd:	 .asciiz "A + B is " 
strResultSub:	 .asciiz "A - B is " 
strDone:	 .asciiz "DONE\n" 	 
strCR:		 .asciiz "\n" 
	
##########################################
# The text segment -- instructions go here
##########################################	
.text
		.globl main
main:
		# STEP 1 -- get the first operand
		# Print a prompt asking user for input
		li $v0, 4   # syscall number 4 will print string whose address is in $a0       
		la $a0, strPromptFirst      # "load address" of the string
		syscall     # actually print the string  

		# Now read in the first operand 
		li $v0, 5      # syscall number 5 will read an int
		syscall        # actually read the int
		move $s0, $v0  # save result in $s0 for later

		# STEP 2 -- repeat above steps to get the second operand
		# First print the prompt
		li $v0, 4      # syscall number 4 will print string whose address is in $a0   
		la $a0, strPromptSecond      # "load address" of the string
		syscall        # actually print the string

		# Now read in the second operand 
		li $v0, 5      # syscall number 5 will read an int
		syscall        # actually read the int
		move $s1, $v0  # save result in $s1 for later
	
		# STEP 3 -- print the sum
                # First print the string prelude  
		li $v0, 4      # syscall number 4 -- print string
	        la $a0, strResultAdd   
	        syscall        # actually print the string   
	        # Then print the actual sum
	        li $v0, 1         # syscall number 1 -- print int
	        add $a0, $s0, $s1 # add our operands and put in $a0 for print
	        syscall           # actually print the int
		# Finally print a carriage return
		li $v0, 4      # syscall for print string
	        la $a0, strCR  # address of string with a carriage return
	        syscall        # actually print the string
		       
		# STEP 4 -- print the difference
                # First print the string prelude  
		li $v0, 4      # syscall number 4 -- print string
	        la $a0, strResultSub
	        syscall        # actually print the string  
	        # Then print the actual sum
	        li $v0, 1         # syscall number 1 -- print int
	        sub $a0, $s0, $s1 # add our operands and put in $a0 for print
	        syscall           # actually print the string
		# Finally print a carriage return
		li $v0, 4      # syscall for print string
	        la $a0, strCR
	        syscall

		# STEP 5 -- exit
		li $v0, 10  # Syscall number 10 is to terminate the program
		syscall     # exit now
