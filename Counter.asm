#1: 00000110	0x06
#2: 01011011 	0x5B
#3: 01001111	0x4F
#4: 01100110	0x66
#5: 01101101	0x6D
#6: 01111101	0x7D
#7: 00000111	0x07
#8: 01111111	0x7F
#9: 01101111	0x6F
.data
number: .byte 0x3F 0x06 0x5B 0x4F 0x66 0x6D 0x7D 0x07 0x7F 0x6F 
.eqv SEVENSEG_LEFT 0xFFFF0011 # Dia chi cua den led 7 doan trai.
.text
main:
	li $a0, 0x3F# set value for segments
 	jal SHOW_7SEG_LEFT # show
	nop
	li $t1, 0 #counter = 0
count:
	bgt $t1, 9, exit 
	lb $a0, number($t1) # set value for segments
	addi $t1, $t1, 1 #counter = counter + 1
 	jal SHOW_7SEG_LEFT # show 
 	li $v0, 32 #delay 1s
 	li $a0, 1000
 	syscall
 	j count
exit: 
	li $v0, 10
 	syscall
endmain:
#---------------------------------------------------------------
# Function SHOW_7SEG_LEFT : turn on/off the 7seg
# param[in] $a0 value to shown 
# remark $t0 changed
#---------------------------------------------------------------
SHOW_7SEG_LEFT: 
	li $t0, SEVENSEG_LEFT # assign port's address
 	sb $a0, 0($t0) # assign new value 
 	nop
	jr $ra
	nop
