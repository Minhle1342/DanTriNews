package Entities;

import jakarta.persistence.*;
import lombok.Data;

@Data @Entity @Table(name = "skins")
public class Skin {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;
    private String name;

    @Column(name = "base_url")
    private String baseUrl; // VD: "assets/avatars/cat_" -> Code sẽ tự ghép thêm "happy.png", "sad.png"

    private int price;

    @Column(name = "is_sponsored")
    private boolean isSponsored;
}
