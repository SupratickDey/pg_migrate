package config

import (
	"github.com/SupratickDey/pg_migrate/internal/logger"
	"os"
)

type Config struct {
	DBName          string
	DBUser          string
	DBPassword      string
	DBHost          string
	DBPort          string
	DBSchema        string
	DBMigrationPath string
}

func LoadConfig() Config {
	logger.Logger.Info("Loading configuration from environment variables or defaults")

	config := Config{
		DBName:          getEnv("DB_NAME", "postgres"),
		DBUser:          getEnv("DB_USER", "postgres"),
		DBPassword:      getEnv("DB_PASSWORD", "defaultpassword"),
		DBHost:          getEnv("DB_HOST", "localhost"),
		DBPort:          getEnv("DB_PORT", "5432"),
		DBSchema:        getEnv("DB_SCHEMA", "public"),
		DBMigrationPath: getEnv("DB_MIGRATION_PATH", "./migrations"),
	}

	logger.Logger.Infow("Configuration loaded successfully",
		"DBName", config.DBName,
		"DBUser", config.DBUser,
		"DBHost", config.DBHost,
		"DBPort", config.DBPort,
		"DBSchema", config.DBSchema,
		"DBMigrationPath", config.DBMigrationPath,
	)

	return config
}

func getEnv(key, fallback string) string {
	value, exists := os.LookupEnv(key)
	if !exists {
		logger.Logger.Warnw("Environment variable not set, using fallback",
			"key", key, "fallback", fallback)
		return fallback
	}
	return value
}
