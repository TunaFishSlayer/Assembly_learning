.data
	message1: .asciiz "Write the n value:"
	message2: .asciiz "Write the k value:"
	message3: .asciiz "The C(n,k) value is:"
.text
# Read the input
 	li $v0, 51
 	la $a0, message1	# Read the n value
 	syscall
 	add $s0,$0,$a0		# $s0 = n
 	
 	li $v0, 51
 	la $a0, message2	# Read the k value
 	syscall  	
 	add $s1,$0,$a0		# $s1 = k
#------------------------------------------- 
# Algorithm idea: k<=n
# C(n,k) = n! / [ k! * (n-k)! ] 
# n! = n*(n-1)...*(n-k)*(n-k-1)*...*1
# => C(n,k) = [n*(n-1)*...*(n-k)] / k!
# cin >> n >> k;
# for (int i = n, j = 1; j <= k; --   i, ++j)
# result = result * i/j;
# cout << result;
#-------------------------------------------
	li $t0,1		# $t0 = j = 1
	add $t1,$s0,$0		# $t1 = i = n
	addi $s2,$0,1		# result = 1
mult_loop:
	bgt $t0,$s1,end_mult_loop
	mult $t1,$s2		
	mflo $s2		# result *= i 
	addi $t1,$t1,-1		# i--
	addi $t0,$t0,1		# j++
	j mult_loop
end_mult_loop:
	li $t0,1		# Reset j
div_loop: 
	bgt $t0,$s1,end_div_loop			
	div $s2,$t0		
	mflo $s2		# result /= j
	addi $t0,$t0,1		# j++
	j div_loop
end_div_loop:

	li $v0, 56 
 	la $a0, message3
 	addi $a1,$s2,0  	# Print the result 
 	syscall # execut	
	
	