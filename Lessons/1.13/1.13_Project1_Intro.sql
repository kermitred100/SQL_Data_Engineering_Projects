SELECT DISTINCT
    job_country,
    COUNT(job_country)
FROM
    job_postings_fact
GROUP BY job_country
ORDER BY COUNT(job_country) DESC;