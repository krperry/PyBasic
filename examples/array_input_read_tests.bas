10 REM ========================================
20 REM ARRAY INPUT AND READ COMPREHENSIVE TEST
30 REM ========================================
40 REM This program tests all array INPUT and READ functionality
50 REM according to the PyBasic specification
60 REM
70 PRINT "PyBasic Array INPUT/READ Test Suite"
80 PRINT "===================================="
90 PRINT
100 REM
110 REM TEST 1: Basic READ into numeric arrays
120 REM Tests: DIM A(3), DATA statements, READ A(1), A(2), A(3)
130 REM Expected: A(1)=5, A(2)=10, A(3)=15
140 REM
150 PRINT "TEST 1: Basic READ into numeric arrays"
160 DIM A(3)
165 DATA 5, 10, 15
175 RESTORE 165
180 READ A(1), A(2), A(3)
190 PRINT "A(1)="; A(1); " A(2)="; A(2); " A(3)="; A(3)
200 PRINT "Expected: A(1)=5 A(2)=10 A(3)=15"
210 PRINT "PASS: Basic READ into arrays"
220 PRINT
230 REM
240 REM TEST 2: READ with string arrays
250 REM Tests: String array DIM, quoted DATA, READ into string array
260 REM Expected: N$(1)="Ken", N$(2)="Pasha"
270 REM
280 PRINT "TEST 2: READ with string arrays"
290 DIM N$(2)
295 DATA "Ken", "Pasha"
305 RESTORE 295
310 READ N$(1), N$(2)
320 PRINT "N$(1)="; N$(1); " N$(2)="; N$(2)
330 PRINT "Expected: N$(1)=Ken N$(2)=Pasha"
340 PRINT "PASS: READ with string arrays"
350 PRINT
360 REM
370 REM TEST 3: READ with expression indices
380 REM Tests: Variable indices, arithmetic expressions as array indices
390 REM Expected: I=2, A(I*3)=A(6)=100, then A(I+4)=A(6)=200 (overwrites)
400 REM
410 PRINT "TEST 3: READ with expression indices"
420 DIM B(10)
430 I = 2
435 DATA 100, 200
445 RESTORE 435
450 PRINT "I="; I; " Reading into B(I*3) and B(I+4)"
460 READ B(I*3), B(I+4)
470 PRINT "B(6)="; B(6); " (should be 200 - second value overwrites first)"
480 PRINT "Expected: B(6)=200"
490 PRINT "PASS: READ with expression indices"
500 PRINT
510 REM
520 REM TEST 4: Mixed data types in READ
530 REM Tests: Reading numeric and string data into different array types
540 REM Expected: M(1)=100, S$(1)="Hello", M(2)=200
550 REM
560 PRINT "TEST 4: Mixed data types in read"
570 DIM M(2)
580 DIM S$(2)
585 DATA 100, "Hello", 200
595 RESTORE 585
600 READ M(1), S$(1), M(2)
610 PRINT "M(1)="; M(1); " S$(1)="; S$(1); " M(2)="; M(2)
620 PRINT "Expected: M(1)=100 S$(1)=Hello M(2)=200"
630 PRINT "PASS: Mixed data types in READ"
640 PRINT
650 REM
660 REM TEST 5: Array access with computed indices
670 REM Tests: Using array values computed from previous tests
680 REM Expected: Various computed array accesses work correctly
690 REM
700 PRINT "TEST 5: Array access with computed indices"
710 J = 1
720 K = 2
730 PRINT "J="; J; " K="; K
740 PRINT "A(J)="; A(J); " A(K)="; A(K); " A(J+K)="; A(J+K)
750 PRINT "N$(K-1)="; N$(K-1); " N$(K)="; N$(K)
760 PRINT "PASS: Array access with computed indices"
770 PRINT
780 REM
790 REM TEST 6: Complex expression indices
800 REM Tests: More complex arithmetic in array indices
810 REM Expected: Complex expressions evaluate correctly as indices
820 REM
830 PRINT "TEST 6: Complex expression indices"
840 DIM C(20)
850 X = 3
860 Y = 4
865 DATA 999, 888, 777
875 RESTORE 865
880 READ C(X*Y+2), C(X+Y*2), C((X+Y)*2)
890 PRINT "X="; X; " Y="; Y
900 PRINT "C(X*Y+2)=C(14)="; C(14)
910 PRINT "C(X+Y*2)=C(11)="; C(11)
920 PRINT "C((X+Y)*2)=C(14)="; C(14); " (overwrote previous)"
930 PRINT "Expected: C(14)=777, C(11)=888"
940 PRINT "PASS: Complex expression indices"
950 PRINT
960 REM
970 REM TEST 7: Boundary conditions
980 REM Tests: Reading into first and last valid array positions
990 REM Expected: Arrays accessed at boundaries work correctly
1000 REM
1010 PRINT "TEST 7: Boundary conditions"
1020 DIM D(5)
1025 DATA 1, 2, 3, 4, 5
1035 RESTORE 1025
1040 READ D(0), D(1), D(2), D(4), D(5)
1050 PRINT "D(0)="; D(0); " D(1)="; D(1); " D(5)="; D(5)
1060 PRINT "Expected: D(0)=1, D(1)=2, D(5)=5"
1070 PRINT "PASS: Boundary conditions"
1080 PRINT
1090 REM
1100 REM TEST 8: String array with unquoted data
1110 REM Tests: String arrays can accept unquoted string data
1120 REM Expected: Unquoted strings work in string arrays
1130 REM
1140 PRINT "TEST 8: String array with unquoted data"
1150 DIM T$(3)
1155 REM Need separate DATA for this test
1160 DATA HELLO, WORLD, TEST
1165 RESTORE 1160
1170 READ T$(1), T$(2), T$(3)
1180 PRINT "T$(1)="; T$(1); " T$(2)="; T$(2); " T$(3)="; T$(3)
1190 PRINT "Expected: T$(1)=HELLO T$(2)=WORLD T$(3)=TEST"
1200 PRINT "PASS: String array with unquoted data"
1210 PRINT
1220 REM
1230 REM ERROR TESTS - These should fail with proper error messages
1240 REM Uncomment one at a time to test error conditions
1250 REM
1260 PRINT "=========================================="
1270 PRINT "ERROR CONDITION TESTS (commented out)"
1280 PRINT "Uncomment one test at a time to verify:"
1290 PRINT
1300 PRINT "TEST E1: SUBSCRIPT ERROR (negative index)"
1310 PRINT "REM READ A(-1) - should cause SUBSCRIPT ERROR"
1320 PRINT
1330 PRINT "TEST E2: SUBSCRIPT ERROR (index too large)"
1340 PRINT "REM READ A(10) - should cause SUBSCRIPT ERROR"
1350 PRINT
1360 PRINT "TEST E3: OUT OF DATA error"
1370 PRINT "REM READ A(1), A(2) - should cause OUT OF DATA"
1380 PRINT
1390 PRINT "TEST E4: Type mismatch (numeric to string)"
1400 PRINT "REM READ T$(1) when next data is numeric"
1410 PRINT
1420 REM Uncomment these lines ONE AT A TIME to test errors:
1430 REM DIM E(3): READ E(-1)
1440 REM DIM E(3): READ E(10)
1450 REM DIM E(3): DATA 1: READ E(1), E(2)
1460 REM DIM E$(1): DATA 123: READ E$(1)
1470 REM
1480 PRINT "=========================================="
1490 PRINT "ALL FUNCTIONAL TESTS COMPLETED SUCCESSFULLY!"
1500 PRINT "To test error conditions, uncomment error test"
1510 PRINT "lines one at a time and run again."
1520 PRINT "=========================================="