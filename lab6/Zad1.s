.data
control: .short 0
 
.text
.global sprawdz, ustaw
.type sprawdz, @function
.type ustaw, @function

sprawdz:
    push %rbp
    mov %rsp, %rbp
 
    mov $0, %rax
    fstcw control
    fwait
    mov control, %ax
    
    # Wyzerowanie wszystkich bitow oprocz 10 i 11 (trybu zaokraglania)
    and $0xC00, %ax # 0000 1100 0000 0000
    shr $10, %ax
 
    mov %rbp, %rsp
    pop %rbp
    ret

ustaw:
    push %rbp
    mov %rsp, %rbp
 
    mov $0, %rax
    fstcw control
    fwait
    mov control, %ax
 
    and $0xF3FF, %ax # 1111 0011 1111 1111
    shl $10, %rdi
    or %di, %ax
    
    # Zapisanie slowa kontrolnego z rejestru ax
    mov %ax, control
    fldcw control
 
    mov %rbp, %rsp
    pop %rbp
    ret
