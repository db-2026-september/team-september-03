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
  target_value_unit VARCHAR(20)
  );


-- [Maksym Bielik] — quipment_types, equipment_items, personal_training, and progress

CREATE TYPE session_status AS ENUM ('scheduled', 'completed', 'cancelled', 'no_show');
CREATE TYPE equipment_status AS ENUM ('operational', 'under_maintenance', 'out_of_service');

--  Personal Training
CREATE TABLE personal_training (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  member_id BIGINT NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  trainer_id BIGINT NOT NULL REFERENCES trainers(id) ON DELETE RESTRICT,
  scheduled_at TIMESTAMP NOT NULL,
  duration_min INT NOT NULL,
  status session_status NOT NULL,
  is_paid BOOLEAN NOT NULL DEFAULT FALSE,
  notes TEXT
);

--  Progress Tracking
CREATE TABLE progress (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  fitness_goal_id BIGINT NOT NULL REFERENCES fitness_goals(id) ON DELETE CASCADE,
  measurement INT NOT NULL,
  recorded_at DATE NOT NULL DEFAULT CURRENT_DATE,
  notes TEXT
);

--  Equipment Types
CREATE TABLE equipment_types (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50) NOT NULL,
  weight_kg REAL
);

-- Equipment Items
CREATE TABLE equipment_items (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  type_id BIGINT NOT NULL REFERENCES equipment_types(id) ON DELETE RESTRICT,
  inventory_number VARCHAR(50) NOT NULL UNIQUE,
  room VARCHAR(50),
  status equipment_status NOT NULL,
  last_service_at DATE,
  purchased_at DATE
);

CREATE INDEX idx_personal_training_member ON personal_training(member_id);
CREATE INDEX idx_personal_training_trainer ON personal_training(trainer_id);
CREATE INDEX idx_progress_fitness_goal ON progress(fitness_goal_id);
CREATE INDEX idx_progress_fitness_goal ON progress(fitness_goal_id);
CREATE INDEX idx_equipment_items_type ON equipment_items(type_id);


-- [Kurchyk Vladyslav] - classes, attendance

CREATE TABLE classes (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    trainer_id BIGINT NOT NULL,
    room VARCHAR(50) NOT NULL,
    scheduled_at TIMESTAMP NOT NULL,
    duration_min INT NOT NULL,
    max_capacity INT NOT NULL,
    FOREIGN KEY (trainer_id) REFERENCES trainers (id)
);

CREATE TABLE attendance (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    attended_at DATE NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members (id),
    FOREIGN KEY (class_id) REFERENCES classes (id)
);
