.data
numall: .word 0:10000	# Ka�da liczba zajmuje 4 bajty, odnosi� si� do pozycji jako 0,4,8,12 itd
primes: .word 0:10000
N: .word 100
nPrimes: .word 0
newLine: .asciiz "\n"
amountString: .asciiz "Liczba znalezionych liczb pierwszych: "



.text
li   $t1, 0	# i, indeks sprawdzanej liczby w array
li   $t2, 2	# x, liczba dla kt�rej sprawdzamy podzielno��
lw   $t3, N	# zapisuje N do rejestru �eby je podzieli�
sll  $s1, $t3, 1# FIX, sll zamiast mult, N*2, bedzie uzywane do sprawdzenia czy jestesmy na indeksie liczby N/2
sll  $s4, $t3, 2# FIX, sll zamiast mult, Mno�� N*4, b�d� tego potrzebowa� do por�wnywania z i (bo ka�dy indeks i ma 4 bajty)		
		# $t0 u�ywam jako rejest jednorazowy,

inicjalizacjaTablicy:
	sw   $t2 ,numall($t1)	# Zapisuje kolejn� liczb� X do odpowiedniego miejsca na tablicy
	subi $t2, $t2, 1 	# Zmniejszam tymczasowo X do obliczania i (i=4*(X-1))
	sll  $t1, $t2, 2	# FIX: sll zamiast mult, obliczam indeks i = X*4
	addi $t2, $t2, 2	# Zwi�kszam X o jeden dla nast�pnej liczby (zmniejszy�em wcze�niej o 1 czyli teraz +2)
	ble  $t2, $t3, inicjalizacjaTablicy 	# Powr�t do pocz�tku tablicy, chyba �e X==N, wtedy zape�nili�my ca��

		#Przed przej�ciem do p�tli trzeba wyzerowac wartosc i
move $t1, $zero	# i to indeks sprawdzanej liczby w array

# Poczatek sita Eratostenesa:
nextNumber:
	lw   $t2, numall($t1)	# x = numall(i)
	addi $t1, $t1, 4 	# i = i+4, przechodze do nastepnej liczby w tablicy
	beqz $t2, nextNumber 	# Jezeli ta liczba jest wyzerowana to nie sprawdzamy jej wielokrotnosci

sll  $t5, $t2, 2 	# X*4 = offset, czyli o ile zwiekszam liczbe zeby przejsc do nastepnej wielokrotnosci
# X = (X*4)-8, adres liczby X to bylby X*4, ale musze odjac 8 bo tablica numall nie zaczyna sie od 0 tylko od 2
subi $t2, $t5, 8

zerowanie:
	add $t2, $t2, $t5 	# x = x+offset, Przechodz� do nast�pnej wielokrotno�ci liczby
	sw  $zero, numall($t2)	# numall(x) = 0, zeruje wielokrotnosci liczby X	
	blt $t2, $s4, zerowanie # Jezeli x<N*4 to nie przeszedlem jeszcze tablicy do konca, nastepna iteracja
	# Dotarlem do konca tablicy
	blt $t1, $s1, nextNumber# Jezeli i<N*2 to nie dotarlem jeszcze do N/2, sprawdzam wielokrotnosci nastepnej liczby
#Koniec sita Eratostenesa
								
		# Ustwiam warto�ci dla nowej p�tli
li $t1, 0	# i b�d� u�ywa� do iterowania po numall[]
li $t2, 0 	# x b�d� u�ywa� do iterowania po primes[]
lw $t4, nPrimes # nprimes = 0	
countPrimes:
	lw   $t0, numall($t1)	# �aduj� warto�� numall[i] do por�wnania
	beqz $t0, skipNumber	# Je�eli liczba w numall[i] jest zerem to nie jest pierwsza
	addi $t4, $t4, 1 	# Zwi�kszam nprimes
	sw   $t0, primes($t2)	# Zapisuje znalezion� liczb� pierwsz� do primes[ x ]
	addi $t2, $t2, 4	# Zwi�kszam indeks x
skipNumber:
	addi $t1, $t1, 4	# Zwi�kszam indeks i
	blt  $t1, $s4 countPrimes	# Je�eli nie doszli�my do ko�ca listy to wracam do pocz�tku p�tli
	sw   $t4, nPrimes	# Zapisuj� znalezion� ilo�� liczb pierwszych
	sll  $s2, $t4, 2 	# FIX, sll zamiast mult, Mno�� nprimes*4, do por�wnywania z iteratorem
	li   $t1, 0		# Resetuj� iterator "i", b�d� go u�ywa� do iterowania po primes[]
print:
	li   $v0, 1		# Warto�� do wy�wietlenia liczby
	lw   $t0, primes($t1) 	# Pobieram warto�� primes[ i ]
	move $a0, $t0		# Przenosz� liczb� pierwsz� do rejestru do wy�wietlenia
	syscall			# Wy�wietlam liczb� pierwsz�
	li   $v0, 4		# Warto�� do wy�wietlenia stringa
	la   $a0, newLine	# Adres \n
	syscall 		# Wy�wietlam znak nowej lini
	addi $t1, $t1, 4 	# Zwi�kszam indeks i
	blt  $t1, $s2, print 	# Je�eli i < nprimes*4 to nie sko�czyli�my printowa�, print nast�pnej liczby		
	
la   $a0, amountString	# Adres Stringa
syscall
li   $v0, 1		# Warto�� do wy�wietlenia liczby
move $a0, $t4 		# Wy�wietlam nprimes
syscall			

li $v0, 10	# Wyjd� z programu
syscall
