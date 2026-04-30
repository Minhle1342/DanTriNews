package Utils;

// --- ❌ XÓA DÒNG NÀY: import java.net.PasswordAuthentication; ---

import java.util.Properties;

// --- ✅ THÊM CÁC IMPORT DƯỚI ĐÂY ---
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication; // Phải dùng cái này của javax.mail
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {

    public static void sendEmail(String toEmail, String subject, String body) {
        final String fromEmail = ConfigLoader.get("mail.from");
        final String password = ConfigLoader.get("mail.password");

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Tạo Authenticator để đăng nhập
        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                // Bây giờ PasswordAuthentication này là của javax.mail, nó nhận (String, String)
                return new PasswordAuthentication(fromEmail, password);
            }
        };

        // Tạo phiên làm việc (Session) với cấu hình và auth
        Session session = Session.getInstance(props, auth);

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(fromEmail));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            msg.setSubject(subject);

            // Nên set encoding UTF-8 để gửi tiếng Việt không lỗi font
            msg.setContent(body, "text/html; charset=UTF-8");

            Transport.send(msg);
            System.out.println("Email sent successfully to: " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("Failed to send email: " + e.getMessage());
        }
    }
}