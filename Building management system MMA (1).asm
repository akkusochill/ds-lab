ORG 0000H

START:

; =====================================================
; STORE LCD MESSAGES IN RAM
; =====================================================

; -------- NORMAL --------
MOV 30H,#'S'
MOV 31H,#'Y'
MOV 32H,#'S'
MOV 33H,#'T'
MOV 34H,#'E'
MOV 35H,#'M'
MOV 36H,#' '
MOV 37H,#'N'
MOV 38H,#'O'
MOV 39H,#'R'
MOV 3AH,#'M'
MOV 3BH,#'A'
MOV 3CH,#'L'
MOV 3DH,#00H

MOV 40H,#'L'
MOV 41H,#'I'
MOV 42H,#'G'
MOV 43H,#'H'
MOV 44H,#'T'
MOV 45H,#' '
MOV 46H,#'O'
MOV 47H,#'F'
MOV 48H,#'F'
MOV 49H,#00H


; -------- RAIN --------
MOV 50H,#'R'
MOV 51H,#'A'
MOV 52H,#'I'
MOV 53H,#'N'
MOV 54H,#' '
MOV 55H,#'D'
MOV 56H,#'E'
MOV 57H,#'T'
MOV 58H,#'E'
MOV 59H,#'C'
MOV 5AH,#'T'
MOV 5BH,#'E'
MOV 5CH,#'D'
MOV 5DH,#00H


; -------- SMOKE --------
MOV 60H,#'S'
MOV 61H,#'M'
MOV 62H,#'O'
MOV 63H,#'K'
MOV 64H,#'E'
MOV 65H,#' '
MOV 66H,#'D'
MOV 67H,#'E'
MOV 68H,#'T'
MOV 69H,#'E'
MOV 6AH,#'C'
MOV 6BH,#'T'
MOV 6CH,#'E'
MOV 6DH,#'D'
MOV 6EH,#00H


; -------- ALERT --------
MOV 70H,#'!'
MOV 71H,#'!'
MOV 72H,#'!'
MOV 73H,#' '
MOV 74H,#'A'
MOV 75H,#'L'
MOV 76H,#'E'
MOV 77H,#'R'
MOV 78H,#'T'
MOV 79H,#' '
MOV 7AH,#'!'
MOV 7BH,#'!'
MOV 7CH,#'!'
MOV 7DH,#00H


; =====================================================
; LCD INITIALIZATION
; =====================================================

CLR P1.3

; Function Set - first time
CLR P1.7
CLR P1.6
SETB P1.5
CLR P1.4

SETB P1.2
CLR P1.2

ACALL DELAY

; Function Set - second time
SETB P1.2
CLR P1.2

; Complete 4-bit function set
SETB P1.7

SETB P1.2
CLR P1.2

ACALL DELAY


; =====================================================
; ENTRY MODE
; =====================================================

CLR P1.7
CLR P1.6
CLR P1.5
CLR P1.4

SETB P1.2
CLR P1.2

SETB P1.6
SETB P1.5

SETB P1.2
CLR P1.2

ACALL DELAY


; =====================================================
; DISPLAY ON
; =====================================================

CLR P1.7
CLR P1.6
CLR P1.5
CLR P1.4

SETB P1.2
CLR P1.2

SETB P1.7
SETB P1.6
SETB P1.5
SETB P1.4

SETB P1.2
CLR P1.2

ACALL DELAY


; =====================================================
; MAIN PROGRAM
; =====================================================

MAIN:

; Check SMOKE first
; P2.1 = 0 means switch closed

JB P2.1,CHECK_RAIN

ACALL SHOW_SMOKE

SJMP MAIN


; =====================================================
; CHECK RAIN
; =====================================================

CHECK_RAIN:

; P2.0 = 0 means rain detected

JB P2.0,SHOW_NORMAL

ACALL SHOW_RAIN

SJMP MAIN


; =====================================================
; NORMAL DISPLAY
; =====================================================

SHOW_NORMAL:

ACALL LCD_CLEAR

; First line
CLR P1.3

MOV A,#80H
ACALL LCD_CMD

SETB P1.3

MOV R1,#30H

