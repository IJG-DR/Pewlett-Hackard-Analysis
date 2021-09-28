-- MODULE 7 Challenge

-- Deliverable 1: Number of Retiring Employees by Title

-- Part 1: create query for retiring employees by title
-- and save to a new table named retirement_titles
SELECT e.emp_no,
       e.first_name,
       e.last_name,
       t.title,
       t.from_date,
       t.to_date
INTO retirement_titles
FROM employees AS e
    INNER JOIN titles AS t
    	ON (e.emp_no = t.emp_no)
	WHERE (e.birth_date >= '1952-01-01') 
		AND (e.birth_date <= '1955-12-31')
	ORDER BY e.emp_no;
	
-- Part 2: Use Dictinct with Orderby to remove duplicate 
-- rows and save table as unique_titles
SELECT DISTINCT ON (emp_no) emp_no, 
	   			   first_name,
	               last_name,
	               title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Part 3: retrieve the number of employees by their
-- most recent job title who are about to retire
SELECT COUNT(title), title 
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

-- Deliverable 2: The Employees Eligible for the
-- Mentorship Program

SELECT DISTINCT ON (e.emp_no)
	   e.emp_no,
	   e.first_name,
	   e.last_name,
	   e.birth_date,
	   de.from_date,
	   de.to_date,
	   t.title
INTO mentorship_eligibility
FROM employees AS e
	INNER JOIN dept_emp AS de
		ON e.emp_no = de.emp_no
	INNER JOIN titles AS t
		ON e.emp_no = t.emp_no
	WHERE (de.to_date = '9999-01-01') 
	AND (e.birth_date >= '1965-01-01')
	AND (e.birth_date <= '1965-12-31')
-- Add the from_date from the titles table in descending order
-- to ensure that the query includes the most recent title
ORDER BY e.emp_no, t.from_date DESC;

-- Check to see if title for some employees is correct (i.e., their
-- most recent title.)
SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   e.birth_date,
	   t.from_date,
	   t.to_date,
	   s.salary,
	   de.dept_no,
	   t.title
FROM employees AS e
	INNER JOIN dept_emp AS de
		ON e.emp_no = de.emp_no
	INNER JOIN titles AS t
		ON e.emp_no = t.emp_no
	INNER JOIN salaries AS s
		ON e.emp_no = s.emp_no
	WHERE (first_name = 'Lech')
	AND (last_name = 'Himler');

-- From the above code, Lech Himler's most recent title
-- should be "Senior Staff". Running the same code on employee
-- Keiichiro Glinert shows his most recent title is "Senior Engineer"
	
-- EXTRA: Create a summary table organized by department and title, showing total
-- employee count, retiring employee count and mentoring employee count.
	
-- Prepare a table with all employees showing current title and current deptarment name
-- and save it in new table named employees_dep_title
SELECT DISTINCT ON (e.emp_no)
	   d.dept_name,
	   t.title,
	   e.emp_no
INTO employees_dep_title
FROM employees AS e
	INNER JOIN titles as t
		ON (e.emp_no = t.emp_no)
	INNER JOIN dept_emp AS de
		ON (de.emp_no = e.emp_no)
	INNER JOIN departments AS d
		ON (d.dept_no = de.dept_no)			
ORDER BY e.emp_no, de.from_date DESC, t.from_date DESC;

-- Use the previous table to create a summary count by department name and title
-- and save it as summary_dept_title_count
SELECT dept_name,
	   title,
	   COUNT (emp_no)
INTO summary_dept_title_count
FROM employees_dep_title
GROUP BY dept_name, title
ORDER BY dept_name, title;

-- Repurpose the code to obtain a similar table for retiring employees
SELECT DISTINCT ON (rt.emp_no)
	   d.dept_name,
	   rt.title,
	   rt.emp_no
INTO retiring_dept_title
FROM retirement_titles AS rt
	INNER JOIN dept_emp AS de
		ON (de.emp_no = rt.emp_no)
	INNER JOIN departments AS d
		ON (d.dept_no = de.dept_no)
ORDER BY rt.emp_no, de.from_date DESC, rt.from_date DESC;

-- Use the previous table to create a summary count by department name and title
-- and save it as summary_ret_dept_title_count
SELECT dept_name,
	   title,
	   COUNT (emp_no)
INTO summary_ret_dept_title_count
FROM retiring_dept_title
GROUP BY dept_name, title
ORDER BY dept_name, title;


-- Repurpose the code to obtain a similar table for mentorship employees
SELECT DISTINCT ON (me.emp_no)
	   d.dept_name,
	   me.title,
	   me.emp_no
INTO mentorship_dept_title
FROM mentorship_eligibility AS me
	INNER JOIN dept_emp AS de
		ON (de.emp_no = me.emp_no)
	INNER JOIN departments AS d
		ON (d.dept_no = de.dept_no)
ORDER BY me.emp_no, de.from_date DESC, me.from_date DESC;

-- Use the previous table to create a summary count by department name and title
-- and save it as summary_ment_dept_title_count
SELECT dept_name,
	   title,
	   COUNT (emp_no)
INTO summary_ment_dept_title_count
FROM mentorship_dept_title
GROUP BY dept_name, title
ORDER BY dept_name, title;

-- Combine all three summary tables to get by department and title counts
-- for all employees, retiring employees and mentorship employees and
-- save it as grand_summary.
SELECT sd.dept_name,
	   sd.title,
	   sd.count AS Total_Employee_Count,
	   sret.count AS Total_Retiring_Count,
	   sment.count AS Total_Mentoring_Count
INTO grand_summary
FROM summary_dept_title_count AS sd
	LEFT JOIN summary_ret_dept_title_count AS sret
		ON (sret.dept_name = sd.dept_name AND sret.title = sd.title)
	LEFT JOIN summary_ment_dept_title_count AS sment
		ON (sment.dept_name = sret.dept_name AND sment.title = sd.title)
ORDER BY sd.dept_name, sd.title;