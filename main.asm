.set macro 		            #To include an external file
.include "sprites/menuSprite.asm"
.include "sprites/mapSprite.asm"
.include "sprites/clearScreen.asm" 	#Para chamar o arquivo externo
.include "mainGame.asm"
.data
.text

# ===== MAIN PROGRAM =====
main:
	# 1. Setup: Initialize colors and background
	jal background_def
	
	# 2. Draw the menu screen
	drawMenu()	        # Call function to draw the menu sprite
	
	# 3. Wait for user input
	j wait_input

wait_input:
	li $16, 1000
	lw $15, 68719411204($zero)  # Receber o valor do teclado
	bne $15, 0, start_game      # If key pressed, start game
	jal delay_menu
	j wait_input

start_game:
	# 4. Clear screen (paint black)
	clearScreen()      # Call function to set the screen to black
	
    drawMap()          # Call function to draw the map sprite

	mainGame()

	# End program with syscall
	li $v0, 10          # System call code for exit
	syscall

# ===== HELPER FUNCTIONS =====
background_def:
	addi $9, $0, 8192	# Background size
	add $10, $0, $9		# Initial position
	lui $10, 0x1001		# Set the first pixel
	jr $31

delay_menu:
	addi $16, $16, -1
	nop
	bne $16, $0, delay_menu
	jr $31

.set nomacro 		#Marks the end of the external file inclusion
