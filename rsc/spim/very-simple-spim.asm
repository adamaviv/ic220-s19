
###################
# The data segment
###################		
.data

cr:		.asciiz "\n"  # Create null-terminated string with a newline

	
##########################################
# The text segment -- instructions go here
##########################################	
.text
		.globl main
main:
		# Initialize variables
		li $a0, 0
		li $t0, 1
		li $t1, 4

		# Execute a loop
loop:		beq $t0, $t1, end
		add $a0, $a0, $t0
		addi $t0, 1
		j loop		;

	        # Now print the result, which we computed in $a0
end:		# Syscall number 1 will print the integer in $a0
		li $v0, 1       
		syscall		

	        # Syscall number 4 will print string whose address is in $a0
		li $v0, 4       
		la $a0, cr      # "load address" of the string
		syscall

	        # Syscall number 10 is to terminate the program
		li $v0, 10 
		syscall
