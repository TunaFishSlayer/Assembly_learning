.data 

Message1: .asciiz "dia chi gia tri lon nhat tai thanh ghi $s" 

Message2: .asciiz ", gia tri lon nhat la " 

Message3: .asciiz "\ndia chi gia tri nho nhat tai thanh ghi $s" 

Message4: .asciiz ", gia tri nho nhat la " 

.text 

	li $s0, 9 

	li $s1, 12 

	li $s2, 2 

	li $s3, 0 

	li $s4, -48 

	li $s5, 68 

	li $s6, -74 

	li $s7, 44 

main: 

	sw $s0, -4($sp)          #dat vao ngan xep cac gia tri tuong ung 

	sw $s1, -12($sp) 

	sw $s2, -20($sp) 

	sw $s3, -28($sp) 

	sw $s4, -36($sp) 

	sw $s5, -44($sp) 

	sw $s6, -52($sp) 

	sw $s7, -60($sp) 

	add $t0, $zero, $zero      # khoi tao bien i = 0 

jal loop 

print_max: 

	li $v0, 4 

	la $a0, Message1 
	
	syscall 

	li $v0, 1 

	add $a0, $t2,$zero      

	syscall 

 
	li $v0, 4 

	la $a0, Message2 

	syscall 


	li $v0, 1 

	add $a0, $s0, $zero  

	syscall 

print_min: 

	li $v0, 4 

	la $a0, Message3 

	syscall 

 
	li $v0, 1 

	add $a0, $t3, $zero  

	syscall 


	li $v0, 4 

	la $a0, Message4 

	syscall 


	li $v0, 1 

	add $a0, $s1, $zero  

	syscall 

exit: 

	li $v0, 10 

	syscall 

loop:	 

	sw $t0, 0($sp) 

	addi $t0, $t0, 1 	# tang bien don vi i = i + 1 

	slti $t1, $t0, 8 

	bne $t1, $zero, move_to_next_number 

	lw $s0, -4($sp)  

	lw $t2, 0($sp) 		#vi tri 

find_max: 

	lw $t3, 4($sp) 			#phan tu ke tiep sau max 

	lw $t4, 8($sp) 			#vi tri cua phan tu do 

	slt $t1, $t3, $s0		#so sanh the tim max 

	bne $t1, $zero, adjust_max 

	add $s0, $t3, $zero 

	add $t2, $t4, $zero 

adjust_max: 

	addi $sp,$sp,8        		# di chuyen con tro stack 

	bgtz $t4, find_max      	# Neu i > 0 thi loop  	 	  

	lw $s1,-4($sp)       		# khoi tao max ban dau	  

	lw $t3,0($sp) 

find_min: 

	lw $t5, -8($sp) 

	lw $t4,-12($sp)     

	slt $t1, $s1, $t4 

	bne $t1, $zero, adjust_min 

	add $s1, $t4, $zero 

	add $t3, $t5, $zero 

adjust_min: 

	addi $sp, $sp, -8       

	slti $t1, $t5, 7 

	bne $t1, $zero, find_min 

jr $ra  

move_to_next_number: 

	addi $sp, $sp, -8  

	j loop 
	