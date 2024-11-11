package jftt.lab.list1.kmp;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class KMP {

    public static void main(String[] args) {
        if (args.length != 2) {
            System.out.println("Użycie: java Test <wzorzec> <plik>");
            return;
        }

        String pattern = args[0];
        String filename = args[1];

        String text = readFile(filename);
        if (text == null) {
            System.out.println("Błąd odczytu pliku: " + filename);
            return;
        }

        searchPattern(text, pattern);
    }

    private static String readFile(String filename) {
        StringBuilder content = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line).append("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
        return content.toString();
    }

    private static void searchPattern(String text, String pattern) {
        int[] lps = LPS(pattern);
        int text_id = 0; 
        int pattern_id = 0; 

        while (text_id < text.length()) {
            if (pattern.charAt(pattern_id) == text.charAt(text_id)) {
                text_id++;
                pattern_id++;
            }
            if (pattern_id == pattern.length()) {
                System.out.println("Wzorzec znaleziony na indeksie " + (text_id - pattern_id));
                pattern_id = lps[pattern_id - 1];
            } else if (text_id < text.length() && pattern.charAt(pattern_id) != text.charAt(text_id)) {
                if (pattern_id != 0) {
                    pattern_id = lps[pattern_id - 1];
                } else {
                    text_id++;
                }
            }
        }
    }

    private static int[] LPS(String pattern) {
        int m = pattern.length();
        int[] lps = new int[m];
        int length = 0;
        int pattern_id = 1;

        while (pattern_id < m) {
            if (pattern.charAt(pattern_id) == pattern.charAt(length)) {
                length++;
                lps[pattern_id] = length;
                pattern_id++;
            } else {
                if (length != 0) {
                    length = lps[length - 1];
                } else {
                    lps[pattern_id] = 0;
                    pattern_id++;
                }
            }
        }
        return lps;
    }
}
