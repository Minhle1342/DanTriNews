package Beans;


import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class UserBean implements Serializable {
    private String username;
    private String email;
    private String name;
    private String phone;
    private String password;

    private Map<String, String> errors = new HashMap<>();

    // Getters và setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public Map<String, String> getErrors() { return errors; }

    // Validation
    public boolean validate() {
        errors.clear();
        boolean valid = true;

        // Họ và tên
        if(name == null || name.trim().isEmpty()) {
            errors.put("name", "Họ và tên không được để trống");
            valid = false;
        }

        // Username: không được chứa số
        if(username != null && username.matches(".*\\d.*")) {
            errors.put("username", "Tên đăng nhập không được chứa số");
            valid = false;
        }

        // Phone: chỉ được chứa số, ít nhất 10 chữ số
        if(phone == null || !phone.matches("\\d{10,}")) {
            errors.put("phone", "Số điện thoại phải là số và ít nhất 10 chữ số");
            valid = false;
        }

        // Password: nếu nhập phải ít nhất 6 ký tự
        if(password != null && !password.isEmpty() && password.length() < 6) {
            errors.put("password", "Mật khẩu phải từ 6 ký tự trở lên");
            valid = false;
        }

        return valid;
    }
}
