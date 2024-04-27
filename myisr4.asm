; Author - Maryanovsky Alla
; My own keyboard interrupt + test
; You may press a s, e, d buttons for move the star on the display
IDEAL
MODEL small
STACK 100h
DATASEG
kbdbuf   db 8 dup (0)
esc_key  db 0
filename db 'try2.bmp',0
filehandle dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0)
ErrorMsg db 'Error', 13, 10 ,'$'
map db 'map.bmp',0
victoryp db 'victory.bmp',0
gforce1 db 0
bluedimond  db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
            db 253,253,253,253,0  ,0  ,0  ,0  ,0  ,0  ,0  ,253,253,253,253
            db 253,253,253,0  ,254,254,244,244,244,217,217,0  ,253,253,253
            db 253,253,0  ,254,254,254,244,244,244,217,217,217,0  ,253,253
            db 253,253,0  ,254,255,254,244,244,244,244,217,217,0  ,253,253
            db 253,253,0  ,254,255,254,244,244,244,244,217,217,0  ,253,253
            db 253,253,0  ,254,254,244,244,244,244,244,217,217,0  ,253,253
            db 253,253,253,0  ,254,244,244,244,244,244,217,0  ,253,253,253
            db 253,253,253,253,0  ,254,244,244,244,244,0  ,253,253,253,253
            db 253,253,253,253,253,0  ,244,244,244,0  ,253,253,253,253,253
            db 253,253,253,253,253,253,0  ,244,0  ,253,253,253,253,253,253
            db 253,253,253,253,253,253,253,0  ,253,253,253,253,253,253,253
            db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
            db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
            db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253

reddimond   db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
            db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
            db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
            db 253,253,253,253,0  ,0  ,0  ,0  ,0  ,0  ,0  ,253,253,253,253
            db 253,253,253,0  ,87 ,15 ,15 ,15 ,14 ,1  ,1  ,0  ,253,253,253
            db 253,253,0  ,87 ,103,87 ,87 ,15 ,15 ,14 ,1  ,1  ,0  ,253,253
            db 253,253,0  ,15 ,103,15 ,14 ,14 ,14 ,14 ,13 ,1  ,0  ,253,253
            db 253,253,0  ,87 ,15 ,87 ,15 ,14 ,14 ,14 ,13 ,1  ,0  ,253,253
            db 253,253,253,0  ,87 ,87 ,15 ,14 ,14 ,14 ,1  ,0  ,253,253,253
            db 253,253,253,253,0  ,87 ,87 ,14 ,14 ,13 ,0  ,253,253,253,253
            db 253,253,253,253,253,0  ,15 ,15 ,14 ,0  ,253,253,253,253,253
            db 253,253,253,253,253,253,0  ,14 ,0  ,253,253,253,253,253,253
            db 253,253,253,253,253,253,253,0  ,253,253,253,253,253,253,253
            db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
            db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253

backgrounddw1   db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  

backgrounddw2   db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0   

backgrounddw3   db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  

backgrounddw4   db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  

backgrounddf1  db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0   

backgrounddf2   db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  

backgrounddf3   db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0   

backgrounddf4   db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  

cube    db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
        db 253,251,251,251,251,251,251,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,251,251,251,251,251,253
        db 253,251,251,251,251,251,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,251,251,251,251,251,253
        db 253,251,251,251,251,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,251,251,251,251,253
        db 253,251,251,251,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,251,251,251,253
        db 253,251,251,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,7  ,7  ,7  ,7  ,7  ,251,251,253
        db 253,253,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,7  ,7  ,7  ,7  ,7  ,7  ,7  ,253,253
        db 253,253,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,253,253
        db 253,253,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,253,253
        db 253,253,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,253,253
        db 253,253,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,7  ,245,7  ,253,253
        db 253,253,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,7  ,7  ,245,7  ,253,253
        db 253,253,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,7  ,7  ,245,245,7  ,253,253
        db 253,253,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,7  ,7  ,7  ,245,247,7  ,253,253
        db 253,253,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,245,7  ,7  ,245,247,245,7  ,253,253
        db 253,251,251,7  ,7  ,7  ,7  ,7  ,7  ,7  ,245,245,245,245,245,247,245,247,251,251,253
        db 253,251,251,251,7  ,7  ,7  ,7  ,245,245,245,245,245,247,247,247,247,251,251,251,253
        db 253,251,251,251,251,7  ,7  ,7  ,245,245,245,245,247,247,247,247,251,251,251,251,253
        db 253,251,251,251,251,251,7  ,7  ,7  ,7  ,7  ,245,247,247,247,251,251,251,251,251,253
        db 253,251,251,251,251,251,253,253,253,253,253,253,253,253,253,251,251,251,251,251,253
        db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253,253

cubebackground1 db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
                db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  

fireboy db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
        db 253,253,253,253,0  ,0  ,253,253,253,0  ,0  ,253,253,253,253
        db 253,253,253,253,0  ,79 ,0  ,0  ,0  ,79 ,0  ,0  ,253,253,253
        db 253,253,253,0  ,79 ,79 ,79 ,79 ,0  ,79 ,0  ,79 ,0  ,253,253
        db 253,0  ,0  ,79 ,79 ,79 ,79 ,79 ,0  ,79 ,0  ,0  ,79 ,0  ,253
        db 253,0  ,79 ,79 ,79 ,79 ,79 ,79 ,66 ,79 ,79 ,0  ,79 ,0  ,253
        db 253,0  ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,0  ,253
        db 253,0  ,79 ,251,251,251,79 ,79 ,79 ,251,251,251,79 ,0  ,253
        db 253,0  ,79 ,251,0  ,251,79 ,79 ,79 ,251,0  ,251,79 ,0  ,253
        db 253,0  ,79 ,251,251,251,79 ,79 ,79 ,251,251,251,79 ,0  ,253
        db 253,0  ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,0  ,253
        db 253,0  ,79 ,79 ,79 ,0  ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,0  ,253
        db 253,0  ,79 ,79 ,79 ,79 ,0  ,0  ,0  ,0  ,79 ,79 ,79 ,0  ,253
        db 253,253,0  ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,79 ,0  ,253,253
        db 253,253,253,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,253,253,253
        db 253,253,253,0  ,79 ,0  ,0  ,79 ,79 ,0  ,0  ,79 ,0  ,253,253
        db 253,253,0  ,79 ,0  ,253,0  ,79 ,79 ,0  ,253,0  ,79 ,0  ,253
        db 253,253,0  ,0  ,253,253,0  ,79 ,79 ,0  ,253,253,0  ,0  ,253
        db 253,253,253,253,253,253,0  ,0  ,0  ,0  ,253,253,253,253,253
        db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253

