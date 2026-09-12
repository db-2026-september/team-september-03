-- ================================================================
-- SQL DDL TEMPLATE (TOPIC 04)
-- ================================================================
-- WHAT SHOULD BE ADDED HERE:
-- 1) Full PostgreSQL DDL for your finalized schema.
-- 2) CREATE TABLE statements for all entities from your ER diagram.
-- 3) Primary keys, foreign keys, NOT NULL, UNIQUE, CHECK constraints.
-- 4) Indexes for important search/join columns.
-- 5) Clean structure and comments (group by tables/constraints/indexes).
--
-- RECOMMENDED ORDER:
-- 1) Tables
-- 2) Constraints (if not inline)
-- 3) Indexes
--
-- TEAM NOTE:
-- Add short attribution comments for who implemented which part.
-- Example:
-- Mykola - trainers, specializations, trainer_specializations
-- [Name] - orders, payments, invoices tables
--
-- IMPORTANT:
-- The script must run in PostgreSQL and produce a working schema that
-- matches your approved ER diagram and conceptual schema.
-- Submit this as one SQL file.
-- ================================================================

-- Add your DDL below this line
-- ============================================================
-- Mykola's Module: Trainers, Specializations & Junction Table
-- ============================================================

-- 1. Wave 1: Independent Tables
CREATE TABLE IF NOT EXISTS trainers (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    experience_years INT DEFAULT 0 CHECK (experience_years >= 0),
    hourly_rate NUMERIC(10, 2) CHECK (hourly_rate >= 0),
    hired_at DATE DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS specializations (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Wave 2: Junction Table (Many-to-Many)
CREATE TABLE IF NOT EXISTS trainer_specializations (
    trainer_id BIGINT NOT NULL,
    specialization_id BIGINT NOT NULL,
    CONSTRAINT pk_trainer_specializations PRIMARY KEY (trainer_id, specialization_id),
    CONSTRAINT fk_ts_trainer FOREIGN KEY (trainer_id) 
        REFERENCES trainers (id) ON DELETE CASCADE,
    CONSTRAINT fk_ts_specialization FOREIGN KEY (specialization_id) 
        REFERENCES specializations (id) ON DELETE CASCADE
);

-- 3. Indexing Strategy
CREATE INDEX IF NOT EXISTS idx_trainers_email ON trainers (email);
CREATE INDEX IF NOT EXISTS idx_ts_specialization ON trainer_specializations (specialization_id);

