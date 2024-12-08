import java.io.*;
import java.util.Random;

public class FileGenerator {
    public static void main(String[] args) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter("largefile.txt"))) {
            long seed = 11447700; // Change this seed to generate a different file
            Random random = new Random(seed);
            for (int i = 0; i < 100000000; i++) { // Adjust the number to generate a larger or smaller file
                writer.write(random.nextInt(10000) + ",");
                if (i % 100 == 0) {
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("File generated successfully");
    }
}
