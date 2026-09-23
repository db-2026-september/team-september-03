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

-- [Anastasiia Khudych] - members, memberships, fitness_goals
DROP TABLE IF EXISTS fitness_goals;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS members;

DROP TYPE IF EXISTS goal_type; 
DROP TYPE IF EXISTS membership_type;

CREATE TABLE members (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  surname VARCHAR(50) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL
);

CREATE TYPE membership_type AS ENUM ('monthly', 'yearly', 'premium');

CREATE TABLE memberships (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  type membership_type NOT NULL,
  member_id BIGINT NOT NULL REFERENCES members(id),
  start_date DATE DEFAULT CURRENT_DATE,
  end_date DATE
);

CREATE TYPE goal_type AS ENUM ( 'weight_loss', 'muscle_gain', 'endurance', 'flexibility' );

CREATE TABLE fitness_goals ( 
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL REFERENCES members(id), 
  goal_type goal_type NOT NULL, 
  target_value DECIMAL(10, 2) NOT NULL, 
  target_value_unit VARCHAR(20), 
  start_date DATE NOT NULL, 
  target_date DATE NOT NULL, 
  achieved_date DATE 
);