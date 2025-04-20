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
320 if a$ = "y" or a$ = "Y" then goto 390
330 if a$ = "n" or a$ = "N" then goto 350
340 else : print "Please answer y or n." : goto 300
350  print "Please set your unit to the correct time and rerun the program."
360 print "Exiting."
370 end
380 rem set the alarm and configuration options
390 input "Enter alarm hour, 0 through 23" , h(2)
400 if  h(2) <0 or h(2) >23 then print "Invalid hour. The valid range is between 0 and 23." :goto 390
430 if h(2) <0 or h(2) >23
440 input "Enter alarm minute, 1 through 59:" , m(2)
450 if  m(2) <1 or m(2) >59 then print "Invalid minute. The valid range is between 1 and 59." :goto 440 
490 input "Enter the number of times to repeat the alarm before it is automatically deactivated:" , rep
500 if  rep = 0 or rep <0 then print "You must enter a number greater than 0 for this option." : goto 490  
540 input "Enter the number of beeps to be sounded before your custom message is spoken:" , b
550 if  b = 0 or b <0 then print "You must enter a number greater than 0 for this option." : got 540 
580 input "Enter a custom message to be displayed before the alarm is sounded:" , m$
590 print "Would you like for the program to click every second during active alarm timing? Enter y or n?"
600 get k$
610 if k$ = "y" or k$ = "Y" or k$ = "n" or k$ = "N" then goto 630
620 else print "Please answer y or n." : goto 590
630 print "Thank you."
640 print "If you requested no clicks during active alarm timing,"
650 print "the speaker on your unit will be turned off to save battery power."
660 print "You must stay in the program for the alarm to work properly."
670 print "Active alarm timing starts as of now..."
680 rem active alarm timing
690 if k$ = "n" or k$ = "N" then off
700 h(1) = time.hour
710 rem while 
720 gosub 5000 : rem delay
730 if k$ = "y" or k$ = "Y" then click
740 h(1) = time.hour
750 if h(1) <>h(2) tjem goto 710 
760 m(1) = time.min
770 rem while m(1) <>m(2)
780 gosub 5000 : rem delay
790 if k$ = "y" or k$ = "Y" then click
800 m(1) = time.min
810 if m(1) <>m(2) then goto 770
820 rem sound the alarm
830 rem on error goto 2040
840 print "."
850 a = 1
860 beep
870 if a = b then goto 890
880 else a = a+1 : goto 860
890 a = 1
900 print m$
910 c = 60
920 sound 990,3 , 130,3
930 c = c-1
940 if c = 0 then goto 960
950 else goto 920
960 if a = rep then goto 980
970 else a = a+1 : goto 900
980 print "Repetition time expired."
990  print "Deactivating the alarm and terminating program..."
995 end
1000 rem snooze mode
1010 on error goto 2060
1015 print "Entering snooze mode"
1020 print "The alarm will be sounded again in about ten minutes."
1030 print "press z-chord or escape to exit the alarm now."
1040 rem time ten minutes for snooze mode
1050 if k$ = "n" or k$ = "N" then off
1060 for x = 1 to 600
1070 gosub 10000 : rem delay
1080 if k$ = "y" or k$ = "Y" then click
1090 next x
1100 goto 830
1990 rem error trapping
2000 if err = 29 then goto 2020
2010 else e = 2010 : goto 2110
2020 print "Abort. Terminating program..."
2030 end
2040 if err = 29 then goto 1010
2050 else e = 2050 : goto 2110
2060 if err = 29 then goto 2080
2070 else e = 2070 : goto 2110
2080 print "Snooze mode deactivated."
2090 print "Terminating program..."
2100 goto 20000
2110 print "Congradulations, you have just discovered a bug in Alarm Version 2.00."
2120 print "Please e-mail, via the internet, jbahm@cris.com"
2130 print "Please include the type of unit you are using."
2140 print "In addition, please also include the error number that is about to be given to you."
2150 print "The error number is:" , e
2160 print "Terminating program..."
2170 end
4990 rem delay for active alarm timing
5000 for pause = 1 to 10 : next pause
5010 return : rem to main program
9990 rem active alarm timing for snooze mode
10000 for pause = 1 to 50 : next pause
10010 return : rem to main program
20000 end
