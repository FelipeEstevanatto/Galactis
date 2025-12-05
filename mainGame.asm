.include"sprites/gameOverScreen.asm"

# --- FIX 1: Move variables to Safe Static Data
# This prevents collision with the Bitmap Display (0x10010000)
# and ensures we don't overflow the Global Pointer offset.
.data # 0x10000100
    # 1. O Buffer de Vídeo DEVE ser o primeiro para ficar em 0x10010000
    displayBuffer: .space 8192

    str1:           .asciiz "Ganhou"
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

    # Colors    
    .eqv COLOR_BLACK  0x000000
    .eqv COLOR_PLAYER 0x00FF00 # Green
    .eqv COLOR_ENEMY  0xFF0000 # Red

    .eqv    KEYBOARD_ADDR, 68719411204($zero) # Standard MMIO Keyboard Control Address
    .eqv    KEY_A 97
    .eqv    KEY_D 100
    .eqv    KEY_W 119
    .eqv    KEY_S 115

.data 0x10010000 

.macro mainGame
# ($18 ao $30 são cores)
.text
game_initialize:
    # Configurações iniciais
    sw $0, game_score
    sw $0, playerPosition

    # Inimigo começa longe para evitar colisão imediata
    li $t0, 512            
    sw $t0, enemyPosition



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

    # # system to end program
    # li $v0, 10      # Load the system call code for 'exit' (10) into register $v0
    # syscall         # Invoke the system call

    # --- 2. ERASE OLD POSITIONS ---
    # We erase BEFORE updating coordinates so we know where they were
    lw $a0, playerPosition
    li $a1, COLOR_BLACK
    jal draw_pixel             # Erase Player

    lw $a0, enemyPosition
    li $a1, COLOR_BLACK
    jal draw_pixel             # Erase Enemy

    # --- 3. UPDATE LOGIC ---
    jal update_player          # Move player based on input
    jal update_enemies         # Move enemy automatically
    jal check_collisions       # Did they touch?

    # --- 4. RENDER NEW POSITIONS ---
    lw $a0, playerPosition
    li $a1, COLOR_PLAYER
    jal draw_pixel             # Draw Player

    lw $a0, enemyPosition
    li $a1, COLOR_ENEMY
    jal draw_pixel             # Draw Enemy

    # --- 5. FRAME DELAY ---
    li $v0, 32                 # Syscall: Sleep
    li $a0, 50                 # Wait 50ms (approx 20 FPS)
    syscall

    j game_loop                # Repeat

# ------------------------------------------------
# SUBROUTINES
# ------------------------------------------------

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

update_player:
    lw $t0, inputKey
    lw $t1, playerPosition  # Carrega posição atual

    beq $t0, KEY_A, move_left     # 'a'
    beq $t0, KEY_D, move_right   # 'd'
    # beq $t0, KEY_W, move_up      # 'w'
    # beq $t0, KEY_S, move_down    # 's'
    j reset_input_key              # No valid movement key

move_left:
    blez $t1, reset_input_key   # Se posição <= 0, ignora movimento para esquerda

    addi $t1, $t1, -4          # Move left by 4 pixels
    j commit_move

move_right:
    li $t3, 8188                    # Limite seguro do buffer
    bge $t1, $t3, reset_input_key   # Bloqueia se for >= 8188

    addi $t1, $t1, 4           # Move right by 4 pixels
    j commit_move

commit_move:
    sw $t1, playerPosition
    # Fall-through para resetar a tecla

reset_input_key:
    sw $0, inputKey            # Clear input key
    jr $ra

update_enemies:
    lw $t0, enemyPosition
    addi $t0, $t0, 4           # Move enemy right by 1 pixel (4 bytes)
    
    # Boundary Check
    li $t2, 8192               # Screen Size Limit (from background_def)
    bge $t0, $t2, reset_enemy_pos

    sw $t0, enemyPosition
    jr $ra

reset_enemy_pos:
    sw $zero, enemyPosition    # Reset to start of screen
    jr $ra

check_collisions:
    lw $t0, playerPosition
    lw $t1, enemyPosition
    beq $t0, $t1, handle_collision
    jr $ra

handle_collision:
    # On collision, end game
    # jal gameOverScreen
    gameOverScreen()

    li $v0, 10                  # Syscall: Exit
    syscall
    jr $ra

draw_pixel:
    # $a0 = position offset
    # $a1 = color
    la $t0, displayBuffer       # Carrega o endereço base de displayBuffer (0x10010000)
    add $t0, $t0, $a0           # Adiciona o offset
    sw $a1, 0($t0)              # Desenha
    jr $ra

.end_macro
