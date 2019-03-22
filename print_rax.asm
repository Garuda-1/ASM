SYS_READ    equ     0
SYS_WRITE   equ     1
SYS_EXIT    equ     60

STDIN       equ     0
STDOUT      equ     1

section	.text
   global _start

; Macro to exit
%macro exit 0
    mov     rax, SYS_EXIT
    xor     rdi, rdi
    syscall
%endmacro

; Macro to write
%macro write 2
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, %1
    mov     rdx, %2
    syscall
%endmacro

; Function to write rax to buf
parse:
    mov     rcx, 10
    xor     rdi, rdi
parse_loop1:
    xor     rdx, rdx
    div     rcx
    add     dl, '0'
    push    rdx
    inc     rdi
    cmp     rax, 0
    jg      parse_loop1

    mov     [buf.len], dil
    xor     rcx, rcx

parse_loop2:
    pop     r8
    mov     [buf + rcx], r8b
    inc     rcx
    dec     rdi
    cmp     rdi, 0
    jg      parse_loop2

    ret

write_rax:
    call    parse
    write   buf, [buf.len]
    write   endl, endl.len
    ret

_start:
    mov     rax, 123123123123
    call    write_rax

    mov     rax, 6006135
    call    write_rax
    exit

section .rodata
endl        db      10
.len        equ     1

section .bss
buf         resb    20
.len        resb    1
