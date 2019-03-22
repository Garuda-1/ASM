;  ,d88b.d88b,
;  88888888888
;  `Y8888888Y'
;    `Y888Y'    -Посвящяю любимым одногруппникам из ОЖВВ-
;      `Y'

SYS_READ    	equ     	0x00
SYS_WRITE   	equ     	0x01
SYS_EXIT    	equ     	0x3c

STDIN		equ		0x00
STDOUT      	equ     	0x01

OP_LEN		equ		128

                section         .text

                global          _start

;
; Macro for exiting
;
; %1	return code
;
%macro exit 1
    		mov     	rax, SYS_EXIT
    		mov     	rdi, %1
    		syscall
%endmacro

;
; Macro for reading
;
; %1	buffer address
; %2	buffer length
;
%macro read 2
    		mov     	rax, SYS_READ
   	 	mov     	rdi, STDIN
    		mov     	rsi, %1
    		mov     	rdx, %2
    		syscall
%endmacro

;
; Macro for writing
;
; %1	buffer pointer
; %2	buffer length
;
%macro write 2
    		mov     	rax, SYS_WRITE
    		mov     	rdi, STDOUT
    		mov     	rsi, %1
    		mov     	rdx, %2
    		syscall
%endmacro

;
; \XXXXX-------\XXX---------\XXXX--------\XXXXXXX---------\
; rsp
;
;     arg1          arg2    arg1 * arg2[i]           res
;
_start:
                sub             rsp, 4 * OP_LEN * 8
		mov		r12, rsp

           	mov             rcx, OP_LEN
		lea             rdi, [rsp]
                call            read_bigint

		mov             rcx, OP_LEN
		lea		rdi, [rsp + OP_LEN * 8]
		call		read_bigint
		
		call		multiply_bigint_bigint

		lea		rdi, [rsp + OP_LEN * 24]
		mov             rcx, OP_LEN
		call		write_bigint
                write		endl, endl.len

                exit		0

;
; Multiply two big integers
; rdi	address of first operand
; rsi	address of second operand
; rcx 	length of big integers in qwords
; r12	stack head
;
; result -> r8
;
multiply_bigint_bigint:
		push            rax
                push            rdi
                push            rcx

                xor             r14, r14
		mov		r13, rcx
.loop:
		lea		rdi, [r12 + OP_LEN * 16]
		mov		rcx, r13
		call		set_zero

		lea		rdi, [r12]
		lea		rsi, [r12 + OP_LEN * 16]
		mov		rcx, r13
		call		copy_bigint

		lea		rdi, [r12 + OP_LEN * 16]
		lea		rbx, [r12 + OP_LEN * 8 + r14 * 8]
		mov		rbx, [rbx]
                mov		rcx, r13
		call		mul_bigint_reg

		mov		rax, r14
		lea		rdi, [r12 + OP_LEN * 16]
		mov		rcx, r13
		call		shr_bigint

		lea		rdi, [r12 + OP_LEN * 24]
		lea		rsi, [r12 + OP_LEN * 16]
		mov		rcx, r13
		call		add_bigint_bigint

		inc		r14
		cmp		r14, rcx
		jl		.loop

                pop             rcx
                pop             rdi
                pop             rax
                ret

;
; Add two big integers
; rdi	address of summand 1
; rsi	address of summand 2
; rcx	length of big integers in qwords
;
; result -> rdi
; 
add_bigint_bigint:
                push            rdi
                push            rsi
                push            rcx

                clc
.loop:
                mov             rax, [rsi]
                lea             rsi, [rsi + 8]
                adc             [rdi], rax
                lea             rdi, [rdi + 8]
                dec             rcx
                jnz             .loop

                pop             rcx
                pop             rsi
                pop             rdi
                ret

;
; Multiply big integer by a register
; rdi	address of big integer multiplier
; rbx	register multiplier
; rcx	length of big integer in qwords
; 
; result -> rdi
;
mul_bigint_reg:
                push            rax
                push            rdi
                push            rcx

                xor             rsi, rsi
.loop:
                mov             rax, [rdi]
                mul             rbx
                add             rax, rsi
                adc             rdx, 0
                mov             [rdi], rax
                add             rdi, 8
                mov             rsi, rdx
                dec             rcx
                jnz             .loop

                pop             rcx
                pop             rdi
                pop             rax
                ret



;
; rdi	source addr
; rsi	target addr
; rcx	big integer length
;
copy_bigint:
		push		rdi
		push		rsi
		push		rcx
		xor		rax, rax
		dec		rcx
		shl		rcx, 3
.loop:
		cmp		rax, rcx
		jg		.done
		mov		r8, [rdi + rax]
		mov		[rsi + rax], r8
		add		rax, 8
		jmp		.loop
.done:
		pop		rcx
		pop		rsi
		pop		rdi
		ret

;
; Shift right one big intege
; rdi	address of target
; rax	delta
; rcx 	length of big integers in qwords
;
; result -> rdi
;
shr_bigint:
		push		rax
		push		rdi
		push		rcx

		lea		rbx, [rdi + rcx * 8 - 8]
		shl		rax, 3
		mov		rdx, rbx
		sub		rdx, rax	
.loop:
		cmp		rdx, rdi
		jl		.cleanup
		mov		r8, [rdx]
		mov		[rbx], r8
		sub		rbx, 8
		sub		rdx, 8
		jmp		.loop

.cleanup:
		cmp		rbx, rdi
		jl		.done
		xor		r8, r8
		mov		[rbx], r8
		sub		rbx, 8
		jmp		.cleanup

.done:	
		pop		rcx
		pop		rdi
		pop		rax
		ret

;
; Add 64-bit register to big integer
; rdi	address of big integer summand
; rax	register summand
; rcx	length of big integer in qwords
;
; result -> rdi
;
add_bigint_reg:
                push            rdi
                push            rcx
                push            rdx

                xor             rdx,rdx
.loop:
                add             [rdi], rax
                adc             rdx, 0
                mov             rax, rdx
                xor             rdx, rdx
                add             rdi, 8
                dec             rcx
                jnz             .loop

                pop             rdx
                pop             rcx
                pop             rdi
                ret

;
; Divide big integer by a short
; rdi	address of big integer dividend
; rbx	register divisor
; rcx	length of big integer in qwords
; 
; result -> rdi
; remainder -> rdx
;
div_bigint_reg:
                push            rdi
                push            rax
                push            rcx

                lea             rdi, [rdi + 8 * rcx - 8]
                xor             rdx, rdx

.loop:
                mov             rax, [rdi]
                div             rbx
                mov             [rdi], rax
                sub             rdi, 8
                dec             rcx
                jnz             .loop

                pop             rcx
                pop             rax
                pop             rdi
                ret

;
; Set big integer to zero
; rdi	address of target big integer
; rcx	length of big integer in qwords
;
; result -> rdi
;
set_zero:
                push            rax
                push            rdi
                push            rcx

                xor             rax, rax
                rep stosq

                pop             rcx
                pop             rdi
                pop             rax
                ret

;
; Check if big integer is a zero
; rdi	address of target big integer
; rcx	length of long number in qwords
;
; result -> ZF
;
is_zero:
                push            rax
                push            rdi
                push            rcx

                xor             rax, rax
                rep scasq

                pop             rcx
                pop             rdi
                pop             rax
                ret

;
; Read big integer from stdin
; rdi	target address
; rcx	length of big integer in qwords
;
read_bigint:
                push            rcx
                push            rdi

                call            set_zero
.loop:
                call            read_char
                or              rax, rax
                js              _reading_failure_error
                cmp             rax, 0x0a
                je              .done
                cmp             rax, '0'
                jb              _invalid_char_error
                cmp             rax, '9'
                ja              _invalid_char_error

                sub             rax, '0'
                mov             rbx, 10
                call            mul_bigint_reg
                call            add_bigint_reg
                jmp             .loop

.done:
                pop             rdi
                pop             rcx
                ret

;
; Read one char from stdin
;
; result -> rax
;
read_char:
                push            rcx
                push            rdi

                sub             rsp, 1
		read		rsp, 1

                cmp             rax, 1
                jne             .error
                xor             rax, rax
                mov             al, [rsp]
                add             rsp, 1

                pop             rdi
                pop             rcx
                ret
.error:
                mov             rax, -1
                add             rsp, 1
                pop             rdi
                pop             rcx
                ret

;
; Write big integer to stdout
;
; rdi	address of target
; rcx	length of target
;
write_bigint:
                push            rax
                push            rcx

                mov             rax, 20
                mul             rcx
                mov             rbp, rsp
                sub             rsp, rax

                mov             rsi, rbp

.loop:
                mov             rbx, 10
                call            div_bigint_reg
                add             rdx, '0'
                dec             rsi
                mov             [rsi], dl
                call            is_zero
                jnz             .loop

                mov             rdx, rbp
                sub             rdx, rsi
		write		rsi, rdx		

                mov             rsp, rbp
                pop             rcx
                pop             rax
                ret

;
; Error exits
;
_reading_failure_error:
    write   reading_fm, reading_fm.len
    write   endl, endl.len
    exit    -1

_writing_failure_error:
    write   writing_fm, writing_fm.len
    write   endl, endl.len
    exit    -1

_invalid_char_error:
    write   inval_char_fm, inval_char_fm.len
    write   endl, endl.len
    exit    -1

                section         .rodata

endl        	db      	0x0a
.len        	equ     	1
inval_char_fm	db              "invalid character"
.len 		equ             $ - inval_char_fm
reading_fm    	db      	"reading failure"
.len     	equ     	$ - reading_fm
writing_fm	db    		"writing failure"
.len     	equ     	$ - writing_fm

