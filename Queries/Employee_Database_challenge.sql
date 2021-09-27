-- MODULE 7 Challenge

-- DELIVERABLE 1: Number of Retiring Employees by Title

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

-- DELIVERABLE 2: The Employees Eligible for the
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

-- Check to see if title for some employees is 
-- correct (i.e., their most recent title.)
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