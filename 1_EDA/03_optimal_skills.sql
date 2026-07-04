/*
Question: What are the most optimal skills for Data Engineers - balancing both demand and salary
- Create a ranking column that combines demand count and median salary to identify the most valuable skills using weighted score:
    Normalized salary = Salary / Highest Salary
    Normalized Demand = Demand / Highest Demand

    Score = (0.4 * Normalized Salary) + (0.6 * Normalized Demand)

    A greater importance is put on demand because it is a better predictor of being hired, some niche skills like Terraform may command a higher salary but the demand is lagging behind core Data Engineering skills such as SQL, Python, AWS, Spark etc.
- Focus only on remote Data Engineer positions with specified annual salaries

Why?
This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately, rather than letting rare, outlier skills distort the results for a better picture of the market.
*/

-- Get the highest salary and demand
SELECT
    MAX(Median_Salary) AS Top_Salary,
    MAX(Demand) AS Top_Demand
FROM (
    SELECT
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
);

/*
┌────────────┬────────────┐
│ Top_Salary │ Top_Demand │
│   double   │   int64    │
├────────────┼────────────┤
│   184000.0 │       1133 │
└────────────┴────────────┘
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS Median_Salary,
    COUNT(jpf.*) AS Demand,
    ROUND(Median_Salary / 184_000, 2) AS Normalized_Salary,
    ROUND(Demand / 1133, 2) AS Normalized_Demand,
    ROUND((0.4 * Normalized_Salary) + (0.6 * Normalized_Demand), 2) AS Score
FROM skills_dim AS sd
INNER JOIN skills_job_dim AS sjd ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
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
    Score DESC
LIMIT 25;

/*
Key Insights:
    - Python and SQL are clear market leaders. These are the foundational skills for data engineering roles and their high demand and strong salaries explain why they achieve the highest composite scores (0.89 and 0.88).
    - AWS is the strongest cloud skill with a demand of 783 and a median salary of 137K. Azure offers slightly lower salaries and GCP remains valuable has fewer demand compared to the two.
    - For engineers looking to specialize beyond Python and SQL, Spark remains one of the most impactful technologies with a demand of 503 and median salary of 140K.
    - Airflow is often associated with production-grade data pipelines and workflow orchestration. Employers typically seek engineers who can build, schedule, monitor, and maintain reliable ETL/ELT workflows, making Airflow a valuable specialization with a high median salary of 150K and moderate demand of 386.
    - Snowflake has become a standard cloud data warehouse in many organizations. Employers increasingly expect data engineers to understand cloud-native analytics platforms.
    - Terraform scores highly because it commands premium salary with 184K and the demand is high enough to justify delving into it.

Data Engineering Skills by median salary and demand scored for balance between the two to determine the optimal skills.
┌────────────┬───────────────┬────────┬───────────────────┬───────────────────┬────────┐
│   skills   │ Median_Salary │ Demand │ Normalized_Salary │ Normalized_Demand │ Score  │
│  varchar   │    double     │ int64  │      double       │      double       │ double │
├────────────┼───────────────┼────────┼───────────────────┼───────────────────┼────────┤
│ python     │      135000.0 │   1133 │              0.73 │               1.0 │   0.89 │
│ sql        │      130000.0 │   1128 │              0.71 │               1.0 │   0.88 │
│ aws        │      137320.0 │    783 │              0.75 │              0.69 │   0.71 │
│ spark      │      140000.0 │    503 │              0.76 │              0.44 │   0.57 │
│ azure      │      128000.0 │    475 │               0.7 │              0.42 │   0.53 │
│ snowflake  │      135500.0 │    438 │              0.74 │              0.39 │   0.53 │
│ airflow    │      150000.0 │    386 │              0.82 │              0.34 │   0.53 │
│ terraform  │      184000.0 │    193 │               1.0 │              0.17 │    0.5 │
│ rust       │      210000.0 │     23 │              1.14 │              0.02 │   0.47 │
│ kafka      │      145000.0 │    292 │              0.79 │              0.26 │   0.47 │
│ java       │      135000.0 │    303 │              0.73 │              0.27 │   0.45 │
│ scala      │      137290.0 │    247 │              0.75 │              0.22 │   0.43 │
│ sheets     │      196698.0 │      2 │              1.07 │               0.0 │   0.43 │
│ databricks │      132750.0 │    266 │              0.72 │              0.23 │   0.43 │
│ redshift   │      130000.0 │    274 │              0.71 │              0.24 │   0.43 │
│ golang     │      184000.0 │     39 │               1.0 │              0.03 │   0.42 │
│ solidity   │      192500.0 │      3 │              1.05 │               0.0 │   0.42 │
│ kubernetes │      150500.0 │    147 │              0.82 │              0.13 │   0.41 │
│ git        │      140000.0 │    208 │              0.76 │              0.18 │   0.41 │
│ spring     │      175500.0 │     33 │              0.95 │              0.03 │    0.4 │
│ gcp        │      136000.0 │    196 │              0.74 │              0.17 │    0.4 │
│ nosql      │      134415.0 │    193 │              0.73 │              0.17 │   0.39 │
│ hadoop     │      135000.0 │    198 │              0.73 │              0.17 │   0.39 │
│ next.js    │      180000.0 │      2 │              0.98 │               0.0 │   0.39 │
│ gdpr       │      169616.0 │     22 │              0.92 │              0.02 │   0.38 │
└────────────┴───────────────┴────────┴───────────────────┴───────────────────┴────────┘
*/