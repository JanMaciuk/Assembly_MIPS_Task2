public class AssemblyComparison {
    private static int nprimes;
    public static void main(String[] args) {
        long startTime = System.nanoTime();
        int[] primes = findPrimes(5000);
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
        for (i = 2; i < N; i++) {
            numall[i] = i;
        }

        for (x=2; x < N/2; x++) {
            for (i=x+1; i < N; i++) {
                if (numall[i] != 0 && numall[i] % x == 0) {
                    numall[i] = 0;
                }
            }
        }

        for (i = 2; i < N; i++) {
            if (numall[i] != 0) {
                primes[nprimes] = numall[i];
                nprimes++;
            }
        }

        return primes;
    }
    /*
    Czas wykonania dla rozmiarów N:
    N = 1000: Assembly: 0.2s, Java: 1.5ms
    N = 2000: Assembly: 1.9s, Java: 2.7ms
    N = 5000: Assembly: 9.6s, Java: 8.5ms

    Jak widać Assembly MIPS jest znacznie wolniejszy od javy.
    Wynika to głównie z emulacji MIPS przez środowisko MARS.
    Kompilator Javy jest także ekstremalnie zoptymalizowany, w przeciwieństwie do kodu który sam napisałem w Assembly (mimo podstawowych optymalizacji).
    Myślę że gdyby program Assembly był napisany w wersji natywnej dla systemu na którym jest uruchamiany, wykazałby się znacznie większą wydajnością.
    Wiekowy już emulator architektury MIPS na pewno nie wykorzystuje całego potencjału nowoczesnego wielowątkowego procesora CISC.
     */
}