/*
Question: What are the top skills based on salary?
 - Look at the average salary associated with each skill for Data Analyst positions
 - Focuses on roles with specified salaries, regardless of location
 - Why? It reveals how different skills impact salary levels for Data Analysts 
   and helps identify the most financially rewarding skills to acquire or improve
*/

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
LIMIT 25





/*
Analysis revealed the following:
• High Demand for Big Data & ML Skills: 
        Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), 
        machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), 
        reflecting the industry's high valuation of data processing and predictive modeling capabilities.
• Software Development & Deployment Proficiency: 
        Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) 
        indicates a lucrative crossover between data analysis and engineering, 
        with a premium on skills that facilitate automation and efficient data pipeline management.
• Cloud Computing Expertise: 
        Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) 
        underscores the growing importance of cloud-based analytics environments, 
        suggesting that cloud proficiency significantly boosts earning potential in data analytics.


JSON File of result
[
  {
    "skill_name": "pyspark",
    "count_of_skill": "2",
    "salary_average": "208172"
  },
  {
    "skill_name": "bitbucket",
    "count_of_skill": "2",
    "salary_average": "189155"
  },
  {
    "skill_name": "couchbase",
    "count_of_skill": "1",
    "salary_average": "160515"
  },
  {
    "skill_name": "watson",
    "count_of_skill": "1",
    "salary_average": "160515"
  },
  {
    "skill_name": "datarobot",
    "count_of_skill": "1",
    "salary_average": "155486"
  },
  {
    "skill_name": "gitlab",
    "count_of_skill": "3",
    "salary_average": "154500"
  },
  {
    "skill_name": "swift",
    "count_of_skill": "2",
    "salary_average": "153750"
  },
  {
    "skill_name": "jupyter",
    "count_of_skill": "3",
    "salary_average": "152777"
  },
  {
    "skill_name": "pandas",
    "count_of_skill": "9",
    "salary_average": "151821"
  },
  {
    "skill_name": "elasticsearch",
    "count_of_skill": "1",
    "salary_average": "145000"
  },
  {
    "skill_name": "golang",
    "count_of_skill": "1",
    "salary_average": "145000"
  },
  {
    "skill_name": "numpy",
    "count_of_skill": "5",
    "salary_average": "143513"
  },
  {
    "skill_name": "databricks",
    "count_of_skill": "10",
    "salary_average": "141907"
  },
  {
    "skill_name": "linux",
    "count_of_skill": "2",
    "salary_average": "136508"
  },
  {
    "skill_name": "kubernetes",
    "count_of_skill": "2",
    "salary_average": "132500"
  },
  {
    "skill_name": "atlassian",
    "count_of_skill": "5",
    "salary_average": "131162"
  },
  {
    "skill_name": "twilio",
    "count_of_skill": "1",
    "salary_average": "127000"
  },
  {
    "skill_name": "airflow",
    "count_of_skill": "5",
    "salary_average": "126103"
  },
  {
    "skill_name": "scikit-learn",
    "count_of_skill": "2",
    "salary_average": "125781"
  },
  {
    "skill_name": "jenkins",
    "count_of_skill": "3",
    "salary_average": "125436"
  },
  {
    "skill_name": "notion",
    "count_of_skill": "1",
    "salary_average": "125000"
  },
  {
    "skill_name": "scala",
    "count_of_skill": "5",
    "salary_average": "124903"
  },
  {
    "skill_name": "postgresql",
    "count_of_skill": "4",
    "salary_average": "123879"
  },
  {
    "skill_name": "gcp",
    "count_of_skill": "3",
    "salary_average": "122500"
  },
  {
    "skill_name": "microstrategy",
    "count_of_skill": "2",
    "salary_average": "121619"
  }
]*/