dnl ## Arithmetic
define({___},{})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl x = x2 + x1
define({ADD},{
    add  HL, DE         ; 1:11      +
    pop  DE             ; 1:10      +})dnl
dnl
dnl
dnl ( x -- x+n )
dnl x = x + n
define({PUSH_ADD},{ifelse(eval($1),{},{
__{}    ; warning The condition ($1) cannot be evaluated
__{}    ld   BC, format({%-11s},$1); 3:10      $1 +
__{}    add  HL, BC         ; 1:11      $1 +},{ifelse(
__{}eval($1),{0},{
__{}                        ;           $1 +},
__{}eval(($1)-1),{0},{
__{}    inc  HL             ; 1:6       $1 +},
__{}eval(($1)-2),{0},{
__{}    inc  HL             ; 1:6       $1 +
__{}    inc  HL             ; 1:6       $1 +},
__{}eval(($1)-3),{0},{
__{}    inc  HL             ; 1:6       $1 +
__{}    inc  HL             ; 1:6       $1 +
__{}    inc  HL             ; 1:6       $1 +},
__{}{
__{}    ld   BC, format({%-11s},$1); 3:10      $1 +
__{}    add  HL, BC         ; 1:11      $1 +})})})dnl
dnl
dnl
dnl "dup +"
dnl ( x1 -- x2 )
dnl x2 = x1 + x1
define({DUP_ADD},{
    add  HL, HL         ; 1:11      dup +})dnl
dnl
dnl
dnl over +
dnl ( x2 x1 -- x2 x1+x2 )
define({OVER_ADD},{
    add  HL, DE         ; 1:11      over +})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl x = x2 - x1
define({SUB},{
    ex   DE, HL         ; 1:4       -
    or    A             ; 1:4       -
    sbc  HL, DE         ; 2:15      -
    pop  DE             ; 1:10      -})dnl
dnl
dnl
dnl over -
dnl ( x2 x1 -- x2 x1-x2 )
define({OVER_SUB},{
    or    A             ; 1:4       over -
    sbc  HL, DE         ; 2:15      over -})dnl
dnl
dnl
dnl ( x -- x-n )
dnl x = x - n
define({PUSH_SUB},{ifelse(eval($1),{},{
__{}    ; warning The condition ($1) cannot be evaluated
__{}    ld   BC, format({%-11s},$1); 3:10      $1 -
__{}    or    A             ; 1:4       $1 -
__{}    sbc  HL, BC         ; 2:15      $1 -},{ifelse(
__{}eval($1),{0},{
__{}                        ;           $1 -},
__{}eval(($1)-1),{0},{
__{}    dec  HL             ; 1:6       $1 -},
__{}eval(($1)-1),{0},{
__{}    dec  HL             ; 1:6       $1 -
__{}    dec  HL             ; 1:6       $1 -},
__{}eval(($1)-1),{0},{
__{}    dec  HL             ; 1:6       $1 -
__{}    dec  HL             ; 1:6       $1 -
__{}    dec  HL             ; 1:6       $1 -},
__{}{
__{}    ld   BC, format({%-11s},eval(-($1))); 3:10      $1 -
__{}    add  HL, BC         ; 1:11      $1 -})})})dnl
dnl
dnl
dnl ( x -- -x )
dnl x = -x
define({NEGATE},{
    xor   A             ; 1:4       negate
    sub   L             ; 1:4       negate
    ld    L, A          ; 1:4       negate
    sbc   A, H          ; 1:4       negate
    sub   L             ; 1:4       negate
    ld    H, A          ; 1:4       negate})dnl
dnl
dnl
dnl ( x -- u )
dnl absolute value of x
define({ABS},{
    ld    A, H          ; 1:4       abs
    add   A, A          ; 1:4       abs
    jr   nc, $+8        ; 2:7/12    abs
    NEGATE})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl x = x2 * x1
define({MUL},{
ifdef({USE_MUL},,define({USE_MUL},{}))dnl
    call MULTIPLY       ; 3:17      *
    pop  DE             ; 1:10      *})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl x = x2 / x1
define({DIV},{
ifdef({USE_DIV},,define({USE_DIV},{}))dnl
    call DIVIDE         ; 3:17      /
    pop  DE             ; 1:10      /})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl x = x2 % x1
define({MOD},{
ifdef({USE_DIV},,define({USE_DIV},{}))dnl
    call DIVIDE         ; 3:17      mod
    ex   DE, HL         ; 1:4       mod
    pop  DE             ; 1:10      mod})dnl
dnl
dnl
dnl ( x2 x1 -- r q )
dnl x = x2 u% x1
define({DIVMOD},{
ifdef({USE_DIV},,define({USE_DIV},{}))dnl
    call DIVIDE         ; 3:17      /mod})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl x = x2 u/ x1
