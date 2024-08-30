-- +goose Up
-- Create the organization_users table with constraints and default values
CREATE TABLE public.organization_users
(
    id              uuid        DEFAULT uuid_generate_v4() NOT NULL, -- Unique identifier for the record
    organization_id uuid                                   NOT NULL, -- Foreign key to the organization
    user_id         uuid                                   NOT NULL, -- Foreign key to the user
    is_active       bool        DEFAULT true NULL,                   -- Indicates if the record is active
    is_deleted      bool        DEFAULT false NULL,                  -- Indicates if the record is deleted
    created_date    timestamptz DEFAULT CURRENT_TIMESTAMP NULL,      -- Timestamp when the record was created
    updated_date    timestamptz DEFAULT CURRENT_TIMESTAMP NULL,      -- Timestamp when the record was last updated
    created_by      uuid NULL,                                       -- Foreign key to the user who created the record
    updated_by      uuid NULL,                                       -- Foreign key to the user who last updated the record

    -- Primary key constraint
    CONSTRAINT organization_users_pkey PRIMARY KEY (id),

    -- Foreign key constraints
    CONSTRAINT fk_created_by FOREIGN KEY (created_by) REFERENCES public.users (id),
    CONSTRAINT fk_organization_id FOREIGN KEY (organization_id) REFERENCES public.organization (id),
    CONSTRAINT fk_updated_by FOREIGN KEY (updated_by) REFERENCES public.users (id),
    CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users (id)
);

-- Create indexes to improve query performance on specific columns
CREATE INDEX idx_organization_users_created_date ON public.organization_users USING btree (created_date);
CREATE INDEX idx_organization_users_is_active ON public.organization_users USING btree (is_active);
CREATE INDEX idx_organization_users_is_deleted ON public.organization_users USING btree (is_deleted);
CREATE INDEX idx_organization_users_organization_id ON public.organization_users USING btree (organization_id);
CREATE INDEX idx_organization_users_user_id ON public.organization_users USING btree (user_id);

-- +goose StatementBegin
-- +goose StatementEnd

-- +goose Down
-- Drop indexes if they exist
DROP INDEX IF EXISTS public.idx_organization_users_user_id;
DROP INDEX IF EXISTS public.idx_organization_users_organization_id;
DROP INDEX IF EXISTS public.idx_organization_users_is_deleted;
DROP INDEX IF EXISTS public.idx_organization_users_is_active;
DROP INDEX IF EXISTS public.idx_organization_users_created_date;

-- Drop the organization_users table if it exists
DROP TABLE IF EXISTS public.organization_users;

-- +goose StatementBegin
-- +goose StatementEnd
