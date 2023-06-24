.data
numall: .word 0:1000	# Ka¿da liczba zajmuje 4 bajty, odnosiæ siê do pozycji jako 0,4,8,12 itd
primes: .word 0:1000
N: .word 100
nPrimes: .word 0
newLine: .asciiz "\n"
amountString: .asciiz "Liczba znalezionych liczb pierwszych: "
overflowString: .asciiz "Overflow, wprowadŸ du¿o mniejsze N"



.text
li   $t1, 0	# i, indeks sprawdzanej liczby w array
li   $t2, 2	# x, liczba dla której sprawdzamy podzielnoœæ
lw   $t3, N	# zapisuje N do rejestru ¿eby je podzieliæ
div  $t3, $t2	# uzyskuje N/2, najdalej do niego bêdê sprawdza³ podzielnoœci
mflo $s1		# zapisuje ca³kowit¹ czêœæ wyniku dzielenia N/2 jako $s1
li   $t0, 4	# zapisuje liczbê 4 tymczasowo aby przez ni¹ pomno¿yæ
mult $t3, $t0	# Mno¿ê N*4, bêdê tego potrzebowa³ do porównywania z i (bo ka¿dy indeks i ma 4 bajty)
mflo $s4		# s4 to N*4  (u¿ywane do porównywania z indeksem)
mfhi $t0		# Pobieram potencjalny overflow lub po prostu zeruje $t0
bnez $t0, over	# Wykrywam wprowadzenie za du¿ego N (N*4 nie mieœci siê na 32 bitach)		
		# $t0 u¿ywam jako rejest jednorazowy, do operacji takich jak mno¿enie

inicjalizacjaTablicy:
	sw   $t2 ,numall($t1)	# Zapisuje kolejn¹ liczbê X do odpowiedniego miejsca na tablicy
	subi $t2, $t2, 1 	# Zmniejszam tymczasowo X do obliczania i
	li   $t0, 4 		# £aduje 4 do rejestru ¿eby pomno¿yæ i*4
	mult $t2, $t0 		# Nowy indeks i to X*4
	mflo $t1			# Zapisuje nowy indeks i
	addi $t2, $t2, 2		# Zwiêkszam X o jeden dla nastêpnej liczby (zmniejszy³em wczeœniej o 1 czyli teraz +2)
	ble  $t2, $t3, inicjalizacjaTablicy 	# Powrót do pocz¹tku tablicy, chyba ¿e X==N, wtedy zape³niliœmy ca³¹

		#Przed przejœciem do pêtli trzeba wyzerowaæ wartoœci X, i do 2, 0
li $t1, 4	# i, indeks sprawdzanej liczby w array
li $t2, 2	# x, liczba dla której sprawdzamy podzielnoœ
	

petla:
	lw   $t0, numall($t1)	# Zapisujê wartoœæ numall(i) aby sprawdziæ jej podzielnoœæ
	div  $t0, $t2		# Dzielê numall(i) na X, aby potem sprawdziæ czy jest podzielne
	mfhi $t0			# Pobieram wartoœæ reszty z dzielenia, aby sprawdziæ podzielnoœæ
	bnez $t0 zwiekszIndex	# Je¿eli reszta !=0, to liczba nie jest podzielna, wiêc zostaje w tablicy
	sw   $zero, numall($t1)	# Je¿eli liczba jest podzielna, to nie mo¿e byæ piersza, zerujê jej pozycje w tablicy
	
zwiekszIndex: 			# Przypisywanie nowych wartoœci zmiennych iteracji x,i,   skok jest ¿eby ³atwo pomijaæ nadpisywanie
	addi $t1, $t1, 4		# Nowy indeks i, przechodzimy o 4 bajty do przodu, czyli o jedn¹ pozycje na liœcie
	lw   $t0 numall($t1)	# £aduje wartoœæ numall[i], ¿eby sorawdziæ czy jest zerem
	beqz $t0, zwiekszIndex	# Je¿eli numall[i] == 0, to ta liczba jest ju¿ usuniêta, nie ma sensu sprawdzaæ, pomijam
	blt  $t1, $s4, petla 	# Je¿eli i<N*4 to nie doszliœmy do koñca pêtli, sprawdzam nastepn¹ pozycje na pêtli (zwiêkszy³em i)
