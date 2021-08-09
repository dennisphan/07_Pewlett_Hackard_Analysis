-- DELIVERABLE 1
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) *
INTO distinct_title
FROM titles
ORDER BY emp_no, to_date DESC;

-- List of retirees by titles
SELECT 	emp.emp_no, emp.first_name, emp.last_name,
		dti.title
INTO unique_titles
FROM employees AS emp
INNER JOIN distinct_title AS dti
	ON emp.emp_no = dti.emp_no
WHERE emp.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY emp.emp_no;

-- Number of retirees by titles
SELECT title, COUNT (title) AS retirees
INTO retiring_titles
FROM unique_titles 
GROUP BY title
ORDER BY COUNT(title);

-- DELIVERABLE 2
-- List of employees eligibled as mentors
SELECT 	emp.emp_no, emp.first_name, emp.last_name, emp.birth_date,
		de.from_date, de.to_date,
		dti.title
INTO mentorship_eligibilty
FROM employees AS emp
INNER JOIN distinct_title AS dti
	ON emp.emp_no = dti.emp_no
INNER JOIN dept_emp AS de
	ON emp.emp_no = de.emp_no
WHERE 	(de.to_date = '9999-01-01') 
		AND (emp.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp.emp_no;

-- Number of eligible mentors by titles
SELECT title, COUNT (title) AS mentors
INTO mentors_titles
FROM mentorship_eligibilty
GROUP BY title;

-- DELIVERABLE 3
-- Number of retirees by title and age
SELECT 	uti.title, 
		date_part('year', age('2018-01-01', emp.birth_date)) AS Current_Age,
		COUNT(date_part('year', emp.birth_date)) AS quantity
INTO retirees_title_age
FROM unique_titles AS uti
INNER JOIN employees AS emp
	ON uti.emp_no = emp.emp_no
GROUP BY 1, 2
ORDER BY 1, 2;

-- Number of mentors vs. candidates for potential empty roles
SELECT 	rti.title, rti.retirees AS candidates, mti.mentors,
		rti.retirees/mti.mentors AS "candidates per mentor"
FROM retiring_titles AS rti
LEFT JOIN mentors_titles AS mti
	ON rti.title = mti.title
GROUP BY rti.title, rti.retirees, mti.mentors
ORDER BY rti.retirees;

-- Number of candidates per mentor by year
SELECT 	rta.title, 
		rta.Current_Age + 1955 AS "Year",
		rta.quantity AS candidates,
		mti.mentors,
		rta.quantity/mti.mentors AS "Candidates per mentor"
FROM retirees_title_age AS rta
LEFT JOIN mentors_titles AS mti
	ON rta.title = mti.title
GROUP BY 1, 2, 3, 4, 5
ORDER BY 1, 2;

