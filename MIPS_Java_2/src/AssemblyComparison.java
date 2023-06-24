public class AssemblyComparison {
    private static int nprimes;
    public static void main(String[] args) {
        long startTime = System.nanoTime();
        int[] primes = findPrimes(100);
        System.out.println("Czas w milisekundach:");
        System.out.println((System.nanoTime()-startTime)/1000000.0);
        System.out.println("Liczba znalezionych liczb pierwszych: " + nprimes);
    }

    private static int[] findPrimes(int N) { // Sieve of Eratosthenes
        // Code is not the most optimized, it's meant to mimic assembly code, for comparison of efficency.

        int[] numall = new int[N];
        int[] primes = new int[N];
        nprimes = 0;
        int i, x;
        for (i = 2; i <= N; i++) {
            numall[i-2] = i;
        }
        i = 0;

        while(i<N/2) {
            //nextNumber:
            x = numall[i];
            i++;
            if (x == 0) continue;

            int offset = x;
            x-=2;
            //zerowanie:
            while (x<N) {
                x+=offset;
                if (x>=N) break;
                numall[x] = 0;
            }

        }


        for (i = 2; i < N; i++) {
            if (numall[i-2] != 0) {
                primes[nprimes] = numall[i];
                nprimes++;
            }
        }

        return primes;
    }
    /*

   Assembly MIPS w MARS jest znacznie wolniejszy od javy.
    Wynika to głównie z emulacji MIPS przez środowisko MARS.
    Kompilator Javy jest także ekstremalnie zoptymalizowany, w przeciwieństwie do kodu który sam napisałem w Assembly (mimo podstawowych optymalizacji).
    Myślę że gdyby program Assembly był napisany w wersji natywnej dla systemu na którym jest uruchamiany, wykazałby się znacznie większą wydajnością.
    Wiekowy już emulator architektury MIPS na pewno nie wykorzystuje całego potencjału nowoczesnego wielowątkowego procesora CISC.
     */
}