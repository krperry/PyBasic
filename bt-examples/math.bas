10 rem Math Practice Program
20 rem written by Marc Mulcahy
30 rem March 29, 1995
40 rem for the BNS, TNS, and Braille Lite Basic interpreter
45 gosub 9000: rem initialization
50 print "Hello, and welcome to the math practice program."
60 rem main program loops until 'q' is pressed
65 c$ = ""
70 if c$ =  "q" or  c$ =  "Q" then goto 210
80 rem display main menu
90 print "Press a to practice addition."
100 print "Press s to practice subtraction."
110 print "Press m to practice multiplication."
120 print "Press d to practice division."
130 print "Or press q to quit."
140 print "Enter your choice."
150 get c$
160 if c$ = "a" or c$ = "A" then 1000
170 if c$ = "S" or c$ = "s" then 2000
180 if c$ = "M" or c$ = "m" then 3000
190 if c$ = "D" or c$ = "d" then 4000
200 goto 70
210 print "Thanks for using this program."
220 print "Have a nice day."
230 end
1000 rem addition practice
1010 gosub 7000: rem get level and number of problems
1160 rem this for loop ends when problems have been done
1170 right = 0
1180 wrong = 0
1190 for counter = 1 to problems
1200 gosub 8000: rem chooses two numbers
1210 answer = n1+n2
1220 uanswer = 0
1230 print "What is "; n1; " plus "; n2
1240 input uanswer
1250if uanswer = answer then gosub 10000: else gosub 11000: rem incorrect
1270 next counter
1280 gosub 6000: rem display score
1290 goto 80
2000 rem subtraction practice
2010 gosub 7000: rem get user's level and number of problems
2020 right = 0: wrong = 0
2030 rem this for loop ends when problems have been done
2040 for counter = 1 to problems
2050 gosub 8000: rem choose two numbers
2060 if n1 < n2 then gosub 7500: rem swap
2070 answer = n1-n2
2080 print "What is " ;n1; " minus "; n2
2090 input uanswer
2100 if uanswer = answer then gosub 10000else gosub 11000: rem incorrect
2120 next counter
2130 gosub 6000: rem display score
2140 goto 80
3000 rem multiplication practice
3010 gosub 7000: rem get user level and number of problems
3020 wrong = 0: right = 0
3030 rem for loop ends when problems have been done
3040 for counter = 1 to problems
3050 gosub 8100: rem chooses two numbers
3060 answer = n1 * n2
3070 print "What is " ; n1 ; " times " ;n2
3080 input uanswer
3090 if uanswer = answer then gosub 10000else gosub 11000: rem incorrect
3110 next counter
3120 gosub 6000:  rem display score
3130 goto 80
4000 rem division practice
4010 gosub 7000: rem get user's level and number of problems
4020 right = 0: wrong = 0
4030 rem for loop ends when problems have been completed
4040 for counter = 1 to problems
4050 gosub 8100: rem chooses two numbers
4060 n1 = n1*n2
4070 answer = n1/n2
4080 print "What is "; n1 ;" divided by "; n2
4090 input uanswer
4100 if uanswer = answer then gosub 10000else gosub 11000: rem incorrect
4120 next counter
4130 gosub 6000: rem display score
4140 goto 80
6000 rem display scor
6010 print "Your score was "; right ; " right, and " ;wrong ; " wrong."
6020 print "Press any key to continue."
6030 get c$
6040 return
7000 rem get user's level and number of problems
7010 l = 0
7020 rem while loop ends when user enters correct level
7030 if  l <>  0 then goto 7130
7040 print "Press e for easy problems."
7050 print "Press m for meedium difficulty problems."
7060 print "Or press h for hard problems."
7070 get c$
7080 if c$ = "E" or c$ = "e" then l = 1
7090 if c$ = "M" or c$ = "m" then l = 2
7100 if c$ = "H" or c$ = "h" then l = 3
7110 if l = 0 then print "that wasn't one of the choices."
7120 goto 7030
7130 print "How many problems would you like?"
7140 input problems
7150 return
7500 rem swap n1 and n2 so that n1 > n2
7510 tmp = n1
7520 n1 = n2
7530 n2 = tmp
7540 return
8000 rem chooses two numbers for addition and subtraction
8010 if l = 1 then limit = 10
8020 if l = 2 then limit = 100
8030 if l = 3 then limit = 500
8040 n1 = int(rnd(1)*limit)+1
8050 n2 = int(rnd(1)*limit)+1
8060 return
8100 rem chooses two numbers for multiplication and division
8110 if l = 1 then limit = 5
8120 if l = 2 then limit = 12
8130 if l = 3 then limit = 20
8140 n1 = int(rnd(1)*limit)+1
8150 n2 = int(rnd(1)*limit)+1
8160 return
9000 rem sets up correct and incorrect responses
9010 dim cr$(5)
9020 dim ir$(5)
9030 cr$(1) = "That's right."
9040 cr$(2) = "Right on."
9050 cr$(3) = "yes, that's right."
9060 cr$(4) = "Good work, that's the right answer."
9070 cr$(5) = "You are right."
9080 ir$(1) = "Sorry, that's not the right answer."
9090 ir$(2) = "That's incorrect."
9100 ir$(3) = "No, that's wrong."
9110 ir$(4) = "That is not correct."
9120 ir$(5) = "Nope, that's the wrong answer."
9130 return
10000 rem correct answer
10010 response = int(rnd(1)*5)+1
10020 print cr$(response)
10030 right = right + 1
10040 return
11000 rem incorrect answer
11010 response = int(rnd(1)*5)+1
11020 print ir$(response)
11030 wrong = wrong + 1
11100 print "The correct answer is "; answer
11110 return
