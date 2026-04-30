package Entities;

import jakarta.persistence.*;

@Entity
@Table(name = "SystemConfig")
public class SystemConfig {

    @Id
    @Column(name = "config_key")
    private String configKey;

    @Column(name = "config_value")
    private String configValue;

    // Constructors
    public SystemConfig() {}

    public SystemConfig(String key, String value) {
        this.configKey = key;
        this.configValue = value;
    }

    // Getters and Setters
    public String getConfigKey() { return configKey; }
    public void setConfigKey(String configKey) { this.configKey = configKey; }

    public String getConfigValue() { return configValue; }
    public void setConfigValue(String configValue) { this.configValue = configValue; }
}