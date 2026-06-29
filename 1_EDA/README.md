# HEADING 1
## HEADING 2


Normal Text  
**Bold Text**  
`This is Code`

[Link Text](https://google.com)  
![Alt Text](../Images\1_1_Project1_EDA.png)


```sql
SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand,
    ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)) / 1_000_000), 2) AS optimal_score
FROM skills_dim AS sd
INNER JOIN skills_job_dim AS sjd ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    --AND jpf.job_location = 'Anywhere'
    AND jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
ORDER BY
    optimal_score DESC
LIMIT 25;
```