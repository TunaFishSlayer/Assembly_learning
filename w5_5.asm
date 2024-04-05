.data
	x: .space 20
	y: .space 20
.text
main:
get_length: 
	la $a0,x  	 	# $a0 = address(string[0])
	add $s0,$0,$0   	# $t0 = i = 0
get_string:
    	li $v0, 12
    	syscall 		#get one character x
    	move $t0,$v0
    	beq $t0, 10,end_of_get_string # check if ENTER
    	add $t1,$s0,$a0 	#$t1= address of string[i]
    	sb $t0,0($t1)	 	#string[i]=x
	addi $s0, $s0, 1 	# $t0 = $t0 + 1 -> i = i + 1
	beq $s0,20,end_of_get_string
	j get_string
end_of_get_string:
reverse_string:
	la $a1,y
	add $t0,$0,$0
	add $t1,$0,$0
	subi $s0,$s0,1
loop:	
	blez $s0,print_reverse_string
	add $t1,$s0,$a0 
	add $t2,$t0,$a1
	lb $t3,0($t1)
	sb $t3,0($t2)
	subi $s0, $s0, 1
	addi $t0, $t0, 1		
	j loop
print_reverse_string:
	li $v0,4
 	la $a0,y
 	syscall
 
	 