define({UDIV},{
ifdef({USE_UDIV},,define({USE_UDIV},{}))dnl
    call UDIVIDE        ; 3:17      u/
    pop  DE             ; 1:10      u/})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl x = x2 u% x1
define({UMOD},{
ifdef({USE_UDIV},,define({USE_UDIV},{}))dnl
    call UDIVIDE        ; 3:17      umod
    ex   DE, HL         ; 1:4       umod
    pop  DE             ; 1:10      umod})dnl
dnl
dnl
dnl ( x2 x1 -- r q )
dnl x = x2 u% x1
define({UDIVMOD},{
ifdef({USE_UDIV},,define({USE_UDIV},{}))dnl
    call UDIVIDE        ; 3:17      u/mod})dnl
dnl
dnl
dnl "1+"
dnl ( x1 -- x )
dnl x = x1 + 1
define({_1ADD},{
    inc  HL             ; 1:6       1+})dnl
dnl
dnl
dnl "1-"
dnl ( x1 -- x )
dnl x = x1 - 1
define({_1SUB},{
    dec  HL             ; 1:6       1-})dnl
dnl
dnl
dnl "2+"
dnl ( x1 -- x )
dnl x = x1 + 2
define({_2ADD},{
    inc  HL             ; 1:6       2+
    inc  HL             ; 1:6       2+})dnl
dnl
dnl
dnl "2-"
dnl ( x1 -- x )
dnl x = x1 - 2
define({_2SUB},{
    dec  HL             ; 1:6       2-
    dec  HL             ; 1:6       2-})dnl
dnl
dnl
dnl "2*"
dnl ( x1 -- x )
dnl x = x1 * 2
define({_2MUL},{
    add  HL, HL         ; 1:11      2*})dnl
dnl
dnl
dnl "2/"
dnl ( x1 -- x )
dnl x = x1 / 2
define({_2DIV},{
    sra   H             ; 2:8       2/   with sign
    rr    L             ; 2:8       2/})dnl
dnl
dnl
dnl "256 *"
dnl ( x1 -- x )
dnl x = x1 * 256
define({_256MUL},{
    ld    H, L          ; 1:4       256*
    ld    L, 0x00       ; 2:7       256*})dnl
dnl
dnl
dnl "256 /"
dnl ( x1 -- x )
dnl x = x1 / 256
define({_256DIV},{
    ld    L, H          ; 1:4       256/   with sign
    rl    H             ; 2:8       256/
    sbc   A, A          ; 1:4       256/
    ld    H, A          ; 1:4       256/})dnl
