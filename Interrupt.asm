.eqv IN_ADRESS_HEXA_KEYBOARD 0xFFFF0012 
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.data
Message: .asciiz "Key pressed: "
NewLine: .asciiz "\n"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MAIN Procedure
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.text
main:
#---------------------------------------------------------
# Enable interrupts you expect
#---------------------------------------------------------
# Enable the interrupt of Keyboard matrix 4x4 of Digital Lab Sim
	li $t1, IN_ADRESS_HEXA_KEYBOARD
	li $t2, OUT_ADRESS_HEXA_KEYBOARD 
Loop:
	li $t3, 0x80 	# bit 7 of = 1 to enable interrupt
	sb $t3, 0($t1)
#---------------------------------------------------------
# No-end loop, main program, to demo the effective of interrupt
#---------------------------------------------------------
	nop
 	nop
 	nop
 	nop
 	b Loop 	# Wait for interrupt
end_main:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# GENERAL INTERRUPT SERVED ROUTINE for all interrupts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180
IntSR:
    # Detect which row was triggered
    li $t4, 0x1  	# start with row 1
    li $v0, 4
    la $a0, Message
    syscall
detect_row:
    sb $t4, 0($t1)  	# assign row to scan
    lb $a0, 0($t2)  	# read scan code of key button
    bnez $a0, print_key  # if key pressed, print it
    sll $t4, $t4, 1  # shift left to check next row
    ble $t4, 0x8, detect_row  # loop until all rows checked
print_key:
    # Print the key code
    li $v0, 34  # print integer (hexa)
    syscall
    li $v0, 4
    la $a0, NewLine
    syscall

next_pc:
    # Evaluate the return address of main routine
    mfc0 $at, $14  # $at <= Coproc0.$14 = Coproc0.epc
    addi $at, $at, 4  # $at = $at + 4 (next instruction)
    mtc0 $at, $14  # Coproc0.$14 = Coproc0.epc <= $at

return:
    eret  # Return from exception
