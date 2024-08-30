-- +goose Up
-- Create UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create user table with indexes
CREATE TABLE users
(
    id                          uuid        DEFAULT uuid_generate_v4() NOT NULL,
    first_name                  varchar(255)                           NULL,
    last_name                   varchar(255)                           NULL,
    middle_name                 varchar(255)                           NULL,
    date_of_birth               date                                   NULL,
    user_role_id                uuid                                   NULL,
    email_address               varchar(255)                           NULL,
    country_code                varchar(20)                            NULL,
    phone_number                varchar(20)                            NULL,
    "password"                  varchar(255)                           NULL,
    verification_otp            varchar(20)                            NULL,
    verification_otp_expires_at timestamptz                            NULL,
    is_active                   bool                                   NULL,
    is_deleted                  bool                                   NULL,
    is_verified                 bool        DEFAULT false              NULL,
    is_block                    bool        DEFAULT false              NULL,
    gender                      varchar                                NULL,
    created_date                timestamptz DEFAULT CURRENT_TIMESTAMP  NULL,
    updated_date                timestamptz DEFAULT CURRENT_TIMESTAMP  NULL,
    created_by                  uuid                                   NULL,
    updated_by                  uuid                                   NULL,
    CONSTRAINT users_pkey PRIMARY KEY (id)
);

-- Indexes for users table
CREATE INDEX idx_users_user_role_id ON users (user_role_id);
CREATE INDEX idx_users_email_address ON users (email_address);
CREATE INDEX idx_users_phone_number ON users (phone_number);
CREATE INDEX idx_users_is_active ON users (is_active);
CREATE INDEX idx_users_is_deleted ON users (is_deleted);
CREATE INDEX idx_users_is_verified ON users (is_verified);
CREATE INDEX idx_users_created_date ON users (created_date);

-- Create role table with indexes
CREATE TABLE user_roles
(
    id           uuid        DEFAULT uuid_generate_v4() NOT NULL,
    name         varchar(50)                            NULL,
    description  text                                   NULL,
    is_active    bool        DEFAULT true               NULL,
    is_deleted   bool        DEFAULT false              NULL,
    created_date timestamptz DEFAULT CURRENT_TIMESTAMP  NULL,
    updated_date timestamptz DEFAULT CURRENT_TIMESTAMP  NULL,
    created_by   uuid                                   NULL,
    updated_by   uuid                                   NULL,
    CONSTRAINT user_roles_pkey PRIMARY KEY (id),
    CONSTRAINT unique_name UNIQUE (name),
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users (id),
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users (id)
);

-- Indexes for user_roles table
CREATE INDEX idx_user_roles_is_active ON user_roles (is_active);
CREATE INDEX idx_user_roles_is_deleted ON user_roles (is_deleted);
CREATE INDEX idx_user_roles_created_date ON user_roles (created_date);

-- Create foreign key user role id
ALTER TABLE users
    ADD CONSTRAINT fk_user_role
        FOREIGN KEY (user_role_id) REFERENCES user_roles (id);

-- Create organization table with indexes
CREATE TABLE organization
(
    id                   uuid        DEFAULT uuid_generate_v4() NOT NULL,
    organization_name    varchar(255)                           NULL,
    contact_person_email varchar(255)                           NULL,
    peach_health_hcp     bool        DEFAULT false              NULL,
    logo_id              uuid                                   NULL,
    is_active            bool        DEFAULT true               NULL,
    is_deleted           bool        DEFAULT false              NULL,
    created_date         timestamptz DEFAULT CURRENT_TIMESTAMP  NULL,
    updated_date         timestamptz DEFAULT CURRENT_TIMESTAMP  NULL,
    created_by           uuid                                   NULL,
    updated_by           uuid                                   NULL,
    CONSTRAINT organization_pkey PRIMARY KEY (id),
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users (id),
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users (id)
);