backgroundw db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0

backgroundf db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0    

watergirl   db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253
            db 253,253,253,253,253,0  ,0  ,0  ,253,253,253,253,253,253,253
            db 253,253,253,253,0  ,240,240,9  ,0  ,253,253,253,253,253,253
            db 253,253,253,0  ,240,240,0  ,0  ,9  ,0  ,0  ,253,253,253,253
            db 253,253,0  ,0  ,9  ,240,0  ,9  ,240,240,9  ,0  ,253,253,253
            db 253,0  ,9  ,9  ,9  ,0  ,0  ,9  ,240,240,9  ,9  ,0  ,253,253
            db 253,0  ,9  ,9  ,0  ,240,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,253
            db 253,0  ,0  ,0  ,9  ,9  ,240,240,240,9  ,9  ,240,240,0  ,253
            db 253,0  ,240,9  ,9  ,9  ,9  ,240,9  ,9  ,9  ,9  ,240,0  ,253
            db 253,0  ,240,9  ,9  ,0  ,9  ,240,9  ,0  ,9  ,9  ,240,0  ,253
            db 253,0  ,240,9  ,9  ,9  ,9  ,240,9  ,9  ,9  ,9  ,240,0  ,253
            db 253,0  ,240,240,240,240,240,240,240,0  ,240,240,240,0  ,253
            db 253,253,0  ,240,240,9  ,0  ,0  ,0  ,240,240,240,0  ,253,253
            db 253,253,0  ,240,240,240,240,240,9  ,240,240,0  ,253,253,253
            db 253,0  ,240,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,253,253,253,253
            db 253,0  ,0  ,198,0  ,240,240,240,240,240,0  ,253,253,253,253
            db 253,253,253,0  ,240,0  ,240,240,240,0  ,240,0  ,253,253,253
            db 253,253,0  ,240,0  ,0  ,240,0  ,240,0  ,0  ,240,0  ,253,253
            db 253,253,253,253,253,0  ,0  ,253,0  ,0  ,253,253,253,253,253
            db 253,253,253,253,253,253,253,253,253,253,253,253,253,253,253

reddoor     db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,16 ,16 ,16 ,16 ,16 ,16 ,17 ,17 ,0  
            db 0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  
            db 0  ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  
            db 0  ,99 ,99 ,99 ,100,100,100,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,100,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,100,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,100,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,87 ,87 ,87 ,87 ,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,87 ,87 ,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,87 ,87 ,87 ,100,87 ,100,87 ,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,87 ,100,100,100,87 ,100,100,100,100,100,0  ,100,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,87 ,100,100,100,87 ,100,100,100,100,100,0  ,100,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,87 ,100,100,100,87 ,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,87 ,87 ,87 ,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  ,99 ,99 ,0  
            db 0  ,16 ,16 ,16 ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  
            db 100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100

bluedoor    db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,16 ,16 ,16 ,16 ,16 ,16 ,17 ,17 ,17 ,0  
            db 0  ,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,0  
            db 0  ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  
            db 0  ,99 ,99 ,100,100,100,100,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,100,100,100,100,100,100,100,100,100,100,100,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,9  ,9  ,99 ,99 ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,9  ,9  ,9  ,9  ,99 ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,9  ,9  ,99 ,99 ,9  ,9  ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,9  ,9  ,99 ,99 ,9  ,9  ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,9  ,9  ,9  ,9  ,99 ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,9  ,9  ,99 ,99 ,99 ,99 ,99 ,99 ,0  ,99 ,99 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,9  ,9  ,9  ,9  ,9  ,9  ,99 ,99 ,99 ,99 ,0  ,91 ,100,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,9  ,9  ,99 ,99 ,99 ,99 ,99 ,99 ,24 ,24 ,2  ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,9  ,9  ,99 ,99 ,99 ,99 ,99 ,99 ,24 ,99 ,16 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  ,99 ,24 ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  ,24 ,2  ,0  
            db 0  ,99 ,99 ,0  ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,0  ,2  ,16 ,0  
            db 0  ,0  ,0  ,0  ,0  ,0  ,0  ,0  ,100,99 ,99 ,99 ,99 ,99 ,99 ,100,91 ,99 ,16 ,40 ,16 ,0  
            db 0  ,2  ,2  ,2  ,2  ,24 ,2  ,2  ,0  ,16 ,16 ,16 ,16 ,16 ,16 ,16 ,16 ,0  ,0  ,2  ,2  ,0  
            db 91 ,16 ,16 ,24 ,40 ,2  ,24 ,24 ,73 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,99 ,73 
;==========================================================
; kbdbuf - array of 4 numbers: index 0 - down, index 1 - left, index 2 - up, index 3 - right
 ; numbers value 1 - key pressed
;==========================================================
CODESEG

proc OpenFile
; Open file
mov ah, 3Dh
xor al, al
mov dx, offset filename
int 21h
jc openerror
mov [filehandle], ax
ret
openerror :
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFile

proc ReadHeader
; Read BMP file header, 54 bytes
mov ah,3fh
mov bx, [filehandle]
mov cx,54
mov dx,offset Header
int 21h
ret
endp ReadHeader

proc ReadPalette
; Read BMP file color palette, 256 colors * 4 bytes (400h)
mov ah,3fh
mov cx,400h
mov dx,offset Palette
int 21h
ret
endp ReadPalette

