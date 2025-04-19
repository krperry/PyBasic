10 Print "Enter the length of a side.":  Input Length
20 Print "Enter the width.":  Input Width
30 Gosub 20000 : rem  Calc area
40 Print "Rectangular area is:";  RectArea;
50 end
19990 : rem  Calc area
20000 RectArea = Length * Width
20010 Return : rem  to main program
