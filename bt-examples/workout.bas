10 rem  Workout-
20 rem An Exercise timer/monitor
30 rem Don C. Urquhart
35 rem Internet: mack@mars.ark.com
40 rem May 4, 1995
45 Gosub 500 : rem Initialize help and comment text
50 Print "Welcome to WORKOUT, version 1.0, by Don C. Urquhart"
60 Print "Please enter countdown minutes, or 0 for help."
70 Input CountMinutes
75 If CountMinutes = 0 then Gosub 600
76 rem Goto 60 : rem Display help
80 OneSecond = 30 : rem Count of 30 = approx. one second
90 BeatCount = 0:  BeatsPerMinute = 0
100 Print "Please be at your station.  Press any key to proceed."
110 Get Start.Key$
120 Gosub 1000 : rem Count down the time
130 Silence = 0:  Gosub 2000 : rem Sound the alarm
140 Gosub 3000 : rem Announcement
150 Reply$ = " "
160 rem while Reply$ <>  "y" and Reply$ <> "n"
170   Print "Would you like to check your heart rate? Enter y or n?"
180   Get Reply$
185 if Reply$ <>  "y" and Reply$ <> "n" then goto 160
190 If Reply$ = "y" then gosub 4000 : rem Check heart rate
200 End : rem of main program
205 : rem Help text
210 Data "I will count down until the number of minutes you enter "
220 Data "has elapsed.  I will then ask you if you wish to check "
230 Data "your heart rate.  If you enter Y, you should then "
240 Data "immediately begin counting beats.  I will stop you "
250 Data "after fifteen seconds, then calculate your heart rate "
260 Data "in beats-per-minute."
265:  rem  Time-is-up announcements
270 Data "your time is up."
280 Data "Your workout is finished."
290 Data "Well done! You have completed your workout."
300 Data "You are finished. Nice work."
310 Data "Time to rest!"
490: rem  Initialize comment and help text
500 Dim HelpText$(6), CommentText$(5)
510 For I = 1 to 6:  Read HelpText$(I):  Next I
520 For C = 1 to 5:  Read CommentText$(C):  Next C
530 Return : rem  to main program
590 : rem  Display help message
600 For I = 1 to 6:  Print HelpText$(I):  Next I
610 Return : rem  to main program
990 : rem  Count down the time
1000 For MinutesElapsed = 1 to CountMinutes
1010   For Seconds = 1 to OneSecond * 60:  Next Seconds
1020   Print MinutesElapsed; " minutes. "
1030 Next MinutesElapsed
1040 Return : rem  to main program
1990 : rem  Sound the alarm
2000 Sound Silence, 2 : rem  Short pause
2010 Sound 300, 1:  Sound 500, 1:  Sound 700, 1
2020 Sound Silence, 3 : rem  Short pause
2030 Return : rem  to main program
2990 :  rem  Announcement
3000 MessageNumber = Int (1 + RND(1) * 5)
3010 Print CommentText$(MessageNumber)
3020 Return : rem  to main program
3990 rem  Check heart rate
4000 For Seconds = 1 to OneSecond * 15:  Next Seconds
4010 Print "STOP! What is your count?"
4020 Input BeatCount
4030 BeatsPerMinute = BeatCount * 4
4040 Print "Your heart rate is "; BeatsPerMinute; " beats per minute."
4050 Return : rem  to main program
