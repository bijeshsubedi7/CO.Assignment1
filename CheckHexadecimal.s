# The data section of the code
.data
	inputMessage: .asciiz "Enter a hexadecimal number: "    	# Storing the string as inputMessage
	userInput: .space 9					# Storing the 
	outputMessage: .asciiz "The equivalent hexadecimal number is "
	errorMessage: .asciiz "The input characters are invalid" 
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
		addu $t1, $t1, 7
		
		li $s0, 0		# Register to store the converted integer value
		li $t4, 0		# The power of the hexadecimal number
		li $t0, 8		# Counter for the loop
	loop:
		lb $t2, ($t1)		# Loading the first byte $t1 is pointing to
		
		# Preparing the arguments and calling the fucntion checkChar
		la $a0, ($t2)		# Passing the argument
		jal checkChar		# Calling the function
		beq $v0, 0, invalidInput		# If the condition doesn't satisfy we go to the end of the program
		
		# converting the character to integer
		la $a1, ($t2) 		# loading the arguements
		jal charToInteger	# callilng the function to call the argument
		la $t5, ($v1)		# loading the return value into thhe $t5
		
		#printing the integer
		li $v0, 1
		la $a0, ($t5)
		syscall
		
		li $v0, 4		# Preparing the register to display a character
		la $a0, newLine		# loading the string newline into the argument dictionary
		syscall
		
		
		addi $t4, $t4, 1		# Increasing the value of the power fo the hexadecimal base
		
		subu $t1, $t1, 1		# Adding one to the value
		subi $t0, $t0, 1 	# Decreasing the counter value
		beq $t0, 0, exitLoop	# If the value in $t0 is equal to 0 exit the loop
		b loop		# Continue the loop
	exitLoop:
		li $v0, 1
		la $a0, ($s0)
		syscall
		
		li $v0, 10
		syscall
			
	invalidInput:
		li $v0, 4
		la $a0,	errorMessage
		syscall
			
		li $v0, 10		# Preparing the register to exit
		syscall			# Making the exit call


	checkChar:
			li $v0, 0		# the default return address is 0
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
			li $v0, 1
			jr $ra
			
	pow:
		li $t5, 1				# Initial value is 1
		loop1:
			beq $a2, 0, exit			# if the value is 0, we exit the loop
			mult $t5, $a1			# multiply $a1 to $t5
			mflo $t5
			subi $a2, $a2, 1			# decreasing the value of the counter
			b loop				# going back to the top
		exit:
		la $v1, ($t5)				# storing the result of the multiplication in $v1 to return 
		jr $ra	
						# going back to the original address


	charToInteger:
		slti $t8, $a1, 59
		beq $t8, 1, numbers
		
		slti $t8, $a1, 71
		beq $t8, 1, capital
		
		slti $t8, $a1, 103
		beq $t8, 1, small
		
		numbers:
			subi $v1, $a1, 48
			b exitCharToInteger 
		capital:
			subi $v1, $a1, 55
			b exitCharToInteger 
		small:
			subi $v1, $a1, 87
			b exitCharToInteger 
		exitCharToInteger:
			jr $ra
		
