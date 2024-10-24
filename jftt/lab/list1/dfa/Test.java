package jftt.lab.list1.dfa;

public class Test {

    public static void main(String[] args) {

        String pattern = "PALLYR";
        String text = "UWUPALLYRIELILIIPALLYR";

        Character[] alphabet = new Character[pattern.length()];

        for (int i = 0; i < pattern.length(); i++) {
            alphabet[i] = pattern.charAt(i);
        }

        int[][] delta = new int[26][26];

        for (int i = 0; i < pattern.length(); i++) {
            for (int j = 0; j < 26; j++) {
                if (alphabet[i] == j + 65) {
                    delta[i][j] = i + 1;
                } else if (alphabet[0] == j + 65) {
                    delta[i][j] = 1;
                } else {
                    delta[i][j] = 0;
                }
            }
        }

        int q = 0;

        for (int i = 0; i < text.length(); i++) {
            q = delta[q][text.charAt(i) - 65];
            if (q == pattern.length()) {
                System.out.println("Pattern found at index " + (i - pattern.length() + 1));
                q = 0;
            }
        }
        
    }
    
}
