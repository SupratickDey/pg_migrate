# pg_migrate

 is a CLI tool for managing PostgreSQL database migrations. It uses  for migrations and  for PostgreSQL interactions.

## Prerequisites

- **Go 1.23** or later

Ensure that Go 1.23 or later is installed on your system. You can download it from [golang.org](https://golang.org/dl/).

## Installation

To install , follow these steps:

1. Clone the repository:
    ```sh
    git clone git@github.com:SupratickDey/pg_migrate.git
    ```

2. Navigate into the project directory:
    ```sh
    cd pg_migrate
    ```

3. Install dependencies:
    ```sh
    go mod tidy
    ```

4. Build the CLI tool MAC or Linux Executable:
    ```sh
    go build -o migrate ./cmd/migration-tool
    ```
   
5. Build the CLI tool for Windows Executable:
    ```sh
   GOOS=windows GOARCH=amd64 go build -o migrate.exe ./cmd/migration-tool
    ```
   

## Running the Program

You can run the  CLI tool without building it first by using the  command. This is useful for development and testing purposes.

### Using 

1. Navigate to the root directory of the project where  is located:

    ```sh
    cd path/to/pg_migrate
    ```

2. Execute the CLI tool using :

    ```sh
    go run cmd/migration-tool/main.go migrate [command] [flags]
    ```

    Replace  with the desired command (e.g., , , , etc.), and  with any necessary flags or arguments.

### Example Usage

- **Run Migrations Up**:
  ```sh
  go run cmd/migration-tool/main.go migrate up --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
  ```

- **Run Migrations Up to a Specific Version**:
  ```sh
  go run cmd/migration-tool/main.go migrate up-to --version=202308161200 --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
  ```

- **Create a New Migration File**:
  ```sh
  go run cmd/migration-tool/main.go migrate create --name=my_migration --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
  ```

- **Migrate Down**:
  ```sh
  go run cmd/migration-tool/main.go migrate down --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
  ```

- **Migrate Down to a Specific Version**:
  ```sh
  go run cmd/migration-tool/main.go migrate down-to --version=202308161200 --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
  ```

- **Check Migration Status**:
  ```sh
  go run cmd/migration-tool/main.go migrate status --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
  ```

## CLI Commands

The  command supports the following subcommands:

### 

Migrate the database to the most recent version available.

```sh
migrate up --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Migrate the database up by one version.

```sh
migrate up-by-one --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Migrate the database to a specific version.

```sh
migrate up-to --version=[VERSION] --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Roll back the database version by one.

```sh
migrate down --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Roll back the database to a specific version.

```sh
migrate down-to --version=[VERSION] --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Re-run the latest migration.

```sh
migrate redo --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Roll back all migrations.

```sh
migrate reset --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Dump the migration status for the current database.

```sh
migrate status --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Print the current version of the database.

```sh
migrate version --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Creates a new migration file with the current timestamp.

```sh
migrate create --name=[MIGRATION_NAME] --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

### 

Apply sequential ordering to migrations.

```sh
migrate fix --db-name=postgres --db-user=postgres --db-password=your_password --db-host=localhost --db-port=5432 --db-schema=public --db-migration-path=./migrations
```

## Configuration

The CLI tool can be configured using environment variables or command-line arguments. Command-line arguments will override the corresponding environment variables.

### Environment Variables

- **DB_NAME**: The name of the database (default: )
- **DB_USER**: The username for the database (default: )
- **DB_PASSWORD**: The password for the database (default: )
- **DB_HOST**: The host where the database is located (default: )
- **DB_PORT**: The port on which the database is listening (default: )
- **DB_SCHEMA**: The schema in the database (default: )
- **DB_MIGRATION_PATH**: The path where migration files are located (default: )

### Command-Line Arguments

Command-line arguments will override the corresponding environment variables:

- **--db-name**: Name of the database
- **--db-user**: Username for the database
- **--db-password**: Password for the database
- **--db-host**: Host of the database
- **--db-port**: Port of the database
- **--db-schema**: Schema of the database
- **--db-migration-path**: Path to the migration files
- **--version**: Version number for ,  commands
- **--name**: Name of the migration file for  command

## Dependencies

The project depends on the following Go modules:

- **github.com/pressly/goose/v3**: For managing database migrations.
- **github.com/jackc/pgx/v5**: PostgreSQL driver.
- **github.com/spf13/cobra**: For building the CLI commands.
- **go.uber.org/zap**: For structured logging.

To install the dependencies, run:

```sh
go mod tidy
```

## Contact

[Supratick Dey](mailto:me.suprodey@gmail.com)