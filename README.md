# Pewlett Hackard Analysis

## Project Overview

Pewlett Hackard, a long standing company with several thousand employees, has requested our assistance in analyzing several plans involving retirement as some of its *"baby boomer"* employees reach retirement age, and identify the resulting job openings this would create. Pewlett Hackard plans to offer a retirement package to employees that meet certain age criteria, as well as a mentorship program where some of these retiring employees can train the next generation. 


## Methodology

The employee data was provided in six csv files, each contaning relevant information. These files are included in the *Data* folder of this repository, and are identified as:

* *current_emp.csv*
* *departments.csv*
* *dept_emp.csv*
* *employees.csv*
* *salaries.csv*
* *titles.csv*

We were asked to perform our analysis in SQL, to improve the robustness of the information for future use by the H.R. Department. To do this, we first mapped the schema for the data tables contained in each csv file into an *ERD* in order to identify the primary and foreign keys. 

![Database Schema ERD](Resources/EmployeeDB.png)

Then, we imported the tables into an *SQL* database using *pgAdmin* and *PostgreSQL*, and used the query tools provided by these platforms to perform a series of queries, join different tables, produce new tables and summarize the results in additional csv files.

## Results

Provide a bulleted list with four major points from the two analysis deliverables. Use images as support where needed

### Number of Retiring Employees by Title

![Number of Retiring Employees by Title]

The data was saved to a new table as *retiring_titles.csv*.

### Employees Eligible for Mentorship Program

![Employees Eligible for Mentorship Program]

In performing the suggested methodology for extracting the list of employees eligible for the mentorship program, we noticed that it was not querying the most current title for some employees. This was because the *from_date* in the Department Employee table (**) on which the sort order was being made in conjunction with the DISTINCT ON () function only captured part of the current employees information. It did capture its current department, but if the employee had been promoted after joining the department, that employees current title was not being necessarily queried. Instead, we based our sort on the from_date field in the Titles tabke (*titles.csv*) to get the most current title. The SQL query code used was as follows:

![Corrected Query Code for Employee Titles](Resources/Correct_title_code.png)

And to confirm that it was correctly selecting the most current title, we queried several employees to confirm our results. The example below is for employee Lech Himler, which appears with the incorrect title on the table presented in the rubric.

![Employee Lech Himler title history](Resources/Correct_title_sample.png)

The corrected data was saved to a new table as mentorship_eligibility.csv.

## Summary

Provide high-level responses to the following questions, then provide two additional queries or tables that may provide more insight into the upcoming "silver tsunami."

*How many roles will need to be filled as the "silver tsunami" begins to make an impact?

*Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees?

