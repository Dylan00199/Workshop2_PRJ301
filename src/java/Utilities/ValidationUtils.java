package Utilities;
import java.util.regex.Pattern;

public class ValidationUtils {

    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    // Email: abc@domain.com
    public static boolean isValidEmail(String email) {
        if (!isNotEmpty(email)) return false;
        return Pattern.matches("^[\\w.+-]+@[\\w-]+\\.[a-zA-Z]{2,}$", email);
    }

    public static boolean isStrongPassword(String password) {
        if (!isNotEmpty(password)) return false;
        return password.length() >= 8
            && password.chars().anyMatch(Character::isUpperCase)
            && password.chars().anyMatch(Character::isDigit);
    }

    public static boolean isValidPhone(String phone) {
        if (!isNotEmpty(phone)) return false;
        return Pattern.matches("^(0|\\+84)(3|5|7|8|9)\\d{8}$", phone);
    }

    public static boolean isPositiveNumber(String value) {
        try { return Integer.parseInt(value) >= 0; }
        catch (NumberFormatException e) { return false; }
    }
}