proc CopyPal
; Copy the colors palette to the video memory
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
push bp
mov bp,sp
push si
push cx
push dx
push ax

;----------------------black box-------------------------
mov si,[bp+4]
mov cx,256
mov dx,3C8h
mov al,0
; Copy starting color to port 3C8h
out dx,al
; Copy palette itself to port 3C9h
inc dx
PalLoop:
; Note: Colors in a BMP file are saved as BGR values rather than RGB .
mov al,[si+2] ; Get red value .
shr al,2 ; Max. is 255, but video palette maximal
; value is 63. Therefore dividing by 4.
out dx,al ; Send it .
mov al,[si+1] ; Get green value .
shr al,2
out dx,al ; Send it .
mov al,[si] ; Get blue value .
shr al,2
out dx,al ; Send it .
add si,4 ; Point to next color .
; (There is a null chr. after every color.)
loop PalLoop
;----------------------black box-------------------------
pop ax
pop dx
pop cx
pop si
pop bp
ret 2
endp CopyPal

proc CopyBitmap
; BMP graphics are saved upside-down .
; Read the graphic line by line (200 lines in VGA format),
; displaying the lines from bottom to top.
mov ax, 0A000h
mov es, ax
mov cx,200
PrintBMPLoop :
push cx
; di = cx*320, point to the correct screen line
mov di,cx
shl cx,6
shl di,8
add di,cx
; Read one line
mov ah,3fh
mov cx,320
mov dx,offset ScrLine
int 21h
; Copy one line into video memory
cld ; Clear direction flag, for movsb
mov cx,320
mov si,offset ScrLine
rep movsb ; Copy line to the screen
 ;rep movsb is same as the following code :
 ;mov es:di, ds:si
 ;inc si
 ;inc di
 ;dec cx
 ;loop until cx=0
pop cx
loop PrintBMPLoop
mov dx, 5000
mov cx, 5000
out_loop:

in_loop:
    loop in_loop
    mov cx, 5000
    dec dx
    cmp dx, 0
    jnz out_loop
ret
endp CopyBitmap

proc CloseFile
mov ah,3Eh
mov bx, [filehandle]
int 21h
ret
endp CloseFile

proc delay
    push si
	push cx
	
	mov si, 0FFFH
odd:
    mov cx, 5H
odin:
    loop odin
	dec si
	jnz odd
	
	pop cx
	pop si
	ret
endp delay	

;---------------------
proc watergirl_right
;watergirl moving right
push bp
mov bp,sp
push si
push di
push ax
push dx
push cx
;----------------------black box-------------------------
mov di,[bp+4]            ;di
cmp si,3
jne outtr
push di
push si
call borders
pop ax
cmp al,'r'
je outtr
mov ax,offset backgroundw            ;offset backgroundw
push ax
push di
call print_backgroundw
call delay
push di
call taking_bluedimonds
;push dx
;call enterdoor
;pop dx
;cmp dl,'v'
;je victory
inc di
push dx
call redpool
pop dx
cmp dl,'e'
je outw1
push ax
push di
call backgroundw1
mov dx,offset watergirl            ;offset watergirl
push dx
push di
call print_watergirl
jmp outtr
;mov [bp+8],di
;victory:
;mov cx,'v'
;mov [bp+6],cx
;jmp outtr
outw1:
mov cx,'e'
mov [bp+6],cx
outtr:
mov [bp+4],di
;----------------------black box-------------------------
pop cx
pop dx
pop ax
pop di
pop si
pop bp
ret 
endp watergirl_right

;---------------------
proc fireboy_right
;fireboy moving right 
push bp
mov bp,sp
push si
push bx
push ax
push dx
push cx
;----------------------black box-------------------------
mov bx,[bp+4]             ;bx
cmp si,7
jne outtr1
push bx
push si
call borders
pop ax
cmp al,'r'
je outtr1
;mov cx,(320*50)+190
;push bx
;push cx
;call cube_right
;pop cx
mov ax,offset backgroundf             ;offset backgroundf
push ax
push bx
call print_backgroungf	
call delay
push bx
call taking_reddimonds
;push dx
;call enterdoor
;pop dx
;cmp dl,'v'
;je victory7
inc bx
push dx
call bluepool
pop dx
cmp dl,'e'
je exittb
push ax
push bx
call backgroundf1
mov dx,offset fireboy            ;offset fireboy
push dx
push bx
call print_fireboy
jmp outtr1
;victory7:
;mov cx,'v'
;mov [bp+6],cx
;jmp outtr1
exittb:
mov cx,'e'
mov [bp+6],cx
outtr1:
mov [bp+4],bx
;----------------------black box-------------------------
pop cx
pop dx
pop ax
pop bx
pop si
pop bp
ret 
endp fireboy_right
;---------------------

proc cube_right
push bp
mov bp,sp
push si
push dx
push bx
push ax
;----------------------black box-------------------------

mov bx,[bp+6]            ;bx/di
mov si,[bp+4]            ;cube's location on the screen
mov ax,si
add ax,44
mov bx,16234
cmp ax,bx
jne notmoving 

push offset cubebackground1
push si
call print_backgroundc
mov dl,'r'
push dx
call cube_borders
pop dx
cmp dl,1
je notmoving
inc si
push offset cube
push si
call cubebackground
;push offset cube
;push si
;call print_cube

notmoving:
mov [bp+6],si
;----------------------black box-------------------------
pop ax
pop bx
pop dx
pop si
pop bp
ret 2
endp cube_right


proc cube_borders
push bp
mov bp,sp 
push ax
push si
push cx
;----------------------black box-------------------------
mov dx,[bp+4]
cmp dl,'r'
je right1
cmp dl,'l'
jne outtb1 
left1:
    dec si
    mov cx,21
    next3:
    mov ah,[es:si]
    cmp ah,91
    je update1
    add si,320
    loop next3
    jmp outtb1

right1:
    add si,21
    mov cx,21
    inc si
    next4:
    mov ah,[es:si]
    cmp ah,91
    je update2
    add si,320
    loop next4
    jmp outtb1

