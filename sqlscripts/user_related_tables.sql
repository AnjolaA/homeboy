-- Create FACT_INDIVIDUAL table (User table)
CREATE TABLE IF NOT EXISTS FACT_INDIVIDUAL (
    individual_id VARCHAR(255) PRIMARY KEY,
    type VARCHAR(50),
    name VARCHAR(255),
    display_picture TEXT,
    high_profile BOOLEAN,
    sanctions_count INTEGER,
    peps_count INTEGER,
    social_reach_count INTEGER,
    biography TEXT
);

-- Create DIM_RELATED_PEOPLE table
CREATE TABLE IF NOT EXISTS DIM_RELATED_PEOPLE (
    related_person_id VARCHAR(255) PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    employer VARCHAR(255),
    job_title VARCHAR(255),
    appointed_on DATE,
    resigned_on DATE,
    date_of_birth DATE,
    FOREIGN KEY (related_person_id) REFERENCES FACT_INDIVIDUAL(individual_id)
);

-- Create index for better query performance
CREATE INDEX IF NOT EXISTS idx_related_people_employer 
ON DIM_RELATED_PEOPLE(employer);

CREATE INDEX IF NOT EXISTS idx_related_people_job_title 
ON DIM_RELATED_PEOPLE(job_title);