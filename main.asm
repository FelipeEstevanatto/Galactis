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
	jal colors		
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
	clearScreen()          # Call function to set the screen to black
	
    drawMap()          # Call function to draw the map sprite

	mainGame()

	# End program with syscall
	li $v0, 10          # System call code for exit
	syscall

# ===== HELPER FUNCTIONS =====

colors:
	addi $18, $0, 0x00A8FF  # Light Blue
	addi $19, $0, 0x00FF00  # Green
	addi $20, $0, 0x000000	# Black
	addi $21, $0, 0x4169E1	# Blue
	addi $22, $0, 0xFFFF00	# Yellow
	addi $23, $0, 0xCFBA95 	# Score color
	addi $24, $0, 0xDC143C  # Crimson
	addi $25, $0, 0x606060  # Light Gray
	addi $26, $0, 0xFFA500  # Orange
	addi $27, $0, 0xFF6600  # Dark Orange
	# addi $28, $0, 0xFF0000  # Red Game Over
	# addi $29, $0, 0x808080  # Gray
	# addi $30, $0, 0xFFFFFF  # White
	jr $31

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
