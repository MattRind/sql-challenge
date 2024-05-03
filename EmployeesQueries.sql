-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, cast(s.salary as money)
FROM EmployeesT e
JOIN SalariesT s
ON (e.emp_no = s.emp_no);

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
CREATE VIEW employees_1986 AS
SELECT first_name, last_name, hire_date
FROM EmployeesT 
WHERE EXTRACT(year from hire_date) = 1986;

SELECT COUNT(*) FROM employees_1986
SELECT * FROM employees_1986;

-- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT  m.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM EmployeesT e
JOIN Dept_ManagerT m
ON (e.emp_no = m.emp_no)
JOIN DepartmentsT d
ON (m.dept_no = d.dept_no)
ORDER BY e.last_name ASC

-- Because the result of the query listing the manager of each department returned 24 different employees while there are only
-- 9 departments, the following query, by including the employee's title, shows that there are multiple managers in all departments
SELECT  m.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name, t.title
FROM EmployeesT e
JOIN Dept_ManagerT m
ON (e.emp_no = m.emp_no)
JOIN DepartmentsT d
ON (m.dept_no = d.dept_no)
JOIN TitlesT t
ON (t.title_id = e.emp_title_id)
ORDER BY d.dept_name ASC

-- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
CREATE VIEW employees_departments AS
SELECT  de.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM EmployeesT e
JOIN  Dept_EmpT de
ON (e.emp_no = de.emp_no)
JOIN DepartmentsT d
ON (de.dept_no = d.dept_no)

SELECT COUNT(*) FROM employees_departments; 
SELECT * FROM employees_departments

-- as a double check, determine whether the same emp.no is in more than one department:
-- output is 31579 records; 31579 = 331603 (rows in dept_emp.csv) - 300024 (rows in employees.csv)
-- therefore output verifies this.
SELECT e.emp_no, e.last_name, COUNT(e.emp_no) AS "frequency of emp no" 
FROM employees_departments e
GROUP BY e.emp_no, e.last_name
HAVING COUNT(e.emp_no) > 1
ORDER BY "frequency of emp no" DESC

-- randomly pick one emp_no to verify same employee is recorded in more than one dept. 
SELECT  de.dept_no, e.emp_no, e.last_name, e.first_name, e.birth_date, e.hire_date, d.dept_name
FROM EmployeesT e
JOIN  Dept_EmpT de
ON (e.emp_no = de.emp_no)
JOIN DepartmentsT d
ON (de.dept_no = d.dept_no)
WHERE e.emp_no = 39754

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM EmployeesT 
WHERE first_name = 'Hercules' AND LEFT(last_name, 1) = 'B'
ORDER BY last_name ASC;     -- this is added to visually check if anyone has same last name

-- 6. List each employee in the Sales department, including their employee number, last name, and first name.
CREATE VIEW sales_dept AS
SELECT emp_no, last_name, first_name, dept_name  -- query will work w/o selecting dept_name, but decide to show anyway
FROM employees_departments
WHERE dept_name = 'Sales'   -- alternatively, WHERE dept_no = "d007"

SELECT COUNT(*) FROM sales_dept; 
SELECT * FROM sales_dept

-- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
CREATE VIEW sales_devs_dept AS
SELECT emp_no, last_name, first_name, dept_name  
FROM employees_departments
WHERE dept_name = 'Sales' OR dept_name = 'Development'

SELECT COUNT(*) FROM sales_devs_dept; 
SELECT * FROM sales_devs_dept

-- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
SELECT last_name, COUNT(emp_no) AS "frequency of same last name"
FROM EmployeesT
GROUP BY last_name
ORDER BY "frequency of same last name" DESC

-- because there many employees with the same last name, created a query to check
-- how many employees have the same first and last name, and birth date. Believe it, there are 6.
-- this could mean a person was 'hired' more than once with gaps in employment
CREATE VIEW same_employee AS
SELECT first_name, last_name, birth_date, COUNT(emp_no) AS "frequency"
FROM EmployeesT
GROUP BY first_name, last_name, birth_date
HAVING COUNT(emp_no) > 1

SELECT * FROM same_employee
ORDER BY "frequency" DESC

-- Looked at 2 different employees. When someone is 'rehired' they get a new employee number:
SELECT  de.dept_no, e.emp_no, e.last_name, e.first_name, e.birth_date, e.hire_date, d.dept_name
FROM EmployeesT e
JOIN  Dept_EmpT de
ON (e.emp_no = de.emp_no)
JOIN DepartmentsT d
ON (de.dept_no = d.dept_no)
WHERE (first_name = 'Pragnesh' AND last_name = 'Acton') or (first_name = 'Shim' AND last_name = 'Gide')