dnl ## Logic
dnl
dnl ( x1 x2 -- x )
dnl x = x1 & x2
define(AND,{
    ld    A, E          ; 1:4       and
    and   L             ; 1:4       and
    ld    L, A          ; 1:4       and
    ld    A, D          ; 1:4       and
    and   H             ; 1:4       and
    ld    H, A          ; 1:4       and
    pop  DE             ; 1:10      and})dnl    
dnl
dnl ( x1 x2 -- x )
dnl x = x1 | x2
define(OR,{
    ld    A, E          ; 1:4       or
    or    L             ; 1:4       or
    ld    L, A          ; 1:4       or
    ld    A, D          ; 1:4       or
    or    H             ; 1:4       or
    ld    H, A          ; 1:4       or
    pop  DE             ; 1:10      or})dnl
dnl
dnl ( x1 x2 -- x )
dnl x = x1 ^ x2
define(XOR,{
    ld    A, E          ; 1:4       xor
    xor   L             ; 1:4       xor
    ld    L, A          ; 1:4       xor
    ld    A, D          ; 1:4       xor
    xor   H             ; 1:4       xor
    ld    H, A          ; 1:4       xor
    pop  DE             ; 1:10      xor})dnl
dnl
dnl ( x1 -- x )
dnl x = ~x1
define(INVERT,{
    ld    A, L          ; 1:4       invert
    cpl                 ; 1:4       invert
    ld    L, A          ; 1:4       invert
    ld    A, H          ; 1:4       invert
    cpl                 ; 1:4       invert
    ld    H, A          ; 1:4       invert})dnl
dnl
dnl -------------------------------------
dnl
dnl ( -- x )
dnl x = 0xFFFF
define(TRUE,{
    push DE             ; 1:11      true
    ex   DE, HL         ; 1:4       true
    ld   HL, 0xffff     ; 3:10      true})dnl
dnl
dnl ( -- x )
dnl x = 0
define(FALSE,{
    push DE             ; 1:11      false
    ex   DE, HL         ; 1:4       false
    ld   HL, 0x0000     ; 3:10      false})dnl
dnl
dnl --------- nedestruktivni ------------
dnl
dnl ( x -- x )
dnl set zero flag ( x | x )
define(CP0,{
    ld    A, H          ; 1:4       cp0
    or    L             ; 1:4       cp0})dnl
dnl
dnl ------------ 32 bitove --------------
dnl
dnl ( x2 x1 -- x2 x1 )
dnl if ( x1x2 ) x = 0; else x = 0xFFFF;
dnl set zero flag ( x1x2 | x1x2 )
define(DCP0,{
    ld    A, H          ; 1:4       dcp0
    or    L             ; 1:4       dcp0
    or    D             ; 1:4       dcp0
    or    E             ; 1:4       dcp0})dnl
dnl
dnl -------------------------------------
dnl
dnl ( x1 -- x )
dnl if ( x1 ) x = 0; else x = 0xFFFF;
dnl 0 if not equal to zero, -1 if equal
define(EQ0,{
    ld    A, H          ; 1:4       eq0
    or    L             ; 1:4       eq0
    ld   HL, 0x0000     ; 3:10      eq0
    jr   nz, $+3        ; 2:7/12    eq0
    dec  HL             ; 1:6       eq0})dnl
dnl
dnl ( x1 -- x )
dnl if ( x1 ) x = 0; else x = 0xFFFF;
dnl 0 if equal to zero, -1 if not equal
dnl Lepsi nepouzivat! Neni potreba, protoze cokoliv nenuloveho je TRUE.
define(NE0,{
    .warning Better not to use! No need, because anything non-zero is TRUE.
    ld    A, H          ; 1:4       ne0
    or    L             ; 1:4       ne0
    jr    z, $+5        ; 2:7/12    ne0
    ld   HL, 0xFFFF     ; 3:10      ne0})dnl
dnl
dnl ------------ signed -----------------
dnl
dnl
dnl =
dnl ( x1 x2 -- x )
dnl equal ( x1 == x2 )
define({EQ},{
    or    A             ; 1:4       eq
    sbc  HL, DE         ; 2:15      eq
    ld   HL, 0x0000     ; 3:10      eq
    jr   nz, $+3        ; 2:7/12    eq
    dec  HL             ; 1:6       eq
    pop  DE             ; 1:10      eq})dnl
dnl
dnl
dnl <>
dnl ( x1 x2 -- x )
dnl not equal ( x1 <> x2 )
define({NE},{
    or    A             ; 1:4       <>
    sbc  HL, DE         ; 2:15      <>
    jr    z, $+5        ; 2:7/12    <>
    ld   HL, 0xFFFF     ; 3:10      <>
    pop  DE             ; 1:10      <>})dnl
dnl
dnl
dnl <
dnl ( x2 x1 -- x )
dnl signed ( x2 < x1 ) --> ( x2 - x1 < 0 ) --> carry is true
define(LT,{
    ld    A, H          ; 1:4       <
    xor   D             ; 1:4       <
    jp    p, $+7        ; 3:10      <
    rl    D             ; 2:8       < sign x2
    jr   $+5            ; 2:12      <
    ex   DE, HL         ; 1:4       <
    sbc  HL, DE         ; 2:15      <
    sbc  HL, HL         ; 2:15      <
    pop  DE             ; 1:10      <})dnl
