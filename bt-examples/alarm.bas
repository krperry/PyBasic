0 rem find out what kind of unit is being used, and display the title screen accordingly
1 print "do not use this it will eat your battery I am adding functionality to make it work"
2 end
5 u$ = unittype
10 if u$ = "BT Speak" then print "The BTs alarm version 1.00 written by Joseph Bahm modified by Ken Perry"
40 print "If you have any questions, comments, or suggestions concerning this program,"
60 print "Email the BT speak list"
70 print "Press any key to start the program..."
75 rem user presses a key
80 get a$
90 if u$ = "BT Speak" then goto 225
95 rem make sure that if a Type 'n Speak is being used, it is in european time mode
100 print "TNS users should place their units in european time mode before running this program."
110 print "If you already have your unit in european time mode, or if you are a BNS or Braille Lite"
120 print "user, then answer y to the following question. If not, answer n."
130 print "Ok to proceed? Enter y or nprint "
140 get a$
150 if a$ = "y" then goto 230
160 if a$ = "n" then goto 180
170 else print "Please answer y or n." : goto 130
180 print "sorry, your unit must be in european time mode if you are using a TNS"
190 print "before you can use this program."
200 print "Please place your unit in european time mode and re run the program."
210 print "Exiting."
220 end
225 rem speak the current system time and varify that it is correct
230 print "The current system time is"
240 print time_hour ;":";time_minute
260 print "Does this sound about right? Enter y or nprint "
270 get a$
280 if a$ = "y" then goto 340
290 if a$ = "n" then goto 310 else print "Please answer y or n."  
300 goto 260
310 print "Please set the clock to the correct time and re run the program."
320 print "Exiting."
330 end
335 rem user sets the hour and minute the alarm should be activated
340 print "Enter alarm hour, 0 through 23:"
350 input hour
360 if  hour >= 0 and  hour <=  23 then goto 410
370 print "Invalid hour. The valid range is between 0 and 23."
380 print "Please try again:"
390 input hour
400 goto  360
410 print "Enter alarm minute, 0 through 59:"
420 input minute
430 if  minute >= 0 and  minute <= 59 then goto 480
440 print "Invalid minute. The valid range is between 0 and 59."
450 print "Please try again:"
460 input minute
470 goto 430
475 rem user specifies number of beeps to be sounded before the alarm is activated
480 print "Enter the number of beeps that you would like to be sounded before the alarm is activated:"
490 input beeps
500 if  beeps >= 1 then  goto 550
510 print "You must enter a number greater than 0."
520 print "Please try again:"
530 input beeps
540 goto  500
545 rem user specifies how many times the alarm should be repeated before it is automatically turned off
550 print "Enter the number of times that you would like the alarm to be repeated"
555 print "before it is automatically turned off:"
560 input repeats
570 if  repeats >= 1 then goto 620
580 print "You must enter a number greater than 0."
590 print "Please try again:"
600 input repeats
610 goto  570
615 rem give the user some final instructions, turn off the speaker, and start timing the alarm
620 print "You must stay in the program for the alarm to work properly."
640 print "Active alarm timing starts as of now..."
660 curhour = time_hour
670 if  curhour  =hour then  goto 700
680 curhour = time_hour
690 goto 670
700 curminute = time_minute
710 if  curminute = minute then  goto 740
720 curminute = time_minute
730 goto 710
735 rem sound the alarm
750 for x = 1 to beeps
760 beep
770 next x
780 for x = 1 to repeats
790 print "Attention please, it's now";time_hour; ":" ;time_minute
820 print "Press z chord or escape to turn off the alarm."
830 for y = 1 to 60
840 sound 990,3
850 sound 130,3
860 next y
870 next x
880 print "Repetition time expired, de activating the alarm and terminating program..."
890 end
