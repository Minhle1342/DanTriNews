package Entities;

import java.util.Date;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
@Table(name = "AdminAuditLog")
public class AdminAuditLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "admin_id", nullable = false)
    private int adminId; // Lưu ID của admin thực hiện

    @Column(name = "action", columnDefinition = "NVARCHAR(255)")
    private String action;

    @Column(name = "related_request")
    private int relatedRequest; // Lưu ID của yêu cầu bị tác động

    @Column(name = "log_time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date logTime;
}