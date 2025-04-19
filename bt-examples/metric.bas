10 rem Converts a measure in inches to a measure in centimeters
20 Print "Enter measurement in inches.":  Input Inches
30 Gosub 5000 : rem  Inches-to-centimeters function
40 Print "Your measurement is:"; Centimeters ;"  centimeters."
50  End : rem  of main program
4990: end : rem  Inches-to-centimeters
5000 Centimeters = Inches * 2.5
5100 Return : rem  to main program
