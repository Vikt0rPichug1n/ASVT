$MOD51

jmp start

org 20h
start:
    ; ----- Nastroika skorosti -----
    ; Ustanavlivaem SMOD=1 dlya skorosti 375 Kbit/s
    mov pcon, #80h
    
    ; ----- Nastroika porta: rezhim 2, PRIEM -----
    ; SCON = 1001 0000 (rezhim 2, razreshen priem)
    mov scon, #90h       ; REN=1 (priem vklyuchen)
    
    ; ----- Podgotovka k priemu -----
    mov r0, #30h         ; nachalniy adres dlya sohraneniya (XX=30h)
    mov r1, #8           ; schetchik bayt (N=8)
    
    ; ========================================
    ; PRIEM 8 BAYT IZ VIRTUAL TERMINAL
    ; ========================================
receive_loop:
    ; Zhdem poka pridet simvol
wait_ri:
    jnb ri, wait_ri      ; zhdem flag RI=1 (simvol prinyat)
    mov a, sbuf          ; chitaem prinyatiy bayt
    mov @r0, a           ; sohranyaem v pamyat po adresu R0
    clr ri               ; sbrosaem flag dlya sleduyushego bayta
    inc r0               ; perehodim k sleduyushemu adresu
    djnz r1, receive_loop ; povtoryaem 8 raz
    
    ; ========================================
    ; OTPRAVKA PRINYATIH DANNIH OBRATNO (DLA PROVERKI)
    ; ========================================
    
    ; Menyaem nastroiku porta na PEREDACHU
    mov scon, #88h       ; REN=0 (priem otklyuchen, rezhim 2)
    
    mov r0, #30h         ; snova ukazivaem na adres 30h
    mov r1, #8           ; schetchik bayt (N=8)
    
send_loop:
    mov a, @r0           ; zagruzhaem bayt iz pamyati
    mov sbuf, a          ; otpravlyaem cherez port
    
wait_ti:
    jnb ti, wait_ti      ; zhdem okonchaniya otpravki
    clr ti               ; sbrosaem flag
    inc r0               ; sleduyushiy adres
    djnz r1, send_loop   ; povtoryaem 8 raz
    
    ; ========================================
    ; BESKONECHNIY CIKL
    ; ========================================
stop:
    jmp stop

END