update1:
mov dl,2
jmp outtb1
update2:
mov dl,1
outtb1:
mov [bp+4],dx
;----------------------black box-------------------------
pop cx
pop si
pop ax
pop bp
ret 
endp cube_borders

proc bluepool
push bp
mov bp,sp
push bx
push ax

add bx,20*320
mov ah,[es:bx]
cmp ah,232
je change
cmp ah,250
je change
add bx,10
mov ah,[es:bx]
cmp ah,232
je change
cmp ah,250
jne outb 
change:
mov ax,'e'
mov [bp+4],ax

outb:
pop ax
pop bx
pop bp
ret 
endp bluepool

proc redpool
push bp
mov bp,sp
push di
push ax

add di,20*320
mov ah,[es:di]
cmp ah,249
je change1
cmp ah,250
je change1
add di,10
mov ah,[es:di]
cmp ah,249
je change1
cmp ah,250
jne outb1

change1:
mov ax,'e'
mov [bp+4],ax

outb1:
pop ax
pop di
pop bp
ret 
endp redpool

proc greenpool
push bp
mov bp,sp
push bx
push ax

mov bx,[bp+4]      ;bx/di
add bx,21*230
mov ah,[es:bx]
cmp ah,250
je change2
add bx,15
mov ah,[es:bx]
cmp ah,250
jne outb3
change2:
mov ax,'e'
mov [bp+6],ax

outb3:
pop ax
pop bx
pop bp
ret 2
endp greenpool

proc watergirl_up
push bp
mov bp,sp
push si
push di
push ax
push dx
push cx
;----------------------black box-------------------------
mov di,[bp+4]            ;di
cmp si,2
jne outtu
push di
push si
call borders
pop ax
cmp al,'u'
je outtu
mov ax,offset backgroundw            ;offset backgroundw
push ax
push di
call print_backgroundw
call delay
push di
call taking_bluedimonds
;push dx
;call enterdoor
;pop dx
;cmp di,'v'
;je victory6
sub di,320
push dx
call redpool
pop dx
cmp dl,'e'
je outw2
push ax
push di
call backgroundw1
mov dx,offset watergirl            ;offset watergirl
push dx
push di
call print_watergirl
jmp outtu
;mov [bp+8],di
;victory6:
;mov cx,'v'
;mov [bp+6],cx
;jmp outtu
outw2:
mov cx,'e'
mov [bp+6],cx
outtu:
mov [bp+4],di
;----------------------black box-------------------------
pop cx
pop dx
pop ax
pop di
pop si
pop bp
ret 
endp watergirl_up
;---------------------

proc fireboy_up
push bp
mov bp,sp
push si
push bx
push ax
push dx
push cx
;----------------------black box-------------------------
mov bx,[bp+4]             ;bx
cmp si,6
jne outtr2
push bx
push si
call borders
pop ax
cmp al,'u'
je outtr2
mov ax,offset backgroundf            ;offset backgroundf
push ax
push bx
call print_backgroungf	
call delay
push bx
call taking_reddimonds
;push dx
;call enterdoor
;pop dx
;cmp di,'v'
;je victory5
sub bx,320
push dx
call bluepool
pop dx
cmp dl,'e'
je exittb1
push ax
push bx
call backgroundf1
mov dx,offset fireboy             ;offset fireboy
push dx
push bx
call print_fireboy
jmp outtr2
;mov [bp+8],bx
;victory5:
;mov cx,'v'
;mov [bp+6],cx
;jmp outtr2
exittb1:
mov cx,'e'
mov [bp+6],cx
outtr2:
mov [bp+4],bx
;----------------------black box-------------------------
pop cx
pop dx
pop ax
pop bx
pop si
pop bp
ret 
endp fireboy_up
;---------------------

proc watergirl_left
push bp
mov bp,sp
push si
push di
push ax
push dx
push cx
;----------------------black box-------------------------
mov di,[bp+4]            ;di
cmp si,1
jne outtl
push di
push si
call borders
pop ax
cmp al,'l'
je outtl
mov ax,offset backgroundw            ;offset backgroundw
push ax
push di
call print_backgroundw
call delay
push di
call taking_bluedimonds
;push dx
;call enterdoor
;pop dx
;cmp dl,'v'
;je victory4
dec di
push dx
call redpool
pop dx
cmp dl,'e'
je outw3
push ax
push di
call backgroundw1
mov dx,offset watergirl           ;offset watergirl
push dx
push di
call print_watergirl
jmp outtl
;victory4:
;mov cx,'v'
;mov [bp+6],cx
;jmp outtl
outw3:
mov cx,'e'
mov [bp+6],cx
outtl:
mov [bp+4],di
;----------------------black box-------------------------
pop cx
pop dx
pop ax
pop di
pop si
pop bp
ret 
endp watergirl_left
;---------------------

proc fireboy_left
push bp
mov bp,sp
push si
push bx
push ax
push dx
push cx
;----------------------black box-------------------------
mov bx,[bp+4]             ;bx
cmp si,5
jne outtl2
push bx
push si
call borders
pop ax
cmp al,'l'
je outtl2
mov dx,offset fireboy             ;offset fireboy
mov ax,offset backgroundf            ;offset backgroundf
push ax
push bx
call print_backgroungf	
call delay
push bx
call taking_reddimonds
;push dx
;call enterdoor
;pop dx
;cmp di,'v'
;je victory3
dec bx
push dx
call bluepool
pop dx
cmp dl,'e'
je exittb12
push ax
push bx
call backgroundf1
push dx
push bx
call print_fireboy
jmp outtl2
;mov [bp+8],bx
;victory3:
;mov cx,'v'
;mov [bp+6],cx
;jmp outtl2
exittb12:
mov cx,'e'
mov [bp+6],cx
outtl2:
mov [bp+4],bx
;----------------------black box-------------------------
pop cx
pop dx
pop ax
pop bx
pop si
pop bp
ret 
endp fireboy_left

