package Beans;

import java.util.HashMap;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RegisterBean {
 private String username;
 private String password;
 private String name;
 private String phone;
 private String email;

 public Map<String, String> getErrors() {
		Map<String, String> map = new HashMap<>();

//		Bắt lỗi

		if (username.isBlank()) {
			map.put("errUsername", "Tên tài khoản không rỗng");
		}

		if (!email.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
			map.put("errEmail", "Email không đúng định dạng");
		}

		if (password.length() < 6) {
			map.put("errPassword", "Mật khẩu phải có ít nhất 6 ký tự");
		}

		if (name.isBlank()) {
			map.put("errName", "Tên không rỗng");
		}

		if (!phone.matches("^0\\d{9}$")) {
			map.put("errPhone", "Số điện thoại không đúng định dạng");
		}

		return map;
	}
}
