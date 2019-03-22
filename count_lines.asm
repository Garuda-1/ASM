SYS_READ    equ     0x0
SYS_WRITE   equ     0x1
SYS_EXIT    equ     0x3c

STDIN       equ     0x0
STDOUT      equ     0x1

section	.text
   global _start

;
; Macro to exit
;
%macro exit 1
    mov     rax, SYS_EXIT
    mov     rdi, %1
    syscall
%endmacro

;
; Macro to read
;
%macro read 2
    mov     rax, SYS_READ
    mov     rdi, STDIN
    mov     rsi, %1
    mov     rdx, %2
    syscall
    cmp     rax, 0
    jl      _error
%endmacro

;
; Macro to write
;
%macro write 2
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, %1
    mov     rdx, %2
    syscall
    cmp     rax, 0
    jl      _error
%endmacro

;
; Function to parse rax to buf
;
; rcx	radix
; rdx   digit
; rdi   length
;
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

    mov     [buf.len], rdi
    xor     rcx, rcx
parse_loop2:
    pop     r8
    mov     [buf + rcx], r8b
    inc     rcx
    dec     rdi
    cmp     rdi, 0
    jg      parse_loop2

    ret

;
; Function to write rax value
;
write_rax:
    call    parse
    write   endl, endl.len
    write   buf, [buf.len]
    write   endl, endl.len
    ret

;
; Function to override data portion
;
; r8	ans
; r9	iterator
; r10   current byte
;
count_lines:
    mov     r8, 1
    mov     rax, cluster
    mov     [buf.len], al
count_lines_loop:
    read    buf, buf.len
    je      count_lines_end
    xor     r9, r9
count_lines_loop_internal:
    mov     r10, [buf + r9]
    cmp     r10b, 0xa
    jne     count_lines_not_increment
    inc     r8
count_lines_not_increment:
    inc     r9
    cmp     r9, rax
    jl      count_lines_loop_internal
    jmp     count_lines_loop
count_lines_end:
    mov     rax, r8
    ret

_start:
    call    count_lines
    call    write_rax
    exit    0

_error:
    exit    -1

section .rodata
cluster     equ     20
endl        db      10
.len        equ     1

section .bss
buf         resb    20
.len        resb    1
