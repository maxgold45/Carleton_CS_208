li $s0, 0x10010000 # memory address where we'll store our answer
li $t1, 56
li  $t2, 40
sub  $t0, $t1, $t2
sw $t0, 0($s0)

#int x = 56;
#int y = 40;
#int res = x - y;
