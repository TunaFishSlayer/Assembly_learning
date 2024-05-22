.eqv KEY_CODE 0xFFFF0004 		# ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 		# =1 if has a new keycode ?
 							# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C 		# ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 	# =1 if the display has already to do
 							# Auto clear after sw
.text
 	li $k0, KEY_CODE
 	li $k1, KEY_READY
 
 	li $s0, DISPLAY_CODE
 	li $s1, DISPLAY_READY
	addi $s4,$0,0 	
loop: 	nop
 
WaitForKey: 
	bge $s4,4, Exit
	lw $t1, 0($k1) 			# $t1 = [$k1] = KEY_READY
 	nop
 	beq $t1, $zero, WaitForKey 	# if $t1 == 0 then Polling
 	nop
 #-----------------------------------------------------
ReadKey: 
	lw $t0, 0($k0) 			# $t0 = [$k0] = KEY_CODE
 	nop
 	beq $s4,1,Wait_x
 	beq $s4,2,Wait_i
 	beq $s4,3,Wait_t	
	beq $t0,101, Check
Wait_x:
	beq $t0,120, Check
	li $s4,0
	j WaitForDis
Wait_i:
	beq $t0,105, Check
	li $s4,0
	j WaitForDis
Wait_t: 
	beq $t0,116, Check
	li $s4,0
	j WaitForDis
			 	
 #-----------------------------------------------------
WaitForDis: 
	lw $t2, 0($s1) 			# $t2 = [$s1] =DISPLAY_READY
 	nop
 	beq $t2, $zero, WaitForDis 	# if $t2 == 0 then Polling 
 	nop 
 #-----------------------------------------------------
Encrypt: 
	addi $t0, $t0, 1 		# change input key
 #-----------------------------------------------------
ShowKey: 
	sw $t0, 0($s0) 			# show key
 	nop 
 #----------------------------------------------------- 
 	j loop
 	nop
Check:
	addi $s4,$s4,1 	
	j WaitForKey
Exit:
	li $v0,10
	syscall 	
