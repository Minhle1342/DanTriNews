package Utils;

import java.io.IOException;

// --- ✅ IMPORT ĐÚNG CHO APACHE FLUENT HC ---
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form; // Import này thay thế java.text.Normalizer.Form
import org.apache.http.client.fluent.Request; // Import này giải quyết lỗi "Request cannot be resolved"

import com.google.gson.Gson;
import com.google.gson.JsonObject;

public class GoogleUtils {

    // Thay thế bằng thông tin của bạn
    public static final String GOOGLE_CLIENT_ID = ConfigLoader.get("google.clientId");
    public static final String GOOGLE_CLIENT_SECRET = ConfigLoader.get("google.clientSecret");

    // Đường dẫn này phải khớp y hệt trong Google Cloud Console
    public static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/ASM1_NguyenLeMinh_PC10524/login-google";

    public static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
    public static final String GOOGLE_GRANT_TYPE = "authorization_code";

    // Bước 1: Lấy Access Token từ Code
    public static String getToken(String code) throws ClientProtocolException, IOException {
        String response = Request.Post(GOOGLE_LINK_GET_TOKEN)
                .bodyForm(Form.form() // Bây giờ Form.form() sẽ chạy đúng
                        .add("client_id", GOOGLE_CLIENT_ID)
                        .add("client_secret", GOOGLE_CLIENT_SECRET)
                        .add("redirect_uri", GOOGLE_REDIRECT_URI)
                        .add("code", code)
                        .add("grant_type", GOOGLE_GRANT_TYPE)
                        .build())
                .execute().returnContent().asString();

        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        // Thêm kiểm tra null để tránh lỗi nếu Google trả về error thay vì access_token
        if (jobj.has("access_token")) {
            return jobj.get("access_token").getAsString();
        }
        return null;
    }

    // Bước 2: Lấy thông tin User từ Token
    public static GooglePojo getUserInfo(String accessToken) throws ClientProtocolException, IOException {
        String link = GOOGLE_LINK_GET_USER_INFO + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        return new Gson().fromJson(response, GooglePojo.class);
    }
}