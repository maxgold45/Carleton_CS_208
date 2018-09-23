# @author: Max Goldberg
# @author: Jordi Freeman
# Homework 4 on MIPS procedures and ASCII

# jump immediately to main function at end of program
j main

#***************************************************#
# procedure to write string of bytes from memory to 
# terminal, assumes end of string is denoted by byte
# with decimal value 10 (ASCII for <enter>)
# arguments: memory address at which string to write begins
# return: none
#***************************************************#
writeline:
li $v0, 4
syscall

# change values in some registers just to make sure 
# calling function is following conventions
li $a0, 1
li $a1, 2
li $a2, 3
li $a3, 4
li $t0, 5
li $t1, 6
li $t2, 7
li $t3, 5
li $t4, 6
li $t5, 7
li $t6, 5
li $t7, 6
li $t8, 7
li $v1, -1

jr $ra



#***************************************************#
# procedure to write single character to terminal
# arguments: character to write
# return: none
#***************************************************#
writechar:
li $v0, 11
syscall

# change values in some registers just to make sure 
# calling function is following conventions
li $a0, 1
li $a1, 2
li $a2, 3
li $a3, 4
li $t0, 5
li $t1, 6
li $t2, 7
li $t3, 5
li $t4, 6
li $t5, 7
li $t6, 5
li $t7, 6
li $t8, 7
li $v1, -1

# return to caller
jr $ra


#***************************************************#
# procedure to read text from keyboard until <enter> is pressed
# and store as null-terminated string of bytes. 
# arguments: memory address at which to store string
# return: 1 if string was !q, 0 otherwise
#***************************************************#
readline:
li $a1, 100	# length of string must be <100
li $v0, 8
syscall

# check if read 2 chars !q and set v0 to 1 if so, 0 otherwise
li $v0, 0
lb $t3, 1($a0)
bne $t3,0x71, return
lb $t3, ($a0)
bne $t3, 0x21, return
addi $v0, $zero, 1

# change values in some registers just to make sure 
# calling function is following conventions
li $a0, 1
li $a1, 2
li $a2, 3
li $a3, 4
li $t0, 5
li $t1, 6
li $t2, 7
li $t3, 5
li $t4, 6
li $t5, 7
li $t6, 5
li $t7, 6
li $t8, 7
li $v1, -1

# return back to caller
return:
jr $ra


# arg in $a0: Starting address of a null-terminated String.
# returns in $v0: Number of characters in the String
getLength:

li $t1, 0 #counter
li $v0, 0 #return value
lengthLoop:
lbu $t0, 0($a0)
beqz $t0, lengthEnd #if $t0 == null, quit
add $a0, $a0, 1 # advance to the next character
addi $t1, $t1, 1 #increment  counter
j lengthLoop

lengthEnd:
add $v0, $v0, $t1

jr $ra


# arg in $a0: Starting address of a null-terminated String.
# returns in $v0: ASCII value of the middle character of the String.
printMiddleChar:
#Get the length of the String, and set the middle character to $t0
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $a0, 4($sp)
jal getLength  # length of string is now in $v0
lw $a0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 8
div $t0, $v0, 2 # middle character index is in $t0

#Find the middle character and set it to $t1
li $t1, 0 # counter
middleCharLoop:
beq $t1, $t0, middleCharEnd
addi $a0, $a0, 1
addi $t1, $t1, 1
j middleCharLoop
middleCharEnd: # $a0 is set to the middle character

# Print the middle character
move $t0, $a0
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $a0, 4($sp)
lb $a0, ($t0)
jal writechar
lw $a0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 8

# Return the middle character ASCII value
lb $v0, 0($a0)
jr $ra


# arg in $a0: Starting address of a null-terminated String.
# returns in $v0: Starting address of the String- reversed
reverseString:
# find the length of the original string.
addi $sp, $sp, -8
sw $ra, 0($sp)
sw $a0, 4($sp)
jal getLength  # length of string is now in $v0
lw $a0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 8
move $t0, $v0 #length in $t0



add $v0, $v0, $a0  # $v0 = the address of the start of the string + length
# Move up one word 
srl $v0, $v0, 2 
addi $v0, $v0, 1 
sll $v0, $v0, 2  # $v0 = the starting address of the reversed String

# Start at the end of the String in memory and work backwards (by working forwards in the original)
add $v0, $v0, $t0 # $v0 = the ending address of the reversed String

# add null to end of $v0
li $t7, 0
sb $t7, 0($v0)
addi $v0, $v0, -1


# add new line to end of $v0
li $t7, 0xA 
sb $t7, 0($v0)
addi $v0, $v0, -1


addi $t0, $t0, -1
# Reverse the String
reverseLoop:
beq $t0, $zero, exitReverseLoop 
lb $t1, 0($a0)
sb $t1, 0($v0)
addi $a0, $a0, 1 #move up 1 byte for each character
addi $v0, $v0, -1  # $v0 = the address of the current character in thes reversed String
addi $t0, $t0, -1
j reverseLoop
exitReverseLoop:

# return the address of the reversed String
addi $v0, $v0, 1
jr $ra

#***************************************************#
# tests each of the 3 initial functions
#***************************************************#
main:
# store memory address of data section is s register so know
# value is "safe", i.e. will not change after a function call
li $s0, 0x10010000

# Ask the user to enter a string until !q:
move $a0, $s0
jal writeline

li $s0, 0x10010010 # After "Enter a String:" with an extra bit for /0

# Read the String
move $a0, $s0
jal readline
beq $v0, 1, quit #quit if !q is entered

move $a0, $s0
jal getLength

# Write the length
addi $a0, $v0, 0
li $v0, 1
syscall

# println()
li $v0, 11
li $a0, 10
syscall

move $a0, $s0
jal printMiddleChar

# println()
li $v0, 11
li $a0, 10
syscall

move $a0, $s0
jal reverseString

move $a0, $v0
jal writeline

# println()
li $v0, 11
li $a0, 10
syscall

j main
quit:

.data
.asciiz
"Enter a String:"
