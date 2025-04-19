10 rem Twenty Three Bricks
15 rem  written for the BNS, TNS, and the Braille Lite
20 rem  by Richard Ehrler of Boise Idaho
25 rem  CompuServe ID = 76645,2710
30 rem  use compile.bns dated May 19, 1995 & run.bns dated May 20, 1995 or later
35 rem  or program will probably not run
40 allcaps
50 print "Welcome to the twenty three bricks program."
60 print "Do you need instructions? y or n"
70 get a$
80 if a$ = "N" then goto 200
90 if a$ <> "Y" then print a$," is not a choice": goto 60
100 print "To play this game you must select 1, 2, or 3 bricks when prompted."
110 print "Then, the computer makes its selection."
120 print "You and the computer take turns selecting bricks until the bricks are gone."
130 print "Whom ever gets the last brick loses the game."
140 print "Enter a 0 to repeat the number of bricks remaining."
150 print "Enter a number without a return because this program uses hot keys."
200 bricks = 23: last = 3
210 print "How many bricks do you want?"
220 get a$: nb = val(a$): if a$ = "%Z" then goto 1040
230 if a$ = "0" then print "There are "bricks" bricks remaining. ,,,": goto 210
240 if nb < 1 or nb > 3 then print "Only 0, 1, 2, or 3 are valid. ,,,": goto 210
250 if nb > bricks then print "There are only ",bricks," bricks left.,": goto 210
260 bricks = bricks - nb
270 print "You took "; nb ;" leaving "; bricks ;" bricks."
280 if bricks = 0 then goto 1000
290 if bricks <= last then last = bricks - 1
300 if (bricks - 1) / 4 + 1 = int(bricks / 4) + 1 then nb = int(rnd(1) * last) + 1 else nb = int((bricks + 2) / 4 - 1) * 4 + 1 : nb = bricks - nb
320 bricks = bricks - nb
330 print "I took "; nb ;" leaving "; bricks ;" bricks."
340 if bricks > 0 then goto 210
350 print "Congratulations!, You beat me this time."
360 goto 1010
1000 print "You took the last brick and lost this game."
1010 print "Would you like to play again?, y or n"
1020 get a$
1030 if a$ = "Y" then goto 200
1040 print "Bye bye.": end
