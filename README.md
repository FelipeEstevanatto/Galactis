# Galactis
cappa
Um jogo simples em MIPS Assembly usando Memory-Mapped I/O para teclado e display bitmap.
Como temos a unidade 4x4 e o display 512x256, temos uma resolução efetiva de 128x64 pixels.

- Utilizando a extensão Better MIPS Support

# Compilar todos os arquivos
- Settings > Assemble all files in directory

# Abrir Tools
- Keyboard and Display MMIO Simulator
- Bitmap display configurado com 
  - Unit width and height: 4
  - Display width and height: 512 x 256
  - Base address: 0x10010000 (static)

# ROdar
- Após abrir as tools e configurar o Bitmap Display
- Focar no MMIO Simulator Keyboard e digitar lá


set0* - Pinta a tela toda com uma "imagem" como de vitória, gameoner, menu, youwin

Cores definidas no código no main.asm, desenhadas manualmente pixel a pixel por endereço de memória


`68719411204` é um decimal especifico que é interpretado como uma pseudo-instrução que se expande em duas funcções reais diferentes pelo assembler:
`lw $15, 68719411204($zero)` se expande para as duas instruções MIPS abaixo no código gerado final:
`lui $at, 0xFFFF      # Load 0xFFFF into the upper 16 bits of $at. $at is now 0xFFFF0000`
`lw  $15, 4($at)      # Load word from address 0xFFFF0000 + 4, which is 0xFFFF0004`

`sw $0, 68719411204($zero)` se expande para as duas instruções MIPS abaixo no código gerado final:
`lui $at, 0xFFFF      # $at = 0xFFFF0000`
`sw  $0, 4($at)       # Store the value of $0 (which is 0) to address 0xFFFF0004`
Isso escreve no buffer do teclado (teoricamente read-only) o valor 0, que é interpretado como "nenhuma tecla pressionada", anterior a qualquer leitura do teclado.

`lw $0, 68719411204($zero)` lê uma palavra buffer do teclado, que é mapeado para o endereço 0xFFFF0004, e
guarda o valor do registrador $0, que é hardwired parar ser 0, então o valor é lido e imediatamente descartado (útil para limpar o buffer do teclado).


 é o valor que representa a tecla 'A' no teclado (definido pela ferramenta Memory-Mapped I/O)   


# Macros e .eqv
https://dpetersanderson.github.io/Help/MacrosHelp.html
