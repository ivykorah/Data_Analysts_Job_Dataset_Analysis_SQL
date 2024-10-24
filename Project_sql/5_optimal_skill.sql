/* Question: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)? 
 - Identify skills in high demand and associated with high average salaries for Data Analyst roles 
 - Concentrates on remote positions with specified salaries
 - Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), 
   offering strategic insights for career development in data analysis
*/

WITH skills_demand AS (
    SELECT 
    sd.skill_id,
    sd.skills as skill_name,
    count(sd.skills) as count_of_skill,
    round(avg(salary_year_avg),0) as salary_average
    FROM
        job_postings_fact jf
    INNER JOIN 
        skills_job_dim sj on sj.job_id = jf.job_id
    INNER JOIN 
        skills_dim sd on sd.skill_id = sj.skill_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = true
    GROUP BY 
        sd.skills, sd.skill_id
), average_salary AS (
    select 
    sj.skill_id,
    round(avg(salary_year_avg),0) as salary_average
    FROM
        job_postings_fact jf
    INNER JOIN 
        skills_job_dim sj on sj.job_id = jf.job_id
    INNER JOIN 
        skills_dim sd on sd.skill_id = sj.skill_id
    WHERE 
        job_title_short = 'Data Analyst' and 
        salary_year_avg IS NOT NULL AND
        job_work_from_home = true
    GROUP BY 
        sj.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skill_name,
    skills_demand.count_of_skill,
    skills_demand.salary_average
FROM 
    skills_demand
INNER JOIN 
    average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    count_of_skill > 10
ORDER BY
    salary_average DESC,
    count_of_skill DESC
LIMIT 25;



/*
rewriting this same query more concisely
SELECT
    skills_dim.skill_id,
    skills_dim.skills as skill_name,
    count(skills_dim.skills) as count_of_skill,
    round(avg(salary_year_avg),0) as salary_average
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id 
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id 
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL 
    AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    salary_average DESC,
    count_of_skill DESC
LIMIT 25;
*/
