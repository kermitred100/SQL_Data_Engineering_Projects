-- Step 2: DW - Load data from CSV files into tables


SELECT '--- Loading company dim ---' AS info;

INSERT INTO company_dim(company_id, company_name)
SELECT company_id, name
FROM read_csv('https://storage.googleapis.com/sql_de/company_dim.csv',
    AUTO_DETECT=TRUE);

SELECT '--- Loading skills dim ---' AS info;

INSERT INTO skills_dim(skill_id, skill_name, skill_type)
SELECT skill_id, skills, type
FROM read_csv('https://storage.googleapis.com/sql_de/skills_dim.csv',
    AUTO_DETECT=TRUE);

SELECT '--- Loading job postings fact ---' AS info;

INSERT INTO job_postings_fact(
    job_id, company_id, job_title_short, job_title, job_location,
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance,
    job_country, salary_rate, salary_year_avg, salary_hour_avg
)
SELECT
    job_id, company_id, job_title_short, job_title, job_location,
    job_via, job_schedule_type, job_work_from_home, search_location,
    job_posted_date, job_no_degree_mention, job_health_insurance,
    job_country, salary_rate, salary_year_avg, salary_hour_avg
FROM read_csv('https://storage.googleapis.com/sql_de/job_postings_fact.csv',
    AUTO_DETECT=TRUE);

SELECT '--- Loading skills job dim ---' AS info;

INSERT INTO skills_job_dim(skill_id, job_id)
SELECT skill_id, job_id
FROM read_csv('https://storage.googleapis.com/sql_de/skills_job_dim.csv',
    AUTO_DETECT=TRUE);

SELECT 'Company Dim' AS table_name, COUNT(*) AS record_count FROM company_dim
UNION ALL
SELECT 'Skills Dim', COUNT(*) FROM skills_dim
UNION ALL
SELECT 'Job Postings Fact', COUNT(*) FROM job_postings_fact
UNION ALL
SELECT 'Skills Job Dim', COUNT(*) FROM skills_job_dim;

SELECT '--- Company Dimension Sample ---' AS info;
SELECT * FROM company_dim LIMIT 5;

SELECT '--- Skills Dimension Sample ---' AS info;
SELECT * FROM skills_dim LIMIT 5;

SELECT '--- Job Postings Fact Sample ---' AS info;
SELECT * FROM job_postings_fact LIMIT 5;

SELECT '--- Skills Job Bridge Sample ---' AS info;
SELECT * FROM skills_job_dim LIMIT 5;