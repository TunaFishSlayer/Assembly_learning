.data
	Message: .asciiz "Type the ticket number:"
	Lucky: 	 .asciiz "This ticket is lucky"
	Unlucky: .asciiz "This ticket is not lucky"
	string: .space 50
.text
# Read the ticket number
	li $v0, 54
 	la $a0, Message
 	la $a1, string
 	la $a2, 50
	syscall
	 
# Find  the size of the string	 
	la $t0,string				# $t0 = address(string[0])
string_length_loop:
    	lb   $t1,0($t0)			
    	beq  $t1,$zero,end_string_length_loop	# Branch if string[i]=\0 or null
    	addi $t0,$t0,1				# Increase the address number
    	j string_length_loop
end_string_length_loop:
	la $t1 string				# $t1 = address(string[0])
	sub $s0,$t0,$t1				# $s0 = address(\0) - address(string[0]) = length of the string with null character
	addi $s0,$s0,-1				# $s0 now contains the length of the string

#----------------------------------
# Algorithm idea in C++: Calculate the sum of the first half and second half of the ticket number then compare them
# int front,back=string_size;
# int sum_f=0,sum_b=0;
# for (front = 0 ; front < string_size/2; front++) {
#     sum_f += (s[front] - '0');
#     back--;
#     sum_b += (s[back]  - '0');
#    }
# cout << (sum_f==sum_b);
#----------------------------------

# Main loop to calculate the sum of the 2 halves
	la $a0,string		# $a0 = address(string[0])
	add $t0,$0,$s0 		# $t0 = back index = string length
	addi $t1,$0,0		# $t1 = front index = 0
	srl $s0, $s0, 1		# Divide the string length by 2			
	addi $s1,$0,0		# Sum of the front half = 0
	addi $s2,$0,0		# Sum of the back half = 0
main_loop:
	beq $t1,$s0,end_loop
	add $t2,$t1,$a0		# $t2 = $a0 + $t1 = address(string[front])
	lb $t3,0($t2)		# $t3 = string[front]
	addi $t3,$t3,-48	# Convert the char into integer 
	add $s1,$s1,$t3		# Sum_front += string[front]
	addi $t1,$t1,1		# Front++
	addi $t0,$t0,-1		# Back--
	add $t4,$t0,$a0		# $t4 = $a0 + $t0 = address(string[back])
	lb $t5,0($t4)		# $t5 = string[back]
	addi $t5,$t5,-48	# Convert the char into integer 
	add $s2,$s2,$t5		# Sum_back += string[back]
	j main_loop
end_loop:	

# Compare the 2 sums
	beq $s1,$s2,equal	# Branch if equal
	li $v0, 55
 	la $a0, Unlucky		# Print unlucky message
 	syscall
	j exit_program
equal:
	li $v0, 55
 	la $a0, Lucky		# Print lucky message
 	syscall
 	
# Exit 	
exit_program:
	li $v0, 10 		#exit
 	syscall 	
		
		
