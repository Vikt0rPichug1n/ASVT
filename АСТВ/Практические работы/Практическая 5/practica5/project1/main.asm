$MOD51

        ORG     00H
        LJMP    START

        ORG     100H
START:
        MOV     P0, #0FFH
        MOV     P1, #0F0H
        MOV     P2, #00H
        
        ; ===== TIMER CONFIGURATION =====
        MOV     TMOD, #01H       ; Timer0 mode 1 (16-bit timer)
        
        ; ===== LCD INITIALIZATION =====
        MOV     P0, #038H
        MOV     P2, #1
        MOV     P2, #0
        MOV     R5, #2           ; 10ms delay
        LCALL   DELAY_MS
        
        MOV     P0, #00CH
        MOV     P2, #1
        MOV     P2, #0
        MOV     R5, #1           ; 5ms delay
        LCALL   DELAY_MS
        
        MOV     P0, #001H
        MOV     P2, #1
        MOV     P2, #0
        MOV     R5, #2           ; 10ms delay
        LCALL   DELAY_MS
        
        MOV     P0, #080H
        MOV     P2, #1
        MOV     P2, #0
        MOV     R5, #1           ; 5ms delay
        LCALL   DELAY_MS

;=============================================================================
; Main loop
;=============================================================================
MAIN:
        LCALL   GET_KEY
        CJNE    A, #0FFH, SHOW
        SJMP    MAIN

SHOW:
        ; Clear display
        MOV     P0, #001H
        MOV     P2, #1
        MOV     P2, #0
        MOV     R5, #1           ; 5ms delay
        LCALL   DELAY_MS
        
        ; Set cursor to start
        MOV     P0, #080H
        MOV     P2, #1
        MOV     P2, #0
        
        ; Show pressed key
        MOV     P0, A
        MOV     P2, #3
        MOV     P2, #2
        
        ; ===== WAIT FOR KEY TO BE RELEASED =====
WAIT_RELEASE:
        LCALL   GET_KEY
        CJNE    A, #0FFH, WAIT_RELEASE
        
        ; Delay after release (10ms)
        MOV     R5, #2           ; 2 x 5ms = 10ms
        LCALL   DELAY_MS
        
        SJMP    MAIN

;=============================================================================
; TIMER DELAY FUNCTION (5ms base)
; Input: R5 = number of 5ms intervals
;=============================================================================
DELAY_MS:
DELAY_LOOP:
        ; Load timer for 5ms (5000 ticks at 12MHz)
        ; 65536 - 5000 = 60536 = 0xEC78
        MOV     TH0, #0ECH       ; High byte: 0xEC
        MOV     TL0, #078H       ; Low byte: 0x78
        CLR     TF0              ; Clear overflow flag
        SETB    TR0              ; Start timer
        
WAIT_TICK:
        JNB     TF0, WAIT_TICK   ; Wait for overflow (TF0 becomes 1)
        CLR     TR0              ; Stop timer
        CLR     TF0              ; Clear flag for next use
        
        DJNZ    R5, DELAY_LOOP   ; Repeat R5 times
        RET

;=============================================================================
; KEYPAD SCANNING
;=============================================================================
GET_KEY:
        ; Scan column 0 (P1.0 = 0)
        MOV     P1, #0F0H
        CLR     P1.0
        SETB    P1.1
        SETB    P1.2
        SETB    P1.3
        MOV     R5, #1           ; 5ms delay for signal stabilization
        LCALL   DELAY_MS
        MOV     A, P1
        ANL     A, #0F0H
        CJNE    A, #0F0H, FOUND0
        
        ; Scan column 1 (P1.1 = 0)
        MOV     P1, #0F0H
        SETB    P1.0
        CLR     P1.1
        SETB    P1.2
        SETB    P1.3
        MOV     R5, #1           ; 5ms delay
        LCALL   DELAY_MS
        MOV     A, P1
        ANL     A, #0F0H
        CJNE    A, #0F0H, FOUND1
        
        ; Scan column 2 (P1.2 = 0)
        MOV     P1, #0F0H
        SETB    P1.0
        SETB    P1.1
        CLR     P1.2
        SETB    P1.3
        MOV     R5, #1           ; 5ms delay
        LCALL   DELAY_MS
        MOV     A, P1
        ANL     A, #0F0H
        CJNE    A, #0F0H, FOUND2
        
        ; Scan column 3 (P1.3 = 0)
        MOV     P1, #0F0H
        SETB    P1.0
        SETB    P1.1
        SETB    P1.2
        CLR     P1.3
        MOV     R5, #1           ; 5ms delay
        LCALL   DELAY_MS
        MOV     A, P1
        ANL     A, #0F0H
        CJNE    A, #0F0H, FOUND3
        
        MOV     A, #0FFH         ; No key pressed
        RET

;=============================================================================
; KEY DETECTION FOR COLUMN 0
;=============================================================================
FOUND0:
        CJNE    A, #0E0H, F0_R2
        MOV     A, #31H           ; '1'
        RET
F0_R2:  CJNE    A, #0D0H, F0_R3
        MOV     A, #34H           ; '4'
        RET
F0_R3:  CJNE    A, #0B0H, F0_R4
        MOV     A, #37H           ; '7'
        RET
F0_R4:  CJNE    A, #070H, F0_END
        MOV     A, #2AH           ; '*'
        RET
F0_END: MOV     A, #0FFH
        RET

;=============================================================================
; KEY DETECTION FOR COLUMN 1
;=============================================================================
FOUND1:
        CJNE    A, #0E0H, F1_R2
        MOV     A, #32H           ; '2'
        RET
F1_R2:  CJNE    A, #0D0H, F1_R3
        MOV     A, #35H           ; '5'
        RET
F1_R3:  CJNE    A, #0B0H, F1_R4
        MOV     A, #38H           ; '8'
        RET
F1_R4:  CJNE    A, #070H, F1_END
        MOV     A, #30H           ; '0'
        RET
F1_END: MOV     A, #0FFH
        RET

;=============================================================================
; KEY DETECTION FOR COLUMN 2
;=============================================================================
FOUND2:
        CJNE    A, #0E0H, F2_R2
        MOV     A, #33H           ; '3'
        RET
F2_R2:  CJNE    A, #0D0H, F2_R3
        MOV     A, #36H           ; '6'
        RET
F2_R3:  CJNE    A, #0B0H, F2_R4
        MOV     A, #39H           ; '9'
        RET
F2_R4:  CJNE    A, #070H, F2_END
        MOV     A, #23H           ; '#'
        RET
F2_END: MOV     A, #0FFH
        RET

;=============================================================================
; KEY DETECTION FOR COLUMN 3
;=============================================================================
FOUND3:
        CJNE    A, #0E0H, F3_R2
        MOV     A, #41H           ; 'A'
        RET
F3_R2:  CJNE    A, #0D0H, F3_R3
        MOV     A, #42H           ; 'B'
        RET
F3_R3:  CJNE    A, #0B0H, F3_R4
        MOV     A, #43H           ; 'C'
        RET
F3_R4:  CJNE    A, #070H, F3_END
        MOV     A, #44H           ; 'D'
        RET
F3_END: MOV     A, #0FFH
        RET

        END