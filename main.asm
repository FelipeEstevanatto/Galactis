.set macro 		            #To include an external file
.include "generated/menuSprite.asm"
.include "set0Menu.asm" 	#Para chamar o arquivo externo
.data
.text
main:
jal colors		
jal background_def

drawMenu()	        # Call function to draw the menu sprite

menuM:
li $16, 1000
lw $15, 68719411204($zero)  #Receber o valor do teclado
bne $15, 0, mapa
jal delay_menu
jal menuM     

# End program with syscall
li $v0, 10        # System call code for exit
syscall

mapa:
set0Menu() # Call function to set the screen to black

delay:
addi $16, $16, -1
nop
bne $16, $0, delay
jr $31

delay_menu:
addi $16, $16, -1
nop
bne $16, $0, delay
jr $31

.set nomacro 		#Marks the end of the external file inclusion
colors:
addi $17, $0, 0x964B00  # Brown
addi $18, $0, 0x00A8FF  # Light Blue
addi $19, $0, 0x00FF00  # Green
addi $20, $0, 0x000000	# Black
addi $21, $0, 0x4169E1	# Blue
addi $22, $0, 0xFFFF00	# Yellow
addi $23, $0, 0xCFBA95 	# Score color
addi $24, $0, 0xDC143C  # Crimson
addi $26, $0, 0xFFA500  # Orange
addi $27, $0, 0xFF6600  # Dark Orange
addi $28, $0, 0xFF0000  # Red Game Over
addi $29, $0, 0x808080  # Gray
addi $30, $0, 0xFFFFFF  # White
addi $25, $0, 0xFF007F  # Pink

jr $31

background_def:
addi $9, $0, 8192	# Background size
add $10, $0, $9		# Initial position
lui $10, 0x1001		# Set the first pixel
jr $31