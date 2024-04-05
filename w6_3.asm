.data
    space: .asciiz " "
    array: .word 5, 3, 8, 4, 2, 1, 6, 9, 7
    length: .word 9  # Length of the array

.text
main:
    la $a0, array  # Load the address of the array into $a0
    lw $a1, length  # Load the length of the array into $a1
    
    outer_loop:
        addi $a1, $a1, -1  # Decrement the length
        blez $a1, end  # If length <= 0, end the program
         		# Load the first element of the array into $s0
        addi $t1, $a0, 4  # $t1 points to the next element of the array

        inner_loop:
            lw $s0, 0($a0)
            lw $t0, 0($t1)  # Load the next element of the array into $t0
            slt $t2, $t0, $s0  # Compare the two elements

            beqz $t2, continue  # If the next element is greater, continue
            sw $t0, 0($a0)  # Otherwise, swap the two elements
            sw $s0, 0($t1)

            continue:
                addi $a0, $a0, 4  # Move to the next element
                addi $t1, $t1, 4  # Move $t1 to the next element
                blt $a0, $a1, inner_loop  # If $a2 < length, repeat the inner loop

        j outer_loop  # Repeat the outer loop

    end:
    la $a3, array  # Load the address of the array into $a0
    lw $a1, length  # Load the length of the array into $a1

    # Loop to print each element of the array
    loop:
        lw $t0, 0($a3)  # Load the current element into $t0

        # Print the current element
        li $v0, 1
        move $a0, $t0
        syscall

        # Print a space
        li $v0, 4
        la $a0, space
        syscall

        addiu $a3, $a3, 4  # Move to the next element
        addiu $a1, $a1, -1  # Decrement the length
        bgtz $a1, loop  # If length > 0, repeat the loop

    # Exit the program
    li $v0, 10
    syscall




