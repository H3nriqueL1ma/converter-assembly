%include 'lib.inc'

section .data
    v1           DW '105', LF, NULL ; Declaração do vetor 'v1' com os elementos '1', '0', '5' (como caracteres ASCII), seguido de uma nova linha (LF) e um caractere nulo (NULL).

section .text

global _start

_start:
    CALL         convert_value      ; Chama a sub-rotina 'convert_value' para converter a string em 'v1' para um número inteiro.
    CALL         show_value         ; Chama a sub-rotina 'show_value' para converter o número inteiro de volta para string e exibir na saída padrão.

    MOV          EAX, SYS_EXIT      ; Move o número da chamada de sistema para encerrar o programa (SYS_EXIT) para o registrador EAX.
    MOV          EBX, RET_EXIT      ; Move o código de retorno para a chamada de sistema SYS_EXIT (RET_EXIT) para o registrador EBX.
    INT          SYS_CALL           ; Chama o sistema operacional para encerrar o programa.

convert_value:
    LEA          ESI, [v1]          ; Carrega o endereço de 'v1' no registrador ESI.
    MOV          ECX, 0x3           ; Configura o contador de repetições para 3 (tamanho da string 'v1').
    CALL         string_to_int      ; Chama a sub-rotina 'string_to_int' para converter a string em 'v1' para um número inteiro.
    ADD          EAX, 0x2           ; Adiciona 2 ao número inteiro resultante.
    RET                             ; Retorno da sub-rotina.

show_value:
    CALL         int_to_string      ; Chama a sub-rotina 'int_to_string' para converter o número inteiro para string e armazenar em 'BUFFER'.
    CALL         resultOutput       ; Chama a sub-rotina 'resultOutput' para exibir o conteúdo de 'BUFFER' na saída padrão.
    RET                             ; Retorno da sub-rotina.

string_to_int:
    XOR          EBX, EBX           ; Zera o registrador EBX para armazenar o número inteiro resultante.

.next_digit_SI:
    MOVZX        EAX, BYTE[ESI]     ; Carrega o próximo byte (caractere) da string para o registrador EAX.
    INC          ESI                ; Incrementa o endereço da string para apontar para o próximo caractere.
    SUB          AL, '0'            ; Subtrai o valor ASCII de '0' para converter o caractere para seu valor numérico.
    IMUL         EBX, 0xA           ; Multiplica o número inteiro atual por 10 (base decimal).
    ADD          EBX, EAX           ; Adiciona o valor numérico do caractere à soma acumulada no registrador EBX.
    LOOP         .next_digit_SI     ; Repete o loop até que todas as posições da string sejam processadas.
    MOV          EAX, EBX           ; Move o resultado final para o registrador EAX.
    RET                             ; Retorno da sub-rotina.

int_to_string:
    LEA          ESI, [BUFFER]      ; Carrega o endereço inicial do buffer 'BUFFER' no registrador ESI.
    ADD          ESI, 0x9           ; Move o ponteiro ESI para a posição do último dígito no buffer (10 caracteres disponíveis).
    MOV          BYTE[ESI], 0xA     ; Insere uma quebra de linha (LF) após o último dígito no buffer.
    MOV          EBX, 0xA           ; Configura o divisor para a base decimal (10).

.next_digit_IS:
    XOR          EDX, EDX           ; Zera o registrador EDX para armazenar o resto da divisão.
    DIV          EBX                ; Divide o número inteiro (EAX) por 10, resultando no quociente em EAX e o resto em EDX.
    ADD          DL, '0'            ; Adiciona o valor ASCII de '0' ao resto para obter o caractere correspondente.
    DEC          ESI                ; Move o ponteiro ESI para a próxima posição no buffer.
    MOV          [ESI], DL          ; Armazena o caractere no buffer.
    TEST         EAX, EAX           ; Testa se ainda há dígitos para converter (EAX != 0).
    JNZ          .next_digit_IS     ; Se ainda houver dígitos, repete o loop.
    RET                             ; Retorno da sub-rotina.
