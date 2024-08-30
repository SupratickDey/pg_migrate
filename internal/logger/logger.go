package logger

import (
	"go.uber.org/zap"
	"sync"
)

// Logger is a global logger instance
var Logger *zap.SugaredLogger
var once sync.Once

// InitLogger initializes the logger with production settings
func InitLogger() {
	once.Do(func() { // Ensure the logger is only initialized once
		logger, err := zap.NewProduction()
		if err != nil {
			logger = zap.NewExample() // Fallback to basic logger if initialization fails
			Logger = logger.Sugar()
			Logger.Fatal("Failed to initialize zap logger: ", err)
		} else {
			Logger = logger.Sugar()
		}
	})
}

// SyncLogger flushes any buffered log entries
func SyncLogger() {
	if Logger != nil {
		_ = Logger.Sync() // flushes buffer, if any
	}
}
