# The data section of the code
.data
	inputMessage: .asciiz "Enter a hexadecimal number: "    	# Storing the string as inputMessage
	userInput: .space 9					# Storing the 
	newLine: .asciiz "\n"					# A newline character
	
# The instruction section
.text
	main:
	# The main part of the program
		li $v0, 4		# preparing the register for displaying information to the screen. 
		la $a0, inputMessage	# Loading the argument to the register
		syscall			# Making th system call to output the string
		
		li $v0, 8		# Preparing the register for inputing the string
		la $a0, userInput	# Specifying what address to input the string to
		li $a1, 9		# Specifying the size of the input
		syscall			# Making the system call to input the string
			
		li $v0, 4		# Preparing the register to display a character
		la $a0, newLine		# loading the string newline into the argument dictionary
		syscall
					
		la $t1, userInput
		
		li $t0, 8		# Counter for the loop
	loop:
		lb $t2, ($t1)		# Loading the first byte $t1 is pointing to
		
		## THIS IS WHERE WE CALL THE FUNCTION TO CHECK IF EACH CHAR STORED IN $T2 IS A HEX-BIT ##
		
		# printing the character $t2 is pointing to just for testing purposes.
		li $v0, 11
		la $a0, ($t2)
		syscall
		
		# Printing the new line
		li $v0, 4
		la $a0, newLine
		syscall
		
		addu $t1, $t1, 1		# Adding one to the value
		
		subi $t0, $t0, 1 	# Decreasing the counter value
		beqz $t0, exitLoop	# If the value in $t0 is equal to 0 exit the loop
		b loop			# Continue the loop
	exitLoop:		
		li $v0, 10		# Preparing the register to exit
		syscall			# Making the exit call
