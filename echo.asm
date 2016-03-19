
global  _start

section .text

_start:
  mov   al, `\n` ;put the newline in al
  xor   rdx, rdx ;set rdx to 0

  pop   rbp ;Pops number of arguments to rbp
  pop   rsi ;pops first argument

  dec   rbp
  jz    _echodone ;if there are no arguments jump to the end

  pop   rsi

  mov   edi, [rsi]
  and   edi, 0x00FFFFFF
  cmp   edi, `-n\0` ;Check if the first argument is -n followed by a null character
  cmovne rdi, rsi
  jne   _main
  ; if this is the last argument just end the program
  dec   rbp
  jz    _done
  ;otherwise remove the newline character stored in al
  xor   al, al
  pop   rsi ;prepare the next argument for _main
  mov   rdi, rsi

_main:
  dec   rbp
  jz    _lastarg
  pop   rdi
  mov   byte [rdi - 1], ' '
  jmp   _main

_lastarg:
  ;puts the following magic numbers in registers for quick access
  mov   r10, 0x7F7F7F7F7F7F7F7F
  mov   rbx, 0x0101010101010101
  mov   rcx, 0x8080808080808080

_nextqword:
  ;qword version of magic number strlen stuff, see
  ;https://gist.github.com/faissaloo/e28b55b0e4671132f522
  ;for a proper explanation of how it works
  mov   r9, [rdi]
  add   rdi, 8
  and   r9, r10
  sub   r9, rbx
  and   r9, rcx
  jz    _nextqword

  sub   rdi, rsi
  sub   rdi, 8
  mov   rdx, rdi
  ;Fancy 64 bit way of getting the first 0
  bsf   r8, r9
  shr   r8, 3
  add   rdx, r8

_echodone:
  mov     byte [rsi + rdx], al
  cmp     al, 0
  je      _nonl
  inc     rdx
_nonl:
  mov     rax, 1
  mov     rdi, 1
  syscall
_done:
  mov     rax, 60
  xor     rdi, rdi
  syscall
