.set macro 		            #To include an external file
.include "menuInicial.asm"
.data
.text
main:
jal colors		
jal background_def

menu() 		        #To call a function located in another file - associated with the .set macro

.set nomacro 		#Marks the end of the external file inclusion
colors:
addi $20, $0, 0x000000	# Black
addi $21, $0, 0x4169E1	# Blue
addi $22, $0, 0xffff00	# Yellow
addi $23, $0, 0xcfba95 	# Score color
addi $24, $0, 0xDC143C  # Crimson
addi $26, $0, 0xffa500  # Orange
addi $27, $0, 0xff6600  # Dark Orange
addi $28, $0, 0xff0000  # Red Game Over
addi $29, $0, 0x808080  # Gray
addi $30, $0, 0xffffff  # White
addi $25, $0, 0xff007f  # Pink
addi $19, $0, 0x00ff00  # Green
addi $18, $0, 0x00a8ff  # Light Blue
addi $17, $0, 0x964b00  # Brown
jr $31

background_def:
addi $9, $0, 8192	# Background size
add $10, $0, $9		# Initial position
lui $10, 0x1001		# Set the first pixel
jr $31

