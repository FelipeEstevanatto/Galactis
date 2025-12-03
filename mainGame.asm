# .include"set0.asm"
.include"sprites/gameOverScreen.asm"
# .include"set0youwin.asm"
# .include"set0map1.asm"

# --- FIX 1: Move variables to Safe Static Data
# This prevents collision with the Bitmap Display (0x10010000)
# and ensures we don't overflow the Global Pointer offset.
.data 0x10000100
    str1: .asciiz "Ganhou"

    enemy1_buffer:  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    game_level:     .word 0
    game_score:     .word 0


    # Game State
    playerPosition: .word 0 # Player position with offset from base address
    enemyPosition:  .word 0
    inputKey:       .word 0

    # Constants
    .eqv BASE_ADDR 0x10010000  # Heap Base / Bitmap Display
    .eqv KEY_DATA  0xFFFF0004  # Keyboard Data Register
    .eqv KEY_READY 0xFFFF0000  # Keyboard Control Register

    .eqv    KEYBOARD_ADDR, 68719411204($zero) # Standard MMIO Keyboard Control Address
    .eqv    KEY_A 97
    .eqv    KEY_D 100
    .eqv    KEY_W 119
    .eqv    KEY_S 115

.macro mainGame
# ($18 ao $30 são cores)
.text
game_initialize:
    lui $7, 0x1001		# base address of the bitmap display memory (first pixel) 
    add $8, $0, $7     # $8 holds the current position of the main player
    add $9, $0, $7     # $9 holds the current position of Enemy 1
    add $11, $0, $7    #

    # Reset Score Variable to 0
    sw $0, game_score

    # Print all these values to terminal



    # gameOverScreen()

# Core loop of Input and Dispatch for the game
# 1 Check Input: Poll the keyboard.
# 2 Erase: Paint the player and enemies black at their current (old) positions.
# 3 Update Logic: Calculate new coordinates for player and enemies. Handle collisions.
# 4 Draw: Paint the player and enemies at their new positions.
# 5 Delay: Pause briefly so the game doesn't run at infinite speed.
game_loop: 
    # lw $15, KEYBOARD_ADDR
    # beq $15, KEY_A, input_handle_left
    # beq $15, KEY_D, input_handle_right
    # beq $15, KEY_W, input_handle_up
    # beq $15, KEY_S, input_handle_down
    # --- 1. INPUT HANDLING ---
    jal check_input            # Check if a key is pressed

    # system to end program
    li $v0, 10      # Load the system call code for 'exit' (10) into register $v0
    syscall         # Invoke the system call

    # --- 2. ERASE OLD POSITIONS ---
    # We erase BEFORE updating coordinates so we know where they were
    # lw $a0, playerPos
    # li $a1, COLOR_BLACK
    # jal draw_pixel             # Erase Player

    j game_loop

check_input:
    # Check if key is ready
    li $t0, KEY_READY
    lw $t1, 0($t0)
    beqz $t1, input_end        # No key pressed, skip
    
    # Read key
    li $t0, KEY_DATA
    lw $t2, 0($t0)             # Load ASCII value
    sw $t2, inputKey           # Store for update_player to use
input_end: 
    jr $ra


.end_macro
