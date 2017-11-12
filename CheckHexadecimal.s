# The data section of the code
.data
	inputMessage: .asciiz "Enter a hexadecimal number"    	# Storing the string as inputMessage
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
		syscall			# Making the system call output to the string
		
		
	li $v0, 10			# Preparing the register to exit
	syscall				# Making the exit call
