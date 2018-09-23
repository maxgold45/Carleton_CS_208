# @Max Goldberg
# HW2 - Simple Multiplication

# The notation in the comments treats this memory as an array of integers.
# The register (i.e. variable) s0 holds the memory array starting at the data section.
# Each integer is 32 bits or 4 bytes, so to get to the next value, you must add 4 instead of 1
	

li $s0,0x10010000		# s0 = address of data section of memory array
lw $t1,0($s0)			# t1 = s0[0]
lw $t2,4($s0)			# t2 = s0[1]
li $t3,0

loopBegin:  # while (true) {

# bring t1 closer to 0 in this loop: (increment negative t1, and decrement positive t1)
beq $t1, $zero, endLoop  # if (t1 == 0), break

bltz $t1, negative # if (t1 < 0) branch to negative:

# if (t1 > 0)
subi $t1, $t1, 1 # decrement t1
add $t3, $t3, $t2 # add t2 and result
j loopBegin # continue

# if (t1 < 0)
negative:
addi $t1, $t1, 1 # increment t1
sub $t3, $t3, $t2 # sub t2 and result
j loopBegin # continue

endLoop: # once t1 == 0

sw $t3,8($s0) # s0[2] = t3

.data
5
6
