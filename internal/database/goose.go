package database

import (
	"fmt"
	"github.com/SupratickDey/pg_migrate/internal/config"
	"github.com/SupratickDey/pg_migrate/internal/logger"
	_ "github.com/jackc/pgx/v5/stdlib"
	"github.com/pressly/goose/v3"
	"go.uber.org/zap"
	"os"
	"strconv"
	"strings"
)

// createDirIfNotExist creates a directory if it doesn't already exist
func createDirIfNotExist(dir string) error {
	logger.Logger.Infof("Checking if directory exists: %s", dir)

	if _, err := os.Stat(dir); os.IsNotExist(err) {
		logger.Logger.Infof("Directory does not exist, creating: %s", dir)
		if err := os.MkdirAll(dir, 0755); err != nil {
			logger.Logger.Errorf("Error creating directory: %v", err)
			return fmt.Errorf("error creating directory: %w", err)
		}
	} else if err != nil {
		logger.Logger.Errorf("Error checking directory: %v", err)
		return fmt.Errorf("error checking directory: %w", err)
	}

	logger.Logger.Infof("Directory exists or created successfully: %s", dir)
	return nil
}

func RunGooseCommand(command string, config *config.Config) error {
	connStr := fmt.Sprintf("postgresql://%s:%s@%s:%s/%s",
		config.DBUser, config.DBPassword, config.DBHost, config.DBPort, config.DBName)

	logger.Logger.Infof("Connecting to database with connection string: %s", connStr)

	goose.SetLogger(zap.NewStdLog(logger.Logger.Desugar()))
	db, err := goose.OpenDBWithDriver("pgx", connStr)
	if err != nil {
		logger.Logger.Errorf("Failed to connect to the database: %v", err)
		return fmt.Errorf("database connection error: %w", err)
	}
	defer func() {
		if err := db.Close(); err != nil {
			logger.Logger.Errorf("Failed to close the database connection: %v", err)
		}
	}()

	logger.Logger.Infof("Running command: %s", command)

	split := strings.Split(command, " ")
	command = split[0]
	args := ""
	if len(split) > 1 {
		rawArgs := split[1:]
		args = strings.Join(rawArgs, " ")
	}

	switch command {
	case "up":
		return goose.Up(db, config.DBMigrationPath)
	case "up-by-one":
		return goose.UpByOne(db, config.DBMigrationPath)
	case "up-to":
		value, err := strconv.ParseInt(args, 10, 64)
		if err != nil {
			logger.Logger.Errorf("Error converting to int64: %v", err)
			return fmt.Errorf("error converting to int64: %w", err)
		}
		return goose.UpTo(db, config.DBMigrationPath, value)
	case "down":
		return goose.Down(db, config.DBMigrationPath)
	case "down-to":
		value, err := strconv.ParseInt(args, 10, 64)
		if err != nil {
			logger.Logger.Errorf("Error converting to int64: %v", err)
			return fmt.Errorf("error converting to int64: %w", err)
		}
		return goose.DownTo(db, config.DBMigrationPath, value)
	case "redo":
		return goose.Redo(db, config.DBMigrationPath)
	case "reset":
		return goose.Reset(db, config.DBMigrationPath)
	case "status":
		return goose.Status(db, config.DBMigrationPath)
	case "version":
		return goose.Version(db, config.DBMigrationPath)
	case "create":
		if len(args) == 0 {
			err := fmt.Errorf("please provide a migration name")
			logger.Logger.Error(err)
			return err
		}
		if err := createDirIfNotExist(config.DBMigrationPath); err != nil {
			logger.Logger.Errorf("Error creating migration directory: %v", err)
			return err
		}
		if err := goose.Create(db, config.DBMigrationPath, args, "sql"); err != nil {
			logger.Logger.Errorf("Error creating migration: %v", err)
			return err
		}
		return nil
	case "fix":
		return goose.Fix(config.DBMigrationPath)
	default:
		err := fmt.Errorf("unknown command: %s", command)
		logger.Logger.Error(err)
		return err
	}
}