iteracja:			# Doszliœmy do koñca pêtli, nastêpuje nastêpna iteracja:
	li   $t0, 4		# £aduje 4 do rejestru aby mno¿yæ przez 4
	mult $t2, $t0		# Mno¿ê x*4 aby uzyskaæ wartoœæ od której zacz¹æ nastêpn¹ pêtlê (nie ma sensu sprawdzaæ podzielnoœci mniejszych wartoœci)
	mflo $t1			# Zapisujê now¹ wartoœæ pocz¹tkow¹ i 
	addi $t2, $t2, 1		# Nastêpna liczba x przez któr¹ sprawdamy podzielnoœæ to x+1
				# Sprawdzanie czy nastêpna liczba x jest parzysta (wiadomo ¿e ¿adna nie bêdzie przez ni¹ podzielna bo usuneliœmy dla x=2)
	li   $t0, 2		# £adujê 2 do rejestru tymczasowego ¿eby dzieliæ przez 2
	div  $t2, $t0		# Dzielê x/2, reszta z dzielenia da mi parzystoœæ
	mfhi $t0			# Pobieram resztê z dzielenia
	beqz $t0 iteracja	# Je¿eli x jest parzyste, to powracam do czêœci gdzie zwiêkszam x (pomijamy parzyste wartoœci x)
				# Je¿eli x jest nieparzyste, powracam do g³ównej pêtli
	ble $t2, $s1, petla	# Je¿eli x jest mniejsze/równe od N/2 to kontynuuje szukanie liczb pierwszych
				# Je¿eli x jest wiêksze od N/2, koñczymy
				
		# Ustwiam wartoœci dla nowej pêtli, teraz bêdê tworzy³	
li $t1, 0	# i bêdê u¿ywa³ do iterowania po numall[]
li $t2, 0 	# x bêdê u¿ywa³ do iterowania po primes[]
lw $t4, nPrimes # nprimes = 0	
countPrimes:
	lw   $t0, numall($t1)	# £adujê wartoœæ numall[i] do porównania
	beqz $t0, skipNumber	# Je¿eli liczba w numall[i] jest zerem to nie jest pierwsza
	addi $t4, $t4, 1 	# Zwiêkszam nprimes
	sw   $t0, primes($t2)	# Zapisuje znalezion¹ liczbê pierwsz¹ do primes[ x ]
	addi $t2, $t2, 4		# Zwiêkszam indeks x
skipNumber:
	addi $t1, $t1, 4		# Zwiêkszam indeks i
	blt  $t1, $s4 countPrimes	# Je¿eli nie doszliœmy do koñca listy to wracam do pocz¹tku pêtli
	sw   $t4, nPrimes	# Zapisujê znalezion¹ iloœæ liczb pierwszych
	li   $t0, 4		# Wczytujê wartoœæ 4 bo bêdê przez ni¹ mno¿y³
	mult $t4, $t0		# Mno¿ê nprimes*4, do porównywania z iteratorem
	mflo $s2 		# Zapisujê wynik mno¿enia
	li   $t1, 0		# Resetujê iterator "i", bêdê go u¿ywa³ do iterowania po primes[]
print:
	li   $v0, 1		# Wartoœæ do wyœwietlenia liczby
	lw   $t0, primes($t1) 	# Pobieram wartoœæ primes[ i ]
	move $a0, $t0		# Przenoszê liczbê pierwsz¹ do rejestru do wyœwietlenia
	syscall			# Wyœwietlam liczbê pierwsz¹
	li   $v0, 4		# Wartoœæ do wyœwietlenia stringa
	la   $a0, newLine	# Adres \n
	syscall 			# Wyœwietlam znak nowej lini
	addi $t1, $t1, 4 	# Zwiêkszam indeks i
	blt  $t1, $s2, print 	# Je¿eli i < nprimes*4 to nie skoñczyliœmy printowaæ, print nastêpnej liczby		
	
la   $a0, amountString	# Adres Stringa
syscall
li   $v0, 1		# Wartoœæ do wyœwietlenia liczby
move $a0, $t4 		# Wyœwietlam nprimes
syscall			

li $v0, 10	# WyjdŸ z programu
syscall

over:
	li   $v0, 4		 # Wartoœæ do wyœwietlenia stringa
	la   $a0, overflowString # Adres Stringa informuj¹cego o overflow
	syscall
	li $v0, 10		 # WyjdŸ z programu
	syscall
