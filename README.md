# Galactis
Galactis é jogo simples em MIPS Assembly usando Memory-Mapped I/O para teclado e display bitmap.

Como temos a unidade 4x4 e o display 512x256, temos uma resolução efetiva de 128x64 pixels.

- VSCode: Utilizando a extensão Better MIPS Support
- MARS 4.5

# Rodar o programa
E necessário compilar todos os arquivos
- Settings > Assemble all files in directory
### Abrir Tools
- Keyboard and Display MMIO Simulator
- Bitmap display configurado com 
  - >Unit width and height: 4
  - >Display width and height: 512 x 256
  - >Base address: 0x10010000 (static)
- Após abrir as tools e configurar o Bitmap Display
- Focar no MMIO Simulator Keyboard e digitar lá para o input de teclado

set0* - Pinta a tela toda com uma "imagem" como de vitória, gameOverScreen, menu, youwin

Paleta de cores definidas no código no main.asm, desenhadas manualmente pixel a pixel por endereço de memória

# Explicações 
`68719411204` é um decimal especifico que é interpretado como uma pseudo-instrução que se expande em duas funcções reais diferentes pelo assembler:
`lw $15, 68719411204($zero)` se expande para as duas instruções MIPS abaixo no código gerado final:
```
lui $at, 0xFFFF      # Load 0xFFFF into the upper 16 bits of $at. $at is now 0xFFFF0000
lw  $15, 4($at)      # Load word from address 0xFFFF0000 + 4, which is 0xFFFF0004
```

`sw $0, 68719411204($zero)` se expande para as duas instruções MIPS abaixo no código gerado final:
```
lui $at, 0xFFFF      # $at = 0xFFFF0000
sw  $0, 4($at)       # Store the value of $0 (which is 0) to address 0xFFFF0004
```
Isso escreve no buffer do teclado (teoricamente read-only) o valor 0, que é interpretado como "nenhuma tecla pressionada", anterior a qualquer leitura do teclado.

`lw $0, 68719411204($zero)` lê uma palavra buffer do teclado, que é mapeado para o endereço 0xFFFF0004, e
guarda o valor do registrador $0, que é hardwired parar ser 0, então o valor é lido e imediatamente descartado (útil para limpar o buffer do teclado).


 é o valor que representa a tecla 'A' no teclado (definido pela ferramenta Memory-Mapped I/O)   


# Macros e .eqv (equivalentes/define)
https://dpetersanderson.github.io/Help/MacrosHelp.html

# Rodar script para fazer backgrounds
```bash
python tools\gen_bitmap_from_excel.py --input .\sprites.xlsx --sheet Menu --out sprites/menuSprite.asm --macro-name drawMenu
```
```bash
python tools\gen_bitmap_from_excel.py --input .\sprites.xlsx --sheet Map --out sprites/mapSprite.asm --macro-name drawMap
```


# INTERFACE
Nossa tela é de 128x64, nossa "interface" será desenhada nas primeiras 8 linhas (0-7) da tela, ou seja, 128x8 pixels.
Nossa borda superior, inferior e lateral esquerda da interface será de 2 pixels cada, e a lateral direita terá informações extras totalizando 16 pixels
Totalizando, teremos 110x60 pixels para o jogo em si, considerando um "bloco" como sendo 5x5, teremos 22 blocos de largura (110/5) e 12 blocos de altura (60/5) para o jogo em si.

