package Utilities;
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;

public class PasswordUtils {


    public static String hash(String plainText) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] bytes = md.digest(plainText.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static boolean isHashed(String value) {
        return value != null && value.matches("^[0-9a-f]{64}$");
    }

    public static boolean verify(String plainText, String stored) {
        if (plainText == null || stored == null) return false;

        if (isHashed(stored)) {
            return hash(plainText).equals(stored);
        } else {
            return plainText.equals(stored);
        }
    }

    public static boolean needsRehash(String stored) {
        return !isHashed(stored);
    }
}
