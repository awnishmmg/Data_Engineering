### This is SQL for Data Migration

```
-- =========================================
-- Create Database Table
-- =========================================

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    signup_date TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL
);

-- =========================================
-- Insert 10,000 Fake Rows
-- =========================================

INSERT INTO users (full_name, email, signup_date, status)
SELECT
    -- Fake Full Name
    first_names[
        FLOOR(RANDOM() * ARRAY_LENGTH(first_names, 1) + 1)::INT
    ] || ' ' ||
    last_names[
        FLOOR(RANDOM() * ARRAY_LENGTH(last_names, 1) + 1)::INT
    ] AS full_name,

    -- Fake Email
    LOWER(
        REPLACE(
            first_names[
                FLOOR(RANDOM() * ARRAY_LENGTH(first_names, 1) + 1)::INT
            ] || '.' ||
            last_names[
                FLOOR(RANDOM() * ARRAY_LENGTH(last_names, 1) + 1)::INT
            ],
            ' ',
            ''
        )
    ) || gs || '@example.com' AS email,

    -- Random Signup Date (last 3 years)
    NOW() - (RANDOM() * INTERVAL '1095 days') AS signup_date,

    -- Random Status
    statuses[
        FLOOR(RANDOM() * ARRAY_LENGTH(statuses, 1) + 1)::INT
    ] AS status

FROM generate_series(1, 10000) AS gs,

LATERAL (
    SELECT
        ARRAY[
            'John','Jane','Michael','Emily','Chris','Sarah',
            'David','Emma','Daniel','Olivia','James','Sophia',
            'Robert','Ava','William','Mia','Joseph','Charlotte',
            'Alexander','Amelia'
        ] AS first_names,

        ARRAY[
            'Smith','Johnson','Williams','Brown','Jones',
            'Garcia','Miller','Davis','Rodriguez','Martinez',
            'Hernandez','Lopez','Gonzalez','Wilson','Anderson',
            'Thomas','Taylor','Moore','Jackson','Martin'
        ] AS last_names,

        ARRAY[
            'active',
            'inactive',
            'pending',
            'suspended'
        ] AS statuses
) AS data;

-- =========================================
-- Verify Data
-- =========================================

SELECT COUNT(*) AS total_users FROM users;

SELECT * FROM users LIMIT 10;

```
