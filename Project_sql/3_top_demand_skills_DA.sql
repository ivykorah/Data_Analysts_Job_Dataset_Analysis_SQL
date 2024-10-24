/*
Question: What are the most in-demand skills for data analysts?
 - Join job postings to inner join table similar to query 2
 - Identify the top 5 in-demand skills for a data analyst.
 - Focus on all job postings.
 - Why? Retrieves the top 5 skills with the highest demand in the job market, 
   providing insights into the most valuable skills for job seekers.
*/


select 
    skills as skill_name,
    count(skills) count_of_skill,
    round(avg(salary_year_avg),1) as salary_average
FROM
    job_postings_fact jf
INNER JOIN 
    skills_job_dim sj on sj.job_id = jf.job_id
INNER JOIN 
    skills_dim sd on sd.skill_id = sj.skill_id
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    sd.skills
ORDER BY 
    count_of_skill DESC
LIMIT 10;



--for Estonia
select 
    skills as skill_name,
    count(skills) count_of_skill,
    round(avg(salary_year_avg),1) as salary_average
FROM
    job_postings_fact jf
INNER JOIN 
    skills_job_dim sj on sj.job_id = jf.job_id
INNER JOIN 
    skills_dim sd on sd.skill_id = sj.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    search_location like '%Estonia%'
GROUP BY 
    sd.skills
ORDER BY 
    count_of_skill DESC
LIMIT 10;
