package Beans;


import java.util.HashMap;
import java.util.Map;

public class UserAddBean {

    private String username;
    private String password;
    private String name;
    private String email;
    private String phone;
    private int role = 1;
    private boolean status = true;

    public Map<String, String> errors = new HashMap<>();

    // Getters / Setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public int getRole() { return role; }
    public void setRole(int role) { this.role = role; }

    public boolean getStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public boolean validate() {
        errors.clear();
        boolean valid = true;

        if (username == null || username.trim().isEmpty()) {
            errors.put("errUsername", "Username không được để trống");
            valid = false;
        }

        if (password == null || password.trim().isEmpty()) {
            errors.put("errPassword", "Password không được để trống");
            valid = false;
        }

        if (name == null || name.trim().isEmpty()) {
            errors.put("errName", "Họ tên không được để trống");
            valid = false;
        }

        if (email == null || email.trim().isEmpty()) {
            errors.put("errEmail", "Email không được để trống");
            valid = false;
        }

        if (phone == null || !phone.matches("\\d{9,12}")) {
            errors.put("errPhone", "Số điện thoại phải từ 9–12 số");
            valid = false;
        }

        return valid;
    }
}