proc watergirl_down
push bp
mov bp,sp
push si
push di
push ax
push dx
push cx
;----------------------black box-------------------------
mov di,[bp+4]            ;di
mov si,0
push di
push si
call borders
pop ax
cmp al,'d'
je outtd
mov ax,offset backgroundw            ;offset backgroundw
push ax
push di
call print_backgroundw
call delay
push di
call taking_bluedimonds
;push dx
;call enterdoor
;pop dx
;cmp dl,'v'
;je victory2
add di,320
push dx
call redpool
pop dx
;push dx
;push di
;call greenpool
;pop dx
cmp dl,'e'
je outd3
push ax
push di
call backgroundw1
mov dx,offset watergirl           ;offset watergirl
push dx
push di
call print_watergirl
jmp outtd
;victory2:
;mov cx,'v'
;mov [bp+6],cx
;jmp outtd
outd3:
mov cx,'e'
mov [bp+6],cx
outtd:
mov [bp+4],di
;----------------------black box-------------------------
pop cx
pop dx
pop ax
pop di
pop si
pop bp
ret 
endp watergirl_down

proc fireboy_down
push bp
mov bp,sp
push si
push bx
push ax
push dx
push cx
;----------------------black box-------------------------
mov bx,[bp+4]             ;bx
mov si,4
push bx
push si
call borders
pop ax
cmp al,'d'
je outtd1
mov dx,offset fireboy             ;offset fireboy
mov ax,offset backgroundf            ;offset backgroundf
push ax
push bx
call print_backgroungf	
call delay
push bx
call taking_reddimonds
;push dx
;call enterdoor
;pop dx
;cmp dl,'v'
;je victory1
add bx,320
push dx
call bluepool
pop dx
cmp dl,'e'
je exittb3
push ax
push bx
call backgroundf1
push dx
push bx
call print_fireboy
jmp outtd1
;mov [bp+8],bx
;victory1:
;mov cx,'v'
;mov [bp+6],cx
;jmp outtd1
exittb3:
mov cx,'e'
mov [bp+6],cx
outtd1:
mov [bp+4],bx
;----------------------black box-------------------------
pop cx
pop dx
pop ax
pop bx
pop si
pop bp
ret
endp fireboy_down

proc backgroundf1
push bp
mov bp,sp
push bx
push cx
push ax
push si
;---------------black box-------------
    mov bx, [bp+4]      ;the fireboy adress
    mov si, [bp+6]      ;offset backgroundf
    mov cx, 20      ;the image width
    next_color:

        push cx
        push bx
        mov cx, 15
        draw_pixel:
            mov ah ,[es:bx]
            mov [si], ah
            inc bx
            inc si
            loop draw_pixel
        pop bx
        pop cx
        add bx, 320
        loop next_color

;---------------black box-------------
pop si
pop ax
pop cx
pop bx
pop bp 
ret 4
endp backgroundf1

proc backgroundw1
push bp
mov bp,sp
push di
push cx
push ax
push si
;---------------black box-------------
    mov di, [bp+4]      ;the watergirl adress on the screen 
    mov si, [bp+6]      ;offset backgroundw
    mov cx, 20      ;the image width
    next_color2:

        push cx
        push di
        mov cx, 15
        draw_pixel2:
            
            mov ah ,[es:di]
            mov [si], ah
            inc di
            inc si
            loop draw_pixel2
        pop di
        pop cx
        add di, 320
        loop next_color2

;---------------black box-------------
pop si
pop ax
pop cx
pop di
pop bp 
ret 4
endp backgroundw1

proc cubebackground
push bp
mov bp,sp
push di
push cx
push ax
push si
;---------------black box-------------
    mov di, [bp+4]      ;the cube adress on the screen 
    mov si, [bp+6]      ;offset backgroundw
    mov cx, 21      ;the image width
    next_color11:

        push cx
        push di
        mov cx, 21
        draw_pixel11:
            
            mov ah ,[es:di]
            mov [si], ah
            inc di
            inc si
            loop draw_pixel11
        pop di
        pop cx
        add di, 320
        loop next_color11

;---------------black box-------------
pop si
pop ax
pop cx
pop di
pop bp 
ret 4
endp cubebackground

proc backgroundd             ;saved the background of the dimonds
push bp
mov bp,sp
push di
push cx
push ax
push si
;---------------black box-------------
    mov di, [bp+4]      ;the reddimond/bluedimond adress on the screen 
    mov si, [bp+6]      ;offset backgroundd
    mov cx, 15      ;the image width
    next_color7:

        push cx
        push di
        mov cx, 15
        draw_pixel7:
            
            mov ah ,[es:di]
            mov [si], ah
            inc di
            inc si
            loop draw_pixel7
        pop di
        pop cx
        add di, 320
        loop next_color7

;---------------black box-------------
pop si
pop ax
pop cx
pop di
pop bp 
ret 4
endp backgroundd

proc printbackgroundd
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
;-----------black_box----------------
    mov bx, [bp+4]      ;the backgroungf adress
    mov si, [bp+6]
    mov cx, 15      ;the image width
    next_color9:

        push cx
        push bx
        mov cx, 15
        draw_pixel9:
            mov ah, [si]
            mov [es:bx], ah  
            inc bx
            inc si
            loop draw_pixel9
        pop bx
        pop cx
        add bx, 320
        loop next_color9


;-----------black_box----------------
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4
endp printbackgroundd

proc taking_reddimonds
push bp
mov bp,sp
push bx

mov bx,[bp+4]        ;bx/di fireboy/watergirl place on the screen 
cmp bx, (320*178)+163
je f1
cmp bx, (320*85)+60
je f2
cmp bx, (320*10)+90
je f3
cmp bx, (320*25)+150
jne nottake1
f4:
push offset backgrounddf4
push bx
call printbackgroundd
jmp nottake1
f1:
push offset backgrounddf1
push bx
call printbackgroundd
jmp nottake1
f2:
push offset backgrounddf2
push bx
call printbackgroundd
jmp nottake1
f3:
push offset backgrounddf3
push bx
call printbackgroundd

