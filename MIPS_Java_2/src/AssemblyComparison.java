public class AssemblyComparison {
    private static int nprimes;
    public static void main(String[] args) {
        long startTime = System.nanoTime();
        int[] primes = findPrimes(100);
        System.out.println("Czas w nanosekundach:");
        System.out.println(System.nanoTime()-startTime);
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
}