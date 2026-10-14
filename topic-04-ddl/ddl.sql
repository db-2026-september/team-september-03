-- ================================================================
-- SQL DDL TEMPLATE (TOPIC 04)
-- ================================================================
-- PROJECT: Fitness Club Management System
-- ================================================================

-- ----------------------------------------------------------------
-- 0. CLEANUP (DROP EXISTING TABLES & TYPES)
-- ----------------------------------------------------------------
DROP TABLE IF EXISTS class_equipments CASCADE;
DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS classes CASCADE;
DROP TABLE IF EXISTS equipment_items CASCADE;
DROP TABLE IF EXISTS rooms CASCADE;
DROP TABLE IF EXISTS equipment_types CASCADE;
DROP TABLE IF EXISTS progress CASCADE;
DROP TABLE IF EXISTS personal_training CASCADE;
DROP TABLE IF EXISTS trainer_specializations CASCADE;
DROP TABLE IF EXISTS specializations CASCADE;
DROP TABLE IF EXISTS trainers CASCADE;
DROP TABLE IF EXISTS fitness_goals CASCADE;
DROP TABLE IF EXISTS memberships CASCADE;
DROP TABLE IF EXISTS members CASCADE;

DROP TYPE IF EXISTS session_status CASCADE;
DROP TYPE IF EXISTS equipment_status CASCADE;
DROP TYPE IF EXISTS goal_type CASCADE; 
DROP TYPE IF EXISTS membership_type CASCADE;

-- ----------------------------------------------------------------
-- 1. ENUMS
-- ----------------------------------------------------------------
CREATE TYPE membership_type AS ENUM ('monthly', 'yearly', 'premium');
CREATE TYPE goal_type AS ENUM ('weight_loss', 'muscle_gain', 'endurance', 'flexibility', 'maintenance');
CREATE TYPE equipment_status AS ENUM ('available', 'in_use', 'under_repair', 'damaged', 'decommissioned');
CREATE TYPE session_status AS ENUM ('scheduled', 'completed', 'cancelled', 'no_show');

-- ----------------------------------------------------------------
-- 2. TABLES & CONSTRAINTS
-- ----------------------------------------------------------------

-- [Anastasiia Khudych] - members, memberships, fitness_goals
CREATE TABLE members (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE memberships (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id BIGINT NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    type membership_type NOT NULL,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE
);

CREATE TABLE fitness_goals ( 
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id BIGINT NOT NULL REFERENCES members(id) ON DELETE CASCADE, 
    goal_type goal_type NOT NULL, 
    target_value DECIMAL(6, 2) NOT NULL, 
    target_value_unit VARCHAR(20),
    start_date DATE NOT NULL,
    target_date DATE NOT NULL,
    achieved_date DATE
);

-- [Mykola Astafiev] - trainers, specializations, trainer_specializations
CREATE TABLE trainers (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    experience_years INT DEFAULT 0,
    hourly_rate DECIMAL(10, 2),
    hired_at DATE
);

CREATE TABLE specializations (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE trainer_specializations (
    trainer_id BIGINT NOT NULL REFERENCES trainers(id) ON DELETE CASCADE,
    specialization_id BIGINT NOT NULL REFERENCES specializations(id) ON DELETE CASCADE,
    PRIMARY KEY (trainer_id, specialization_id)
);

-- [Maksym Bielik] - equipment_types, rooms, equipment_items, progress, personal_training, class_equipments
CREATE TABLE equipment_types (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    weight_kg DECIMAL(5, 2)
);

CREATE TABLE rooms (
    id SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE equipment_items (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_id BIGINT NOT NULL REFERENCES equipment_types(id) ON DELETE RESTRICT,
    inventory_number VARCHAR(50) NOT NULL UNIQUE,
    room_id SMALLINT REFERENCES rooms(id) ON DELETE SET NULL,
    status equipment_status NOT NULL DEFAULT 'available',
    last_service_at DATE,
    purchased_at DATE
);

CREATE TABLE progress (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fitness_goal_id BIGINT NOT NULL REFERENCES fitness_goals(id) ON DELETE CASCADE,
    measurement DECIMAL(6, 2) NOT NULL,
    recorded_at DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT
);

CREATE TABLE personal_training (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id BIGINT NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    trainer_id BIGINT NOT NULL REFERENCES trainers(id) ON DELETE RESTRICT,
    scheduled_at TIMESTAMP NOT NULL,
    duration_min SMALLINT NOT NULL DEFAULT 60,
    status session_status NOT NULL DEFAULT 'scheduled',
    is_paid BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT
);

-- [Kurchyk Vladyslav] - classes, attendance
CREATE TABLE classes (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    trainer_id BIGINT NOT NULL REFERENCES trainers(id) ON DELETE RESTRICT,
    room_id SMALLINT NOT NULL REFERENCES rooms(id) ON DELETE RESTRICT,
    scheduled_at TIMESTAMP NOT NULL,
    duration_min SMALLINT NOT NULL,
    max_capacity SMALLINT NOT NULL
);

CREATE TABLE attendance (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    member_id BIGINT NOT NULL REFERENCES members(id) ON DELETE CASCADE,
    class_id BIGINT REFERENCES classes(id) ON DELETE SET NULL, -- NULL = візит без групового заняття
    attended_at TIMESTAMP NOT NULL
);

-- [Maksym Bielik & Kurchyk Vladyslav] - class equipments junction table
CREATE TABLE class_equipments (
    class_id BIGINT NOT NULL REFERENCES classes(id) ON DELETE CASCADE,
    equipment_item_id BIGINT NOT NULL REFERENCES equipment_items(id) ON DELETE RESTRICT,
    quantity SMALLINT NOT NULL DEFAULT 1,
    PRIMARY KEY (class_id, equipment_item_id)
);

-- ----------------------------------------------------------------
-- 3. INDEXES FOR OPTIMIZATION
-- ----------------------------------------------------------------

-- Foreign key & search indexes
CREATE INDEX idx_memberships_member ON memberships(member_id);
CREATE INDEX idx_fitness_goals_member ON fitness_goals(member_id);

CREATE INDEX idx_trainer_spec_trainer ON trainer_specializations(trainer_id);
CREATE INDEX idx_trainer_spec_specialization ON trainer_specializations(specialization_id);

CREATE INDEX idx_equipment_items_type ON equipment_items(type_id);
CREATE INDEX idx_equipment_items_room ON equipment_items(room_id);

CREATE INDEX idx_progress_fitness_goal ON progress(fitness_goal_id);

CREATE INDEX idx_personal_training_member ON personal_training(member_id);
CREATE INDEX idx_personal_training_trainer ON personal_training(trainer_id);

CREATE INDEX idx_classes_trainer ON classes(trainer_id);
CREATE INDEX idx_classes_room ON classes(room_id);

CREATE INDEX idx_attendance_member ON attendance(member_id);
CREATE INDEX idx_attendance_class ON attendance(class_id);

CREATE INDEX idx_class_equipments_class ON class_equipments(class_id);
CREATE INDEX idx_class_equipments_equipment ON class_equipments(equipment_item_id);
