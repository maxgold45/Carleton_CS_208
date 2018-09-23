# @Max Goldberg- did not work with Jordi F, because he was out of town.
# HW3 - Fast Multiplication

li $s0,0x10010000		# adress of data section of memory array
lw $t1,0($s0)			# operand 1 (first spot in memory)
lw $t2,4($s0)			# operand 2 (second spot in memory)
li $t3,0			# result    (eventually stored in third spot in memory)

# if both operands are negative, change them both to positive
bgez $t1, continue
bgez $t2, loopBegin
sub $t1, $zero, $t1
sub $t2, $zero, $t2

# Swap first and second operand if second operand is negative,
# because my algorithm is unable to multiply if the second operand is negative.
continue:
bgez $t2, loopBegin
lw $t1,4($s0) 
lw $t2,0($s0)

loopBegin:			# while (t2 != zero) {		
beqz $t2, endLoop	
and $t4, $t2, 0x00000001	# if t2 is odd, t4 will be 0x00000001

beqz $t4, shift		# t2 is odd, add it to result, otherwise bitshift
add $t3, $t3, $t1

shift:
sra $t2, $t2, 1
sll $t1, $t1, 1
j loopBegin

endLoop:
sw $t3,8($s0) # (stored in third spot in memory)

.data
-5
-6


