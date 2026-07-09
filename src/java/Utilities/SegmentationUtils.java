package Utilities;

public class SegmentationUtils {

    public static final int LOW_MAX = 5_000_000;
    public static final int MIDDLE_MAX = 15_000_000;

    /** avgViewedPrice in VND -> income segment label. */
    public static String classify(double avgViewedPrice) {
        if (avgViewedPrice < LOW_MAX) {
            return "Low Income";
        } else if (avgViewedPrice <= MIDDLE_MAX) {
            return "Middle Income";
        } else {
            return "High Income";
        }
    }
}
