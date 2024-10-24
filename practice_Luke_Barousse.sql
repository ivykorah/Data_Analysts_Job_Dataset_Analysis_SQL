
--lukeb.co/sql_chatbot

CREATE TABLE job_applied(
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name Varchar(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name Varchar(255),
    status Varchar(50)
);


INSERT INTO job_applied (
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status)
Values(1,
    '2024-10-19',
    true,
    'prisca_CV_QA.pdf',
    true,
    'Google_CL.pdf',
    'submitted'
);

select * from job_applied;

ALTER TABLE job_applied
ADD contact Varchar(50);

UPDATE job_applied
SET contact = 'Jason Statham';


ALTER TABLE job_applied
rename column contact to contact_name; -- rename a column in an existing table


ALTER TABLE job_applied
ALTER column contact_name type text;

ALTER TABLE job_applied
drop column status;

ALTER TABLE job_applied
add status Varchar(50);

UPDATE job_applied
SET status = 'Submitted';


DROP TABLE job_applied;  --to delete a table. be careful

/* Handling dates
: :DATE - converts to a date format by removing the time portion
AT TIME ZONE - converts a timestamp btwn diff time zones. can be used on TS with or without the timezone info
EXTRACT - gets specific date parts (eg year, month, day) 
use double column to cast data from one dtype to another*/

--timestamp YYYY-MM-DD HH:MM:SS
--timestamp with Timezone YYYY-MM-DD HH:MM:SS + 00:00  (00:00 is the timezone)
--timezone is displayed as the query's or systems timezone. to convert tp UTC of a specific countries TZ, we use "AT TIME ZONE"


SELECT 
    '2023-02-19'::DATE,
    '123' ::INTEGER,
    'true'::BOOLEAN,
    '3.14'::REAL;

SELECT 
    job_title_short AS Title,
    job_location AS Location,
    job_posted_date::DATE AS date -- casting as date only. removing the timestamp
FROM job_postings_fact;


SELECT 
    job_title_short AS Title,
    job_location AS Location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date --since we dont have TZ, we are first adding UTC TZ then changing to EST
FROM job_postings_fact
LIMIT 10;

-- You can find diff TZ on postgres timestamp doc

SELECT 
    job_title_short AS Title,
    job_location AS Location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST' AS date, --since we dont have TZ, we are first adding UTC TZ then changing to EST
    EXTRACT(MONTH FROM job_posted_date) AS Date_month,
    EXTRACT(YEAR FROM job_posted_date) AS Date_month
FROM job_postings_fact
LIMIT 10;

SELECT 
    COUNT(job_title_short) AS job_title_count,
    EXTRACT(MONTH FROM job_posted_date) AS Date_month
FROM job_postings_fact
GROUP BY Date_month
ORDER BY job_title_count DESC;


CREATE TABLE january_jobs AS 
    select * from job_postings_fact
    WHERE EXTRACT(MONTH from job_posted_date) = 1;

CREATE TABLE february_jobs AS 
    SELECT * FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS 
    SELECT * FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

select * from january_jobs
limit 10;


--CASE STATEMENTS
SELECT
    job_title_short,
    job_location,
    CASE
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    END AS location_category
From job_postings_fact;


SELECT
    count(job_id),
    CASE
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    END AS location_category
From job_postings_fact
GROUP BY location_category;


SELECT
    count(job_id),
    CASE
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    END AS location_category
From job_postings_fact
where job_title_short = 'Data Analyst'
GROUP BY location_category;


SELECT
    count(job_id),
    CASE
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    END AS location_category
From job_postings_fact
where job_title_short = 'Data Analyst'
GROUP BY location_category;



SELECT 
    job_title_short,
    salary_year_avg,
    CASE
        when salary_year_avg >=200000 then 'High Salary'
        when salary_year_avg between 100000 and 199999 then 'Standard Salary'
        else 'Low Salary'
    END AS salary_ranges
from job_postings_fact
WHERE job_title_short = 'Data Analyst' and salary_year_avg is not null
ORDER BY salary_year_avg DESC;


/*Subqueries and Common Table Expressions (CTEs)
used for organizing and simplifying complex queries
Subqueries are for simpler queries
CTEs are for more complex queries and defined first using the WITH statement */


--subquery example
SELECT 
    name AS company_name
FROM 
    company_dim
WHERE company_id in (
    SELECT 
        company_id
    FROM 
        job_postings_fact
    WHERE 
        job_no_degree_mention = true
);


select company_id, count(company_id) as total_jobs from job_postings_fact
GROUP BY company_id;


--same result as using CTE below
select c.name as company_name, count(j.company_id) as total_jobs
from company_dim c
Left join job_postings_fact j on c.company_id = j.company_id
GROUP BY company_name
ORDER BY total_jobs DESC;


--CTE example. used in select, inser, update or delete. From this you can always reference the upper temp. table
with company_job_count AS (  
    SELECT
        company_id,
        count(*) as total_jobs
    From
        job_postings_fact
    GROUP BY 
        company_id
)   --temp. table

SELECT
    company_dim.name as company_name,
    company_job_count.total_jobs
From    company_dim
Left join company_job_count on company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs DESC;



/* Question:
Identify the top 5 skills that are most frequently mentioned in job postings. 
Use a subquery to find the skill IDs with the highest counts in the skills_job_dim table 
and then join this result with the skills_dim table to get the skill names. */

--my solution:
SELECT 
    skills as skill_name
FROM 
    skills_dim
WHERE skill_id in (
    SELECT 
        skill_id   --in a subquery this must only be one column else error
    FROM 
        skills_job_dim
    GROUP BY skill_id
    Order by count(skill_id) DESC --can do your count in the order by statement
    Limit 5
);



/* Question:
Determine the size category ('Small', 'Medium', or 'Large') for each company 
by first identifying the number of job postings they have. 
Use a subquery to calculate the total job postings per company. 
A company is considered 'Small' if it has less than 10 job postings, 
'Medium' if the number of job postings is between 10 and 50, and 
'Large' if it has more than 50 job postings. 
Implement a subquery to aggregate job counts per company before classifying them based on size.*/

--my solution:
with company_category as (
    select company_id,
        CASE
            when count(job_title_short) > 50 then 'Large'
            when count(job_title_short) between 10 and 50 then 'Medium'
            else 'Small'
        END as company_size
    from job_postings_fact
    GROUP BY company_id
)

SELECT company_dim.name as company_name, company_category.company_size
from company_category
left join company_dim on company_category.company_id = company_dim.company_id
order by company_category.company_size ASC;




/* Question:
Find the count of the number of remote job postings per skill
 - Display the top 5 skills by their demand in remote jobs Include skill
 - Include ID, name, and count of postings requiring the skill 
  - only DA roles*/

--solution
With top_skills as (
    select 
        skill_id, 
        count(*) as number_of_posting
    from 
        job_postings_fact j 
    inner join 
        skills_job_dim sj on j.job_id = sj.job_id
    where 
        job_work_from_home = true and 
        job_title_short = 'Data Analyst'
    GROUP BY 
        skill_id
)

select 
    top_skills.skill_id as skill_id, 
    sd.skills as Skill_name, 
    top_skills.number_of_posting
from 
    skills_dim sd
inner join 
    top_skills on top_skills.skill_id = sd.skill_id
ORDER BY 
    number_of_posting DESC
Limit 5;


/* Unions are used to combine result of two or more select statements into a single result set
 - Union: removes duplicate rows
 - Union all: includes all duplicate rows
Each select statement within the union must have same no of columns in the result sets with similar dtypes 
row wise as against column wise for join*/


--UNION
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs



--union all (mostly used as we want duplicates)
SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    january_jobs

UNION all

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    february_jobs

UNION all

SELECT
    job_title_short,
    company_id,
    job_location
FROM 
    march_jobs



/* Question:
Find job postings from the first quarter that have a salary greater than $70K
 - Combine job posting tables from the first quarter of 2023 (Jan-Mar)
 - Gets job postings with an average yearly salary > $70,000
*/

SELECT 
    q1_job_postings.job_title_short,
    q1_job_postings.job_location,
    q1_job_postings.job_via,
    q1_job_postings.job_posted_date::date,
    q1_job_postings.salary_year_avg
FROM (
    SELECT * FROM january_jobs
UNION all
SELECT * FROM february_jobs
UNION all
SELECT * FROM march_jobs
) AS q1_job_postings
WHERE 
    q1_job_postings.salary_year_avg > 70000 and 
    q1_job_postings.job_title_short = 'Data Analyst'
ORDER BY 
    q1_job_postings.salary_year_avg DESC