NORMAL_LINE1:

MOV A,@R1
JZ NORMAL_LINE2

ACALL SEND_CHAR

INC R1
SJMP NORMAL_LINE1


NORMAL_LINE2:

CLR P1.3

MOV A,#0C0H
ACALL LCD_CMD

SETB P1.3

MOV R1,#40H

NORMAL_PRINT2:

MOV A,@R1
JZ NORMAL_DONE

ACALL SEND_CHAR

INC R1
SJMP NORMAL_PRINT2


NORMAL_DONE:

ACALL LONG_DELAY

RET


; =====================================================
; RAIN DISPLAY
; =====================================================

SHOW_RAIN:

ACALL LCD_CLEAR

; First line
CLR P1.3

MOV A,#80H
ACALL LCD_CMD

SETB P1.3

MOV R1,#50H

RAIN_LINE1:

MOV A,@R1
JZ RAIN_LINE2

ACALL SEND_CHAR

INC R1
SJMP RAIN_LINE1


RAIN_LINE2:

CLR P1.3

MOV A,#0C0H
ACALL LCD_CMD

SETB P1.3

MOV R1,#30H

RAIN_PRINT2:

MOV A,@R1
JZ RAIN_DONE

ACALL SEND_CHAR

INC R1
SJMP RAIN_PRINT2


RAIN_DONE:

ACALL LONG_DELAY

RET


; =====================================================
; SMOKE DISPLAY
; =====================================================

SHOW_SMOKE:

ACALL LCD_CLEAR

; First line
CLR P1.3

MOV A,#80H
ACALL LCD_CMD

SETB P1.3

MOV R1,#60H

SMOKE_LINE1:

MOV A,@R1
JZ SMOKE_LINE2

ACALL SEND_CHAR

INC R1
SJMP SMOKE_LINE1


SMOKE_LINE2:

CLR P1.3

MOV A,#0C0H
ACALL LCD_CMD

SETB P1.3

MOV R1,#70H

SMOKE_PRINT2:

MOV A,@R1
JZ SMOKE_DONE

ACALL SEND_CHAR

INC R1
SJMP SMOKE_PRINT2


SMOKE_DONE:

ACALL LONG_DELAY

RET


; =====================================================
; LCD CLEAR
; =====================================================

LCD_CLEAR:

CLR P1.3

MOV A,#01H
ACALL LCD_CMD

ACALL LONG_DELAY

RET


; =====================================================
; LCD COMMAND
; =====================================================

LCD_CMD:

; High nibble

MOV C,ACC.7
MOV P1.7,C

MOV C,ACC.6
MOV P1.6,C

MOV C,ACC.5
MOV P1.5,C

MOV C,ACC.4
MOV P1.4,C

CLR P1.3

SETB P1.2
CLR P1.2


; Low nibble

MOV C,ACC.3
MOV P1.7,C

MOV C,ACC.2
MOV P1.6,C

MOV C,ACC.1
MOV P1.5,C

MOV C,ACC.0
MOV P1.4,C

CLR P1.3

SETB P1.2
CLR P1.2

ACALL DELAY

RET


; =====================================================
; SEND CHARACTER
; =====================================================

SEND_CHAR:

; High nibble

MOV C,ACC.7
MOV P1.7,C

MOV C,ACC.6
MOV P1.6,C

MOV C,ACC.5
MOV P1.5,C

MOV C,ACC.4
MOV P1.4,C

SETB P1.3

SETB P1.2
CLR P1.2


; Low nibble

MOV C,ACC.3
MOV P1.7,C

MOV C,ACC.2
MOV P1.6,C

MOV C,ACC.1
MOV P1.5,C

MOV C,ACC.0
MOV P1.4,C

SETB P1.3

SETB P1.2
CLR P1.2

ACALL DELAY

RET


; =====================================================
; SHORT DELAY
; =====================================================

DELAY:

MOV R0,#50

D1:
DJNZ R0,D1

RET


; =====================================================
; LONG DELAY
; =====================================================

LONG_DELAY:

MOV R6,#20

LD1:
MOV R7,#255

LD2:
DJNZ R7,LD2
DJNZ R6,LD1