nottake1:
pop bx
pop bp
ret 2
endp taking_reddimonds

proc taking_bluedimonds
push bp
mov bp,sp
push di

mov di,[bp+4]        ;bx/di fireboy/watergirl place on the screen 
cmp di, (320*178)+230
je w1
cmp di, (320*93)+185
je w2
cmp di, (320*31)+10
je w3
cmp di,(320*25)+180
jne nottake
w4:
push offset backgrounddw4
push di
call printbackgroundd
jmp nottake
w1:
push offset backgrounddw1
push di
call printbackgroundd
jmp nottake
w2:
push offset backgrounddw2
push di
call printbackgroundd
jmp nottake
w3:
push offset backgrounddw3
push di
call printbackgroundd

nottake:
pop di
pop bp
ret 2
endp taking_bluedimonds

proc enterdoor
push bp
mov bp,sp
push bx
push ax
push cx

mov cx,20
mov ax,(320*20)+262
add bx,15
keepchacking:
    cmp bx,ax
    je win
    add ax,320
    add bx,320
    loop keepchacking
    jmp outk
win:
mov cx,'v'
mov [bp+4],cx

outk:
pop cx
pop ax
pop bx
pop bp
ret
endp enterdoor

proc gforce
push bp
mov bp,sp
push ax
push bx
push dx
push di

    push ax
    push bx
    call fireboy_down
    pop bx
    pop ax
    cmp ax,'e'
    je changee
    push dx
    push di
    call watergirl_down
    pop di
    pop dx
    cmp dx,'e'
    jne toout
changee:
mov [bp+4],ax
toout:
mov [bp+6],bx
mov [bp+8],di
pop di
pop dx
pop bx
pop ax
pop bp
ret 
endp gforce
;======================================================================	
proc change_handler
    xor     ax, ax
    mov     es, ax

    cli                              ; interrupts disabled
    push    [word ptr es:9*4+2]      ; save old keyboard (9) ISR address - interrupt service routine(ISR)
    push    [word ptr es:9*4]
	                                 ; put my keyboard (9) ISR address: procedure irq1isr
    mov     [word ptr es:9*4], offset my_isr
	                                 ; put cs in ISR address
    mov     [es:9*4+2],        cs
    sti                               ; interrupts enabled

    call    my_program                     ; program that use the interrupt  lines 43 - 83

    cli                               ; interrupts disabled
    pop     [word ptr es:9*4]         ; restore ISR address
    pop     [word ptr es:9*4+2]
    sti                               ; interrupts enabled

    ret
endp change_handler	
;=====================================================================
proc my_program   
; main program
; moves the star
; 's' or downArrow - down, 'a' or leftArrow - left, 'w' or upArrow - up, 'd' or rightArrow - right
	mov ax, es                        ; save es
	push ax

	mov ax, 0a000h                    ; start address of text video memory
	                                  ; 80 columns * 25 rows * 2 bytes per character:
						              ; low byte = character code; high byte = attribute (background+color)
	mov es, ax
	
	;push bp
    ;mov bp,sp


	mov bx, (320*178)+10             ; address on the middle of display, red star
	push offset fireboy
	push bx
	call print_fireboy 
    call delay
	mov di, (320*150)+10            ; address on the middle of display, green star
	push offset watergirl
	push di
	call print_watergirl
    call delay
    mov si, (320*178)+163          ;first red dimond's address 1
    push offset reddimond
    push si
    call printdimond
    mov si, (320*178)+230           ;first blue dimond's address 1
    push offset bluedimond
    push si
    call printdimond
    mov si, (320*85)+60             ;second red dimond's address 2
    push offset reddimond          
    push si
    call printdimond
    mov si, (320*93)+185            ;second blue dimond's address 2
    push offset bluedimond
    push si
    call printdimond
    mov si, (320*31)+10            ;third blue dimond's address 3
    push offset bluedimond
    push si
    call printdimond
    mov si, (320*10)+90          ;third red dimond's address 3
    push offset reddimond       
    push si
    call printdimond
    mov si, (320*25)+150         ;thorth red dimond's address 4
    push offset reddimond
    push si
    call printdimond
    mov si, (320*25)+180         ;thorth blue dimond's address 4
    push offset bluedimond      
    push si
    call printdimond
    mov si,(320*20)+292
    push offset bluedoor
    push si
    call print_doors
    mov si, (320*20)+262
    push offset reddoor
    push si
    call print_doors
    ;mov si, (320*50)+190
    ;push offset cube
    ;push si
    ;call print_cube
main_loop:                            ; none end loop: scan array kbdbuf
    mov si,0
	mov cx,8
check_buttons:
    cmp [byte ptr cs:esc_key], 0       ; if clicked ?
	jne toret                          ; yes ---> end the program
    mov al, [cs:kbdbuf + si]       ;scan array of clickes
	cmp al,0
	je cont
watergirlmove:	
    push dx
    push di
	call watergirl_right
    pop di
    pop dx
    push dx
    push di
    call watergirl_up
    pop di
    pop dx
    push dx
    push di
    call watergirl_left
    pop di
    pop dx
    cmp dx,'e'
    je toret
fireboymove:
    push ax
    push bx
    ;mov si,7
    call fireboy_right
    pop bx
    pop ax
    push ax
    push bx
	call fireboy_up
    pop bx
    pop ax
    push ax
    push bx
    call fireboy_left
    pop bx
    pop ax
    cmp ax,'e'
    je toret
    ;cmp ax,'v'
    ;jne cont
    ;cmp dx,'v'
    ;jne cont
;change3:
    ;mov [bp+4],ax
    ;jmp toret
cont:	
	inc si
	loop check_buttons
    mov cl,[gforce1]
    inc cl
    cmp cl,10
    mov [gforce1],cl
    jne main_loop
    mov cx,0
    mov [gforce1],cl
    push di
    push bx
    push dx
    call gforce
    pop dx
    pop bx
    pop di
    cmp dx,'e'
    je toret
    call delay
    jmp main_loop
