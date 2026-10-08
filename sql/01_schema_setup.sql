CREATE DATABASE BookstoreAnalytics;
GO

USE BookstoreAnalytics;
GO

-- 1. Roles Reference Table
CREATE TABLE roles (
    id NVARCHAR(50) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    created_at DATETIME2 NULL
);

-- 2. Teams Reference Table
CREATE TABLE teams (
    id NVARCHAR(50) PRIMARY KEY,
    store_id NVARCHAR(50) NULL,
    name NVARCHAR(50) NOT NULL,
    created_at DATETIME2 NULL
);

-- 3. Profiles / Employee Table (Sanitized)
CREATE TABLE profiles (
    id NVARCHAR(50) PRIMARY KEY,
    xp INT DEFAULT 0,
    updated_at DATETIME2 NULL,
    role NVARCHAR(50) NULL,
    store_id NVARCHAR(50) NULL,
    team_id NVARCHAR(50) NULL,
    role_id NVARCHAR(50) NULL,
    teams_id NVARCHAR(50) NULL,
    FOREIGN KEY (role_id) REFERENCES roles(id),
    FOREIGN KEY (teams_id) REFERENCES teams(id)
);

-- 4. Quiz Mapping Table
CREATE TABLE quiz_map (
    quiz_id NVARCHAR(100) NOT NULL,
    module_id NVARCHAR(100) NOT NULL,
    PRIMARY KEY (quiz_id, module_id)
);

-- 5. User Progress Fact Table
CREATE TABLE user_progress (
    id NVARCHAR(50) PRIMARY KEY,
    user_id NVARCHAR(50) NOT NULL,
    quiz_id NVARCHAR(100) NOT NULL,
    passed VARCHAR(10) NOT NULL,       -- Staged as text to handle 'True'/'False' CSV strings
    completed_at DATETIMEOFFSET NOT NULL,
    module_id NVARCHAR(100) NOT NULL,
    score INT NOT NULL,
    xp_awarded VARCHAR(10) NULL,
    FOREIGN KEY (user_id) REFERENCES profiles(id)
);
GO