dnl
dnl
dnl
dnl
define({SUM_1BITS},{define({TEMP},eval((($1) & 0x5555) + (($1) & 0xAAAA)/2)){}dnl
___{}define({TEMP},eval((TEMP & 0x3333) + (TEMP & 0xCCCC)/4)){}dnl
___{}define({TEMP},eval((TEMP & 0x0F0F) + (TEMP & 0xF0F0)/16)){}dnl
___{}eval((TEMP & 0x00FF) + (TEMP & 0xFF00)/256)})dnl
dnl
dnl
dnl
define({SUM_0BITS},{define({INV_BITS},eval(($1) | (($1) >> 1)))dnl
___{}define({INV_BITS},eval(INV_BITS | (INV_BITS >> 2)))dnl
___{}define({INV_BITS},eval(INV_BITS | (INV_BITS >> 4)))dnl
___{}define({INV_BITS},eval(INV_BITS | (INV_BITS >> 8)))dnl 
___{}define({INV_BITS},eval(INV_BITS | (INV_BITS >> 16)))dnl
___{}define({INV_BITS},eval(INV_BITS-($1)))dnl
___{}SUM_1BITS(eval(INV_BITS))})dnl
dnl
dnl
dnl
dnl
define({XMUL_LOOP},{define({XMUL_PAR},eval($1)){}define({XMUL_SUM},{1}){}_XMUL_LOOP($1)})dnl
dnl
define({_XMUL_LOOP},{ifelse(eval(XMUL_PAR>1),{1},{dnl
___{}ifelse(eval(XMUL_PAR & 1),{1},{XMUL_SAVE}){}dnl
___{}define({XMUL_PAR},eval(XMUL_PAR/2)){}dnl
___{}ifelse(dnl
___{}___{}eval(XMUL_PAR & 127),{0},{dnl
___{}___{}___{}define({XMUL_PAR},eval(XMUL_PAR/128)){}dnl
___{}___{}___{}define({XMUL_SUM},eval(XMUL_SUM*256))
    ld    H, L          ; 1:4       $1 *
    ld    L, 0x00       ; 2:7       $1 * XMUL_SUM{}x{}dnl
___{}___{}},
___{}___{}eval(((XMUL_PAR & 63)==0) && (XMUL_SUM > 1)),{1},{dnl
___{}___{}___{}define({XMUL_PAR},eval(XMUL_PAR/64)){}dnl
___{}___{}___{}define({XMUL_SUM},eval(XMUL_SUM*128))
    rr    H             ; 2:8       $1 *
    rr    L             ; 2:8       $1 *
    ld    H, L          ; 1:4       $1 *
    ld    L, 0x00       ; 2:7       $1 * XMUL_SUM{}x{}dnl
___{}___{}},
___{}___{}{define({XMUL_SUM},eval(2*XMUL_SUM)){}XMUL_2X}{}dnl
___{}){}dnl
___{}_XMUL_LOOP($1){}dnl
})})dnl
dnl
dnl
dnl
dnl
define({XMUL_NEGLOOP},{define({XMUL_PAR},eval($1-1)){}define({XMUL_SUM},{1}){}_XMUL_NEGLOOP($1)})dnl
dnl
define({_XMUL_NEGLOOP},{ifelse(eval(XMUL_PAR>=1),{1},{dnl
___{}ifelse(eval(XMUL_PAR & 1),{0},{XMUL_SAVE}){}dnl
___{}define({XMUL_PAR},eval(XMUL_PAR/2)){}dnl
___{}ifelse(dnl
___{}___{}eval(XMUL_PAR & 127),{127},{dnl
___{}___{}___{}define({XMUL_PAR},eval(XMUL_PAR/128)){}dnl
___{}___{}___{}define({XMUL_SUM},eval(XMUL_SUM*256))
    ld    H, L          ; 1:4       $1 *
    ld    L, 0x00       ; 2:7       $1 * XMUL_SUM{}x{}dnl
___{}___{}},
___{}___{}eval(((XMUL_PAR & 63)==63) && (XMUL_SUM > 1)),{1},{dnl
___{}___{}___{}define({XMUL_PAR},eval(XMUL_PAR/64)){}dnl
___{}___{}___{}define({XMUL_SUM},eval(XMUL_SUM*128))
    rr    H             ; 2:8       $1 *
    rr    L             ; 2:8       $1 *
    ld    H, L          ; 1:4       $1 *
    ld    L, 0x00       ; 2:7       $1 * XMUL_SUM{}x{}dnl
___{}___{}},
___{}___{}{define({XMUL_SUM},eval(2*XMUL_SUM)){}XMUL_2X}{}dnl
___{}){}dnl
___{}_XMUL_NEGLOOP($1){}dnl
})})dnl
dnl
dnl
dnl 
dnl "const *"
dnl ( x1 -- const*x1 )
define({PUSH_MUL},{define({XMUL_1BITS},SUM_1BITS($1)){}define({XMUL_0BITS},SUM_0BITS($1-1))dnl
dnl
dnl
ifelse(eval($1==0),{1},{
dnl n = 0
dnl

    ld   HL, 0x0000     ; 3:10      0*{}dnl
},XMUL_1BITS,{1},{dnl
dnl n = 2^a
dnl 1,2,4,8,16,32,...
dnl 
___{}define({XMUL_2X},{
    add  HL, HL         ; 1:11      $1 * XMUL_SUM{}x  Variant: 2^a{}dnl
___{}___{}define({XMUL_2X},{
    add  HL, HL         ; 1:11      $1 * XMUL_SUM{}x})})dnl
___{}XMUL_LOOP($1){}dnl
},XMUL_1BITS,{2},{dnl
dnl n = 2^a + 2^b
dnl 3,5,6,9,10,12,17,18,20,24,...
dnl Not all variants are optimal. For example, 258.
dnl
___{}define({XMUL_SAVE},{
    ld    B, H          ; 1:4       $1 * Variant: 2^a + 2^b
    ld    C, L          ; 1:4       $1 * save XMUL_SUM{}x}){}dnl
___{}define({XMUL_2X},{
    add  HL, HL         ; 1:11      $1 * XMUL_SUM{}x}){}dnl
___{}XMUL_LOOP($1)
    add  HL, BC         ; 1:11      $1 * HL + save{}dnl
},XMUL_0BITS,{1},{dnl
dnl n = 2^a - 2^b, a > b
dnl 60=64-4
dnl
___{}define({XMUL_SAVE},{
    ld    B, H          ; 1:4       $1 * Variant: 2^a - 2^b
    ld    C, L          ; 1:4       $1 * save XMUL_SUM{}x}){}dnl
___{}define({XMUL_2X},{
    add  HL, HL         ; 1:11      $1 * XMUL_SUM{}x})dnl
___{}XMUL_NEGLOOP($1)
    or    A             ; 1:4       $1 *
    sbc  HL, BC         ; 2:15      $1 * HL - save{}dnl
},XMUL_1BITS,{3},{dnl
dnl
dnl n = 2^a + 2^b + 2^c
dnl 11=8+2+1,69=64+4+1
dnl
___{}define({XMUL_SAVE},{
    ld    B, H          ; 1:4       $1 * Variant: 2^a + 2^b + 2^c
    ld    A, L          ; 1:4       $1 * save XMUL_SUM{}x{}define({XMUL_SAVE},{
    add   A, L          ; 1:4       $1 * +
    ld    C, A          ; 1:4       $1 * +
    ld    A, B          ; 1:4       $1 * +
    adc   A, H          ; 1:4       $1 * +
    ld    B, A          ; 1:4       $1 * + save XMUL_SUM{}x})}){}dnl
___{}define({XMUL_2X},{
    add  HL, HL         ; 1:11      $1 * XMUL_SUM{}x}){}dnl
___{}XMUL_LOOP($1)
    add  HL, BC         ; 1:11      $1 * HL + save{}dnl
},XMUL_0BITS,{2},{dnl
dnl
dnl n = 2^a - 2^b - 2^c, a > b > c
dnl 27=32-4-1,54=64-8-2
dnl
___{}define({XMUL_SAVE},{
    ld    B, H          ; 1:4       $1 * Variant: 2^a - 2^b - 2^c
    ld    A, L          ; 1:4       $1 * save XMUL_SUM{}x{}dnl
___{}___{}define({XMUL_SAVE},{
    add   A, L          ; 1:4       $1 *
    ld    C, A          ; 1:4       $1 * +
    ld    A, B          ; 1:4       $1 * +
    adc   A, H          ; 1:4       $1 * +
    ld    B, A          ; 1:4       $1 * + save XMUL_SUM{}x{}dnl
___{}___{}}){}dnl
___{}}){}dnl
___{}define({XMUL_2X},{
    add  HL, HL         ; 1:11      $1 * XMUL_SUM{}x}){}dnl
___{}XMUL_NEGLOOP($1)
    or    A             ; 1:4       $1 *
    sbc  HL, BC         ; 2:15      $1 * HL - save{}dnl
},eval(XMUL_1BITS <= XMUL_0BITS + 2),{1},{dnl
dnl n = 2^a + 2^b + 2^c + ...
dnl
___{}define({XMUL_SAVE},{
    ld    D, H          ; 1:4       $1 *
    ld    E, L          ; 1:4       $1 * save XMUL_SUM{}x{}dnl
___{}___{}define({XMUL_SAVE},{
    ex   DE, HL         ; 1:4       $1 * +
    add  HL, DE         ; 1:11      $1 * + save XMUL_SUM{}x
    ex   DE, HL         ; 1:4       $1 * +{}dnl
___{}___{}}){}dnl
___{}}){}dnl
___{}define({XMUL_2X},{
    add  HL, HL         ; 1:11      $1 * XMUL_SUM{}x}){}dnl
    
    ld    B, D          ; 1:4       $1 * Variant: 2^a + 2^b + 2^c + ...
    ld    C, E          ; 1:4       $1 *{}dnl
___{}XMUL_LOOP($1)
    add  HL, DE         ; 1:11      $1 * HL + save
    ld    D, B          ; 1:4       $1 *
    ld    E, C          ; 1:4       $1 *{}dnl
},{dnl
dnl 187=128+32+16+8+2+1=256-64-4-1
dnl
___{}define({XMUL_SAVE},{
    ld    D, H          ; 1:4       $1 *
    ld    E, L          ; 1:4       $1 * save XMUL_SUM{}x{}dnl
___{}___{}define({XMUL_SAVE},{
    ex   DE, HL         ; 1:4       $1 * +
    add  HL, DE         ; 1:11      $1 * + save XMUL_SUM{}x
    ex   DE, HL         ; 1:4       $1 * +{}dnl
___{}___{}}){}dnl
___{}}){}dnl
___{}define({XMUL_2X},{
    add  HL, HL         ; 1:11      $1 * XMUL_SUM{}x}){}dnl

    ld    B, D          ; 1:4       $1 * Variant: 2^a - 2^b - 2^c - ...
    ld    C, E          ; 1:4       $1 *{}dnl
___{}XMUL_NEGLOOP($1)
    or    A             ; 1:4       $1 *
    sbc  HL, DE         ; 2:15      $1 * HL - save
    ld    D, B          ; 1:4       $1 *
    ld    E, C          ; 1:4       $1 *})})dnl
dnl
dnl
dnl
