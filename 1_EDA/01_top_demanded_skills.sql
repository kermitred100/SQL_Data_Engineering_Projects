/*
Problem statement
*/

SELECT *
FROM job_postings_fact AS jpf 
INNER JOIN skills_job_dim AS sjd 
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd 
    ON sjd.skill_id = sd.skill_id
LIMIT 10;

SELECT
    sd.skills,
    COUNT(*)
FROM skills_dim AS sd
INNER JOIN skills_job_dim AS sjd ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_location = 'Anywhere'
    AND jpf.job_work_from_home = TRUE
GROUP BY sd.skills
ORDER BY COUNT(*) DESC
LIMIT 10;

/*
┌────────────┬──────────────┐
│   skills   │ count_star() │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘
*/





