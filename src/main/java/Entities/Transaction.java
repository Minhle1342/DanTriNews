package Entities;

import java.util.Date;

import jakarta.persistence.*;

@Entity
@Table(name = "transactions")
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    // Khóa ngoại trỏ đến bảng users, cột user_id
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "amount")
    private long amount;

    @Column(name = "order_info") // Ánh xạ với cột order_info
    private String orderInfo;

    @Column(name = "vnp_txn_ref") // Ánh xạ với cột vnp_txn_ref
    private String vnpTxnRef;

    @Column(name = "vnp_transaction_no") // Ánh xạ với cột vnp_transaction_no
    private String vnpTransactionNo;

    @Column(name = "status")
    private int status; // 0: Pending, 1: Success, 2: Failed

    @Column(name = "create_at") // Ánh xạ với cột create_at
    @Temporal(TemporalType.TIMESTAMP)
    private Date createAt;

    // --- CONSTRUCTORS ---
    public Transaction() {}

    // --- GETTERS & SETTERS ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }

    public String getOrderInfo() { return orderInfo; }
    public void setOrderInfo(String orderInfo) { this.orderInfo = orderInfo; }

    public String getVnpTxnRef() { return vnpTxnRef; }
    public void setVnpTxnRef(String vnpTxnRef) { this.vnpTxnRef = vnpTxnRef; }

    public String getVnpTransactionNo() { return vnpTransactionNo; }
    public void setVnpTransactionNo(String vnpTransactionNo) { this.vnpTransactionNo = vnpTransactionNo; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Date getCreateAt() { return createAt; }
    public void setCreateAt(Date createAt) { this.createAt = createAt; }
}