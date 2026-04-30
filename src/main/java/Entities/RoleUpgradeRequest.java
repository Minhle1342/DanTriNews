package Entities;



import java.sql.Date;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "RoleUpgradeRequest")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class RoleUpgradeRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "reason")
    private String reason;

    @Column(name = "experience")
    private String experience;

    @Column(name = "portfolio")
    private String portfolio;

    @Column(name = "status")
    private int status;

    @Column(name = "create_at")
    private Date createAt;
}


