5 rem irish jig song
7 rem Marc Mulcahy
9 rem May 9, 1995
10 TEMPO = 120
12 print "One moment please."
20 GOSUB 20000
30 EN = QN*.5
40 Setsound A*4,EN
50 Setsound G*2,EN
60 Setsound F*2,QN
70 Setsound F*2,EN
80 Setsound G*2,EN
90 Setsound F*2,EN
100 Setsound C*2,EN
110 Setsound A*2,EN
120 Setsound BF*2,EN
130 Setsound C*2,EN
140 Setsound D*2,EN
150 Setsound C*2,EN
160 Setsound A*2,EN
170 Setsound C*2,QN
180 Setsound F*2,EN
190 Setsound G*2,EN
200 Setsound A*4,QN
210 Setsound A*4,QN
220 Setsound A*4,EN
230 Setsound G*2,EN
240 Setsound F*2,EN
250 Setsound G*2,EN
260 Setsound A*4,QN
270 Setsound G*2,QN
280 Setsound G*2,QN
290 Setsound A*4,EN
300 Setsound G*2,EN
310 Setsound F*2,QN
320 Setsound F*2,EN
330 Setsound G*2,EN
340 Setsound F*2,EN
350 Setsound C*2,EN
360 Setsound A*2,EN
370 Setsound BF*2,EN
380 Setsound C*2,EN
390 Setsound D*2,EN
400 Setsound C*2,EN
410 Setsound A*2,EN
420 Setsound C*2,QN
430 Setsound F*2,EN
440 Setsound G*2,EN
450 Setsound A*4,QN
460 Setsound C*4,EN
470 Setsound D*4,EN
480 Setsound C*4,EN
490 Setsound A*4,EN
500 Setsound F*2,EN
510 Setsound G*2,EN
520 Setsound A*4,EN
530 Setsound F*2,EN
540 Setsound G*2,EN
550 Setsound E*2,EN
560 Setsound F*2,QN
570 Setsound 0,QN
580 Setsound A*4,EN
590 Setsound C*4,QN
600 Setsound A*4,EN
610 Setsound C*4,QN
620 Setsound C*4,QN
622 Setsound A*4,EN
624 Setsound C*4,QN
626 Setsound A*4,EN
628 Setsound C*4,QN
629 Setsound 0,QN
630 Setsound BF*4,EN
640 Setsound D*4,QN
650 Setsound BF*4,EN
660 Setsound D*4,QN
670 Setsound D*4,QN
672 Setsound BF*4,EN
674 Setsound D*4,QN
676 Setsound bf*4,EN
678 Setsound D*4,QN
679 Setsound d*4,EN
680 Setsound E*4,EN
690 Setsound F*4,QN
700 Setsound F*4,QN
710 Setsound C*4,QN
720 Setsound C*4,QN
730 Setsound A*4,QN
740 Setsound A*4,QN
750 Setsound G*2,QN
760 Setsound F*2,EN
770 Setsound G*2,EN
780 Setsound A*4,QN
790 Setsound C*4,EN
800 Setsound D*4,EN
810 Setsound C*4,EN
820 Setsound A*4,EN
830 Setsound F*2,EN
840 Setsound G*2,EN
850 Setsound A*4,EN
860 Setsound F*2,EN
870 Setsound G*2,EN
880 Setsound E*2,EN
890 Setsound F*2,EN
900 Setsound F*4,EN
905 print "press any key to play song."
907 get c$
910 for i = 1 to notes
911 play
912 next i
915 sound 0,5
920 end
20000 a = 110
20010 bf = 117
20020 b = 124
20030 c = 131
20040 cs = 139
20050 d = 147
20060 ef = 156
20070 e = 165
20080 f = 175
20090 fs = 185
20100 g = 196
20110 gs = 208
20120 if tempo = 0 then return
20130 qn = (60/tempo)*10
20140 hn = qn*2
20150 wn = qn*4
20160 en = qn/2
20170 sn = qn/4
20180 r = 0
20181 af = 93
20190 return
