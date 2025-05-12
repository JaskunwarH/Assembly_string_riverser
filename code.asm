section .data
    input db "goodbye", 0   ; Hardcoded input string
    output db "Mirrored string: ", 0
    result db 100, 0

section .bss
    mirrored resb 50      ; Space for the mirrored string

section .text
    global _start

_start:
    ; Find length of the input string
    mov esi, input        ; Input string pointer
    xor ecx, ecx          ; Clear counter
find_length:
    cmp byte [esi], 0     ; Null terminator
    je reverse_string     ; Jump to reverse logic if null terminator found
    inc esi
    inc ecx
    jmp find_length

reverse_string:
    dec esi               ; Point to the last character of the input
    mov edi, mirrored     ; Pointer to the mirrored buffer

reverse_loop:
    mov al, [esi]         ; Copy character from input
    mov [edi], al         ; Store in mirrored buffer
    dec esi
    inc edi
    loop reverse_loop

    ; Concatenate original and mirrored
    mov esi, input        ; Reset pointer to the original string
concat_loop:
    mov al, [esi]         ; Copy each character
    mov [edi], al         ; Store after mirrored string
    inc esi
    inc edi
    cmp byte [esi], 0     ; Check null terminator
    jne concat_loop

    ; Add null terminator at the end of the concatenated string
    mov byte [edi], 0

    ; Display result
    mov eax, 4            ; syscall: write
    mov ebx, 1            ; file descriptor: stdout
    mov ecx, output       ; Message to display
    mov edx, 17           ; Length of message
    int 0x80              ; System call

    mov eax, 4            ; syscall: write
    mov ecx, mirrored     ; Address of the concatenated string
    mov edx, edi          ; Length of the concatenated string
    int 0x80              ; System call

    ; Exit program
    mov eax, 1            ; syscall: exit
    xor ebx, ebx          ; Return code 0
    int 0x80
