.data
numall: .word 2:100 # Wygl�da na to �e ka�da liczba zajmuje 4 bajty, odnosi� si� do pozycji jako 0,4,8,12 itd
N: .word 100
nPrimes: .word 0



.text
li $t1, 0 # i, indeks sprawdzanej liczby w array
li $t2, 2 # x, liczba dla kt�rej sprawdzamy podzielno��
lw $t3, N # zapisuje N do rejestru �eby je podzieli�
div $t3, $t2 # uzyskuje N/2, najdalej do niego b�d� sprawdza� podzielno�ci
mflo $s1 # zapisuje ca�kowit� cz�� wyniku dzielenia N/2 jako $s1


petla:
bgt $t2, $s1, end # Je�eli x jest wi�ksze od N/2 ko�cz� szukanie liczb pierwszych



j petla




end:
li $v0, 1   # warto�� dla syscall do wy�wietlania liczby
li $t0, 16
lw $a0, numall($t0) # liczba do wy�wietlenia
syscall