-- Indexes for organization table
CREATE INDEX idx_organization_organization_name ON organization (organization_name);
CREATE INDEX idx_organization_contact_person_email ON organization (contact_person_email);
CREATE INDEX idx_organization_peach_health_hcp ON organization (peach_health_hcp);
CREATE INDEX idx_organization_is_active ON organization (is_active);
CREATE INDEX idx_organization_is_deleted ON organization (is_deleted);
CREATE INDEX idx_organization_created_date ON organization (created_date);

-- Create file upload table with indexes
CREATE TABLE uploaded_file_info
(
    id             UUID        DEFAULT uuid_generate_v4() PRIMARY KEY,
    file_url       VARCHAR(255),
    file_name      VARCHAR(255),
    file_size      BIGINT,                                -- Use BIGINT if file sizes can exceed INT limits
    file_extension VARCHAR(50),                           -- Assuming extensions are short, adjust as needed
    file_mime_type VARCHAR(100),                          -- MIME types can be longer; adjust as needed
    created_by     UUID NOT NULL,
    updated_by     UUID,
    created_date   TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_date   TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP, -- Update timestamp on row change
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES users (id),
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES users (id)
);

-- Indexes for uploaded_file_info table
CREATE INDEX idx_uploaded_file_info_created_by ON uploaded_file_info (created_by);
CREATE INDEX idx_uploaded_file_info_updated_by ON uploaded_file_info (updated_by);
CREATE INDEX idx_uploaded_file_info_file_url ON uploaded_file_info (file_url);
CREATE INDEX idx_uploaded_file_info_file_name ON uploaded_file_info (file_name);
CREATE INDEX idx_uploaded_file_info_file_extension ON uploaded_file_info (file_extension);
CREATE INDEX idx_uploaded_file_info_created_date ON uploaded_file_info (created_date);

-- +goose StatementBegin
-- +goose StatementEnd

-- +goose Down
-- Drop indexes for uploaded_file_info table
DROP INDEX IF EXISTS idx_uploaded_file_info_created_by;
DROP INDEX IF EXISTS idx_uploaded_file_info_updated_by;
DROP INDEX IF EXISTS idx_uploaded_file_info_file_url;
DROP INDEX IF EXISTS idx_uploaded_file_info_file_name;
DROP INDEX IF EXISTS idx_uploaded_file_info_file_extension;
DROP INDEX IF EXISTS idx_uploaded_file_info_created_date;

-- Drop uploaded_file_info table
DROP TABLE IF EXISTS uploaded_file_info;

-- Drop indexes for organization table
DROP INDEX IF EXISTS idx_organization_organization_name;
DROP INDEX IF EXISTS idx_organization_contact_person_email;
DROP INDEX IF EXISTS idx_organization_peach_health_hcp;
DROP INDEX IF EXISTS idx_organization_is_active;
DROP INDEX IF EXISTS idx_organization_is_deleted;
DROP INDEX IF EXISTS idx_organization_created_date;

-- Drop organization table
DROP TABLE IF EXISTS organization;

-- Drop indexes for user_roles table
DROP INDEX IF EXISTS idx_user_roles_is_active;
DROP INDEX IF EXISTS idx_user_roles_is_deleted;
DROP INDEX IF EXISTS idx_user_roles_created_date;

-- Drop user_roles table
DROP TABLE IF EXISTS user_roles;

-- Drop foreign key constraint from users table
ALTER TABLE users DROP CONSTRAINT IF EXISTS fk_user_role;

-- Drop indexes for users table
DROP INDEX IF EXISTS idx_users_user_role_id;
DROP INDEX IF EXISTS idx_users_email_address;
DROP INDEX IF EXISTS idx_users_phone_number;
DROP INDEX IF EXISTS idx_users_is_active;
DROP INDEX IF EXISTS idx_users_is_deleted;
DROP INDEX IF EXISTS idx_users_is_verified;
DROP INDEX IF EXISTS idx_users_created_date;

-- Drop users table
DROP TABLE IF EXISTS users;

-- Drop UUID extension if it was created specifically for this schema
DROP EXTENSION IF EXISTS "uuid-ossp";

-- +goose StatementBegin
-- +goose StatementEnd
