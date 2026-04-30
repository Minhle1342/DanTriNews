package Entities;


import java.util.Date;
import java.util.List;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "users")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "username", length = 150, nullable = false, unique = true)
    private String username;

    @Column(name = "password", length = 150, nullable = false)
    private String password;

    @Column(name = "name", nullable = false, columnDefinition = "NVARCHAR(255)")
    private String name;

    @Column(name = "email", length = 150, nullable = false, unique = true)
    private String email;

    @Column(name = "phone", length = 12, nullable = false, unique = true)
    private String phone;

    @Column(name = "role", nullable = false)
    private int role;

 // Thành:
    @Column(name = "points") // Hoặc tên cột đúng trong DB
    private Integer points = 0; // Thêm giá trị mặc định 0

    // Nhớ sửa cả Getter và Setter tương ứng
    public Integer getPoints() {
        return points == null ? 0 : points;
    }

    public void setPoints(Integer points) {
        this.points = points;
    }



    @Column(name = "status", nullable = false)
    private boolean status;

    @Column(name = "code_recovery", length = 50)
    private String codeRecovery;

    @Column(name = "code_expired")
    private Date codeExpired;

    @Column(name = "balance")
    private long balance = 0; // Số dư ví (VNĐ)

 // Thêm trường này vào class User
    @Column(name = "vip_expire_date")
    private Date vipExpireDate; // Ngày hết hạn VIP

    @Column(name = "bank_name")
    private String bankName;

    @Column(name = "bank_account")
    private String bankAccount;

    @Column(name = "bank_account_name")
    private String bankAccountName;

    // --- Thêm Getter & Setter cho 3 trường này ---
    public String getBankName() { return bankName; }
    public void setBankName(String bankName) { this.bankName = bankName; }

    public String getBankAccount() { return bankAccount; }
    public void setBankAccount(String bankAccount) { this.bankAccount = bankAccount; }

    public String getBankAccountName() { return bankAccountName; }
    public void setBankAccountName(String bankAccountName) { this.bankAccountName = bankAccountName; }

    // Helper method kiểm tra còn VIP không
    public boolean isVip() {
        if (vipExpireDate == null) {
			return false;
		}
        return vipExpireDate.after(new Date()); // Còn hạn là VIP
    }

    @OneToMany(mappedBy = "user")
    private List<RoleUpgradeRequest> upgradeRequests; // nên có



    @OneToMany(mappedBy = "user")
    private List<Video> videos;

    @OneToMany(mappedBy = "user")
    private List<Favourite> favourites;


}