dnl
dnl
dnl <=
dnl ( x2 x1 -- x )
dnl signed ( x2 <= x1 ) --> ( x2 - 1 < x1 ) --> ( x2 - x1 - 1 < 0 ) --> carry is true
define(LE,{
    ld    A, H          ; 1:4       <=
    xor   D             ; 1:4       <=
    jp    p, $+7        ; 3:10      <=
    rl    D             ; 2:8       <= sign x2
    jr   $+6            ; 2:12      <=
    scf                 ; 1:4       <=
    ex   DE, HL         ; 1:4       <=
    sbc  HL, DE         ; 2:15      <=
    sbc  HL, HL         ; 2:15      <=
    pop  DE             ; 1:10      <=})dnl
dnl
dnl
dnl >
dnl ( x2 x1 -- x )
dnl signed ( x2 > x1 ) --> ( 0 > x1 - x2 ) --> carry is true
define(GT,{
    ld    A, H          ; 1:4       >
    xor   D             ; 1:4       >
    jp    p, $+7        ; 3:10      >
    rl    H             ; 2:8       > sign x1
    jr   $+4            ; 2:12      >
    sbc  HL, DE         ; 2:15      >
    sbc  HL, HL         ; 2:15      >
    pop  DE             ; 1:10      >})dnl
dnl
dnl
dnl >=
dnl ( x2 x1 -- x )
dnl signed ( x2 >= x1 ) --> ( x2 + 1 > x1 ) --> ( 0 > x1 - x2 - 1 ) --> carry is true
define({GE},{
    ld    A, H          ; 1:4       <
    xor   D             ; 1:4       <
    jp    p, $+7        ; 3:10      <
    rl    H             ; 2:8       < sign x1
    jr   $+5            ; 2:12      <
    scf                 ; 1:4       <
    sbc  HL, DE         ; 2:15      <
    sbc  HL, HL         ; 2:15      <
    pop  DE             ; 1:10      <})dnl
dnl
dnl ------------ unsigned ---------------
dnl
dnl ( x1 x2 -- x )
dnl equal ( x1 == x2 )
define({UEQ},{EQ})dnl
dnl
dnl ( x1 x2 -- x )
dnl not equal ( x1 <> x2 )
define({UNE},{NE})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl unsigned ( x2 < x1 ) --> ( x2 - x1 < 0 ) --> carry is true
define(ULT,{
    or    A             ; 1:4       (u) <
    ex   DE, HL         ; 1:4       (u) <
    sbc  HL, DE         ; 2:15      (u) <
    sbc  HL, HL         ; 2:15      (u) <
    pop  DE             ; 1:10      (u) <})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl unsigned ( x2 <= x1 ) --> ( x2 - 1 < x1 ) --> ( x2 - x1 - 1 < 0) --> carry is true
define(ULE,{
    scf                 ; 1:4       (u) <=
    ex   DE, HL         ; 1:4       (u) <=
    sbc  HL, DE         ; 2:15      (u) <=
    sbc  HL, HL         ; 2:15      (u) <=
    pop  DE             ; 1:10      (u) <=})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl unsigned ( x2 > x1 ) --> ( 0 > x1 - x2 ) --> carry is true
define(UGT,{
    or    A             ; 1:4       (u) >
    sbc  HL, DE         ; 2:15      (u) >
    sbc  HL, HL         ; 2:15      (u) >
    pop  DE             ; 1:10      (u) >})dnl
dnl
dnl
dnl ( x2 x1 -- x )
dnl unsigned ( x2 >= x1 ) --> ( x2 + 1 > x1 ) --> ( 0 > x1 - x2 - 1 ) --> carry is true
define(UGE,{
    scf                 ; 1:4       (u) >=
    sbc  HL, DE         ; 2:15      (u) >=
    sbc  HL, HL         ; 2:15      (u) >=
    pop  DE             ; 1:10      (u) >=})dnl
dnl
dnl ------------- shifts ----------------
dnl
dnl ( x u -- x)
dnl shifts x left u places
define(LSHIFT,{
    .warning Nedodelano...
})dnl
dnl
dnl ( x u -- x)
dnl shifts x right u places
define(RSHIFT,{
    .warning Nedodelano...
})dnl
dnl
dnl
dnl <<
dnl ( x u -- x)
dnl shifts x left u places
define(XLSHIFT1,{
    add  HL, HL         ; 1:11      xlshift1})dnl
dnl
dnl
dnl >>
dnl ( x u -- x)
dnl shifts x right u places
define(XRSHIFT1,{
    sra   H             ; 2:8       xrshift1 signed
    rr    L             ; 2:8       xrshift1})dnl
dnl
dnl
dnl
dnl u<<
dnl ( x u -- x)
dnl shifts x left u places
define(XULSHIFT1,{
    add  HL, HL         ; 1:11      xulshift1})dnl
dnl
dnl
dnl u>>
dnl ( x u -- x)
dnl shifts x right u places
define(XURSHIFT1,{
    srl   H             ; 2:8       xurshift1 unsigned
    rr    L             ; 2:8       xurshift1})dnl
dnl
dnl