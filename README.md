# Introduction
 📊 Analysis into job market data! 
 This analysis focuses on Data Analyst roles and explores insights such as:
 - Top paying jobs 💰
 - In-demand skills 🔥
 - High demand and high salary meeting points 📈  

🔎 SQL queries can be found on the [project_sql](/Project_sql/) folder


# Background
This analysis is driven by my interest in Data analysis using SQL for database manipulation, and a quest to navigate the data analyst job market more effectively by understanding salary expectaitions and skills required. This project aims at pinpointing top-paid and in-demand skills from the provided dataset.  
🗂️ Data for the project can be found on the [sqlliteviz website](https://sqliteviz.com/app/#/workspace?hide_schema=1:~:text=Search%20table-,jobs_2023,-company_dim) linked from Luke Barousse's [SQL Course](https://lukebarousse.com/sql).  
It is packed with tables and columns as listed below:
| **job_postings_fact table**| **company_dimension table** | **skills_job_dimension table** | **skills_dimension table** |
|----------------------------|-----------------------|---------------------|----------------|
| job_id                     | company_id            | index               | index          |
| company_id                 | name                  | job_id              | skill_id       |
| job_title_short            | link                  | skill_id            | skills         |
| job_title                  | link_google           |                     | type           |
| job_location               | thumbnail             |                     |                |
| job_via                    |                       |                     |                |
| job_schedule_type          |                       |                     |                |
| job_work_from_home         |                       |                     |                |
| search_location            |                       |                     |                |
| job_posted_date            |                       |                     |                |
| job_no_degree_mention      |                       |                     |                |
| job_health_insurance       |                       |                     |                |
| job_country                |                       |                     |                |
| salary_rate                |                       |                     |                |
| salary_year_avg            |                       |                     |                |
| salary_hour_avg            |                       |                     |                |



### The questions I sought to answer in this analysis included:
1. What are the top-paying jobs for my role? Data analyst in my case
2. What are the skills required for these top-paying roles?
3. What are the most in-demand skills for my role?
4. What are the top skills based on salary for my role?
5. What are the most optimal skills to learn?

# Tools Used
For a concise deep dive into the Data Analysis job Market, I harnessed the power of the below key tools:
- ![SQL database](image.png) **SQL**: This was the backbone of my analysis. Allowing me to query and modify the database for accurate and concise analysis.
- ![PostgreSQL](/output-onlinepngtools.png) **PostgreSQL (PGAdmin)**: This was my chosen database management system. This was chosen due to its ease of use and integration.
- ![VS code](VS_code.png) **Visual Studio Code**: My goto IDE for writing and executing SQL queries.
- ![Git](image-1.png) **Git & Github**: Eseential tool for Version control and sharing my SQL scripts and analysis results. It ensure for collaboration and project tracking. 

# The Analysis
Each Query for this project is aimed at investigating specific aspects of the Data Analyst job market.
The Analysis centered around Data Analyst roles and Remote opportunities.

### 1. Top-paying jobs for Data Analyst roles:
- This query was designed to identify the highest-paying job titles within the Data Analyst field. The goal is to help understand which specific roles or industries offer the most competitive salaries for data analysts. The Query used to answer this question can be found [Here](/Project_sql/1_top_paying_job.sql), and highlighted below.

```sql
SELECT
    name as Company_name,
    job_title,
    job_id,
    salary_year_avg,
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
```

The query revealed that top paying remote Data analyst jobs are from companies like Meta, AT&T, Mantys, etc.
The salary ranges from $184k - $650k with titles such as Director of Analytis, Director of Data insights, etc.  

| Company Name                          | Job Title                                   | Salary (Year Avg) |
|---------------------------------------|---------------------------------------------|--------------------|
| Mantys                                | Data Analyst                                | 650000.0          |
| Meta                                  | Director of Analytics                       | 336500.0          |
| AT&T                                  | Associate Director- Data Insights           | 255829.5          |
| Pinterest Job Advertisements          | Data Analyst, Marketing                     | 232423.0          |
| Uclahealthcareers                      | Data Analyst (Hybrid/Remote)                | 217000.0          |
| SmartAsset                            | Principal Data Analyst (Remote)             | 205000.0          |
| Inclusively                           | Director, Data Analyst - HYBRID             | 189309.0          |
| Motional                              | Principal Data Analyst, AV Performance      | 189000.0          |
| SmartAsset                            | Principal Data Analyst                      | 186000.0          |
| Get It Recruit - Information Technology | ERM Data Analyst                          | 184000.0          | 
*Table showing top paying Remote Data Analyst jobs for 2023*



### 2. Skills required for top-paying roles:
- This analysis seeks to pinpoint the key skills associated with the highest-paying data analyst positions. The aim is to identify which technical skills contribute to earning higher salaries in the field. The Query used to answer this question can be found [HERE](/Project_sql/2_top_paying_job_skills.sql) and  highlighted below.

```sql
WITH top_job AS (
    SELECT
    name as Company_name,
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
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
Limit 10
)

SELECT
    top_job.job_title,
    top_job.job_location,
    top_job.job_schedule_type,
    top_job.salary_year_avg,
    sd.skills as skill_name
From skills_job_dim sj 
inner join top_job on sj.job_id = top_job.job_id
inner join skills_dim sd on sj.skill_id = sd.skill_id
;
```

This Query revealed that the top skills for high paying Data Analyst rolesinclude SQL, Python, Tableau and R, amongst others.  
  

![Skills for Top Paying roles](<Project_sql/Assets/2_top_paying_roles_skills.png>)  
*Chart showing the top skills for high paying Data Analyst roles. Chart was created by ChatGPT*

### 3. Most in-demand skills for Data Analysts:
- The objective here is to discover the skills most frequently required in job postings for data analysts. This analysis helps to reveal the most sought-after qualifications for anyone looking to stay competitive in the job market. The Query used to answer this question can be found [HERE](/Project_sql/3_top_demand_skills_DA.sql) and highlighted below.

```sql
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
```
Query revealed that the most in-deman skills for Data analyst roles include SQL, Excel, Python, Tableau and PowerBI.  
For roles in Estonia, the most in-deman skills for Data analyst roles include SQL, Python, Tableau, Excel and Looker.  


The following table summarizes the count of skills identified in the dataset:

| Skill Name   | Count of Skills |
|--------------|-----------------|
| SQL          | 92,628          |
| Excel        | 67,031          |
| Python       | 57,326          |
| Tableau      | 46,554          |
| Power BI     | 39,468          |
| R            | 30,075          |
| SAS          | 28,068          |
| PowerPoint   | 13,848          |
| Word         | 13,591          |
| SAP          | 11,297          |  

*In-demands skills for Data Analysts*  


The following table summarizes the count of skills identified in Estonia:

| Skill Name   | Count of Skills |
|--------------|-----------------|
| SQL          | 87              |
| Python       | 46              |
| Tableau      | 35              |
| Excel        | 31              |
| Looker       | 23              |
| R            | 21              |
| Power BI     | 20              |
| SAS          | 14              |
| Go           | 13              |
| Airflow      | 8               |     

*In-demands skills for Data Analysts in Estonia*    

### 4. Top skills based on salary:
- This analysis focuses on understanding which skills correlate with higher salaries. It provides insight into which specific capabilities are valued more by employers, linking them to better compensation. The Query used to answer this question can be found [HERE](/Project_sql/4_top_paying_skills.sql) and highlighted below.

```sql
select 
    skills as skill_name,
    count(skills) count_of_skill,
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
    sd.skills
ORDER BY 
    salary_average DESC
LIMIT 25;
```

Analysis shows that there is large potential for Big Query (PySpark, Couchbase), ML skills (DataRobot, Jupyter), and python Libraries (Pandas, NumPy).  
Knowledge in development and deplyment tools has high potential for jobs (GitLab, Kubernetes, Airflow).  
Also Cloud computing is an essential skill for high opaying Data Analyst roles.  

| Skill Name     | Average Salary |
|----------------|----------------|
| PySpark        | $208,172       |
| Bitbucket      | $189,155       |
| Couchbase      | $160,515       |
| Watson         | $160,515       |
| DataRobot      | $155,486       |
| GitLab         | $154,500       |
| Swift          | $153,750       |
| Jupyter        | $152,777       |
| Pandas         | $151,821       |
| Elasticsearch  | $145,000       |
| Golang         | $145,000       |
| NumPy          | $143,513       |
| Databricks     | $141,907       |
| Linux          | $136,508       |
| Kubernetes     | $132,500       |


### 5. Most optimal skills to learn:
- The final question aims to combine the results from the previous analyses to determine the best skills to invest time in learning. The idea is to identify skills that are both in demand and highly paid, making them the most strategic to learn for career advancement. The Query used to answer this question can be found [HERE](/Project_sql/5_optimal_skill.sql) and highlighted below.

```sql
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
```

Each query is about combining demand, salary, and relevance of skills to help make informed decisions regarding career development as a Data Analyst. The breakdown is as follows:
- **Wide Salary Range**: Top 10 paying data analyst roles span from $184,000 to $650,000, indicating significant salary potential in the field.
- **Diverse Employers**: Companies like SmartAsset, Meta, and AT&T are among those offering high salaries, showing a broad interest across different industries.
- **Job Title Variety**: There's a high diversity in job titles, from Data Analyst to Director of Analytics, reflecting varied roles and specializations within data analytics.

 # Key Takeaway from Project
 This project helped me hone my SQL querying skills for database retrieval and Manipulation.  
 I have been able to add to my toolkit the following SQL superpowers:
 - **CTEs and Subqueries**: I mastered the are of using Common Table Expressions (CTEs) and subqueries, which helped me enhance the clarity and efficiency of my SQL queries. By leveraging CTEs, I was able to organize complex logic into more manageable parts, making my analysis easier to understand. The ability to embed subqueries also allowed me to perform sophisticated data retrievals seamlessly, resulting in more insightful outcomes from the datasets I worked with. 🐐
 - **Data Aggregation Functions**: During this project, I deepened my understanding of data aggregation functions, which are essential for summarizing and analyzing information effectively. By applying functions like COUNT, AVG, and SUM, using Groupby statements, I was able to distill large volumes of data into meaningful metrics that highlighted key trends. This skill not only streamlined my analysis but also empowered me to present clearer insights that inform decision-making. 🏋️‍♂️
 - **Analytics Superpower**: I developed my "analytics superpower" by embracing advanced analytical techniques and tools on real life data. This experience allowed me to uncover deeper insights from the data, revealing patterns that were not immediately apparent and work on ways for effective story telling to non technical stakeholders. 💪


 # Conclusions
### Insights from the Analysis include:
 1. Analysis to question 1 highlights some of the top-paying roles for Data Analysts, showcasing the companies, specific job titles, and average annual salaries. The roles vary in specialization, with titles such as "Director of Analytics," "Principal Data Analyst," and more entry-level positions like "Data Analyst." Notably, positions at companies like Mantys, Meta, and AT&T offer some of the highest salaries, which aligns with the trend that high-level or niche data analytics roles, often requiring specialized expertise, tend to command higher pay.
Additionally, for data professionals looking to maximize earnings, this data suggests that pursuing advanced, director-level analytics roles or focusing on high-demand skills like marketing analysis or performance analysis could be beneficial.

 2. High paying jobs require advanced proficiency in SQL, Python and Tableau. High paying roles also require understanding of cetain Libraries like Pandas. This is beneficial for individuals looking to go into Analyst roles to understand the skills required to get in and progress along the career ladder.
 3. The analysis of skills and salaries reveals distinct differences between the global data and that of Estonia. Globally, SQL is the most sought-after skill, with 92,628 listings and an average salary of $96,435, followed closely by Python, which commands the highest average salary at $101,511.8. This indicates a strong correlation between skill demand and earning potential in various data-related fields.  
 In contrast, Estonia shows a smaller market with SQL again leading, but with a lower average salary of $88,160. The presence of niche skills like Looker and Go suggests a developing landscape.
 4. The data reveals a strong demand for specialized technical skills, with PySpark leading the way at an impressive average salary of $208,172. This highlights the premium placed on advanced data processing capabilities in the industry. Following closely are Bitbucket and Couchbase, with average salaries of $189,155 and $160,515, respectively. Such figures suggest that expertise in version control and database management is also highly valued in today’s tech landscape.  
 Moreover, skills like Pandas and Databricks show competitive average salaries of around $151,821 and $141,907, reflecting their integral role in data science and analytics. This analysis indicates that while niche skills can yield higher compensation, there remains significant earning potential for commonly utilized technologies, underlining the importance of both specialized and versatile skill sets in career development for Data Analysts.
