/*
Problem statement
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand
FROM skills_dim AS sd
INNER JOIN skills_job_dim AS sjd ON sd.skill_id = sjd.skill_id
INNER JOIN job_postings_fact AS jpf ON jpf.job_id = sjd.job_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    --AND jpf.job_location = 'Anywhere'
    AND jpf.job_work_from_home = TRUE
    --AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills
ORDER BY
    median_salary DESC
LIMIT 25;

SELECT *
FROM job_postings_fact
LIMIT 10;

/*
┌───────────┬───────────────┬────────┐
│  skills   │ median_salary │ demand │
│  varchar  │    double     │ int64  │
├───────────┼───────────────┼────────┤
│ rust      │      210000.0 │    232 │
│ sheets    │      196698.0 │     98 │
│ solidity  │      192500.0 │     45 │
│ terraform │      184000.0 │   3248 │
│ golang    │      184000.0 │    912 │
│ next.js   │      180000.0 │     19 │
│ ggplot2   │      176250.0 │     15 │
│ spring    │      175500.0 │    364 │
│ ocaml     │      172500.0 │      1 │
│ erlang    │      172500.0 │      9 │
│ haskell   │      172500.0 │     17 │
│ neo4j     │      170000.0 │    277 │
│ gdpr      │      169616.0 │    582 │
│ zoom      │      168438.0 │    127 │
│ graphql   │      167500.0 │    445 │
│ plotly    │      162500.0 │     61 │
│ mongo     │      162250.0 │    265 │
│ centos    │      159350.0 │     31 │
│ mxnet     │      157500.0 │      5 │
│ fastapi   │      157500.0 │    204 │
│ vue       │      156000.0 │     71 │
│ drupal    │      156000.0 │      9 │
│ django    │      155000.0 │    265 │
│ trello    │      155000.0 │     36 │
│ bitbucket │      155000.0 │    478 │
└───────────┴───────────────┴────────┘
*/