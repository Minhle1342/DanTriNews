package Beans;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class LoginBean {
    private String usernameOrEmail;
    private String password;

    public Map<String, String> getErrors() {
        Map<String, String> map = new HashMap<>();

        // Kiểm tra usernameOrEmail
        if (usernameOrEmail == null || usernameOrEmail.isBlank()) {
            map.put("errUsernameOrEmail", "Không được để trống");
        } else {

            String input = usernameOrEmail.trim();

            // Kiểm tra có phải email hay không
            boolean isEmail = input.contains("@");

            if (isEmail) {
                // Check email format
                String emailRegex = "^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,}$";
                if (!Pattern.matches(emailRegex, input)) {
                    map.put("errUsernameOrEmail", "Email không hợp lệ");
                }
            } else {
                // Kiểm tra username
                if (input.length() < 4) {
                    map.put("errUsernameOrEmail", "Tên đăng nhập phải >= 4 ký tự");
                }

                if (!Pattern.matches("^[a-zA-Z0-9_]+$", input)) {
                    map.put("errUsernameOrEmail", "Tên đăng nhập chỉ gồm chữ, số, dấu _");
                }
            }
        }

        if (password == null || password.isBlank()) {
            map.put("errPassword", "Mật khẩu không được để trống");
        } else {

            String pw = password.trim();

            if (pw.length() < 2) {
                map.put("errPassword", "Mật khẩu phải >= 3 ký tự");
            }

            if (pw.contains(" ")) {
                map.put("errPassword", "Mật khẩu không chứa khoảng trắng");
            }
        }

        return map;
    }
}
