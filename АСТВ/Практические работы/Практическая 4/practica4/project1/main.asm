$MOD51
jmp start

org 0bh
clr tcon.4
reti

org 20h
start:
clr c
mov tmod,#01h
setb ie.7
setb ie.1
mov p1,#0h

met1:

mov a,#08h
mov p1,a
mov r2,#30          
lcall delay


mov a,#14h
mov p1,a
mov r2,#20         
lcall delay


mov a,#22h
mov p1,a
mov r2,#50          
lcall delay


mov a,#41h
mov p1,a
mov r2,#70          
lcall delay


mov a,#80h
mov p1,a
mov r2,#30          
lcall delay

jmp met1


delay:
mov a, r2          
mov r0, a           
mov r3, a         

dly_outer:
mov r1, #2          

dly_inner:
mov TL0, #0B0h      
mov TH0, #3Ch
setb tcon.4

wait:
jnb tcon.5, wait
clr tcon.5
clr tcon.4

djnz r1, dly_inner 
djnz r0, dly_outer  

mov a, r3           
mov r2, a
ret

END