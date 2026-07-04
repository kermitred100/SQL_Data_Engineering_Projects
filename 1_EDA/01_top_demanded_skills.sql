/*
Question: What are the most in-demand skills for Data Engineers?
- Identify the top 10 in-demand skills for Data Engineers
- Focus on remote positions (on-site skills will also be included but is not the focus of the EDA exercise)
- Determine the top skills for Data Engineers for remote job postings
- For non-remote job postings, which country pays their Data Engineers the best and the amount of job listings that exist.

Why?
We need to retrieve the top 10 skills with the highest demand in the remote job market and provide insights into the most valuable skills for Data Engineers to determine the skills aspiring/current Data Engineers should be learning/bolstering.
For Data Engineers who want to migrate, seeing which countries has the best salaries and adequate demand would also help the decision making process.
*/

-- Remote Data Engineer Skills Demand
SELECT
    sd.skills AS "DE Skills",
    COUNT(sjd.*) AS "Demand Count"
FROM skills_dim AS sd
INNER JOIN skills_job_dim AS sjd
    ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf
    ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_location = 'Anywhere'
    AND jpf.job_work_from_home = TRUE
GROUP BY
    sd.skills
ORDER BY
    COUNT(sjd.*) DESC
LIMIT 10;

-- On-site Data Engineer Skills Demand
SELECT
    sd.skills AS "DE Skills",
    COUNT(sjd.*) AS "Demand Count"
FROM skills_dim AS sd
INNER JOIN skills_job_dim AS sjd
    ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf
    ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_location <> 'Anywhere'
    AND jpf.job_work_from_home = FALSE
GROUP BY sd.skills
ORDER BY COUNT(sjd.*) DESC
LIMIT 10;

-- On-site Data Engineer Jobs By Country
SELECT
    jpf.job_country AS Country,
    ROUND(MEAN(jpf.salary_year_avg), 0) AS "Salary/Year",
    COUNT(jpf.*) "Job Listings"
FROM job_postings_fact AS jpf 
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_location <> 'Anywhere'
    AND jpf.job_country IS NOT NULL
    AND jpf.job_work_from_home = FALSE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY jpf.job_country
ORDER BY COUNT(jpf.*) DESC,
    MEAN(jpf.salary_year_avg) DESC
LIMIT 25;

/*
Knowledge on SQL and Python sit firmly at the top of the list with 29,221 and 28,776 listings respectively showing that Data Engineers must excel at both data querying/modeling and data manipulation. Followed by the top 2 are cloud platforms with AWS leading the category with 17,823 listings followed by Azure with 14,143. Apache Spark completes the top 5 skills with 12,799 listings, highlighting the importance of large-scale data processing knowledge.

Highlights:
- SQL and Python is the bread and butter of Data Engineers in terms of skills
- Cloud platforms like AWS and Azure should also be studied as they are critical for modern Data Engineers
- Data pipeline tools (Airflow, Snowflake, Databricks) show growing demand
- Java and GCP round out the top 10 most in-demand skills
- The top 5 skills are consistent even if the job listing is remote or on-site.

Skill demand for remote Data Engineer listings
┌────────────┬──────────────┐
│ DE Skills  │ Demand Count │
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

Skill demand for on-site Data Engineer listings
┌────────────┬──────────────┐
│ DE Skills  │ Demand Count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │       203345 │
│ python     │       194770 │
│ azure      │       114416 │
│ aws        │       112071 │
│ spark      │        93894 │
│ java       │        62260 │
│ databricks │        54709 │
│ snowflake  │        51588 │
│ scala      │        50660 │
│ kafka      │        49877 │
└────────────┴──────────────┘


Highlights:
- The United states boasts the most amount of Data Engineer job listings with 6,585 with an excellent mean salary of ~137K
- Sudan also has high demand for data engineers because of a new government for push to innovate through data projects
- The top 5 countries has an average of 128K yearly salary

Mean yearly salary for on-site Data Engineer jobs by Country (Top 25, balanced with demand)
┌─────────────────────┬─────────────┬──────────────┐
│       Country       │ Salary/Year │ Job Listings │
│       varchar       │   double    │    int64     │
├─────────────────────┼─────────────┼──────────────┤
│ United States       │    137445.0 │         6585 │
│ Sudan               │    137859.0 │          678 │
│ India               │    116274.0 │          360 │
│ Canada              │    122098.0 │          230 │
│ United Kingdom      │    127829.0 │           74 │
│ France              │    114302.0 │           64 │
│ Poland              │    117650.0 │           56 │
│ Germany             │    124952.0 │           46 │
│ Philippines         │     89572.0 │           41 │
│ Spain               │    122195.0 │           40 │
│ Australia           │    123868.0 │           37 │
│ South Africa        │    109093.0 │           37 │
│ Puerto Rico         │    136447.0 │           32 │
│ Portugal            │    120073.0 │           32 │
│ Netherlands         │    110491.0 │           28 │
│ Greece              │     99777.0 │           27 │
│ Cyprus              │     72924.0 │           23 │
│ Mexico              │    135815.0 │           22 │
│ U.S. Virgin Islands │    112828.0 │           21 │
│ Malaysia            │    112887.0 │           20 │
│ Latvia              │     38251.0 │           19 │
│ Panama              │    397792.0 │           18 │
│ Sweden              │    117503.0 │           16 │
│ Vietnam             │    103758.0 │           16 │
│ Israel              │    105299.0 │           15 │
└─────────────────────┴─────────────┴──────────────┘
*/