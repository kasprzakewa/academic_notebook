package jftt.lab.list1.dfa;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class FA {

    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Użycie: java Test <wzorzec> <plik>");
            return;
        }

        String pattern = args[0];
        String filePath = args[1];

        Character[] alphabet = getAlphabet(pattern);
        int[][] delta = buildDeltaTable(pattern, alphabet);

        try {
            findPatternInFile(filePath, pattern, delta);
        } catch (IOException e) {
            System.out.println("Błąd odczytu pliku: " + e.getMessage());
        }
    }

    private static Character[] getAlphabet(String pattern) {
        Character[] alphabet = new Character[pattern.length()];
        for (int i = 0; i < pattern.length(); i++) {
            alphabet[i] = pattern.charAt(i);
        }
        return alphabet;
    }

    private static int[][] buildDeltaTable(String pattern, Character[] alphabet) {
        int[][] delta = new int[pattern.length() + 1][128];
        for (int i = 0; i <= pattern.length(); i++) {
            for (int j = 0; j < 128; j++) {
                if (i < pattern.length() && alphabet[i] == j) {
                    delta[i][j] = i + 1;
                } else if (i > 0) {
                    delta[i][j] = Math.min(pattern.length(), delta[getPrefix(pattern, i - 1)][j]);
                }
            }
        }
        return delta;
    }

    private static int getPrefix(String pattern, int length) {
        for (int i = length; i > 0; i--) {
            if (pattern.substring(0, i).equals(pattern.substring(length - i + 1, length + 1))) {
                return i;
            }
        }
        return 0;
    }

    private static void findPatternInFile(String filePath, String pattern, int[][] delta) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            int q = 0;
            int index = 0;
            int charRead;

            while ((charRead = reader.read()) != -1) {
                q = delta[q][charRead];
                if (q == pattern.length()) {
                    System.out.println("Wzorzec znaleziony na indeksie " + (index - pattern.length() + 1));
                }
                index++;
            }
        }
    }
}

