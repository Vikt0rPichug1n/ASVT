$MOD51
ORG 00h



START:
 
        MOV P0, #038h
        MOV P2, #1
        MOV P2, #0

        MOV P0, #00Ch
        MOV P2, #1
        MOV P2, #0

        MOV P0, #006h
        MOV P2, #1
        MOV P2, #0

        MOV P0, #001h
        MOV P2, #1
        MOV P2, #0

        MOV R7, #0FFh
DELAY:  DJNZ R7, DELAY

        MOV R0, #0              
        MOV R1, #0             

MAIN_LOOP:
        MOV A, R1
        CJNE A, #0, LINE2

LINE1:

        MOV P0, #001h
        MOV P2, #1
        MOV P2, #0


        MOV A, #080h
        ADD A, R0               
        MOV P0, A
        MOV P2, #1
        MOV P2, #0


        MOV P0, #162
        MOV P2, #3
        MOV P2, #2


        MOV P0, #169
        MOV P2, #3
        MOV P2, #2


        MOV P0, #171
        MOV P2, #3
        MOV P2, #2


        MOV P0, #179
        MOV P2, #3
        MOV P2, #2


        MOV P0, #175
        MOV P2, #3
        MOV P2, #2


        MOV P0, #177
        MOV P2, #3
        MOV P2, #2

        MOV R7, #0FFh
WAIT1:  DJNZ R7, WAIT1

        INC R0
        MOV A, R0
        CJNE A, #3, NOT_END1     
        LJMP END_LINE1
NOT_END1:
        LJMP MAIN_LOOP

END_LINE1:
        MOV R0, #0
        MOV R1, #1
        LJMP MAIN_LOOP

LINE2:
    
        MOV P0, #001h
        MOV P2, #1
        MOV P2, #0

       
        MOV A, #0C0h
        ADD A, R0               
        MOV P0, A
        MOV P2, #1
        MOV P2, #0

      
        MOV P0, #162
        MOV P2, #3
        MOV P2, #2

        
        MOV P0, #169
        MOV P2, #3
        MOV P2, #2

       
        MOV P0, #171
        MOV P2, #3
        MOV P2, #2

       
        MOV P0, #179
        MOV P2, #3
        MOV P2, #2

       
        MOV P0, #175
        MOV P2, #3
        MOV P2, #2

       
        MOV P0, #177
        MOV P2, #3
        MOV P2, #2

        MOV R7, #0FFh
WAIT2:  DJNZ R7, WAIT2

        INC R0
        MOV A, R0
        CJNE A, #3, NOT_END2
        LJMP END_LINE2
NOT_END2:
        LJMP MAIN_LOOP

END_LINE2:
        MOV R0, #0
        MOV R1, #0
        LJMP MAIN_LOOP

        END