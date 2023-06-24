.data
numall: .word 0:10000	# Ka¿da liczba zajmuje 4 bajty, odnosiæ siê do pozycji jako 0,4,8,12 itd
primes: .word 0:10000
N: .word 100
nPrimes: .word 0
newLine: .asciiz "\n"
amountString: .asciiz "Liczba znalezionych liczb pierwszych: "



.text
li   $t1, 0	# i, indeks sprawdzanej liczby w array
li   $t2, 2	# x, liczba dla której sprawdzamy podzielnoœæ
lw   $t3, N	# zapisuje N do rejestru ¿eby je podzieliæ
sll  $s1, $t3, 1# FIX, sll zamiast mult, N*2, bedzie uzywane do sprawdzenia czy jestesmy na indeksie liczby N/2
sll  $s4, $t3, 2# FIX, sll zamiast mult, Mno¿ê N*4, bêdê tego potrzebowa³ do porównywania z i (bo ka¿dy indeks i ma 4 bajty)		
		# $t0 u¿ywam jako rejest jednorazowy,

inicjalizacjaTablicy:
	sw   $t2 ,numall($t1)	# Zapisuje kolejn¹ liczbê X do odpowiedniego miejsca na tablicy
	subi $t2, $t2, 1 	# Zmniejszam tymczasowo X do obliczania i (i=4*(X-1))
	sll  $t1, $t2, 2	# FIX: sll zamiast mult, obliczam indeks i = X*4
	addi $t2, $t2, 2	# Zwiêkszam X o jeden dla nastêpnej liczby (zmniejszy³em wczeœniej o 1 czyli teraz +2)
	ble  $t2, $t3, inicjalizacjaTablicy 	# Powrót do pocz¹tku tablicy, chyba ¿e X==N, wtedy zape³niliœmy ca³¹

		#Przed przejœciem do pêtli trzeba wyzerowac wartosc i
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
	add $t2, $t2, $t5 	# x = x+offset, Przechodzê do nastêpnej wielokrotnoœci liczby
	sw  $zero, numall($t2)	# numall(x) = 0, zeruje wielokrotnosci liczby X	
	blt $t2, $s4, zerowanie # Jezeli x<N*4 to nie przeszedlem jeszcze tablicy do konca, nastepna iteracja
	# Dotarlem do konca tablicy
	blt $t1, $s1, nextNumber# Jezeli i<N*2 to nie dotarlem jeszcze do N/2, sprawdzam wielokrotnosci nastepnej liczby
#Koniec sita Eratostenesa
								
		# Ustwiam wartoœci dla nowej pêtli
li $t1, 0	# i bêdê u¿ywa³ do iterowania po numall[]
li $t2, 0 	# x bêdê u¿ywa³ do iterowania po primes[]
lw $t4, nPrimes # nprimes = 0	
countPrimes:
	lw   $t0, numall($t1)	# £adujê wartoœæ numall[i] do porównania
	beqz $t0, skipNumber	# Je¿eli liczba w numall[i] jest zerem to nie jest pierwsza
	addi $t4, $t4, 1 	# Zwiêkszam nprimes
	sw   $t0, primes($t2)	# Zapisuje znalezion¹ liczbê pierwsz¹ do primes[ x ]
	addi $t2, $t2, 4	# Zwiêkszam indeks x
skipNumber:
	addi $t1, $t1, 4	# Zwiêkszam indeks i
	blt  $t1, $s4 countPrimes	# Je¿eli nie doszliœmy do koñca listy to wracam do pocz¹tku pêtli
	sw   $t4, nPrimes	# Zapisujê znalezion¹ iloœæ liczb pierwszych
	sll  $s2, $t4, 2 	# FIX, sll zamiast mult, Mno¿ê nprimes*4, do porównywania z iteratorem
	li   $t1, 0		# Resetujê iterator "i", bêdê go u¿ywa³ do iterowania po primes[]
print:
	li   $v0, 1		# Wartoœæ do wyœwietlenia liczby
	lw   $t0, primes($t1) 	# Pobieram wartoœæ primes[ i ]
	move $a0, $t0		# Przenoszê liczbê pierwsz¹ do rejestru do wyœwietlenia
	syscall			# Wyœwietlam liczbê pierwsz¹
	li   $v0, 4		# Wartoœæ do wyœwietlenia stringa
	la   $a0, newLine	# Adres \n
	syscall 		# Wyœwietlam znak nowej lini
	addi $t1, $t1, 4 	# Zwiêkszam indeks i
	blt  $t1, $s2, print 	# Je¿eli i < nprimes*4 to nie skoñczyliœmy printowaæ, print nastêpnej liczby		
	
la   $a0, amountString	# Adres Stringa
syscall
li   $v0, 1		# Wartoœæ do wyœwietlenia liczby
move $a0, $t4 		# Wyœwietlam nprimes
syscall			

li $v0, 10	# WyjdŸ z programu
syscall
