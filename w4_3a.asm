.text
	li $s1,-7		#Assign value to $s1
	addi $t0,$s1,0		# $t0 = $s1
	bltz $t0,NEGATIVE	#Branch if $t0<0
	j CALCULATE
NEGATIVE:
	sub $t0,$zero,$t0	#Find - $t0
CALCULATE:
	add $s0,$t0,$zero	# $s0 = abs($s1)	