/*
Question: What are the top-paying data analyst jobs?
 - Identify the top 10 highest-paying Data Analyst roles that are available remotely.
 - Focuses on job postings with specified salaries (remove nulls).
 - Company name
 - Why? Highlight the top-paying opportunities for Data Analysts, offering insights based on employee needs
*/

SELECT
    name as Company_name,
    job_title,
    salary_year_avg,
    job_id,
    job_location,
    job_schedule_type,
    job_posted_date
FROM 
    job_postings_fact
LEFT JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_work_from_home = true AND 
    job_title_short = 'Data Analyst' AND 
    salary_year_avg is not null
ORDER BY salary_year_avg DESC
Limit 10;