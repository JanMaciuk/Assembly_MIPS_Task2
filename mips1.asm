.data
numall: .word 0:100	# Wygl�da na to �e ka�da liczba zajmuje 4 bajty, odnosi� si� do pozycji jako 0,4,8,12 itd
N: .word 100
nPrimes: .word 0



.text
li $t1, 0	# i, indeks sprawdzanej liczby w array
li $t2, 2	# x, liczba dla kt�rej sprawdzamy podzielno��
lw $t3, N	# zapisuje N do rejestru �eby je podzieli�
div $t3, $t2	# uzyskuje N/2, najdalej do niego b�d� sprawdza� podzielno�ci
mflo $s1		# zapisuje ca�kowit� cz�� wyniku dzielenia N/2 jako $s1
li $t0, 4	# zapisuje liczb� 4 tymczasowo aby przez ni� pomno�y�
mult $t3, $t0	# Mno�� N*4, b�d� tego potrzebowa� do por�wnywania z i (bo ka�dy indeks i ma 4 bajty)
mflo $s4		# s4 to N*4  (u�ywane do por�wnywania z indeksem)		
		# $t0 u�ywam jako rejest jednorazowy, do operacji takich jak mno�enie

inicjalizacjaTablicy:
	beq $t2, $t3, petlaZero	# Je�eli X==N doszli�my do ko�ca tablicy, nie trzeba jej wype�nia�
	sw $t2 ,numall($t1)	# Zapisuje kolejn� liczb� X do odpowiedniego miejsca na tablicy
	subi $t2, $t2, 1 	# Zmniejszam tymczasowo X do obliczania i
	li $t0, 4 		# �aduje 4 do rejestru �eby pomno�y� i*4
	mult $t2, $t0 		# Nowy indeks i to X*4
	mflo $t1			# Zapisuje nowy indeks i
	addi $t2, $t2, 2		# Zwi�kszam X o jeden dla nast�pnej liczby (zmniejszy�em wcze�niej o 1 czyli teraz +2)
	j inicjalizacjaTablicy

petlaZero:	#Przed przej�ciem do p�tli trzeba wyzerowa� warto�ci X, i do 2, 0
li $t1, 4	# i, indeks sprawdzanej liczby w array
li $t2, 2	# x, liczba dla kt�rej sprawdzamy podzielno�
	

petla:
	lw $t0, numall($t1)	# Zapisuj� warto�� numall(i) aby sprawdzi� jej podzielno��
	div $t0, $t2		# Dziel� numall(i) na X, aby potem sprawdzi� czy jest podzielne
	mfhi $t0			# Pobieram warto�� reszty z dzielenia, aby sprawdzi� podzielno��
	bnez $t0 zwiekszIndex	# Je�eli reszta !=0, to liczba nie jest podzielna, wi�c zostaje w tablicy
	sw $zero, numall($t1)	# Je�eli liczba jest podzielna, to nie mo�e by� piersza, zeruj� jej pozycje w tablicy
	
zwiekszIndex: 			# Przypisywanie nowych warto�ci zmiennych iteracji x,i,   skok jest �eby �atwo pomija� nadpisywanie
	addi $t1, $t1, 4		# Nowy indeks i, przechodzimy o 4 bajty do przodu, czyli o jedn� pozycje na li�cie
	lw $t0 numall($t1)	# �aduje warto�� numall[i], �eby sorawdzi� czy jest zerem
	beqz $t0, zwiekszIndex	# Je�eli numall[i] == 0, to ta liczba jest ju� usuni�ta, nie ma sensu sprawdza�, pomijam
	blt $t1, $s4, petla 	# Je�eli i<N*4 to nie doszli�my do ko�ca p�tli, sprawdzam nastepn� pozycje na p�tli (zwi�kszy�em i)
iteracja:			# Doszli�my do ko�ca p�tli, nast�puje nast�pna iteracja:
	li $t0, 4		# �aduje 4 do rejestru aby mno�y� przez 4
	mult $t2, $t0		# Mno�� x*4 aby uzyska� warto�� od kt�rej zacz�� nast�pn� p�tl� (nie ma sensu sprawdza� podzielno�ci mniejszych warto�ci)
	mflo $t1			# Zapisuj� now� warto�� pocz�tkow� i 
	addi $t2, $t2, 1		# Nast�pna liczba x przez kt�r� sprawdamy podzielno�� to x+1
				# Sprawdzanie czy nast�pna liczba x jest parzysta (wiadomo �e �adna nie b�dzie przez ni� podzielna bo usuneli�my dla x=2)
	li $t0, 2		# �aduj� 2 do rejestru tymczasowego �eby dzieli� przez 2
	div $t2, $t0		# Dziel� x/2, reszta z dzielenia da mi parzysto��
	mfhi $t0			# Pobieram reszt� z dzielenia
	beqz $t0 iteracja	# Je�eli x jest parzyste, to powracam do cz�ci gdzie zwi�kszam x (pomijamy parzyste warto�ci x)
				# Je�eli x jest nieparzyste, powracam do g��wnej p�tli
	ble $t2, $s1, petla	# Je�eli x jest mniejsze/r�wne od N/2 to kontynuuje szukanie liczb pierwszych
				# Je�eli x jest wi�ksze od N/2, ko�czymy
countPrimes:
				
				
				
	
end:
	li $v0, 1	     # warto�� dla syscall do wy�wietlania liczby
	li $t0, 4	     # Indeks liczby kt�r� wy�wietlamy na li�cie (*4)
	lw $a0, numall($t0)  # liczba do wy�wietlenia
	syscall
