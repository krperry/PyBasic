0 rem setup longterm counters and default settings for the program
10 ltright = 0 : ltwrong = 0 : ltall = 0 : beep$ = "y" : beeps = 1
20 print "The TNS keyboard drill program version 1.00 written by Joseph Bahm."
30 print "If you have any questions, comments, or suggestions concerning this program,"
40 print "e-mail, via the internet, jbahm@cris.com"
50 input "Please enter your first name" , n$
60 print "Wellcome to the program" : ?n$ : print "press any key for the main menu"
70 get a$
75 on error goto 500
80 print "Main Menu"
90 print "c=create a drill"
100 print "p=practice a drill"
110 print "o=options"
120 print "i=program information"
130 print "q=quit"
140 print "Please enter your selection"
150 get a$
160 if a$ = "c" or a$ = "C" then goto 1000
170 if a$ = "p" or a$ = "P" then goto 2000
180 if a$ = "o" or a$ = "O" then goto 3000
190 if a$ = "i" or a$ = "I" then goto 4000
200 if a$ = "q" or a$ = "Q" then goto 5000
210 else print "Invalid response." : goto 80
490 rem error trapping statements
500 if err = 29 then print "Program aborted." : end
510 else print "Congradulations, you have just discovered a bug in TNS v1.00. Please e-mail via the internet, jbahm@cris.com" : end
990 rem create a drill
1000 print "Create a Drill"
1010 input "Enter the file name to contain the drill:" , f$
1020 gosub 10000 : rem see if the file exists
1025 on error goto 500
1030 input "How many drills will you have in this lessonprint " , d
1040 input "Enter a brief discription of this lesson:" , e$
1050 fprint 1,d , 1,e$
1060 for x = 1 to d
1070 print "Enter the key sequence for drill" : ?x : input s$
1080 input "Enter the pronunciation for this drill:" , p$
1090 fprint 1,s$ , 1,p$
1100 next x
1110 close 1
1120 print "Your drill is ready"
1130 goto 80
1990 rem practice a drill
2000 print "Practice a Drill"
2010 input "Enter the name of the file containing the lesson:" , f$
2020 gosub 20000 : rem see if the file exists
2025 on error goto 500
2030 rem start short term counters for right, wrong, and total answers
2040 stright = 0 : stwrong = 0 : stall = 0
2050 finput 1,d , 1,e$
2060 print "You will be given" : ?d : print "drills concerning" : ?e$
2070 for x = 1 to d
2080 print "Drill number" : ?x
2090 finput 1,s$ , 1,p$
2100 ?p$
2110 input a$
2115 ltall = ltall+1 : stall = stall+1
2120 if a$ = s$ then goto 2140
2130 else goto 2170
2140 ltright = ltright+1 : stright = stright+1
2150 print "Correct."
2160 goto 2200
2170 ltwrong = ltwrong+1 : stwrong = stwrong+1
2180 if beep$ = "y" or beep$ = "Y" then gosub 50000 : rem beep
2190 print "Incorrect."
2200 next x
2210 close 1
2220 gosub 30000 : rem calculate percentage
2230 print "Good job" : ?n$ : print "you have completed your lesson."
2240 print "You got" : ?stright : print "answers right"
2250 print "You got" : ?stwrong : print "answers wrong"
2260 print "There were" : ?stall : print "answers possible"
2270 print "You got" : ?percent : print "percent of these correct"
2280 if percent >89 then print "You don't need any more work on this lesson."
2290 if percent = 89 or percent <89 then print "You need more work on this lesson."
2300 goto 80
2990 rem options
3000 print "Options Menu"
3010 print "b=beeps on/off"
3020 print "r=reset program"
3030 print "s=set number of beeps"
3040 print "v=view your current profile"
3050 print "q=quit this menu"
3055 print "Please enter your selection:"
3060 get m$
3070 if m$ = "b" or m$ = "B" then goto 3200 : rem beeps on/off
3080 if m$ = "r" or m$ = "R" then goto 3300 : rem reset program
3090 if m$ = "s" or m$ = "S" then goto 3400 : rem set number of beeps
3100 if m$ = "v" or m$ = "V" then goto 3500 : rem view current profile
3110 if m$ = "q" or m$ = "Q" then goto 80
3120 else print "Invalid response." : goto 3000
3200 print "Do you want beeps on an incorrect answer? Enter y or nprint "
3210 get beep$
3220 if beep$ = "y" or beep$ = "Y" or beep$ = "n" or beep$ = "N" then goto 3000
3230 else print "Please answer y or n." : goto 3000
3300 print "Are you sure you want to reset the program? Enter y or nprint "
3310 get y$
3320 if y$ = "y" or y$ = "Y" then clear : goto 0
3330 if y$ = "n" or y$ = "N" then goto 3000
3340 else print "Please answer y or n." : goto 3300
3400 input "How many beeps should be sounded on an incorrect answerprint " , beeps
3410 if  beeps = 0 or beeps = <0 then while =1 goto 3470 
3420 print "You must enter a number grater than zero."
3430 print "If you want beeps off, turn them off using the beeps on/off"
3440 print "option from the options menu."
3450 goto 3400
3460 goto 3410
3470 goto 3000
3500 gosub 40000 : rem calculate percentage
3510 print "YOur Current Profile"
3520 print "Name..." : ?n$
3530 print "Answers Right so Far..." : ?ltright
3540 print "Answers Wrong so Far..." : ?ltwrong
3550 print "Answers Possible..." : ?ltall
3560 ?percent : print "percent of these are correct."
3570 goto 3000
4000 print "TNS, a Type 'n Speak keyboard drills manager."
4010 print "Version 1.00."
4020 print "Written by Joseph Bahm."
4030 print "Beta tested by Joseph Bahm, and Ryan Shugart."
4040 print "Compiled friday December 8, 1995 at 18:22"
4050 print "Comments and suggestions would be greatly appreciated."
4060 print "Problems, questions, comments, and suggestions should be directed to Joseph Bahm."
4070 print "E-mail: jbahm@cris.com"
4080 print "Phone: (719) 596-4345"
4090 goto 80
5000 gosub 40000 : rem calculate percentage
5010 print "Before you quit, I'm going to give you your long term statistics."
5020 print "You got" : ?ltright : print "answers right"
5030 print "You got" : ?ltwrong : print "answers wrong"
5040 print "There were a total of" : ?ltall : print "answers possible"
5050 print "You got" : ?percent : print "percent of these correct."
5060 print "Thank you for using this program" : ?n$
5070 print "I hope that you found it useful, and that you will use it again in the future."
5080 print "Exiting."
5090 end
5100 rem end of main program
9990 rem see if the file exists
10000 on error goto 10040
10010 open 1,f$
10020 input "That file allready exists. Please specify a different file name:" , f$
10030 close 1 : goto 10000
10040 if err = 8 then goto 10100
10050 if err = 12 then goto 10110
10060 if err = 19 then goto 10120
10070 if err = 23 then goto 10130
10075 if err = 29 then print "Program aborted." : end
10080 else print "Congradulations you have just discovered a bug in TNS V1.00. Please e-mail via the internet, jbahm@cris.com" : end
10100 print "Error, not enough memory to create file. Please delete some files and rerun the program." : end
10110 create 1,f$ : return
10120 input "Bad file name. Please specify a different file name:" , f$ : goto 10000
10130 print "Error, can't create file. Please check your unit and rerun the program." : end
10140 return : rem to main program
19990 rem see if the file exists
20000 on error goto 20020
20010 open 1,f$ : return : rem to main program
20020 if err = 12 then goto 20040
20025 if err = 29 then print "Program aborted." : end
20030 else print "Congradulations you have just discovered a bug in TNS V1.00. Please e-mail via the internet, jbahm@cris.com" : end
20040 input "That file doesn't exist. Please specify a different file name:" , f$ : goto 20000
20050 return : rem to main program
29990 rem calculate short term percentage
30000 on error goto 30020
30010 a = stright/stall : percent = a*100 : return : rem to main program
30020 if err = 16 then goto 30040
30030 else print "Congradulations you have just discovered a bug in TNS V1.00. Please e-mail via the internet, jbahm@cris.com" : end
30040 percent = 0 : return : rem to main program
30050 return : rem to main program
39990 rem calculate long term percentage
40000 on error goto 40020
40010 a = ltright/ltall : percent = a*100 : return : rem to main program
40020 if err = 16 then goto 40040
40030 else print "Congradulations you have just discovered a bug in TNS V1.00. Please e-mail via the internet, jbahm@cris.com" : end
40040 percent = 0 : return : rem to main program
40050 return : rem to main program
49990 rem beep
50000 for y = 1 to beeps
50010 beep
50020 next y
50030 return : rem to main program