toret:
    pop ax
	mov es, ax
    ;pop bp
    ret
endp my_program
;==============================================================

;==============================================================
proc my_isr               
 ; my isr for keyboard   
	push    ax
	push    bx
    push    cx
    push    dx
	push    di
	push    si
        

                        ; read keyboard scan code
    in      al, 60h

                        ; update keyboard state
    xor     bh, bh
    mov     bl, al
    and     bl, 7Fh     ; bx = scan code
	cmp bl, 11h         ; if click on w (index 1 in array kbdbuf)
	jne check1
	mov bl,2
	jmp end_check
	
check1:
	cmp bl, 1eh		    ; if click on a (index 0 in array kbdbuf)
	jne check2
	mov bl,1
	jmp end_check
	
check2:
	cmp bl, 20h		    ; if click on d (index 2 in array kbdbuf)
	jne check3
	mov bl,3
	jmp end_check
	
check3:
	cmp bl, 1fh		    ; if click on s (index 3 in array kbdbuf)
	jne check4
	mov bl,0
	jmp end_check
	
check4:
    cmp bl, 1h		    ; if click on esc
	jne check5
	mov [byte ptr cs:esc_key], 1

check5:
	cmp bx, 4Bh	    ; if click on leftarrow (index 3 in array kbdbuf)
	jne check6
	mov bl,5
	jmp end_check

check6:
	cmp bx, 50h	    ; if click on downarrow (index 3 in array kbdbuf)
	jne check7
	mov bl,4
	jmp end_check

check7:
	cmp bx, 4Dh	    ; if click on rightarrow (index 3 in array kbdbuf)
	jne check8
	mov bl,7
	jmp end_check

check8:
	cmp bx, 48h	    ; if click on rightarrow (index 3 in array kbdbuf)
	jne end_check
	mov bl,6
	jmp end_check
	
end_check:
    push cx
	mov cx, 7
    shr al, cl              ; al = 0 if pressed, 1 if released
	pop cx
    xor al, 1               ; al = 1 if pressed, 0 if released
    mov     [cs:kbdbuf+bx], al  ; save pressed buttons in array kbdbuf
	
	
                                ; send EOI to XT keyboard
    in      al, 61h
    mov     ah, al
    or      al, 80h
    out     61h, al
    mov     al, ah
    out     61h, al

                                ; send EOI to master PIC
    mov     al, 20h
    out     20h, al
	
    pop     si
    pop     di                       
    pop     dx
    pop     cx
    pop     bx
    pop     ax
   
    iret
endp my_isr

proc print_backgroungf
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
;-----------black_box----------------
    mov bx, [bp+4]      ;the backgroungf adress
    mov si, [bp+6]
    mov cx, 20      ;the image width
    next_color3:


        push cx
        push bx
        mov cx, 15
        draw_pixel3:
            mov ah, [si]
            mov [es:bx], ah  
            inc bx
            inc si
            loop draw_pixel3
        pop bx
        pop cx
        add bx, 320
        loop next_color3


;-----------black_box----------------
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4
endp print_backgroungf

proc print_backgroundw
push bp
mov bp,sp
push di
push si
push cx
push ax
;-----------black_box----------------
    mov di, [bp+4]      ;the backgroundw adress
    mov si, [bp+6]
    mov cx, 20      ;the image width
    next_color6:


        push cx
        push di
        mov cx, 15
        draw_pixel6:
            mov ah, [si]
            mov [es:di], ah  
            inc di
            inc si
            loop draw_pixel6
        pop di
        pop cx
        add di, 320
        loop next_color6

;-----------black_box----------------
pop ax
pop cx
pop si
pop di
pop bp
ret 4
endp print_backgroundw

proc print_backgroundc
push bp
mov bp,sp
push di
push si
push cx
push ax
;-----------black_box----------------
    mov di, [bp+4]      ;the backgroundw adress
    mov si, [bp+6]
    mov cx, 21      ;the image width
    next_color12:


        push cx
        push di
        mov cx, 21
        draw_pixel12:
            mov ah, [si]
            mov [es:di], ah  
            inc di
            inc si
            loop draw_pixel12
        pop di
        pop cx
        add di, 320
        loop next_color12

;-----------black_box----------------
pop ax
pop cx
pop si
pop di
pop bp
ret 4
endp print_backgroundc

proc print_fireboy
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
;-----------black_box----------------
    mov bx, [bp+4]      ;the fireboy adress
    mov si, [bp+6]
    mov cx, 20      ;the image width
    next_color8:


        push cx
        push bx
        mov cx, 15
        draw_pixel8:
            mov ah, [si]
            cmp ah, 253
            je next_pixel8
            mov [es:bx], ah  
            next_pixel8:
            inc bx
            inc si
            loop draw_pixel8
        pop bx
        pop cx
        add bx, 320
        loop next_color8


;-----------black_box----------------
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4
endp print_fireboy

proc print_watergirl
    push bp
    mov bp, sp
    push ax
    push di
    push cx
    push dx
    push si
;-----------black_box----------------
    mov di, [bp+4]      ;the watergirl adress
    mov si, [bp+6]
    mov cx, 20        ;the image width
    next_color4:


        push cx
        push di
        mov cx, 15      ;image length 
        draw_pixel4:
            mov ah, [si]
            cmp ah, 253
            je next_pixel4
            mov [es:di], ah  
            next_pixel4:
            inc di
            inc si
            loop draw_pixel4
        pop di
        pop cx
        add di, 320
        loop next_color4


;-----------black_box----------------
    pop si
    pop dx
    pop cx
    pop di
    pop ax
    pop bp
    ret 4
endp print_watergirl

proc print_doors
    push bp
    mov bp, sp
    push ax
    push di
    push cx
    push dx
    push si
