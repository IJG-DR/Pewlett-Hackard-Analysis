-- MODULE 7.3.1 - Query Dates

-- Determine Retirement Elegibility
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Narrow the Search for Retirement Elegibility
-- Retirement elegibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Count the Queries
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create New Table
-- Export the list of retirement employees to a new table retirement_info
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info

-- MODULE 7.3.2 Join Tables

-- Recreate the retirement_info Table with the emp_no Column
DROP TABLE retirement_info;

-- Create new table for retiring employees and include emp_no column
-- so that it can be joined later
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Check the table
SELECT * FROM retirement_info;

-- MODULE 7.3.3 Joins in Action

-- Use Inner Join for Departments and dept_manager Tables

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Use Left Join to Capture retirement_info Table
-- Joining retirement_infor and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Using Aliases for Code Readability
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

-- Use Left Join for retirement_info and dept_emp tables and
-- store in a new table called current_emp
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_emp AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = '9999-01-01';

-- MODULE 7.3.4 Use Count, Group By, and Order By

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Perform the same select but now order the table by dept_no
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- SKILL DRILL - create a new table from the above select and export
-- the table as csv.
SELECT COUNT(ce.emp_no), de.dept_no
INTO emp_count_by_dep
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- MODULE 7.3.5 Create Additional Lists

-- List 1: Employee Information
-- Step 1: inspect the salaries table
SELECT * FROM salaries;

-- Sort dates in descending order.
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Test the code before generating the output table.
SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
    de.to_date
-- INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');

-- Generate List 1 and store it as emp_info table.
SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');
	 
-- LIST 2: Management
-- Test the query for the list of managers per department
SELECT dm.dept_no,
	   d.dept_name,
	   dm.emp_no,
	   ce.last_name,
	   ce.first_name,
       dm.from_date,
       dm.to_date
-- INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);

-- Generate the list and save it to a new table named manager_info	 
SELECT dm.dept_no,
	   d.dept_name,
	   dm.emp_no,
	   ce.last_name,
	   ce.first_name,
       dm.from_date,
       dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);

-- List 3: Department Retirees
-- Test the query
SELECT ce.emp_no,
	   ce.first_name,
	   ce.last_name,
	   d.dept_name
--INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

-- Generate the list and save it as a table named dept_info
SELECT ce.emp_no,
	   ce.first_name,
	   ce.last_name,
	   d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

-- MODULE 7.3.6 Create a Tailored List

-- Skill Drill: Create a query that will contain everything in the retirement_info table, only tailored for the Sales team.
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
	   d.dept_name
FROM retirement_info AS ri
	INNER JOIN dept_emp AS de
		ON (ri.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (d.dept_no = de.dept_no)
	WHERE (de.dept_no = 'd007');
	
-- Skill Drill: Create another query including both the Sales and Development teams.
SELECT ri.emp_no,
	   ri.first_name,
	   ri.last_name,
	   d.dept_name
FROM retirement_info AS ri
	INNER JOIN dept_emp AS de
		ON (ri.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (d.dept_no = de.dept_no)
	WHERE de.dept_no IN ('d007','d005');

