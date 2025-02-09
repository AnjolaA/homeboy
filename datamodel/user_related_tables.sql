-- Remove USE statement as database context is handled by connection string
-- IF NOT EXISTS check for Azure SQL Database
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'FACT_INDIVIDUAL')
BEGIN
    CREATE TABLE [dbo].[FACT_INDIVIDUAL] (
        jobID NVARCHAR(255) PRIMARY KEY,
        name NVARCHAR(255),
        sanctions_count INT,
        peps_count INT,
        social_reach_count INT,
        totalWebsites INT,
        websitesFilteredout INT,
        websitesAnalysed INT,
        jobTitles INT,
        drugs INT,
        concerns INT,
        mediaSources INT,
        charitable INT,
        companyFormation INT,
        professionalBodies INT,
        personalWebsites INT,
        manual_effort NVARCHAR(255),
        report_duration NVARCHAR(255),
        employer_name NVARCHAR(255),
        employer_job_title NVARCHAR(255),
        employer_town NVARCHAR(255)
    );
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DIM_RELATED_PEOPLE')
BEGIN
    CREATE TABLE [dbo].[DIM_RELATED_PEOPLE] (
        ID NVARCHAR(255) PRIMARY KEY,
        jobID NVARCHAR(255),
        first_name NVARCHAR(255),
        last_name NVARCHAR(255),
        employer NVARCHAR(255),
        job_title NVARCHAR(255),
        start_date DATE,
        end_date DATE,
        CONSTRAINT FK_RelatedPeople_Individual FOREIGN KEY (jobID) 
            REFERENCES [dbo].[FACT_INDIVIDUAL](jobID)
    );
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DIM_COMPANY_OVERLAP')
BEGIN
    CREATE TABLE [dbo].[DIM_COMPANY_OVERLAP] (
        overlap_id NVARCHAR(255) PRIMARY KEY,
        ID NVARCHAR(255),
        employer NVARCHAR(255),
        job_title NVARCHAR(255),
        appointed_on DATE,
        resigned_on DATE,
        CONSTRAINT FK_CompanyOverlap_RelatedPeople FOREIGN KEY (ID) 
            REFERENCES [dbo].[DIM_RELATED_PEOPLE](ID)
    );
END

-- Create indexes using IF NOT EXISTS check compatible with Azure SQL
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_related_people_jobid' AND object_id = OBJECT_ID('dbo.DIM_RELATED_PEOPLE'))
    CREATE INDEX idx_related_people_jobid ON [dbo].[DIM_RELATED_PEOPLE](jobID);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_company_overlap_id' AND object_id = OBJECT_ID('dbo.DIM_COMPANY_OVERLAP'))
    CREATE INDEX idx_company_overlap_id ON [dbo].[DIM_COMPANY_OVERLAP](ID);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_related_people_employer' AND object_id = OBJECT_ID('dbo.DIM_RELATED_PEOPLE'))
    CREATE INDEX idx_related_people_employer ON [dbo].[DIM_RELATED_PEOPLE](employer);

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_company_overlap_employer' AND object_id = OBJECT_ID('dbo.DIM_COMPANY_OVERLAP'))
    CREATE INDEX idx_company_overlap_employer ON [dbo].[DIM_COMPANY_OVERLAP](employer);