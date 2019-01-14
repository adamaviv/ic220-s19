# SPIM Program Structure

The following is a template on how to organize your program.

``` 
.data                           
            (Constant and variable declarations go here.)
 
            .text                 # Main (must be global).
            .globl main
 
main:       (Your program starts here.)
 
            li $v0, 10            # Syscall to exit.
            syscall
```

## REMARKS

1. The order of the data and main sections is interchangeable

2. The main label always must be declare as global.

3. Always finish your program with a syscall to exit 
