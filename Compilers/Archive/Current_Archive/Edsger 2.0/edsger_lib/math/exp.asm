; double exp (double d);
; ----------------------
; This function returns e to the power of a real number.

; KNOWN BUGS !!!
; 1. Does not handle exceptions.


        section .code
        global    _exp

_exp    push        rbp
        mov         rbp, rsp
        sub         rsp, 32
        movupd      [rbp-24], xmm0       ; @Important: for our purposes, the size specifier should be 'tword'

        fld         tword [rbp-24]
        fldl2e                           ; x, log2(e)
        fmulp       st1, st0             ; x * log2(e)
        fld         st0                  ; x * log2(e), x * log2(e)
        frndint                          ; x * log2(e), int(x * log2(e))
        fsub        st1,st0              ; x * log2(e) - int(x * log2(e)) , int(x * log2(e))  
        fxch        st1                  ; int(x * log2(e)) , x * log2(e) - int(x * log2(e))
        f2xm1                            ; int(x * log2(e)) , 2 ^ (x * log2(e) - int(x * log2(e))) - 1
        fld1                             ; int(x * log2(e)) , 2 ^ (x * log2(e) - int(x * log2(e))) - 1, 1
        fadd                             ; int(x * log2(e)) , 2 ^ (x * log2(e) - int(x * log2(e)))
        fscale                           ; 2 ^ (x * log2(e))
        fstp        st1
        fstp        tword [rbp-24]

        movupd      xmm0, [rbp-24]      ; output is expected on xmm0
        add         rsp, 32
        pop         rbp
        ret
