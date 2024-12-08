import java.io.*;
import java.util.*;
import java.util.concurrent.*;

public class Benchmark {
    public static void main(String[] args) {
        // Parse input arguments
        if (args.length != 1) {
            System.out.println("Usage: java Benchmark <mode>");
            System.out.println("<mode> can be 'single' or 'multi'");
            return;
        }
        String mode = args[0];

        if (mode.equals("single")) {
            runSingleCoreBenchmark();
        } else if (mode.equals("multi")) {
            runMultiCoreBenchmark();
        } else {
            System.out.println("Invalid mode. Use 'single' or 'multi'");
        }
    }

    private static void runSingleCoreBenchmark() {
        System.out.println("Running single-core benchmark...");
        long startTime = System.currentTimeMillis();

        performTasks();

        long endTime = System.currentTimeMillis();
        System.out.println("Single-core benchmark completed in " + (endTime - startTime) + " milliseconds");
    }

    private static void runMultiCoreBenchmark() {
        System.out.println("Running multi-core benchmark...");
        long startTime = System.currentTimeMillis();

        int cores = Runtime.getRuntime().availableProcessors();
        ExecutorService executor = Executors.newFixedThreadPool(cores);
        List<Callable<Void>> tasks = new ArrayList<>();

        for (int i = 0; i < cores; i++) {
            tasks.add(() -> {
                performTasks();
                return null;
            });
        }

        try {
            executor.invokeAll(tasks);
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            executor.shutdown();
        }

        long endTime = System.currentTimeMillis();
        System.out.println("Multi-core benchmark completed in " + (endTime - startTime) + " milliseconds");
    }

    private static void performTasks() {
        // Parsing data
        List<Integer> numbers = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader("largefile.txt"))) {
            String line;
            while ((line = br.readLine()) != null) {
                for (String part : line.split(",")) {
                    numbers.add(Integer.parseInt(part.trim()));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Sorting
        Collections.sort(numbers);

        // Calculations
        int sum = 0;
        for (int number : numbers) {
            sum += number;
        }
        double average = sum / (double) numbers.size();
    }
}
