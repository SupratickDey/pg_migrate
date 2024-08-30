package main

import (
	"github.com/SupratickDey/pg_migrate/internal/logger"
	"github.com/SupratickDey/pg_migrate/pkg/cli"
	"github.com/spf13/cobra"
	"os"
)

func main() {
	// Initialize the logger
	logger.InitLogger()
	defer logger.SyncLogger() // Ensure logs are flushed before the program exits

	// Initialize the root command
	rootCmd := &cobra.Command{
		Use:   "migration-tool",
		Short: "A CLI tool for managing PostgreSQL migrations",
	}

	// Add the migrate command to the root command
	rootCmd.AddCommand(cli.NewMigrateCommand())

	// Execute the root command and handle any errors
	if err := rootCmd.Execute(); err != nil {
		logger.Logger.Errorf("An error occurred: %v", err)
		os.Exit(1) // Exit the program with a non-zero status
	}
}
