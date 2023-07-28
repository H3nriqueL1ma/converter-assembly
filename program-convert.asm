%include 'lib.inc'

section .data
    v1          DW '105', LF, NULL

section .text

global _start

_start:
    CALL        convert_value
    CALL        show_value

    MOV         EAX, SYS_EXIT
    MOV         EBX, RET_EXIT
    INT         SYS_CALL

convert_value:
    LEA         ESI, [v1]
    MOV         ECX, 0x3
    CALL        string_to_int
    ADD         EAX, 0x2
    RET

show_value:
    CALL        int_to_string
    CALL        resultOutput
    RET




string_to_int:
    XOR         EBX, EBX

.next_digit_SI:
    MOVZX       EAX, BYTE[ESI]
    INC         ESI
    SUB         AL, '0'
    IMUL        EBX, 0xA
    ADD         EBX, EAX
    LOOP        .next_digit_SI
    MOV         EAX, EBX
    RET




int_to_string:
    LEA         ESI, [BUFFER]
    ADD         ESI, 0x9
    MOV         BYTE[ESI], 0xA
    MOV         EBX, 0xA

.next_digit_IS:
    XOR         EDX, EDX
    DIV         EBX
    ADD         DL, '0'
    DEC         ESI
    MOV         [ESI], DL
    TEST        EAX, EAX
    JNZ         .next_digit_IS
    RET