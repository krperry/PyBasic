10 rem  Experimental program to send a Morse code message
20 rem  Don C. Urquhart
30 rem  Internet: mack@mars.ark.com
40 rem  Amateur call sign: VE7DCD
50 rem  May 5, 1995
60 rem  Adjust these variables to your preferences
70 CodeFreq = 400 : rem  Frequency of code tones
75 Silence = 0 : rem  0 = silence for specified duration
80 ShortTone = 1 : rem  "DIT" tone
90 LongTone = 3 : rem  "DAH" tone
100 Print "Please enter a coded message, or type help for help."
110 AllCaps : rem  Make all input upper case
120 Input CodedMessage$
130 If CodedMessage$ = "help" then gosub 2000 Else gosub 1000 : rem  Send message
150 AllCaps : rem  Caps lock is now off
160 End : rem of main program
990 : rem  Send message
1000 For Position = 1 to Len (CodedMessage$)
1010   Ch$ = Mid$ (CodedMessage$, Position, 1)
1020   If Ch$ = "." then Sound CodeFreq, ShortTone
1030   If Ch$ = "-" then Sound CodeFreq, LongTone
1040   If Ch$ = " " then Sound Silence, LongTone
1050 Next Position
1060 Return : rem  to main program
1990 : rem  Help message
2000 Print "Enter your message in Morse code.  "
2010 Print "It should contain only periods, dashes, and spaces."
2020 Return : rem  to main program
