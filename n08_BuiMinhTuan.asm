.data
start: .asciiz "Nhap chuoi ky tu : "
hexadecimal: .byte '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f' 
d1: .space 4
d2: .space 4
d3: .space 4
array: .space 32
string: .space 1001
enter: .asciiz "\n"
error_length: .asciiz "Do dai chuoi khong hop le! Nhap lai.\n"
m1: .asciiz "      Disk 1                 Disk 2               Disk 3\n"
m2: .asciiz "----------------       ----------------       ----------------\n"
m3: .asciiz "|     "
m4: .asciiz "     |       "
m5: .asciiz "|["
m6: .asciiz " ]|       "
comma: .asciiz ","
mrs: .asciiz "Thu lai khong?"

.text
	la $s1, d1
	la $s2, d2
	la $s3, d3
	la $a2, array		# dia chi mang chua parity
	
input:	li $v0, 4		# nhap chuoi co boi cua 8
	la $a0, start
	syscall
	li $v0, 8
	la $a0, string
	li $a1, 1001
	syscall
	move $s0, $a0		# s0 chua dia chi xau moi nhap
#-----------------------kiem tra do dai co chia het cho 8 khong--------------------------
length: 
	addi $t3, $zero, 0    # t3 = length
        addi $t0, $zero, 0    # t0 = index

find_length: 
	add $t1, $s0, $t0 # t1 = address of string[i]
        lb $t2, 0($t1)    # t2 = string[i]
        beqz $t2,exit
        beq $t2, 10, test_length # t2 = '\n' ket thuc xau
        addi $t3, $t3, 1  # length++
	addi $t0, $t0, 1  # index++
        j find_length
test_length: 
	move $t5, $t3		# luu lai do dai mang de reset lai	
	beqz $t3,exit	
        andi $t1, $t3, 7	# lay 3 bit cuoi cua do dai xau
        bne $t1, 0, error1	# neu 3 bit cuoi khac 0 thi ko chia het cho 8			
        j print_title
error1: li $v0, 4
        la $a0, error_length
        syscall
        j input

#-------------------------------ket thuc kiem tra do dai----------------------------------

#------------------------in gia tri patity bang Hexa----------------------------
# Minh hoa thuat toan: vi du gia tri t8=15 dich phai 4 bit thu duoc 1, lay byte cuoi cung thi thu duoc 5
#
HEX:	la $t4, hexadecimal
	srl $a0, $t8, 4 		# a0 = t8>>4
	add $t7, $t4, $a0 
	lb $a0, 0($t7) 			# print hex[a0]
	li $v0, 11
	syscall
	
	addi $a0, $t8, 0
	andi $a0, $a0, 0x0000000f 	# lay byte cuoi cung cua a0
	add $t7, $t4, $a0 
	lb $a0, 0($t7)			# print hex[a0]
	li $v0, 11
	syscall

endHEX: jr $ra
#------------------------ket thuc in gia tri patity ----------------------------

#----------------------------mo phong RAID 5------------------------------------
#----------------------------xet 6 khoi dau-------------------------------------
#----------------lan 1: luu vao 2 khoi 1,2; xor vao 3---------------------------
print_title:
	li $v0, 4
	la $a0, m1
	syscall
	
	li $v0, 4
	la $a0, m2
	syscall
	
split1:	addi $t0, $zero, 0	# so byte duoc in ra (4 byte)
	addi $t9, $zero, 0
	addi $t8, $zero, 0
	la $s1, d1
	la $s2, d2
	la $a2, array
print11:
	li $v0, 4
	la $a0, m3
	syscall
	
b11:	lb $t1, 0($s0)		# t1 = input[i]
	addi $t3, $t3, -1	# t3 = length; length --;
	sb $t1, ($s1)		# luu vao disk 1
	
b21:	add $s5, $s0, 4
	lb $t2, ($s5)		# t2 = input[i+4]
	addi $t3, $t3, -1	# t3 = length; length --;
	sb $t2, ($s2)
	
b31:	xor $a3, $t1, $t2	# tinh parity
	sw $a3, ($a2)		
	addi $a2, $a2, 4	# tang den 4 byte tiep theo cua mang array
	addi $t0, $t0, 1	# tang bien
	addi $s0, $s0, 1	# s0 la dia chi byte dau tien cua xau input, s0 ++
	addi $s1, $s1, 1	# tang den byte tiep trong disk1
	addi $s2, $s2, 1	# tang den byte tiep trong disk2
	bgt $t0, 3, reset
	j b11
	
reset:	la $s1, d1		# dat lai gai tri s1 va s2 lan luot len vi tri dau tien cua disk1 va disk2
	la $s2, d2
print12:lb $a0, ($s1)		# in tung gia tri disk1
	li $v0, 11
	syscall
	addi $t9, $t9, 1
	addi $s1, $s1, 1
	bgt $t9, 3, next11
	j print12	
next11:	li $v0, 4		# in dau phan cach
	la $a0, m4
	syscall
	li $v0, 4
	la $a0, m3
	syscall
print13:lb $a0, ($s2)		# in tung gia tri disk2
	li $v0, 11
	syscall
	addi $t8, $t8, 1
	addi $s2, $s2, 1
	bgt $t8, 3, next12
	j print13
next12:	li $v0, 4		# in dau phan cach
	la $a0, m4
	syscall
	li $v0, 4
	la $a0, m5
	syscall	
	la $a2, array
	addi $t9, $zero, 0
