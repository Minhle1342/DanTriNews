package Controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import Utils.ConfigLoader;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/explainer-bot")
public class ExplainerBotController extends HttpServlet {

    private static final String GEMINI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=";

    private static final String SYSTEM_INSTRUCTION =
        "Bạn là 'Trợ lý Tin tức Thông minh' của trang báo điện tử. " +
        "Nhiệm vụ: Giải thích thuật ngữ, tóm tắt tin tức, cung cấp số liệu và phân tích sự kiện cho người đọc. " +
        "Phong cách: Khách quan, chuyên nghiệp, lịch sự. " +
        "Quy tắc: 1. Trả lời bằng Tiếng Việt. 2. Nếu là số liệu, phải ghi rõ nguồn hoặc thời điểm. " +
        "3. Sử dụng định dạng HTML cơ bản (<b>, <i>, <br>, <ul>, <li>) để trình bày đẹp. \n\n";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8"); // Đổi sang text/html để trình duyệt hiểu thẻ <br>, <b>

        String userMessage = req.getParameter("message");
        String videoDuration = req.getParameter("duration");

        if (userMessage == null || userMessage.trim().isEmpty()) {
            resp.getWriter().write("Chào bạn! Tôi có thể giúp gì cho bạn về thông tin bài báo này?");
            return;
        }

        String refinedPrompt;
        String lowerMsg = userMessage.toLowerCase();

        if (lowerMsg.contains("tạo chapter") || lowerMsg.contains("phân đoạn")) {
            String limit = (videoDuration != null && !videoDuration.isEmpty()) ? videoDuration : "60";

            refinedPrompt = SYSTEM_INSTRUCTION +
                "Dựa trên nội dung bài báo, hãy chia thành 4-6 phân đoạn. " +
                "QUY TẮC QUAN TRỌNG: \n" +
                "1. Video dài TỐI ĐA " + limit + " giây. Không tạo mốc quá số này. \n" +
                "2. Định dạng trả về: 'số_giây|tiêu_đề'. \n" +
                "3. Mỗi phân đoạn một dòng. \n" +
                "Ví dụ:\n0|Giới thiệu\n20|Diễn biến\n\n" +
                "Nội dung: " + userMessage;
        } else if (lowerMsg.contains("tóm tắt") || lowerMsg.contains("ý chính")) {
            refinedPrompt = SYSTEM_INSTRUCTION + "Hãy tóm tắt nội dung chính ngắn gọn, súc tích... " + userMessage;
        } else {
            refinedPrompt = SYSTEM_INSTRUCTION + "Giải thích ngắn gọn hoặc trả lời câu hỏi: " + userMessage;
        }

        try {
            String aiResponse = callGeminiAPI(refinedPrompt);
            resp.getWriter().write(aiResponse);
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("Xin lỗi, hệ thống AI đang bận. Vui lòng thử lại sau!");
        }
    }

    private String callGeminiAPI(String prompt) throws IOException {
        String apiKey = ConfigLoader.get("gemini.apiKey");
        URL url = new URL(GEMINI_BASE_URL + apiKey);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);
        conn.setConnectTimeout(15000);

        String jsonBody = "{ \"contents\": [{ \"parts\": [{ \"text\": \"" + escapeJson(prompt) + "\" }] }] }";

        try (OutputStream os = conn.getOutputStream()) {
            os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
        }

        int responseCode = conn.getResponseCode();
        InputStream is = (responseCode == 200) ? conn.getInputStream() : conn.getErrorStream();

        BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
			response.append(line);
		}

        String rawJson = response.toString();

        if (responseCode != 200) {
            return "Lỗi kết nối AI (Code " + responseCode + ").";
        }

        return extractTextRobust(rawJson);
    }

    private String escapeJson(String input) {
        if (input == null) {
			return "";
		}
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }

    // --- PHẦN SỬA LỖI QUAN TRỌNG NHẤT ---
    private String extractTextRobust(String json) {
        try {
            // 1. Cắt chuỗi JSON thủ công để lấy nội dung trong field "text"
            int partsIndex = json.indexOf("\"parts\"");
            if (partsIndex == -1) {
				return "Không tìm thấy nội dung trả lời.";
			}

            int textKeyIndex = json.indexOf("\"text\"", partsIndex);
            int startQuote = json.indexOf("\"", textKeyIndex + 6);

            // Tìm dấu ngoặc kép đóng, bỏ qua các dấu \" (escaped quote)
            int endQuote = startQuote + 1;
            while (endQuote < json.length()) {
                if (json.charAt(endQuote) == '\"' && json.charAt(endQuote - 1) != '\\') {
					break;
				}
                endQuote++;
            }

            String content = json.substring(startQuote + 1, endQuote);

            // 2. GIẢI MÃ UNICODE (Sửa lỗi \u003c, \u003e...)
            content = unescapeUnicode(content);

            // 3. Xử lý các ký tự thoát JSON chuẩn
            content = content.replace("\\n", "\n");
            content = content.replace("\\\"", "\"");

            // 4. Định dạng sang HTML để hiển thị đẹp trên Web
            // Chuyển Markdown **text** thành <b>text</b>
            content = content.replaceAll("\\*\\*(.*?)\\*\\*", "<b>$1</b>");

            // Chuyển dấu gạch đầu dòng thành bullet point đẹp
            content = content.replaceAll("^\\* ", "• ");
            content = content.replace("\n* ", "\n• ");

            // Chuyển xuống dòng thành thẻ <br>
            content = content.replace("\n", "<br>");

            return content;
        } catch (Exception e) {
            e.printStackTrace();
            return "Lỗi xử lý phản hồi từ AI: " + e.getMessage();
        }
    }

    private String unescapeUnicode(String input) {
        if (input == null) {
			return null;
		}

        Pattern pattern = Pattern.compile("\\\\u([0-9a-fA-F]{4})");
        Matcher matcher = pattern.matcher(input);

        StringBuffer decoded = new StringBuffer();
        while (matcher.find()) {
            try {
                // Chuyển đổi hex thành ký tự thực
                char ch = (char) Integer.parseInt(matcher.group(1), 16);
                matcher.appendReplacement(decoded, Matcher.quoteReplacement(String.valueOf(ch)));
            } catch (NumberFormatException e) {
                // Nếu lỗi thì giữ nguyên
                matcher.appendReplacement(decoded, matcher.group(0));
            }
        }
        matcher.appendTail(decoded);
        return decoded.toString();
    }
}