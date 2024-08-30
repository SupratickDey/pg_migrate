package cli

import (
	"fmt"
	"github.com/SupratickDey/pg_migrate/internal/config"
	"github.com/SupratickDey/pg_migrate/internal/database"
	"github.com/SupratickDey/pg_migrate/internal/logger"
	"github.com/spf13/cobra"
)

func NewMigrateCommand() *cobra.Command {
	var cmd = &cobra.Command{
		Use:   "migrate [command]",
		Short: "Manage PostgreSQL migrations",
		Args:  cobra.ExactArgs(1), // Ensure exactly one command is provided
		RunE: func(cmd *cobra.Command, args []string) error {
			// Load configuration from environment variables or use defaults
			logger.Logger.Info("Loading configuration...")
			cfg := config.LoadConfig()

			// Override configuration with flags if provided
			if dbName, err := cmd.Flags().GetString("db-name"); err == nil && dbName != "" {
				cfg.DBName = dbName
			}
			if dbUser, err := cmd.Flags().GetString("db-user"); err == nil && dbUser != "" {
				cfg.DBUser = dbUser
			}
			if dbPassword, err := cmd.Flags().GetString("db-password"); err == nil && dbPassword != "" {
				cfg.DBPassword = dbPassword
			}
			if dbHost, err := cmd.Flags().GetString("db-host"); err == nil && dbHost != "" {
				cfg.DBHost = dbHost
			}
			if dbPort, err := cmd.Flags().GetString("db-port"); err == nil && dbPort != "" {
				cfg.DBPort = dbPort
			}
			if dbSchema, err := cmd.Flags().GetString("db-schema"); err == nil && dbSchema != "" {
				cfg.DBSchema = dbSchema
			}
			if dbMigrationPath, err := cmd.Flags().GetString("db-migration-path"); err == nil && dbMigrationPath != "" {
				cfg.DBMigrationPath = dbMigrationPath
			}

			command := args[0]
			logger.Logger.Infof("Executing command: %s", command)

			// Handle the command with its specific arguments
			var err error
			switch command {
			case "up":
				err = database.RunGooseCommand("up", &cfg)
			case "up-by-one":
				err = database.RunGooseCommand("up-by-one", &cfg)
			case "up-to":
				version, _ := cmd.Flags().GetString("version")
				err = database.RunGooseCommand(fmt.Sprintf("up-to %s", version), &cfg)
			case "down":
				err = database.RunGooseCommand("down", &cfg)
			case "down-to":
				version, _ := cmd.Flags().GetString("version")
				err = database.RunGooseCommand(fmt.Sprintf("down-to %s", version), &cfg)
			case "redo":
				err = database.RunGooseCommand("redo", &cfg)
			case "reset":
				err = database.RunGooseCommand("reset", &cfg)
			case "status":
				err = database.RunGooseCommand("status", &cfg)
			case "version":
				err = database.RunGooseCommand("version", &cfg)
			case "create":
				name, _ := cmd.Flags().GetString("name")
				err = database.RunGooseCommand(fmt.Sprintf("create %s", name), &cfg)
			case "fix":
				err = database.RunGooseCommand("fix", &cfg)
			default:
				err = fmt.Errorf("unknown command: %s", command)
				logger.Logger.Error(err)
			}

			if err != nil {
				logger.Logger.Errorf("Error executing command '%s': %v", command, err)
				return err
			}

			logger.Logger.Infof("Command '%s' executed successfully", command)
			return nil
		},
	}

	// Define global flags
	cmd.Flags().String("db-name", "", "Name of the database")
	cmd.Flags().String("db-user", "", "Username for the database")
	cmd.Flags().String("db-password", "", "Password for the database")
	cmd.Flags().String("db-host", "", "Host of the database")
	cmd.Flags().String("db-port", "", "Port of the database")
	cmd.Flags().String("db-schema", "", "Schema of the database")
	cmd.Flags().String("db-migration-path", "", "Path to the migration files")

	// Define flags specific to commands
	cmd.Flags().String("version", "", "Version number for up-to, down-to commands")
	cmd.Flags().String("name", "", "Name of the migration file for create command")

	return cmd
}
