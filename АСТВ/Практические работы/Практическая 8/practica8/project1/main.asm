$MOD51

ORG 0H
    MOV P0, #0FFH      
    MOV P1, #0FFH      
    MOV P2, #00H       

MAIN:
    CLR P3.6
    SETB P3.6
    CLR P3.6
    JB P3.7, $
    
    MOV A, P0          
    CLR C
    SUBB A, #128       
    MOV A, P1          
    JC SKIP            
    ADD A, #1          
SKIP:
    MOV P2, A          
    
    SJMP MAIN

END