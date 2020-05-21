dnl ## Device
dnl
dnl .
dnl ( x -- )
dnl print number
define(DOT,{ifdef({USE_DOT},,define({USE_DOT},{}))
    call PRINT_NUM      ; 3:17      .})dnl
dnl
dnl
dnl .S
dnl ( x3 x2 x1 -- x3 x2 x1 )
dnl print 3 stack number 
define(DOTS,{
    ex  (SP), HL        ; 1:19      .S  ( x1 x2 x3 )
    push HL             ; 1:11      .S  ( x1 x3 x2 x3 ){}DOT                 
    push HL             ; 1:11      .S  ( x1 x2 x3 x2 ){}DOT                    
    ex  (SP), HL        ; 1:19      .S  ( x3 x2 x1 ){}DUP_DOT})dnl
dnl
dnl
dnl DUP .
dnl ( x -- )
dnl non-destructively print number
define(DUP_DOT,{
    push HL             ; 1:11      dup .   x3 x1 x2 x1{}DOT
    ex   DE, HL         ; 1:4       dup .   x3 x2 x1})dnl
dnl
dnl
dnl ( -- )
dnl new line
define(CR,{
    ld    A, 0x0D       ; 2:7       cr      Pollutes: AF, DE', BC'
    rst   0x10          ; 1:11      cr      with 48K ROM in, this will print char in A})dnl
dnl
dnl
dnl ( -- )
dnl .( char )
define(PUTCHAR,{
    ld    A, format({%-11s},$1); 2:7       putchar Pollutes: AF, DE', BC'
    rst   0x10          ; 1:11      putchar with 48K ROM in, this will print char in A})dnl
dnl
dnl
dnl ( addr n -- )
dnl print n chars from addr 
define(TYPE,{
ifdef({USE_TYPE},,define({USE_TYPE},{}))dnl
    call PRINT_STRING   ; 3:17      type
    pop  HL             ; 1:10      type
    pop  DE             ; 1:10      type})dnl
dnl
dnl
dnl ( addr n -- addr n )
dnl non-destructively print string 
define(DUP2_TYPE,{
    push DE             ; 1:11      2dup
    push HL             ; 1:11      2dup{}TYPE
    pop  HL             ; 1:10      2dup
    pop  DE             ; 1:10      2dup})dnl
dnl
dnl
define(PRINT_COUNT,100)dnl
pushdef({ALL_STRING_STACK},{})dnl
dnl
dnl ( -- )
dnl print ( sring )
define(PRINT,{define({PRINT_COUNT}, incr(PRINT_COUNT))
    push DE             ; 1:11      print
    push HL             ; 1:11      print
    ld    L, 0x1A       ; 2:7       print Upper screen
    call 0x1605         ; 3:17      print Open channel
    ld   BC, size{}PRINT_COUNT    ; 3:10      print Length of string to print
    ld   DE, string{}PRINT_COUNT  ; 3:10      print Address of string
    call 0x203C         ; 3:17      print Print our string
    pop  HL             ; 1:10      print
    pop  DE             ; 1:10      print
pushdef({STRING_STACK},{$@})define({ALL_STRING_STACK},{string}PRINT_COUNT{:
db STRING_POP
size}PRINT_COUNT{ EQU $ - string}PRINT_COUNT
ALL_STRING_STACK)})dnl
dnl
dnl