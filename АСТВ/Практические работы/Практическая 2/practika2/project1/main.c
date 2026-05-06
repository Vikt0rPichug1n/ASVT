#include <8051.h>

void delay_with_button(unsigned int count, unsigned char *flag)
{
    unsigned int x;
    for(x = 0; x < count; x++)
    {
        if((P3 & 0x01) != 0) 
        {
            *flag = 1;
        }
    }
}

void main()
{
    unsigned char i;
    unsigned char mode = 0;           
    unsigned char current_digit;       
    unsigned char button_was_pressed;
    
    unsigned char mode0_pos = 0;
    unsigned char mode1_pos = 0;
    
    unsigned char j;  
    unsigned char digit; 

    unsigned char codes[10] = {
        0xC0, 0xF9, 0xA4, 0xB0, 0x99,
        0x92, 0x82, 0xF8, 0x80, 0x90
    };

    P3 = P3 | 0x01;  

    while(1)
    {
        if(mode == 0)
        {

            P2 = codes[mode0_pos];
            current_digit = mode0_pos;

            button_was_pressed = 0;
            delay_with_button(70, &button_was_pressed);

            if(button_was_pressed == 1)
            {
                while((P3 & 0x01) != 0);
                
                mode1_pos = 0;

                if(current_digit == 1) mode1_pos = 0;
                else if(current_digit == 9) mode1_pos = 1;
                else if(current_digit == 2) mode1_pos = 2;
                else if(current_digit == 8) mode1_pos = 3;
                else if(current_digit == 3) mode1_pos = 4;
                else if(current_digit == 7) mode1_pos = 5;
                else if(current_digit == 4) mode1_pos = 6;
                else if(current_digit == 6) mode1_pos = 7;
                else if(current_digit == 5) mode1_pos = 8;
                
                mode = 1;
            }
            else
            {
                mode0_pos++;
                if(mode0_pos >= 10) mode0_pos = 0;
            }
        }
        else // mode == 1
        {

            if(mode1_pos == 0) digit = 1;
            else if(mode1_pos == 1) digit = 9;
            else if(mode1_pos == 2) digit = 2;
            else if(mode1_pos == 3) digit = 8;
            else if(mode1_pos == 4) digit = 3;
            else if(mode1_pos == 5) digit = 7;
            else if(mode1_pos == 6) digit = 4;
            else if(mode1_pos == 7) digit = 6;
            else digit = 5; // mode1_pos == 8
            
            P2 = codes[digit];
            current_digit = digit;

            button_was_pressed = 0;
            delay_with_button(70, &button_was_pressed);

            if(button_was_pressed == 1)
            {
                while((P3 & 0x01) != 0);
                
                mode0_pos = current_digit;
                
                mode = 0;
            }
            else
            {
                mode1_pos++;
                if(mode1_pos >= 9) mode1_pos = 0;
            }
        }
    }
}