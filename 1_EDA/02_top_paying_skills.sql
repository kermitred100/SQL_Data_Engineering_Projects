/*
Question: What are the highest-paying skills for Data Engineers?
- Calculate the median salary for each skill required in Data Engineer positions
- Include skill frequency to identify both salary and demand

Why?
We need to identify which skills command the highest compensation while also showing the demand, providing a more complete picture for skill development priorities.
The median is used instead of the average to reduce the impact of outlier salaries.

For our use case we will set the minimum demand for skills at 100 to qualify as anything less might be too niche a skill.
*/

SELECT
    sd.skills AS Skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS Median_Salary,
    COUNT(jpf.*) AS Demand
FROM skills_dim AS sd
INNER JOIN skills_job_dim AS sjd
    ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf
    ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_location = 'Anywhere'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) > 100
ORDER BY
    Median_Salary DESC
LIMIT 25;

/*
Key Insights:
    - Terraform sits at the top for the highest paid skill with 184K median salary though the demand is limited at 193.
    - SQL and Python, though they did not crack top 10 still are by far the most in-demand skills with 1128 and 1133 demand respectively. This means that these 2 really are the non-negotiable skills a Data Engineer must possess.
    - The top 25 is riddled with Cloud skills (AWS, Snowflake, Databricks, GCP, etc) signaling a shift from traditional on-premise data platforms to cloud computing.
    - For big data, Spark still dominates the market with 503 demand and 140K median salary. Note that most job listings will mention "Spark" regardless of language hence this should be bundled in with PySpark with 152 demand and the same median salary of 140K.
    - Modern data pipelines are also in demand such as Airflow (386 demand with 150K median salary) and Kafka (292 demand with 145K salary).

Skills by median salary and demand
┌────────────┬───────────────┬────────┐
│   Skills   │ Median_Salary │ Demand │
│  varchar   │    double     │ int64  │
├────────────┼───────────────┼────────┤
│ terraform  │      184000.0 │    193 │
│ kubernetes │      150500.0 │    147 │
│ airflow    │      150000.0 │    386 │
│ kafka      │      145000.0 │    292 │
│ pyspark    │      140000.0 │    152 │
│ git        │      140000.0 │    208 │
│ go         │      140000.0 │    113 │
│ spark      │      140000.0 │    503 │
│ aws        │      137320.0 │    783 │
│ scala      │      137290.0 │    247 │
│ gcp        │      136000.0 │    196 │
│ mongodb    │      135750.0 │    136 │
│ snowflake  │      135500.0 │    438 │
│ github     │      135000.0 │    127 │
│ python     │      135000.0 │   1133 │
│ java       │      135000.0 │    303 │
│ hadoop     │      135000.0 │    198 │
│ bigquery   │      135000.0 │    123 │
│ docker     │      135000.0 │    144 │
│ r          │      134775.0 │    133 │
│ nosql      │      134415.0 │    193 │
│ databricks │      132750.0 │    266 │
│ mysql      │      130500.0 │    101 │
│ sql        │      130000.0 │   1128 │
│ redshift   │      130000.0 │    274 │
└────────────┴───────────────┴────────┘
*/