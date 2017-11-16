.data	# The data section of the code
	errorMessage:  .asciiz "Invalid hexadecimal number."
	newLine:       .asciiz   "\n"
	userInput:     .space  9
	
.text 	# The instructions for the code

main: 
# Main Function
# Registers Used
  # $s0 to point to the current byte of the input
  # $t0 to store the power of the hexadecimal number
  # $t1 is used as the counter to the loop
  # $t2 is used to store the current byte
  # $s1 is used to store the decimal value
  	
  	# Inputing the strin
  	li $v0, 8			# About to input a string
  	la $a0, userInput		# Specifying the max size of the string
  	li $a1, 9			# Specifying the size of the input
  	syscall
  	
  	# Pointing to the last byte of the input
  	la   $s0, userInput		# making s0 point to the first byte
  	
  	# If the input is only the return value then the input is invalid
  	
  	lb $t0, ($s0)
  	beq $t0, 10, invalidInput
  	# Creating some variables
  	li $s1, 0			# variable to store the converted decimal value
  	li $t0, 1			# variable to store the power
  	li $t1, 8			# The counter for the loop
  	li $t3, 0			# First Char Found is set to false
  	li $t4, 0			# Char after space is set to false
  	li $t5, 0			# The number of space
  	
  	loop:
  		# loading the value pointed by $s0
  		lb $t2, ($s0)		# $t2 now stores byte pointed by $s0	
  		
  		beq $t2, 10, exitLoop
  		beq $t2, 32, skip
  		# if the character is not space
		li $t3, 1  			# First char found is now set to true
		beq $t3, $t4, invalidInput	# If a valid char is found after space then the input is invalid
		
  		# calling the function to check if the char is valid
  		la  $a0, ($t2)			# passing $t2 as an argument
  		jal checkChar			# calling the function, return value in $v1
  		beq $v1, 0, invalidInput		# If the char is invalid exit the loop
  		
  		# If the input is vaild we convert the character to integer
  		la $a0, ($t2)		# Passing $t2 as an argument
  		jal charToInteger	# calling the function, return value in $v1
  		
  		# perform the operation in $v1 to convert it to equivalent hexadecimal value
  		sll $s1, $s1, 4
  		add $s1, $s1, $v1
		
		# Loop and the character related operations
		skip:
		jal space
		addu $s0, $s0, 1		# s0 now points to the next char 
		addi $t1, $t1, -1	# decreasing the value of the counter
		beq  $t1, 0, exitLoop
		b    loop
	exitLoop:
	# checking if the input was all spaces
	addi $t1, $t1, -8
	sub $t1, $0, $t1
	beq $t5, $t1, invalidInput
	
	# If the loops executes successfully we check if the resulting number is negative
	addi $t0, $0, 10			# loading the value 10 into $t0
	divu $s1, $t0
	mflo $s0			# loading the quotiend into $s0
	mfhi $s1			# loading the quotient into $s1
	
	beq $s0, 0, jump
	# Printing the number with higher significane
	li $v0, 1
	la $a0, ($s0)
	syscall
	jump:
	li $v0, 1
	la $a0, ($s1)
	syscall
	 
	li $v0, 10
	syscall 
	
	invalidInput:
		li $v0, 4
		la $a0, errorMessage
		syscall
		
		li $v0, 10
		syscall

checkChar:
# Function to check if the character is valid
# Arguemnt required: $a0
# Return Value in: $v1 (1 if true, 0 if false)
	li $v1, 0
	beq $a0, 97, else	# $a0 == 'a'
	beq $a0, 98, else
	beq $a0, 99, else
	beq $a0, 100, else
	beq $a0, 101, else
	beq $a0, 102, else
	beq $a0, 65, else	# $a0 == 'A'
	beq $a0, 66, else
	beq $a0, 67, else
	beq $a0, 68, else
	beq $a0, 69, else
	beq $a0, 70, else
	beq $a0, 48, else	# $a0 == 0
	beq $a0, 49, else
	beq $a0, 50, else
	beq $a0, 51, else
	beq $a0, 52, else
	beq $a0, 53, else
	beq $a0, 54, else
	beq $a0, 55, else
	beq $a0, 56, else
	beq $a0, 57, else
	jr $ra
	else:
	li $v1, 1
	jr $ra
	
charToInteger:
# Function to convert character to integer
# Arguments: $a0
	slti $t8, $a0, 59		# If the char is less than 59, the char is a number
	beq $t8, 1, numbers
	
	slti $t8, $a0, 71		# If the char is less than 71 and greater than 59, the char is captial letter
	beq $t8, 1, capital
	
	slti $t8, $a0, 103		# If the char is less than 103, and greater than 71, the char is small letter
	beq $t8, 1, small
	
	numbers:
		addi $v1, $a0, -48	# subtract 48 from the numbers to get the decimal value
		b exitCharToInteger 
	capital:
		addi $v1, $a0, -55	# subtract 55 from the capital letters to get the decimal value
		b exitCharToInteger 
	small:
		addi $v1, $a0, -87	# subtract 87 from the small letters to get the decimal value
	exitCharToInteger:
	jr $ra
	
space:
#increase the count of space and 
	bne $t2, 32, exitSpace
	seq $t4, $t3, 1
	addi $t5, $t5, 1
	exitSpace:
	jr $ra
