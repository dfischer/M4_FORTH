    ORG 32768
    
;   ===  b e g i n  ===
    exx
    push HL
    push DE
    ld   HL, 60000
    exx
    
    call bench          ; 3:17      call
    ex   DE,HL          ; 1:4       call    
    exx                 ; 1:4       call
    
    pop  DE
    pop  HL
    exx
    ret
;   =====  e n d  =====   

    
;   ---  b e g i n  ---
gcd1:                   ;           ( a b -- gcd )
    exx                 ; 1:4       :
    pop  DE             ; 1:10      : ret
    dec  HL             ; 1:6       :
    ld  (HL),D          ; 1:7       :
    dec   L             ; 1:4       :
    ld  (HL),E          ; 1:7       : (HL') = ret
    exx                 ; 1:4       :                                                                
    
    push DE             ; 1:11      over
    ex   DE, HL         ; 1:4       over 
    ld    A, H          ; 1:4       if
    or    L             ; 1:4       if
    ex   DE, HL         ; 1:4       if
    pop  DE             ; 1:10      if
    jp    z, else101    ; 3:10      if                                                                         
            
begin101:                                                                         
                
    push DE             ; 1:11      dup
    ld    D, H          ; 1:4       dup
    ld    E, L          ; 1:4       dup 
            
    ld    A, H          ; 1:4       while 101
    or    L             ; 1:4       while 101
    ex   DE, HL         ; 1:4       while 101
    pop  DE             ; 1:10      while 101
    jp    z, repeat101  ; 3:10      while 101                                                                   
                
    push DE             ; 1:11      2dup
    push HL             ; 1:11      2dup 
    or    A             ; 1:4       (u) >
    sbc  HL, DE         ; 2:15      (u) >
    sbc  HL, HL         ; 2:15      (u) >
    pop  DE             ; 1:10      (u) > 
    ld    A, H          ; 1:4       if
    or    L             ; 1:4       if
    ex   DE, HL         ; 1:4       if
    pop  DE             ; 1:10      if
    jp    z, else102    ; 3:10      if 
    ex   DE, HL         ; 1:4       swap 
else102  EQU $          ;           = endif
endif102: 
    push DE             ; 1:11      over
    ex   DE, HL         ; 1:4       over 
    ex   DE, HL         ; 1:4       -
    or    A             ; 1:4       -
    sbc  HL, DE         ; 2:15      -
    pop  DE             ; 1:10      -                                               
            
    jp   begin101       ; 3:10      repeat 101
repeat101: 
    ex   DE, HL         ; 1:4       drop
    pop  DE             ; 1:10      drop 
        
    jp   endif101       ; 3:10      else
else101:                                                               
            
    push DE             ; 1:11      dup
    ld    D, H          ; 1:4       dup
    ld    E, L          ; 1:4       dup 
    ld    A, H          ; 1:4       if
    or    L             ; 1:4       if
    ex   DE, HL         ; 1:4       if
    pop  DE             ; 1:10      if
    jp    z, else103    ; 3:10      if 
    pop  DE             ; 1:10      nip 
    jp   endif103       ; 3:10      else
else103: 
    ex   DE, HL         ; 1:4       drop
    pop  DE             ; 1:10      drop 
    ld   HL, 1          ; 3:10      drop_push 
endif103:                                                   
        
endif101: 
    
gcd1_end:
    exx                 ; 1:4       ;
    ld   E,(HL)         ; 1:7       ;
    inc  L              ; 1:4       ;
    ld   D,(HL)         ; 1:7       ; DE = ret
    inc  HL             ; 1:6       ;
    ex   DE,HL          ; 1:4       ;
    jp  (HL)            ; 1:4       ;
;   -----  e n d  -----
    
    
;   ---  b e g i n  ---
gcd2:                   ;           ( a b -- gcd )
    exx                 ; 1:4       :
    pop  DE             ; 1:10      : ret
    dec  HL             ; 1:6       :
    ld  (HL),D          ; 1:7       :
    dec   L             ; 1:4       :
    ld  (HL),E          ; 1:7       : (HL') = ret
    exx                 ; 1:4       :                                                              
        
    ld    A, H          ; 1:4       dcp0
    or    L             ; 1:4       dcp0
    or    D             ; 1:4       dcp0
    or    E             ; 1:4       dcp0     
    jp   nz, else104    ; 3:10      ifz 
    ex   DE, HL         ; 1:4       drop
    pop  DE             ; 1:10      drop 
    ld   HL, 1          ; 3:10      drop_push 
    jp   gcd2_end       ; 3:10 
else104  EQU $          ;           = endif
endif104:                                          
        
    ld    A, H          ; 1:4       cp0
    or    L             ; 1:4       cp0      
    jp   nz, else105    ; 3:10      ifz 
    ex   DE, HL         ; 1:4       drop
    pop  DE             ; 1:10      drop              
    jp   gcd2_end       ; 3:10 
else105  EQU $          ;           = endif
endif105:                                          
        
    ex   DE, HL         ; 1:4       swap 
    ld    A, H          ; 1:4       cp0
    or    L             ; 1:4       cp0 
    jp   nz, else106    ; 3:10      ifz 
    ex   DE, HL         ; 1:4       drop
    pop  DE             ; 1:10      drop              
    jp   gcd2_end       ; 3:10 
else106  EQU $          ;           = endif
endif106:                                          
        
begin102:  
    push DE             ; 1:11      2dup
    push HL             ; 1:11      2dup 
    ex   DE, HL         ; 1:4       -
    or    A             ; 1:4       -
    sbc  HL, DE         ; 2:15      -
    pop  DE             ; 1:10      -                                                                    
        
    ld    A, H          ; 1:4       while 102
    or    L             ; 1:4       while 102
    ex   DE, HL         ; 1:4       while 102
    pop  DE             ; 1:10      while 102
    jp    z, repeat102  ; 3:10      while 102  
    push DE             ; 1:11      2dup
    push HL             ; 1:11      2dup 
    ld    A, H          ; 1:4       <
    xor   D             ; 1:4       <
    jp    p, $+7        ; 3:10      <
    rl    D             ; 2:8       < sign x2
    jr   $+5            ; 2:12      <
    ex   DE, HL         ; 1:4       <
    sbc  HL, DE         ; 2:15      <
    sbc  HL, HL         ; 2:15      <
    pop  DE             ; 1:10      <  
    ld    A, H          ; 1:4       if
    or    L             ; 1:4       if
    ex   DE, HL         ; 1:4       if
    pop  DE             ; 1:10      if
    jp    z, else107    ; 3:10      if 
    push DE             ; 1:11      over
    ex   DE, HL         ; 1:4       over 
    ex   DE, HL         ; 1:4       -
    or    A             ; 1:4       -
    sbc  HL, DE         ; 2:15      -
    pop  DE             ; 1:10      -                                                          
                 
    jp   endif107       ; 3:10      else
else107: 
    ex   DE, HL         ; 1:4       swap 
    push DE             ; 1:11      over
    ex   DE, HL         ; 1:4       over 
    ex   DE, HL         ; 1:4       -
    or    A             ; 1:4       -
    sbc  HL, DE         ; 2:15      -
    pop  DE             ; 1:10      - 
    ex   DE, HL         ; 1:4       swap                                              
                 
endif107:                                                               
        
    jp   begin102       ; 3:10      repeat 102
repeat102: 
    pop  DE             ; 1:10      nip 
    
gcd2_end:
    exx                 ; 1:4       ;
    ld   E,(HL)         ; 1:7       ;
    inc  L              ; 1:4       ;
    ld   D,(HL)         ; 1:7       ; DE = ret
    inc  HL             ; 1:6       ;
    ex   DE,HL          ; 1:4       ;
    jp  (HL)            ; 1:4       ;
;   -----  e n d  -----

    
;   ---  b e g i n  ---
bench:                  ;           ( -- )
    exx                 ; 1:4       :
    pop  DE             ; 1:10      : ret
    dec  HL             ; 1:6       :
    ld  (HL),D          ; 1:7       :
    dec   L             ; 1:4       :
    ld  (HL),E          ; 1:7       : (HL') = ret
    exx                 ; 1:4       :
        
    exx                 ; 1:4       xdo 101
    dec  HL             ; 1:6       xdo 101
    ld  (HL),high 0     ; 2:10      xdo 101
    dec   L             ; 1:4       xdo 101
    ld  (HL),low 0      ; 2:10      xdo 101
    exx                 ; 1:4       xdo 101
xdo101:                 ;           xdo 101
            
    exx                 ; 1:4       index xi 101    
    ld    A,(HL)        ; 1:7       index xi 101 lo
    inc   L             ; 1:4       index xi 101
    ex   AF, AF'        ; 1:4       index xi 101
    ld    A,(HL)        ; 1:7       index xi 101 hi
    dec   L             ; 1:4       index xi 101
    exx                 ; 1:4       index xi 101
    push DE             ; 1:11      index xi 101
    ex   DE, HL         ; 1:4       index xi 101
    ld    H, A          ; 1:4       index xi 101
    ex   AF, AF'        ; 1:4       index xi 101
    ld    L, A          ; 1:4       index xi 101
;   exx                 ; 1:4       index xi 101
;   ld    E,(HL)        ; 1:7       index xi 101
;   inc   L             ; 1:4       index xi 101
;   ld    D,(HL)        ; 1:7       index xi 101
;   push DE             ; 1:11      index xi 101
;   dec   L             ; 1:4       index xi 101
;   exx                 ; 1:4       index xi 101
;   ex   DE, HL         ; 1:4       index xi 101 ( i x2 x1 -- i  x1 x2 )
;   ex  (SP),HL         ; 1:19      index xi 101 ( i x1 x2 -- x2 x1 i ) 
    call PRINT_NUM      ; 3:17      . 
    ld    A, ':'        ; 2:7       putchar Pollutes: AF, DE', BC'
    rst   0x10          ; 1:11      putchar with 48K ROM in, this will print char in A
            
    exx                 ; 1:4       xdo 102
    dec  HL             ; 1:6       xdo 102
    ld  (HL),high 0     ; 2:10      xdo 102
    dec   L             ; 1:4       xdo 102
    ld  (HL),low 0      ; 2:10      xdo 102
    exx                 ; 1:4       xdo 102
xdo102:                 ;           xdo 102 
    exx                 ; 1:4       index xj 102    
    ld    E, L          ; 1:4       index xj 102
    ld    D, H          ; 1:4       index xj 102
    inc   L             ; 1:4       index xj 102
    inc  HL             ; 1:6       index xj 102
    ld    C,(HL)        ; 1:7       index xj 102 lo    
    inc   L             ; 1:4       index xj 102
    ld    B,(HL)        ; 1:7       index xj 102 hi
    push BC             ; 1:11      index xj 102
    ex   DE, HL         ; 1:4       index xj 102
    exx                 ; 1:4       index xj 102
    ex   DE, HL         ; 1:4       index xj 102 ( j x2 x1 -- j  x1 x2 )
    ex  (SP),HL         ; 1:19      index xj 102 ( j x1 x2 -- x2 x1 j ) 
    exx                 ; 1:4       index xi 102    
    ld    A,(HL)        ; 1:7       index xi 102 lo
    inc   L             ; 1:4       index xi 102
    ex   AF, AF'        ; 1:4       index xi 102
    ld    A,(HL)        ; 1:7       index xi 102 hi
    dec   L             ; 1:4       index xi 102
    exx                 ; 1:4       index xi 102
    push DE             ; 1:11      index xi 102
    ex   DE, HL         ; 1:4       index xi 102
    ld    H, A          ; 1:4       index xi 102
    ex   AF, AF'        ; 1:4       index xi 102
    ld    L, A          ; 1:4       index xi 102
;   exx                 ; 1:4       index xi 102
;   ld    E,(HL)        ; 1:7       index xi 102
;   inc   L             ; 1:4       index xi 102
;   ld    D,(HL)        ; 1:7       index xi 102
;   push DE             ; 1:11      index xi 102
;   dec   L             ; 1:4       index xi 102
;   exx                 ; 1:4       index xi 102
;   ex   DE, HL         ; 1:4       index xi 102 ( i x2 x1 -- i  x1 x2 )
;   ex  (SP),HL         ; 1:19      index xi 102 ( i x1 x2 -- x2 x1 i ) 
    push HL             ; 1:11      dup .   x3 x1 x2 x1
    call PRINT_NUM      ; 3:17      .
    ex   DE, HL         ; 1:4       dup .   x3 x2 x1 
    call gcd1           ; 3:17      call
    ex   DE,HL          ; 1:4       call    
    exx                 ; 1:4       call 
    call PRINT_NUM      ; 3:17      . 
    exx                 ; 1:4       xloop 102
    inc (HL)            ; 1:7       xloop 102 index_lo++
    ld    A, 10         ; 2:7       xloop 102
    scf                 ; 1:4       xloop 102
    sbc   A, (HL)       ; 1:7       xloop 102 stop_lo - index_lo - 1
    exx                 ; 1:4       xloop 102
    jp   nc,xdo102      ; 3:10      xloop 102 again
    exx                 ; 1:4       xloop 102
    inc   L             ; 1:4       xloop 102
    inc  HL             ; 1:6       xloop 102
    exx                 ; 1:4       xloop 102
            
    ld    A, 0x0D       ; 2:7       cr      Pollutes: AF, DE', BC'
    rst   0x10          ; 1:11      cr      with 48K ROM in, this will print char in A
        
    exx                 ; 1:4       xloop 101
    inc (HL)            ; 1:7       xloop 101 index_lo++
    ld    A, 10         ; 2:7       xloop 101
    scf                 ; 1:4       xloop 101
    sbc   A, (HL)       ; 1:7       xloop 101 stop_lo - index_lo - 1
    exx                 ; 1:4       xloop 101
    jp   nc,xdo101      ; 3:10      xloop 101 again
    exx                 ; 1:4       xloop 101
    inc   L             ; 1:4       xloop 101
    inc  HL             ; 1:6       xloop 101
    exx                 ; 1:4       xloop 101
    
bench_end:
    exx                 ; 1:4       ;
    ld   E,(HL)         ; 1:7       ;
    inc  L              ; 1:4       ;
    ld   D,(HL)         ; 1:7       ; DE = ret
    inc  HL             ; 1:6       ;
    ex   DE,HL          ; 1:4       ;
    jp  (HL)            ; 1:4       ;
;   -----  e n d  -----

; Input: A = or numbers, DE string index, HL = number, BC = 10000,1000,100,10,1
; Output: Write number to memory
; Pollutes: AF, AF', HL, B, DE
NEXTNUMBER:
    ex   AF, AF'        ; 1:4
    xor   A             ; 1:4

    inc   A             ; 1:4
    sbc  HL, BC         ; 2:15
    jr   nc, $-3        ; 2:7/12
    
    add  HL, BC         ; 1:11
    dec   A             ; 1:4
    ld    B, A          ; 1:4    
    add   A, '0'        ; 2:7       0   
    ex   AF, AF'        ; 1:4
    
    or    B             ; 1:4
    ret   z             ; 1:5/11    zatim same nuly
    
    ex   AF, AF'        ; 1:4
    ld  (DE), A         ; 1:7
    inc  DE             ; 1:6
    ex   AF, AF'        ; 1:4
    ret                 ; 1:10

; Input: HL
; Output: Print decimal number in HL
; Pollutes: AF, AF', BC, delete top stack
PRINT_NUM:
    push DE             ; 1:11

    ld   DE, STRNUM     ; 3:10

    bit   7, H          ; 2:8
    jr    z, PRINT_NUM_P; 2:7/12
    
    ld    A, '-'        ; 2:7
    ld  (DE), A         ; 1:7
    inc  DE             ; 1:6

    ld    A, L          ; 1:4
    cpl                 ; 1:4
    ld    L, A          ; 1:4
    ld    A, H          ; 1:4
    cpl                 ; 1:4
    ld    H, A          ; 1:4
    inc  HL             ; 1:6
PRINT_NUM_P:
    
    xor   A             ; 1:4
    ld   BC, 10000      ; 3:10
    call NEXTNUMBER     ; 3:17
    
    ld   BC, 1000       ; 3:10
    call NEXTNUMBER     ; 3:17
    
    ld   BC, 100        ; 3:10
    call NEXTNUMBER     ; 3:17
    
    ld   BC, 10         ; 3:10
    call NEXTNUMBER     ; 3:17
    
    ld    A, '0'        ; 2:7
    add   A, L          ; 1:4
    ld  (DE), A         ; 1:7
    
    ex   DE, HL         ; 1:4
    
    inc  HL             ; 1:6
    ld  (HL), 0x20      ; 2:10      space after
    
    ld   DE, STRNUM     ; 3:10
    sbc  HL, DE         ; 2:15
    push HL             ; 1:11
            
    ld    L, 0x1A       ; 2:7       Upper screen
    call 0x1605         ; 3:17      Open channel
    
    pop  BC             ; 1:10      Length-1 of string to print
    ld   DE, STRNUM     ; 3:10      Address of string
    call 0x2040         ; 3:17      Print our string

    pop  HL             ; 1:10      last DE
    pop  BC             ; 1:10      ret
    pop  DE             ; 1:10
    push BC             ; 1:11      ret
    ret                 ; 1:10
STRNUM:
DB      "Dw0rkin"
VARIABLE_SECTION:

STRING_SECTION:
