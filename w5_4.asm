#Laboratory Exercise 5, Assignment 5
.data
    x: .space 21
    y: .space 21
.text
main:
    addi $s0, $0, 0    		# $s0 = i = 0

    li $v0, 8
    la $a0, x
    li $a1, 20
    syscall
get_string:
    add $t1, $s0, $a0
    lb $t0, 0($t1)     		# t0 = x[i]

    beqz $t0, end_of_get_string	# Check if end of string
    addi $s0, $s0, 1		# i += 1
    j get_string

end_of_get_string:
    subi $s0, $s0, 1   		# Decrement i to point to the last character

reverse_string:
    la $a1, y
    add $t0, $0, $0    		# $t0 = j = 0
    add $t1, $0, $0    		# $t1 = 0

loop:
    bltz $s0, print		# If i < 0 => print
    add $t1, $s0, $a0  		# $t1 = address of x[i]
    add $t2, $t0, $a1  		# $t2 = address of y[j]
    lb $t3, 0($t1)     		# $t3 = x[i]
    sb $t3, 0($t2)     		# y[j] = $t3
    subi $s0, $s0, 1   		# i -= 1 
    addi $t0, $t0, 1   		# j += 1
    j loop

print:
	li $v0, 4
 	la $a0, x
 	syscall
 	
 	li $v0, 4
 	la $a0, y
 	syscall