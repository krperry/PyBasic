0 print "Welcome to the guess the number game."
1 tempo = 240
2 print "I will pick a number between 1 and 100."
3 gosub 20000
4 print "You will have six chances to guess it."
6 gosub 30000
8 flag = 1
9  if  flag <> 1 then goto 270
10 guesses = 1
20 number = int((rnd(1)*100)+1)
30 if  guesses >= 7 or  g = number then goto 105
40 print "guess number " guesses
50 print "enter a guess."
60 input g
70 if g < number then gosub 1000
80 if g > number then gosub 2000
90 if g = number then gosub 3000
95 guesses = guesses + 1
100 goto 30
105 if guesses = 7 and g <> number then 200
110 goto 210
200 print "You are out of guesses."
205 print "my number was "; number
210 print "want to play again?"
220 get c$
225 flag = 2
230 if c$ = "y" or c$ = "Y" then flag = 1
240 if c$ = "n" or c$ = "N" then flag = 0
250 if flag = 2 then 300
260 goto 9
270 print "Ok, thanks for playing the guess the number game."
280 print "have a nice day."
290 end
300 print "Press y or n."
310 goto 220
1000 c = (int(rnd(1)*5)+1)
1010 if c = 1 then print "incorrect, your guess is too low."
1020 if c = 2 then print "Wrong, my number is higher."
1030 if c = 3 then print "That's not right, your guess was too low."
1040 if c = 4 then print "Sorry, my number's higher."
1050 if c = 5 then print "no, your guess was too low."
1060 return
2000 c = (int(rnd(1)*5)+1)
2010 if c = 1 then print "sorry, your guess was too high."
2020 if c = 2 then print "Wrong, my number's lower."
2030 if c = 3 then print "no, my number's lower."
2040 if c = 4 then print "Incorrect, my number is lower."
2050 if c = 5 then print "That's not right, your guess was too high."
2060 return
3000 setpos 1 
3001 for i = 1 to notes
3002 play
3003 next  i
3007 print "right on."
3008 print "congratulations, you guessed my number in "; guesses; " guesses."
3009 print "My number was "; number
3010 return
20000 A = 110
20010 BF = 119
20020 B = 124
20030 C = 131
20040 CS = 140
20050 D = 147
20060 EF = 158
20070 E = 165
20080 F = 175
20090 FS = 186
20100 G = 196
20110 AF = 210
20120 IF TEMPO = 0 THEN RETURN
20130 QN = 60/TEMPO*10
20140 HN = QN*2
20150 WN = HN*2
20160 RETURN
30000 setsound c,qn,f,qn,a*2,qn,c*2,hn,a*2,qn,c*2,hn+qn
30010 return
