


###################################################################################       
###################################################################################        
        .text
        .globl main
main:   
        # Print the welcome prompt 
        la      $a0, strPrompt          # 'load address' of prompt string
        li      $v0, 4                  # syscall #4 = print string
        syscall                         # actually print the prompt
        
        # Ask user for password, and check the password.  
        jal processLogin                # Returns 1 if access granted

        # Check if access granted or not
        bne $v0, $zero, GrantAccess
        
        # Nope, password was wrong.  Tell them it was wrong
        la      $a0, strWrongPassword   
        li      $v0, 4                  # syscall 4 is print string
        syscall   
        j DoExit

GrantAccess:
        # Password WAS correct -- call function to release lotsa money
        jal ShowEmTheMoney
        
        # terminate the program
DoExit: li $v0, 10
        syscall

       
###################################################################################       
###################################################################################        
# processLogin() reads password from user, checks it, returns 1 if okay
processLogin:  
        # make space then save return address on stack
        addi $sp, $sp, -4
        sw $ra, 0($sp)

        # Prompt user for the password 
        la      $a0, strAskPassword     # load string to request password
        li      $v0, 4                  # syscall #4 = print string
        syscall                         # actually print the prompt
        
        # We have output the passoword prompt, but not actually read
        # the password from user.  Next function does that, 
        # then checks if password correct.  
        # It returns 1 in $v0 if password correct, zero otherwise
        jal readAndCheckPassword
        
        # Return back to caller -- desired result already in $v0
        lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra

###################################################################################       
###################################################################################        
readAndCheckPassword:
        # Make stack space for buffer to store password in
        addi $sp, -16    # buffer limit of 16 characters
        
        # Make more stack space for $ra
        addi $s0, -4     

        # Save $ra for later
        sw $ra, 0($sp)
        
        # Use syscall to read password into the buffer
        # This is syscall #8 -- need buffer address in $a0, length in $a1
        addi $a0, $sp, 4  # buffer starts at $sp+4
        li   $a1, 16      # 16 characters allowed for the buffer
        li   $v0, 8       # syscall #8 is "read string"
        syscall           # actually read the string

        # Now compute hash of the password
        addi $a0, $sp, 4  # pass start of buffer location to hash function
        jal computeHash
                
        # Check if the password hashes match
        li $t0, 104798  
        beq $v0, $t0, PasswordYesMatch
        li $v0, 0         # password did NOT match, so return 0
        j readAndCheckPassword_end
PasswordYesMatch:
        li $v0, 1         # password DID match, so return 1
readAndCheckPassword_end:
        # Reload ra
        lw $ra, 0($sp)

        # Fix-up stack
        addi $s0,  4    # release space for $ra
        addi $sp, 16    # release space for the buffer
        jr $ra


# Add some random space to confuse would-be attackers!
.space 139360 


###################################################################################       
###################################################################################      
# computeHash takes one argument -- a pointer to a buffer holding null-terminated string
# It returns a simple hash of that string
# [IC220 students -- don't sweat the details -- assume this function just works!]
computeHash:
                li $v0, 0   # initial value of hash function output
                li $t0, 100 # temp value to use for computation
 
                # Loop, updating hash, until find null value at end of string
loopForHash:
                lb $t1, 0($a0)                # get next character (a byte, not a word!)
                beq $t1, $zero, exitHash      # if zero, we are done
                mul $t2, $t1, $t0             # t2 = next part of hash
                add $v0, $v0, $t2             # add onto hash result
                addi $a0, $a0, 1              # advance to next character (next byte)
                addi $t0, $t0, 7              # update the constant used for hashing 
                j loopForHash
exitHash:       jr $ra                        # return              
                
###################################################################################      
###################################################################################        
# This function gets called ONLY when password login is successful
# Ha-ha -- this is so secret and important, let's not put any comments!
ShowEmTheMoney:
        la      $a0, str001   
        li      $v0, 4                 
        syscall  
        addi $sp, $sp, -100
        move      $a0, $sp
        li        $a1, 100
        li        $v0, 8
        syscall  
        la      $a0, str002  
        li      $v0, 4                 
        syscall 
        li      $v0, 5
        syscall 
        la      $a0, str003   
        li      $v0, 4                 
        syscall  
        li      $v0, 7                 
        syscall     # terminate program!


        .data
strPrompt: .asciiz "Welcome to the NationBank ATM.\n"
strAskPassword: .asciiz "Please enter your password=> "
str_1:  .asciiz "Enter a number=> "
str_2:  .asciiz "Result=> "
strWrongPassword:  .asciiz "Wrong password.  Go AWAY unauthorized user!!!"
str001:  
.byte 10 10 10 76 111 103 105 110 32 115 117 99 99 101 115 115 46 32 32 82 111 111 116 32 97 99 99 101 115 115 32 103 114 97 110 116 101 100 33 
.byte 10 80 108 101 97 115 101 32 101 110 116 101 114 32 121 111 117 114 32 108 97 115 116 32 110 97 109 101 32 61 62 32 0

str002:
.byte 10 72 111 119 32 109 97 110 121 32 100 111 108 108 97 114 115 32 119 111 117 108 100 32 121 111 117 32 108 105 107 101 32 100 105 115 112 101 110 115 101 100 61 62 32 0
str003:
.byte 10 10 89 111 117 114 32 109 111 110 101 121 32 105 115 32 110 111 119 32 98 101 105 110 103 32 100 105 115 112 101 110 115 101 100 46 
.byte 10 65 110 100 32 119 101 32 97 114 101 32 115 101 110 100 105 110 103 32 55 32 109 105 108 108 105 111 110 32 85 83 68 32 116 111 32 115 101 99 114 101 116 32 83 119 105 115 115 32 66 97 110 107 32 65 99 99 111 117 110 116 32 35 67 72 48 48 57 56 55 54 53 52 51 50 51 46  
.byte 10 80 108 101 97 115 101 32 119 105 116 104 100 114 97 119 32 102 114 111 109 32 116 104 97 116 32 115 101 99 114 101 116 32 97 99 99 111 117 110 116 32 97 116 32 121 111 117 114 32 99 111 110 118 101 110 105 101 110 99 101 46 
.byte 10 84 104 97 110 107 32 121 111 117 44 32 82 111 111 116 32 85 115 101 114 44 32 102 111 114 32 118 105 115 105 116 105 110 103 32 111 117 114 32 65 84 77 46 32 32 72 97 118 101 32 97 32 103 114 101 97 116 32 100 97 121 33 10 10

        


    
