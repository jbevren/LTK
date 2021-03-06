10 REM --------------------------------- 
20 REM -- ALTERNATE KEY OPTIONS MENU --- 
30 REM --------------------------------- 
40 POKE 45,0:POKE 46,40:POKE 47,0:POKE 48,40:POKE 49,0:POKE 50,40 
50 POKE 51,255:POKE 52,126:POKE 55,255:POKE 56,126 
60 CLR  
70 PL=38480 
80 POKE 830,10:POKE 831,0:POKE 832,8:SYS 32512 
90 PD=PEEK (828):SA=PEEK (829) 
100 MO=0:LF=2:DR=2:K$="user.alternates,30,4":L=225:H=0:S=0 
110 SYS 64628:MO,LF,DR,K$,L,H,S 
120 IF S=0 THEN 160 
130 IF S=3 THEN 160 
140 IF S<>0 THEN STOP 
150 REM --------------------------------- 
160 OPEN 2,8,2,"user.alternates" 
170 SYS 39424 
175 ?(6,15,0) 
180 REM ---- INFORMATION MESSAGES ------ 
190 SS$="                                          " 
195 OP$="{reverse on}{blue}      alternate keys options menu     {blue}{reverse off}" 
200 BL$="{reverse on}{blue}   enter blank key to return to menu  {blue}{reverse off}" 
210 DS$="{black}[    ] [                          ]  [ ]{blue}" 
220 FS$="{reverse on}{blue}       select desired function        {blue}{reverse off}" 
230 EK$="{reverse on}{blue}   end of alternate keys encountered   {blue}{reverse off}" 
240 PK$="{reverse on}{black} press any key to continue     _=abort {home}{blue}{reverse off}" 
250 EF$="{reverse on}{blue}0=immediate action    1=display action{blue}{reverse off}" 
260 YN$="{reverse on}{blue}              correct y/n             {blue}{reverse off}" 
265 DL$="{reverse on}{blue}              delete  y/n             {blue}{reverse off}" 
267 MD$="{reverse on}{blue}              modify  y/n             {blue}{reverse off}" 
268 AB$="{reverse on}{blue}      press '_' to abort printing     {blue}{reverse off}" 
270 PR$="{reverse on}{blue}       screen or printer  s/p         {blue}{reverse off}" 
280 SF$="{reverse on}{red}please wait reorganizing key file ....{blue}{reverse off}" 
290 SX$="{reverse on}{red}!!!!!!!!   key file is full   !!!!!!!!{blue}{reverse off}" 
300 REM ---- ERROR MESSAGES ------------ 
310 ER$(1)="{reverse on}{red} first character must not be a space  {blue}{reverse off}" 
320 ER$(2)="{reverse on}{red} first character must not be a colon  {blue}{reverse off}" 
330 ER$(3)="{reverse on}{red}   first character must not be a '?'  {blue}{reverse off}" 
340 ER$(4)="{reverse on}{red} first character must not be a number {blue}{reverse off}" 
350 ER$(5)="{reverse on}{red}   embedded spaces are not allowed    {blue}{reverse off}" 
360 ER$(6)="{reverse on}{red}     alternate key already exists     {blue}{reverse off}" 
370 ER$(7)="{reverse on}{red} effect indicator must be '0' or '1'  {blue}{reverse off}" 
380 ER$(8)="{reverse on}{red}end of keys encountered no match found{blue}{reverse off}" 
390 REM ---- SELECT MESSAGES 
400 SL$(1)="{reverse on}{blue}f1{right}{right}{right}add alternate keys{reverse off}" 
410 SL$(2)="{reverse on}{blue}f2{right}{right}{right}modify alternate keys{reverse off}" 
420 SL$(3)="{reverse on}{blue}f3{right}{right}{right}delete alternate keys{reverse off}" 
430 SL$(4)="{reverse on}{blue}f4{right}{right}{right}display or print alternate keys{reverse off}" 
440 SL$(5)="{reverse on}{blue}f5{right}{right}{right}exit alternate key menu{reverse off}" 
450 SYS PL,0,0,0,24 
455 ?(1,1):PRINT OP$; 
460 ?(1,23):PRINT FS$; 
470 ?:KE=PEEK (254) 
480 IF KE<1 OR KE>5 THEN 470 
490 ?(2,(KE*2)+2):PRINT SL$(KE) 
500 ?(1,23):PRINT BL$; 
510 ON KE GOTO 550,1320,550,1690,520 
520 SYS 32512:?:CLOSE 2 
530 END  
540 REM ---- ADD KEYS 
550 SYS PL,0,0,15,24 
552 ?(1,23):PRINT BL$; 
555 ?(10,16,4),K1$ 
560 IF K1$="    " THEN 450 
570 KT$=MID$(K1$,1,1) 
580 IF KT$=" " THEN ER=1:GOSUB 830: GOTO 552 
590 IF KT$=":" THEN ER=2:GOSUB 830: GOTO 552 
600 IF KT$="?" THEN ER=3:GOSUB 830: GOTO 552 
610 IF ASC(KT$)>47 AND ASC(KT$)<58 THEN ER=4:GOSUB 830: GOTO 552 
620 K1=0 
630 FOR I=4 TO 2 STEP -1 
640 IF MID$(K1$,I,1)=" " AND K1=0 THEN 680 
650 IF K1=0 THEN K1=1: GOTO 680 
660 IF MID$(K1$,I,1)<>" " THEN 680 
670 ER=5:GOSUB 830:I=1: GOTO 552 
680 NEXT  
690 SYS 64628:3,LF,2,K1$,L,H,S 
700 IF KE=3 THEN 1100 
710 IF S=0 THEN ER=6:GOSUB 830: GOTO 552 
720 ?(10,18,26),K2$ 
730 IF K2$="                          " THEN 450 
740 ?(1,23):PRINT EF$; 
750 ?(10,20,1),K3$ 
760 IF K3$<>"0" AND K3$<>"1" THEN ER=7:GOSUB 830: GOTO 740 
770 L=VAL(K3$):H=0 
780 ?(1,23):PRINT YN$; 
790 GET Q$:IF Q$="" THEN 790 
800 IF Q$="y" THEN 870 
810 IF Q$<>"n" THEN 790 
820 GOTO 552 
825 REM ---- ERROR HANDLER 
830 ?(1,23):PRINT ER$(ER);:PRINT CHR$(7); 
840 FOR J=1 TO 2000:NEXT  
850 ?(1,23):PRINT BL$; 
860 RETURN 
870 K4$=K1$+K2$ 
880 SX=0 
890 SYS 64628:1,LF,1,K4$,L,H,S 
900 IF S=0 THEN 970 
910 IF S<>4 THEN STOP 
920 SX=SX+1:IF SX>2 THEN :?(1,23):PRINT SX$;:FOR I=1 TO 4000:NEXT : GOTO 450 
930 ?(1,23):PRINT SF$; 
940 SYS 64628:7,LF,1,K4$,L,H,S 
950 ?(1,23):PRINT BL$; 
960 GOTO 890 
970 ?(1,23):PRINT BL$; 
980 SX=0 
990 SYS 64628:1,LF,2,K1$,L,H,S 
1000 IF S=0 THEN 1060 
1010 IF S<>4 THEN STOP 
1020 SX=SX+1:IF SX>2 THEN :?(1,23):PRINT SX$;:FOR I=1 TO 4000:NEXT : GOTO 450 
1030 ?(1,23):PRINT SF$; 
1040 SYS 64628:7,LF,2,K1$,L,H,S 
1050 GOTO 990 
1060 SYS PL,0,0,15,24 
1070 IF KE=2 THEN 1317 
1080 GOTO 550 
1090 REM ---- DELETE KEYS 
1100 IF S<>0 THEN ER=8:GOSUB 830: GOTO 552 
1110 K$=K1$+SS$:K$=MID$(K$,1,30) 
1120 SYS 64628:4,LF,1,K$,L,H,S 
1130 IF S=5 THEN ER=8:GOSUB 830: GOTO 550 
1140 IF S<>0 THEN STOP 
1150 ?(10,16):PRINT MID$(K$,1,4) 
1160 ?(10,18):PRINT MID$(K$,5,26) 
1170 Z0$=STR$(L):Z0$=RIGHT$(Z0$,1) 
1180 IF Z0$<>"0" AND Z0$<>"1" THEN STOP 
1190 ?(10,20):PRINT Z0$ 
1200 ?(1,23):PRINT DL$; 
1210 GET Q$:IF Q$="" THEN 1210 
1220 IF Q$="y" THEN 1250 
1230 IF Q$<>"n" THEN 1210 
1240 GOTO 552 
1250 SYS 64628:2,LF,1,K$,L,H,S 
1260 IF S<>0 THEN STOP 
1270 SYS 64628:2,LF,2,K1$,L,H,S 
1280 IF S<>0 THEN STOP 
1290 SYS PL,0,0,15,24 
1300 GOTO 552 
1310 REM ---- MODIFY KEYS 
1315 SYS PL,0,0,15,24 
1317 ?(1,23):PRINT BL$; 
1320 ?(10,16,4),K1$ 
1330 IF K1$="    " THEN 450 
1340 KT$=MID$(K1$,1,1) 
1350 IF KT$=" " THEN ER=1:GOSUB 830: GOTO 1320 
1360 IF KT$=":" THEN ER=2:GOSUB 830: GOTO 1320 
1370 IF KT$="?" THEN ER=3:GOSUB 830: GOTO 1320 
1380 IF ASC(KT$)>47 AND ASC(KT$)<58 THEN ER=4:GOSUB 830: GOTO 1320 
1390 K1=0 
1400 FOR I=4 TO 2 STEP -1 
1410 IF MID$(K1$,I,1)=" " AND K1=0 THEN 1450 
1420 IF K1=0 THEN K1=1: GOTO 1450 
1430 IF MID$(K1$,I,1)<>" " THEN 1450 
1440 ER=5:GOSUB 830:I=1: GOTO 1320 
1450 NEXT  
1460 SYS 64628:3,LF,2,K1$,L,H,S 
1470 IF S<>0 THEN ER=8:GOSUB 830: GOTO 1320 
1480 K$=K1$+SS$:K$=MID$(K$,1,30) 
1490 SYS 64628:4,LF,1,K$,L,H,S 
1500 IF S=5 THEN ER=8:GOSUB 830: GOTO 1320 
1510 IF S<>0 THEN STOP 
1520 ?(10,16):PRINT MID$(K$,1,4) 
1530 ?(10,18):PRINT MID$(K$,5,26) 
1540 Z0$=STR$(L):Z0$=RIGHT$(Z0$,1) 
1550 IF Z0$<>"0" AND Z0$<>"1" THEN STOP 
1560 ?(10,20):PRINT Z0$ 
1570 ?(1,23):PRINT MD$; 
1580 GET Q$:IF Q$="" THEN 1580 
1590 IF Q$="y" THEN 1620 
1600 IF Q$<>"n" THEN 1580 
1610 GOTO 1315 
1620 K3$=K$:Z3$=Z0$ 
1630 SYS 64628:2,LF,1,K$,L,H,S 
1640 IF S<>0 THEN STOP 
1650 SYS 64628:2,LF,2,K1$,L,H,S 
1660 IF S<>0 THEN STOP 
1670 GOTO 552 
1680 REM ---- DISPLAY OR PRINT KEYS 
1690 ?(16,16):PRINT "{reverse on}enter '0' for all keys{reverse off}" 
1691 ?(1,23):PRINT BL$; 
1692 ?(10,16,4),K1$ 
1695 IF K1$="    " THEN 450 
1700 IF K1$="0   " THEN 1830 
1710 KT$=MID$(K1$,1,1) 
1720 IF KT$=" " THEN ER=1:GOSUB 830: GOTO 1690 
1730 IF KT$=":" THEN ER=2:GOSUB 830: GOTO 1690 
1740 IF KT$="?" THEN ER=3:GOSUB 830: GOTO 1690 
1750 IF ASC(KT$)>47 AND ASC(KT$)<58 THEN ER=4:GOSUB 830: GOTO 1690 
1760 K1=0 
1770 FOR I=4 TO 2 STEP -1 
1780 IF MID$(K1$,I,1)=" " AND K1=0 THEN 1820 
1790 IF K1=0 THEN K1=1: GOTO 1820 
1800 IF MID$(K1$,I,1)<>" " THEN 1820 
1810 ER=5:GOSUB 830:I=1: GOTO 1690 
1820 NEXT  
1822 K9$=K1$+SS$:K9$=MID$(K9$,1,30) 
1825 SYS 64628:4,LF,1,K9$,L,H,S 
1826 IF S=5 THEN ER=8:GOSUB 830: GOTO 1690 
1827 IF S<>0 THEN STOP 
1830 ?(1,23):PRINT PR$; 
1840 GET Q$:IF Q$="" THEN 1840 
1850 IF Q$="p" THEN 2160 
1860 IF Q$<>"s" THEN 1840 
1870 K$=K1$+SS$:K$=MID$(K$,1,30) 
1880 TK=0 
1890 SYS PL,1,0,0,24:I=0 
1900 TK=TK+1:I=I+1:IF I>20 THEN TK=TK-1: GOTO 2020 
1910 SYS 64628:4,LF,1,K$,L,H,S 
1920 IF S=0 THEN 1950 
1930 IF S=5 THEN 2080 
1940 IF S<>0 THEN STOP 
1950 ?(0,3+I):PRINT DS$; 
1960 ?(1,3+I):PRINT MID$(K$,1,4) 
1970 ?(8,3+I):PRINT MID$(K$,5,26) 
1980 Z0$=STR$(L):Z0$=RIGHT$(Z0$,1) 
1990 IF Z0$<>"0" AND Z0$<>"1" THEN STOP 
2000 ?(38,3+I):PRINT Z0$ 
2010 GOTO 1900 
2020 ?(33,1):PRINT TK 
2030 ?(0,24):PRINT PK$; 
2040 POKE 2023,160:POKE 56295,0 
2050 GET Q$:IF Q$="" THEN 2050 
2060 IF Q$="_" THEN 450 
2070 GOTO 1890 
2080 ?(33,1):PRINT TK-1 
2085 ?(0,24):PRINT EK$; 
2090 POKE 2023,160:POKE 56295,6 
2100 FOR I=1 TO 3000:NEXT  
2110 ?(0,24):PRINT PK$; 
2120 POKE 2023,160:POKE 56295,0 
2130 GET Q$:IF Q$="" THEN 2130 
2140 GOTO 450 
2150 REM ---- PRINTER ROUTINE 
2160 ?(1,23):PRINT PK$; 
2170 GET Q$:IF Q$="" THEN 2170 
2180 IF Q$="_" THEN 430 
2185 ?(1,23):PRINT AB$; 
2190 PF=4 
2200 OPEN PF,PD,SA 
2210 TK=0 
2220 K$=K1$+SS$:K$=MID$(K$,1,30) 
2230 PRINT#PF,"altkey   altkey action               effect" 
2240 PRINT#PF,"======   ==========================  ======" 
2250 PRINT#PF,"  " 
2260 I=0 
2270 GET Q$:IF Q$="_" THEN 2390 
2280 TK=TK+1:I=I+1:IF I>58 THEN TK=TK-1:PRINT#4,CHR$(12): GOTO 2230 
2290 SYS 64628:4,LF,1,K$,L,H,S 
2300 IF S=0 THEN 2330 
2310 IF S=5 THEN 2390 
2320 IF S<>0 THEN STOP 
2330 PRINT#PF,MID$(K$,1,4)"     "; 
2340 PRINT#PF,MID$(K$,5,26)"     "; 
2350 Z0$=STR$(L):Z0$=RIGHT$(Z0$,1) 
2360 IF Z0$<>"0" AND Z0$<>"1" THEN STOP 
2370 PRINT#PF,Z0$ 
2380 GOTO 2270 
2390 PRINT#PF,"  " 
2400 PRINT#PF,"keys printed ="TK-1 
2410 PRINT#PF,CHR$(12) 
2420 CLOSE PF 
2430 GOTO 430 
