# System Calls 

SPIM provides a system call interface for you to use with your MIPS program. A
*system call* is a way to interact with key services, such as doing input and
output. Another way to think of these are as special function calls that are
provided by the SPIM interface.

To request a system call, the user sets the [system call
number](systemcalls-table.md) into register `$v0` and the arguments in registers
`$a0-$a3`. The result of the system call, if it returns a value, is found in
`$v0`. The sytem call itself is invoked with the special instruction `syscall`

For example, there is a `print_string` and a `print_int` system call, that
combined can be used to print to the console `"the answer = 5"`

```
    .data
str:
    .asciiz "the answer = "
    .text
    
    li $v0, 4   # system call number
    la $a0, str # address of the string
    syscall     # invoke the sytem call
    
    li $v0, 1   # system call number
    li $a0, 5   # integer to print
    syscall     # invoke the system call
```

Some other system calls you may need are `read_int`, which will read an entire line of input, including the newline, and convert it to an integer. Characters following the number are ignored.

`read_string` system call will read up to n-1 characters into a buffer (the
address is passed as an argument) and terminate the string with a null byte. If
fewer than n-1 are provided, `read_string` reads up to and including the newline,
placing the result in the buffer with a null terminator.

`print_char` and `read_char` do as they suggest.

When working with files, you can use `open`, `write`, and `close` which are the
standard UNIX library calls.

