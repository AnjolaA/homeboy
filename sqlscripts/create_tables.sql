-- Create FACT_INDIVIDUAL table
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

-- Create DIM_PERSON table
CREATE TABLE IF NOT EXISTS DIM_PERSON (
    person_id VARCHAR(255) PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    date_of_birth DATE,
    image_url TEXT
);

-- Create DIM_EMPLOYER table
CREATE TABLE IF NOT EXISTS DIM_EMPLOYER (
    employer_id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    job_title VARCHAR(255),
    town VARCHAR(255)
);

-- Create DIM_STATS table
CREATE TABLE IF NOT EXISTS DIM_STATS (
    stats_id VARCHAR(255) PRIMARY KEY,
    total_websites INTEGER,
    websites_filtered_out INTEGER,
    websites_analysed INTEGER,
    job_titles INTEGER,
    total_images INTEGER,
    drugs INTEGER,
    concerns INTEGER,
    media_sources INTEGER,
    charitable INTEGER,
    company_formations INTEGER,
    professional_bodies INTEGER,
    personal_websites INTEGER,
    manual_effort VARCHAR(255),
    website_text_extraction_failures INTEGER,
    report_duration VARCHAR(255)
);

-- Create DIM_IMAGES table
CREATE TABLE IF NOT EXISTS DIM_IMAGES (
    image_id VARCHAR(255) PRIMARY KEY,
    src TEXT,
    url TEXT,
    caption TEXT,
    date_year INTEGER,
    category VARCHAR(255),
    logo TEXT,
    screenshot_url TEXT
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
    date_of_birth DATE
);

-- Add Foreign Key constraints
ALTER TABLE DIM_PERSON
ADD CONSTRAINT fk_person_individual
FOREIGN KEY (person_id) REFERENCES FACT_INDIVIDUAL(individual_id);

ALTER TABLE DIM_EMPLOYER
ADD CONSTRAINT fk_employer_individual
FOREIGN KEY (employer_id) REFERENCES FACT_INDIVIDUAL(individual_id);

ALTER TABLE DIM_STATS
ADD CONSTRAINT fk_stats_individual
FOREIGN KEY (stats_id) REFERENCES FACT_INDIVIDUAL(individual_id);

ALTER TABLE DIM_IMAGES
ADD CONSTRAINT fk_images_individual
FOREIGN KEY (image_id) REFERENCES FACT_INDIVIDUAL(individual_id);

ALTER TABLE DIM_RELATED_PEOPLE
ADD CONSTRAINT fk_related_people_individual
FOREIGN KEY (related_person_id) REFERENCES FACT_INDIVIDUAL(individual_id);