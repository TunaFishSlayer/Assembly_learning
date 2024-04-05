.data
mes1: .asciiz "The sum of "
mes2: .asciiz " and "
mes3: .asciiz " is "

.text
addi $s1,$0,4
addi $s2,$0,5
add $s3,$s1,$s2

addi $v0, $0, 4
la $a0, mes1  
syscall

addi $v0, $0, 1 
add $a0, $0, $s1  
syscall

addi $v0, $0, 4
la $a0, mes2  
syscall

addi $v0, $0, 1 
add $a0, $0, $s2  
syscall

addi $v0, $0, 4
la $a0, mes3  
syscall

addi $v0, $0, 1 

add $a0, $0, $s3  
syscall