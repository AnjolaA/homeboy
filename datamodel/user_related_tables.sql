-- Create FACT_INDIVIDUAL table
CREATE TABLE IF NOT EXISTS FACT_INDIVIDUAL (
    jobID VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255),
    sanctions_count INTEGER,
    peps_count INTEGER,
    social_reach_count INTEGER,
    totalWebsites INTEGER,
    websitesFilteredout INTEGER,
    websitesAnalysed INTEGER,
    jobTitles INTEGER,
    drugs INTEGER,
    concerns INTEGER,
    mediaSources INTEGER,
    charitable INTEGER,
    companyFormation INTEGER,
    professionalBodies INTEGER,
    personalWebsites INTEGER,
    manual_effort VARCHAR(255),
    report_duration VARCHAR(255),
    employer_name VARCHAR(255),
    employer_job_title VARCHAR(255),
    employer_town VARCHAR(255)
);

-- Create DIM_RELATED_PEOPLE table
CREATE TABLE IF NOT EXISTS DIM_RELATED_PEOPLE (
    ID VARCHAR(255) PRIMARY KEY,
    jobID VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    employer VARCHAR(255),
    job_title VARCHAR(255),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (jobID) REFERENCES FACT_INDIVIDUAL(jobID)
);

-- Create DIM_COMPANY_OVERLAP table
CREATE TABLE IF NOT EXISTS DIM_COMPANY_OVERLAP (
    overlap_id VARCHAR(255) PRIMARY KEY,
    ID VARCHAR(255),
    employer VARCHAR(255),
    job_title VARCHAR(255),
    appointed_on DATE,
    resigned_on DATE,
    FOREIGN KEY (ID) REFERENCES DIM_RELATED_PEOPLE(ID)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_related_people_jobid 
ON DIM_RELATED_PEOPLE(jobID);

CREATE INDEX IF NOT EXISTS idx_company_overlap_id 
ON DIM_COMPANY_OVERLAP(ID);

CREATE INDEX IF NOT EXISTS idx_related_people_employer 
ON DIM_RELATED_PEOPLE(employer);

CREATE INDEX IF NOT EXISTS idx_company_overlap_employer 
ON DIM_COMPANY_OVERLAP(employer);