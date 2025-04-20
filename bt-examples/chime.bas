10 Tempo = 180 : Gosub 20010 
20 Sound e * 2, qn:  Sound c * 2, qn:  Sound d * 2, qn:  Sound g, qn
30 Sound r, hn
40 Sound g, qn:  Sound d * 2, qn:  Sound e * 2, qn:  Sound c * 2, hn
50 End
19990:  rem  Define notes
20010 bf = 119
20020 b = 124
20030 C = 131
20040 Cs = 140
20050 D = 147
20060 Ef = 156
20070 E = 165
20075 F = 175
20080 Fs = 186
20085 G = 196
20090 Af = 210
20100 If Tempo = 0 then return : rem  to main program
20110 Qn = 60 / Tempo * 10
20120 Hn = Qn * 2
20130 Wn = Hn * 2
20140 r = 0
20150 return : rem  to main program