RET


END
ORG 0000H

START:

; =====================================================
; STORE LCD MESSAGES IN RAM
; =====================================================

; -------- NORMAL --------
MOV 30H,#'S'
MOV 31H,#'Y'
MOV 32H,#'S'
MOV 33H,#'T'
MOV 34H,#'E'
MOV 35H,#'M'
MOV 36H,#' '
MOV 37H,#'N'
MOV 38H,#'O'
MOV 39H,#'R'
MOV 3AH,#'M'
MOV 3BH,#'A'
MOV 3CH,#'L'
MOV 3DH,#00H

MOV 40H,#'L'
MOV 41H,#'I'
MOV 42H,#'G'
MOV 43H,#'H'
MOV 44H,#'T'
MOV 45H,#' '
MOV 46H,#'O'
MOV 47H,#'F'
MOV 48H,#'F'
MOV 49H,#00H


; -------- RAIN --------
MOV 50H,#'R'
MOV 51H,#'A'
MOV 52H,#'I'
MOV 53H,#'N'
MOV 54H,#' '
MOV 55H,#'D'
MOV 56H,#'E'
MOV 57H,#'T'
MOV 58H,#'E'
MOV 59H,#'C'
MOV 5AH,#'T'
MOV 5BH,#'E'
MOV 5CH,#'D'
MOV 5DH,#00H


; -------- SMOKE --------
MOV 60H,#'S'
MOV 61H,#'M'
MOV 62H,#'O'
MOV 63H,#'K'
MOV 64H,#'E'
MOV 65H,#' '
MOV 66H,#'D'
MOV 67H,#'E'
MOV 68H,#'T'
MOV 69H,#'E'
MOV 6AH,#'C'
MOV 6BH,#'T'
MOV 6CH,#'E'
MOV 6DH,#'D'
MOV 6EH,#00H


; -------- ALERT --------
MOV 70H,#'!'
MOV 71H,#'!'
MOV 72H,#'!'
MOV 73H,#' '
MOV 74H,#'A'
MOV 75H,#'L'
MOV 76H,#'E'
MOV 77H,#'R'
MOV 78H,#'T'
MOV 79H,#' '
MOV 7AH,#'!'
MOV 7BH,#'!'
MOV 7CH,#'!'
MOV 7DH,#00H


; =====================================================
; LCD INITIALIZATION
; =====================================================

CLR P1.3

; Function Set - first time
CLR P1.7
CLR P1.6
SETB P1.5
CLR P1.4

SETB P1.2
CLR P1.2

ACALL DELAY

; Function Set - second time
SETB P1.2
CLR P1.2

; Complete 4-bit function set
SETB P1.7

SETB P1.2
CLR P1.2

ACALL DELAY


; =====================================================
; ENTRY MODE
; =====================================================

CLR P1.7
CLR P1.6
CLR P1.5
CLR P1.4

SETB P1.2
CLR P1.2

SETB P1.6
SETB P1.5

SETB P1.2
CLR P1.2

ACALL DELAY


; =====================================================
; DISPLAY ON
; =====================================================

CLR P1.7
CLR P1.6
CLR P1.5
CLR P1.4

SETB P1.2
CLR P1.2

SETB P1.7
SETB P1.6
SETB P1.5
SETB P1.4

SETB P1.2
CLR P1.2

ACALL DELAY


; =====================================================
; MAIN PROGRAM
; =====================================================

MAIN:

; Check SMOKE first
; P2.1 = 0 means switch closed

JB P2.1,CHECK_RAIN

ACALL SHOW_SMOKE

SJMP MAIN


; =====================================================
; CHECK RAIN
; =====================================================

CHECK_RAIN:

; P2.0 = 0 means rain detected

JB P2.0,SHOW_NORMAL

ACALL SHOW_RAIN

SJMP MAIN


; =====================================================
; NORMAL DISPLAY
; =====================================================

SHOW_NORMAL:

ACALL LCD_CLEAR

; First line
CLR P1.3

MOV A,#80H
ACALL LCD_CMD

SETB P1.3

MOV R1,#30H

NORMAL_LINE1:

