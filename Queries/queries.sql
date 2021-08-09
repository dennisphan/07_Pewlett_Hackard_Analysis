-- Retirement eligibility to table 'retirement_info'
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
	ON departments.dept_no = dept_manager.dept_no;

-- Joining employees to retire and their departments
SELECT ri.emp_no, ri.first_name, ri.last_name, de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
	ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT  de.dept_no, COUNT(ce.emp_no)
FROM current_emp as ce
LEFT JOIN dept_emp as de
	ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
INTO retire_emp_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
	ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- List of employee information
SELECT 	emp.emp_no, emp.first_name, emp.last_name, emp.gender,
		sal.salary,
		dep.to_date
FROM employees AS emp
INNER JOIN salaries AS sal
	ON emp.emp_no = sal.emp_no
INNER JOIN dept_emp AS dep
	ON emp.emp_no = dep.emp_no
WHERE (emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     	AND (emp.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
		AND (dep.to_date = '9999-01-01')
ORDER BY emp.emp_no;

-- List of managers per department
SELECT  dm.dept_no,
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
		
-- Retirees by departments
SELECT 	ce.emp_no, ce.first_name, ce.last_name,
		d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
	ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no = d.dept_no);

SELECT * FROM dept_info;

-- Employees in Sales and Product departments
SELECT 	dep.dept_name, 
		emp.emp_no, emp.first_name, emp.last_name
FROM employees AS emp
INNER JOIN dept_emp AS de
	ON emp.emp_no = de.emp_no
INNER JOIN departments AS dep
	ON de.dept_no = dep.dept_no
WHERE dep.dept_name IN ('Sales', 'Production')
ORDER BY dep.dept_name;