print14:lb $t8, ($a2)		# in tung gia tri parity tu mang array vao vi tri disk3
	jal HEX
	li $v0, 4
	la $a0, comma
	syscall
	addi $t9, $t9, 1
	addi $a2, $a2, 4
	bgt $t9, 2, end1	# in ra 3 parity dau co dau ",", parity cuoi cung k co
	j print14	
end1:	lb $t8, ($a2)
	jal HEX
	li $v0, 4
	la $a0, m6
	syscall
	li $v0, 4
	la $a0, enter		
	syscall
	beq $t3, 0, exit1
#----------------lan 2: luu vao 2 khoi 1,3; xor vao 2---------------------------
split2:	la $a2, array
	la $s1, d1
	la $s3, d3
	addi $s0, $s0, 4
	addi $t0, $zero, 0
print21:li $v0, 4
	la $a0, m3
	syscall
b12:	lb $t1, ($s0)
	addi $t3, $t3, -1
	sb $t1, ($s1)
b32:	add $s5, $s0, 4
	lb $t2, ($s5)
	addi $t3, $t3, -1
	sb $t2, ($s3)
b22:	xor $a3, $t1, $t2
	sw $a3, ($a2)
	addi $a2, $a2, 4
	addi $t0, $t0, 1
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	addi $s3, $s3, 1
	bgt $t0, 3, reset2
	j b12
reset2:	la $s1, d1
	la $s3, d3
	addi $t9, $zero, 0
print22:lb $a0, ($s1)
	li $v0, 11
	syscall
	addi $t9, $t9, 1
	addi $s1, $s1, 1
	bgt $t9, 3, next21
	j print22
next21:	li $v0, 4
	la $a0, m4
	syscall
	la $a2, array
	addi $t9, $zero, 0
	li $v0, 4
	la $a0, m5
	syscall
print23:lb $t8, ($a2)
	jal HEX
	li $v0, 4
	la $a0, comma
	syscall
	addi $t9, $t9, 1
	addi $a2, $a2, 4
	bgt $t9, 2, next22
	j print23		
next22:	lb $t8, ($a2)
	jal HEX
	li $v0, 4
	la $a0, m6
	syscall
	li $v0, 4
	la $a0, m3
	syscall
	addi $t8, $zero, 0
print24:lb $a0, ($s3)
	li $v0, 11
	syscall
	addi $t8, $t8, 1
	addi $s3, $s3, 1
	bgt $t8, 3, end2
	j print24

end2:	li $v0, 4
	la $a0, m4
	syscall
	li $v0, 4
	la $a0, enter
	syscall
	beq $t3, 0, exit1
#----------------lan 3: luu vao 2 khoi 2,3; xor vao 1---------------------------
split3:	la $a2, array
	la $s2, d2
	la $s3, d3
	addi $s0, $s0, 4
	addi $t0, $zero, 0
print31:li $v0, 4
	la $a0, m5
	syscall
b23:	lb $t1, ($s0)
	addi $t3, $t3, -1
	sb $t1, ($s1)
b33:	add $s5, $s0, 4
	lb $t2, ($s5)
	addi $t3, $t3, -1
	sb $t2, ($s3)
b13:	xor $a3, $t1, $t2
	sw $a3, ($a2)
	addi $a2, $a2, 4
	addi $t0, $t0, 1
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	addi $s3, $s3, 1
	bgt $t0, 3, reset3
	j b23
reset3:	la $s2, d2
	la $s3, d3
	la $a2, array
	addi $t9, $zero, 0
print32:lb $t8, ($a2)
	jal HEX
	li $v0, 4
	la $a0, comma
	syscall
	addi $t9, $t9, 1
	addi $a2, $a2, 4
	bgt $t9, 2, next31
	j print32		
next31:	lb $t8, ($a2)
	jal HEX
	li $v0, 4
	la $a0, m6
	syscall
	li $v0, 4
	la $a0, m3
	syscall
	addi $t9, $zero, 0
print33:lb $a0, ($s2)
	li $v0, 11
	syscall
	addi $t9, $t9, 1
	addi $s2, $s2, 1
	bgt $t9, 3, next32
	j print33
next32:	addi $t9, $zero, 0
	addi $t8, $zero, 0
	li $v0, 4
	la $a0, m4
	syscall	
	li $v0, 4
	la $a0, m3
	syscall	
print34:lb $a0, ($s3)
	li $v0, 11
	syscall
	addi $t8, $t8, 1
	addi $s3, $s3, 1
	bgt $t8, 3, end3
	j print34

end3:	li $v0, 4
	la $a0, m4
	syscall
	li $v0, 4
	la $a0, enter
	syscall
	beq $t3, 0, exit1
#--------------------------------end 6 khoi dau---------------------------------------
# chuyen sang 6 khoi tiep theo
nextloop: addi $s0, $s0, 4
	j split1
	
exit1:	li $v0, 4
	la $a0, m2	
	syscall
	j wait
#-------------------------------ket thuc mo phong RAID 5-------------------------------

#-------------------------------------thu lai------------------------------------------
wait:   li $v0,32		# sleep 2000ms
	li $a0,2000
	syscall
	
ask:	li $v0, 50		# in thong bao hoi thu lai
	la $a0, mrs
	syscall
	beq $a0, 0, clear
	j exit
# clear: dua string ve trang thai ban dau de thuc hien lai qua trinh
clear:	la $s0, string
	add $s3, $s0, $t5	# t5 la do dai string
	li $t1, 0
goAgain: sb $t1, ($s0)		# set byte o dia chi s0 thanh 0
	addi $s0, $s0, 1
	bge  $s0, $s3, input
	j goAgain
#-----------------------------------ket thuc thu lai------------------------------------

exit:	li $v0, 10
	syscall
