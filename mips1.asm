.data
numall: .word 2:100 # Wygl¹da na to ¿e ka¿da liczba zajmuje 4 bajty, odnosiæ siê do pozycji jako 0,4,8,12 itd
N: .word 100
nPrimes: .word 0



.text
li $t1, 0 # i, indeks sprawdzanej liczby w array
li $t2, 2 # x, liczba dla której sprawdzamy podzielnoœæ
lw $t3, N # zapisuje N do rejestru ¿eby je podzieliæ
div $t3, $t2 # uzyskuje N/2, najdalej do niego bêdê sprawdza³ podzielnoœci
mflo $s1 # zapisuje ca³kowit¹ czêœæ wyniku dzielenia N/2 jako $s1


petla:
bgt $t2, $s1, end # Je¿eli x jest wiêksze od N/2 koñczê szukanie liczb pierwszych



j petla




end:
li $v0, 1   # wartoœæ dla syscall do wyœwietlania liczby
li $t0, 16
lw $a0, numall($t0) # liczba do wyœwietlenia
syscall