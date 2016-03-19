
global  _start

section .text

_start:
  mov   al, `\n`
  xor   rdx, rdx

  pop   rbp
  pop   rsi

  dec   rbp
  jz    _echodone

  pop   rsi

  mov   edi, [rsi]
  and   edi, 0x00FFFFFF
  cmp   edi, `-n\0`
  cmovne rdi, rsi
  jne   _main

  dec   rbp
  jz    _done

  xor   al, al
  pop   rsi
  mov   rdi, rsi

_main:
  dec   rbp
  jz    _lastarg
  pop   rdi
  mov   byte [rdi - 1], ' '
  jmp   _main

_lastarg:
  mov   r10, 0x7F7F7F7F7F7F7F7F
  mov   rbx, 0x0101010101010101
  mov   rcx, 0x8080808080808080

_nextqword:
  mov   r9, [rdi]
  add   rdi, 8
  and   r9, r10
  sub   r9, rbx
  and   r9, rcx
  jz    _nextqword

  sub   rdi, rsi
  sub   rdi, 8
  mov   rdx, rdi

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
