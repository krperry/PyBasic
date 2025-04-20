2 rem Take Me Out to the Ballgame
5 rem Programmed by Marc Mulcahy
7 rem May 9, 1995
10 TEMPO = 120
12 print "One moment please..  Please rise!"
20 GOSUB 20000
30 Setsound C,QN
35 Setsound 0,QN
40 Setsound C*2,QN
50 Setsound A*2,QN
60 Setsound G,QN
70 Setsound E,QN
80 Setsound G,QN+HN
90 Setsound D,QN+HN
100 Setsound C,QN
105 Setsound 0,QN
110 Setsound C*2,QN
120 Setsound A*2,QN
130 Setsound G,QN
140 Setsound E,QN
150 Setsound G,WN+HN
160 Setsound A*2,QN
170 Setsound AF,QN
180 Setsound A*2,QN
185 Setsound E,QN
190 Setsound F,QN
200 Setsound G,QN
210 Setsound A*2,HN
220 Setsound F,QN
230 Setsound D,HN+QN
240 Setsound A*2,QN
250 Setsound 0,QN
260 Setsound A*2,QN
270 Setsound A*2,QN
280 Setsound B*2,QN
290 Setsound C*2,QN
300 Setsound D*2,QN
310 Setsound B*2,QN
320 Setsound A*2,QN
330 Setsound G,QN
340 Setsound E,QN
350 Setsound D,QN
360 Setsound C,QN
370 Setsound 0,QN
380 Setsound C*2,QN
390 Setsound A*2,QN
400 Setsound G,QN
410 Setsound E,QN
420 Setsound G,QN+HN
430 Setsound D,QN+HN
440 Setsound C,QN
450 Setsound C,QN
460 Setsound D,QN
470 Setsound E,QN
480 Setsound F,QN
490 Setsound G,QN
500 Setsound A*2,WN
510 Setsound A*2,QN
520 Setsound B*2,QN
530 Setsound C*2,QN
540 Setsound 0,HN
550 Setsound C*2,QN
560 Setsound 0,HN
570 Setsound C*2,QN
580 Setsound B*2,QN
590 Setsound A*2,QN
600 Setsound G,QN
610 Setsound FS,QN
620 Setsound G,QN
630 Setsound A*2,QN+HN
640 Setsound B*2,QN+HN
650 Setsound C*2,WN
670 print "Press any key to play song."
680 get c$
690 for i = 1 to notes
691 play
692 next i
695 sound 0,5
696 print "Play Ball!"
700 end
20000 a = 110 : print "did a"
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