MOV A,@R1
JZ NORMAL_LINE2

ACALL SEND_CHAR

INC R1
SJMP NORMAL_LINE1


NORMAL_LINE2:

CLR P1.3

MOV A,#0C0H
ACALL LCD_CMD

SETB P1.3

MOV R1,#40H

NORMAL_PRINT2:

MOV A,@R1
JZ NORMAL_DONE

ACALL SEND_CHAR

INC R1
SJMP NORMAL_PRINT2


NORMAL_DONE:

ACALL LONG_DELAY

RET


; =====================================================
; RAIN DISPLAY
; =====================================================

SHOW_RAIN:

ACALL LCD_CLEAR

; First line
CLR P1.3

MOV A,#80H
ACALL LCD_CMD

SETB P1.3

MOV R1,#50H

RAIN_LINE1:

MOV A,@R1
JZ RAIN_LINE2

ACALL SEND_CHAR

INC R1
SJMP RAIN_LINE1


RAIN_LINE2:

CLR P1.3

MOV A,#0C0H
ACALL LCD_CMD

SETB P1.3

MOV R1,#30H

RAIN_PRINT2:

MOV A,@R1
JZ RAIN_DONE

ACALL SEND_CHAR

INC R1
SJMP RAIN_PRINT2


RAIN_DONE:

ACALL LONG_DELAY

RET


; =====================================================
; SMOKE DISPLAY
; =====================================================

SHOW_SMOKE:

ACALL LCD_CLEAR

; First line
CLR P1.3

MOV A,#80H
ACALL LCD_CMD

SETB P1.3

MOV R1,#60H

SMOKE_LINE1:

MOV A,@R1
JZ SMOKE_LINE2

ACALL SEND_CHAR

INC R1
SJMP SMOKE_LINE1


SMOKE_LINE2:

CLR P1.3

MOV A,#0C0H
ACALL LCD_CMD

SETB P1.3

MOV R1,#70H

SMOKE_PRINT2:

MOV A,@R1
JZ SMOKE_DONE

ACALL SEND_CHAR

INC R1
SJMP SMOKE_PRINT2


SMOKE_DONE:

ACALL LONG_DELAY

RET


; =====================================================
; LCD CLEAR
; =====================================================

LCD_CLEAR:

CLR P1.3

MOV A,#01H
ACALL LCD_CMD

ACALL LONG_DELAY

RET


; =====================================================
; LCD COMMAND
; =====================================================

LCD_CMD:

; High nibble

MOV C,ACC.7
MOV P1.7,C

MOV C,ACC.6
MOV P1.6,C

MOV C,ACC.5
MOV P1.5,C

MOV C,ACC.4
MOV P1.4,C

CLR P1.3

SETB P1.2
CLR P1.2


; Low nibble

MOV C,ACC.3
MOV P1.7,C

MOV C,ACC.2
MOV P1.6,C

MOV C,ACC.1
MOV P1.5,C

MOV C,ACC.0
MOV P1.4,C

CLR P1.3

SETB P1.2
CLR P1.2

ACALL DELAY

RET


; =====================================================
; SEND CHARACTER
; =====================================================

SEND_CHAR:

; High nibble

MOV C,ACC.7
MOV P1.7,C

MOV C,ACC.6
MOV P1.6,C

MOV C,ACC.5
MOV P1.5,C

MOV C,ACC.4
MOV P1.4,C

SETB P1.3

SETB P1.2
CLR P1.2


; Low nibble

MOV C,ACC.3
MOV P1.7,C

MOV C,ACC.2
MOV P1.6,C

MOV C,ACC.1
MOV P1.5,C

MOV C,ACC.0
MOV P1.4,C

SETB P1.3

SETB P1.2
CLR P1.2

ACALL DELAY

RET


; =====================================================
; SHORT DELAY
; =====================================================

DELAY:

MOV R0,#50

D1:
DJNZ R0,D1

RET


; =====================================================
; LONG DELAY
; =====================================================

LONG_DELAY:

MOV R6,#20

LD1:
MOV R7,#255

LD2:
DJNZ R7,LD2
DJNZ R6,LD1

RET


END