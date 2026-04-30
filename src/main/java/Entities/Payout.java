package Entities;

import java.util.Date;

import jakarta.persistence.*;

// Nếu bạn dùng Hibernate 6+ hoặc Tomcat 10+, hãy đổi thành:
// import jakarta.persistence.*;

@Entity
@Table(name = "Payouts")
public class Payout {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    // Mapping khóa ngoại admin_id -> Bảng Users (Người chuyển tiền)
    @ManyToOne
    @JoinColumn(name = "admin_id", nullable = false)
    private User admin;

    // Mapping khóa ngoại editor_id -> Bảng Users (Người nhận tiền)
    @ManyToOne
    @JoinColumn(name = "editor_id", nullable = false)
    private User editor;

    @Column(name = "amount")
    private long amount;

    @Column(name = "bank_name")
    private String bankName;

    @Column(name = "bank_account")
    private String bankAccount;

    @Column(name = "pay_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date payDate;

    @Column(name = "note")
    private String note;

    // --- CONSTRUCTORS ---
    public Payout() {
        // Constructor rỗng bắt buộc cho JPA
    }

    // --- GETTERS & SETTERS ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public User getAdmin() {
        return admin;
    }

    public void setAdmin(User admin) {
        this.admin = admin;
    }

    public User getEditor() {
        return editor;
    }

    public void setEditor(User editor) {
        this.editor = editor;
    }

    public long getAmount() {
        return amount;
    }

    public void setAmount(long amount) {
        this.amount = amount;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getBankAccount() {
        return bankAccount;
    }

    public void setBankAccount(String bankAccount) {
        this.bankAccount = bankAccount;
    }

    public Date getPayDate() {
        return payDate;
    }

    public void setPayDate(Date payDate) {
        this.payDate = payDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}