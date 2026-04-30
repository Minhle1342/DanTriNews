package Entities;

import jakarta.persistence.*;
import lombok.Data;

@Data @Entity @Table(name = "user_avatars")
public class UserAvatar {
    @Id
    @Column(name = "user_id")
    private int userId;

    @ManyToOne
    @JoinColumn(name = "current_skin_id")
    private Skin currentSkin;

    @Column(name = "is_active")
    private boolean isActive;
}