;-----------black_box----------------
    mov di, [bp+4]      ;the door adress on the screen
    mov si, [bp+6]      ;offset reddoor/bluedoor
    mov cx, 25        ;the image width
    next_color13:


        push cx
        push di
        mov cx, 22      ;image length 
        draw_pixel13:
            mov ah, [si]
            cmp ah, 253
            je next_pixel13
            mov [es:di], ah  
            next_pixel13:
            inc di
            inc si
            loop draw_pixel13
        pop di
        pop cx
        add di, 320
        loop next_color13


;-----------black_box----------------
    pop si
    pop dx
    pop cx
    pop di
    pop ax
    pop bp
ret 4
endp print_doors

proc print_cube
    push bp
    mov bp, sp
    push ax
    push di
    push cx
    push dx
    push si
;-----------black_box----------------
    mov di, [bp+4]      ;the cube adress
    mov si, [bp+6]
    mov cx, 21        ;the image width
    next_color10:


        push cx
        push di
        mov cx, 21      ;image length 
        draw_pixel10:
            mov ah, [si]
            cmp ah, 253
            je next_pixel10
            mov [es:di], ah  
            next_pixel10:
            inc di
            inc si
            loop draw_pixel10
        pop di
        pop cx
        add di, 320
        loop next_color10

;-----------black_box----------------
    pop si
    pop dx
    pop cx
    pop di
    pop ax
    pop bp
ret 4
endp print_cube

proc printdimond
push bp
mov bp, sp
push ax
push di
push cx
push dx
push si
;-----------black_box----------------
    mov di, [bp+4]      ;the bluedimond adress/reddimond adress on the screen
    mov si, [bp+6]
    mov cx, 15      ;the image width
    next_color5:


        push cx
        push di
        mov cx, 15      ;image length 
        draw_pixel5:
            mov ah, [si]
            cmp ah, 253
            je next_pixel5
            mov [es:di], ah  
            next_pixel5:
            inc di
            inc si
            loop draw_pixel5
        pop di
        pop cx
        add di, 320
        loop next_color5


;-----------black_box----------------
pop si
pop dx
pop cx
pop di
pop ax
pop bp
ret 4
endp printdimond

proc OpenFilemap
; Open file
mov ah, 3Dh
xor al, al
mov dx, offset map
int 21h
jc openerror1
mov [filehandle], ax
ret
openerror1 :
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFilemap

proc OpenFilevictory
mov ah, 3Dh
xor al, al
mov dx, offset victoryp
int 21h
jc openerror2
mov [filehandle], ax
ret
openerror2 :
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFilevictory

proc borders
push bp
mov bp,sp
push bx
push si
push ax
push dx
push cx
push di
;-----------black_box----------------
mov si,[bp+4]                        ;si value of key press
mov bx,[bp+6]                        ;fireboy   bx                   
    cmp si,7
    je right
    cmp si,3
    je right
    cmp si,6
    je up
    cmp si,2
    je up
    cmp si,5
    je left
    cmp si,1
    jne down
left: 
    dec bx
    mov cx,20
    next:
    mov ah,[es:bx]
    cmp ah,91
    je updatel
    add bx,320
    loop next
    jmp down
up:
    sub bx,320
    mov cx,15
    nex1:
    mov ah,[es:bx]
    cmp ah,91
    je updateu
    inc bx
    loop nex1
    jmp down
right:
    add bx,15
    mov cx,20
    inc bx
    next2:
    mov ah,[es:bx]
    cmp ah,91
    je updater
    add bx,320
    loop next2
    jmp down
updated:
mov al,'d'
jmp outtb
updater:
mov al,'r'
jmp down
updateu:
mov al,'u'
jmp down
updatel:
mov al,'l'
down:
    add bx,(320*20)+5
    mov cx,10
    next5:
    mov ah,[es:bx]
    cmp ah,91
    je updated
    inc bx
    loop next5
outtb:
mov [bp+6],ax
;-----------black_box----------------
pop di
pop cx
pop dx
pop ax
pop si
pop bx
pop bp
ret 2
endp borders


;=====================================================================
;   Start code
;=====================================================================
;
start:
  	mov ax, @data                    ; start address of segment data
	mov ds, ax
	mov ax, 0a000h 
	mov es,ax
	mov ax, 13h
	int 10h
	; Graphic mode
	;mov ax, 13h
	;int 10h
	; Process BMP file
    wait1:
    call OpenFile
    call ReadHeader
    call ReadPalette
    push offset palette
    call CopyPal
    call CopyBitmap
    ;Wait for key press
    mov ah,1
    int 21h
    cmp al,0dh
    jne wait1
    call closefile
    
continue:
    ;push [byte ptr map]
    call OpenFilemap
    call ReadHeader
    call ReadPalette
    push offset palette
    call CopyPal
    call CopyBitmap
    call closefile
	;push offset fireboy
	;call blackscreen
    push offset backgroundf
	push (320*178)+10
	call backgroundf1
	push offset backgroundw
    push (320*150)+10
    call backgroundw1
    push offset backgrounddf1
    push (320*178)+163
    call backgroundd
    push offset backgrounddw1
    push (320*178)+230
    call backgroundd
    push offset backgrounddf2
    push (320*85)+60  
    call backgroundd
    push offset backgrounddw2
    push (320*93)+185 
    call backgroundd
    push offset backgrounddw3
    push (320*31)+10 
    call backgroundd
    push offset backgrounddf3
    push (320*10)+90  
    call backgroundd
    push offset backgrounddf4
    push (320*25)+150  
    call backgroundd
    push offset backgrounddw4
    push (320*25)+180  
    call backgroundd
    push offset cubebackground1
    push (320*50)+190
    call cubebackground
    ;push ax
	call change_handler              ; put my own keyboard interrupt
    ;pop ax
    ;cmp ax,'e'
	;je exit
    ;cmp ax,'v'
    ;je victorypic
victorypic:
    call OpenFilevictory
    call ReadHeader
    call ReadPalette
    push offset palette
    call CopyPal
    call CopyBitmap
    call closefile
exit:
	mov ah, 0
	mov al, 2
	int 10h
	mov ax, 4c00h
	int 21h
END start
