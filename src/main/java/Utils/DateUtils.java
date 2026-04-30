package Utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Lớp tiện ích để xử lý các thao tác liên quan đến Date/Time.
 * Hỗ trợ chuyển đổi giữa String (định dạng yyyy-MM-dd) và java.util.Date.
 */
public class DateUtils {

    // Định dạng chuẩn cho HTML input type="date" và SQL Date
    private static final String DATE_FORMAT = "yyyy-MM-dd";

    // SimpleDateFormat không an toàn cho đa luồng, nên tạo đối tượng mới khi cần
    private static SimpleDateFormat getDateFormat() {
        return new SimpleDateFormat(DATE_FORMAT);
    }

    /**
     * Chuyển đổi String sang java.util.Date.
     * Thường dùng để nhận dữ liệu ngày tháng từ form HTML (input type="date").
     * * @param dateString Chuỗi ngày tháng ở định dạng "yyyy-MM-dd".
     * @return java.util.Date, hoặc null nếu chuỗi không hợp lệ.
     */
    public static Date parseDate(String dateString) {
        if (dateString == null || dateString.trim().isEmpty()) {
            return null;
        }
        try {
            return getDateFormat().parse(dateString);
        } catch (ParseException e) {
            System.err.println("Lỗi parseDate: Chuỗi '" + dateString + "' không đúng định dạng " + DATE_FORMAT);
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Chuyển đổi java.util.Date sang String.
     * Thường dùng để hiển thị ngày tháng lên giao diện người dùng.
     * * @param date Đối tượng java.util.Date.
     * @return Chuỗi ngày tháng ở định dạng "yyyy-MM-dd", hoặc chuỗi rỗng nếu date là null.
     */
    public static String formatDate(Date date) {
        if (date == null) {
            return "";
        }
        return getDateFormat().format(date);
    }

    /**
     * Chuyển đổi java.util.Date sang java.sql.Date.
     * Hữu ích khi cần tương tác trực tiếp với các hàm JDBC yêu cầu java.sql.Date.
     * * @param date Đối tượng java.util.Date.
     * @return java.sql.Date, hoặc null nếu date là null.
     */
    public static java.sql.Date convertUtilToSqlDate(Date date) {
        if (date == null) {
            return null;
        }
        return new java.sql.Date(date.getTime());
    }

    /**
     * Chuyển đổi java.sql.Date sang String.
     * * @param sqlDate Đối tượng java.sql.Date.
     * @return Chuỗi ngày tháng ở định dạng "yyyy-MM-dd", hoặc chuỗi rỗng nếu sqlDate là null.
     */
    public static String formatSqlDate(java.sql.Date sqlDate) {
        if (sqlDate == null) {
            return "";
        }
        // java.sql.Date có thể được format trực tiếp
        return sqlDate.toString();
    }
}