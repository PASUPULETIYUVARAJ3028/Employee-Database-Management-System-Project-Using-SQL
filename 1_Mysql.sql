-- Project Name: "Employee Database Management System"

-- Step 1: Creating DB of Employee_DB_Management_System
CREATE DATABASE Employee_DB_Management_System;
USE Employee_DB_Management_System;


-- Step 2: CRUD Operations
-- Task 1: Create: Inserted sample records into the tables.
-- Task 2: Read: Retrieved and displayed data from various tables.
-- Task 3: Update: Updated records in the customer table.
-- Task 4: Delete: Removed records from the cusomter table as needed.

-- Task 1: Creating varies tables of "Employee Database Management System"
-- Table: departments
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

-- Table: Employees
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    hire_date DATE,
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Table: Performance_Reviews
CREATE TABLE Performance_Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    reviewer_id INT,
    review_date DATE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (reviewer_id) REFERENCES Employees(employee_id)
);
-- Table: Attendance
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    date DATE,
    status ENUM('Present', 'Absent', 'Leave'),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
-- Table: Projects
CREATE TABLE Projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE
);
-- Table: Employee_Projects
CREATE TABLE Employee_Projects (
    employee_id INT,
    project_id INT,
    role VARCHAR(100),
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);


-- Task 2: Read: Retrieved and displayed data from various tables.
-- Insert 'Departments' records
INSERT INTO Departments (department_name) VALUES
('Sales'),
('Research and Development'),
('Customer Support');
-- Insert 'Departments' records
INSERT INTO Employees (name, gender, hire_date, department_id, salary) VALUES
('Noah', 'Female', '2022-04-10', 6, 68282.25),
('Emma', 'Female', '2022-01-28', 5, 96617.93),
('Olivia', 'Female', '2021-04-30', 2, 50960.2);
-- Insert 'Performance_Reviews' records
INSERT INTO Performance_Reviews (employee_id, reviewer_id, review_date, rating, comments) VALUES
(27, 13, '2021-08-21', 4, 'Performance review 18'),
(28, 27, '2022-11-30', 5, 'Performance review 19'),
(17, 13, '2021-08-26', 2, 'Performance review 20');
-- Insert 'Performance_Reviews' records
INSERT INTO Attendance (employee_id, date, status) VALUES
(10, '2025-04-28', 'Leave'),
(7, '2025-04-22', 'Leave'),
(17, '2025-05-07', 'Absent');
-- Insert 'Performance_Reviews' records
INSERT INTO Projects (project_name, start_date, end_date) VALUES
('Horizon', '2024-02-10', '2024-12-08'),
('Eclipse', '2024-01-28', '2025-03-12'),
('Aurora', '2023-08-02', '2025-01-06');
-- Insert 'Employee_Projects' records
INSERT INTO Employee_Projects (employee_id, project_id, role) VALUES
(7, 22, 'Analyst'),
(6, 26, 'Manager'),
(8, 1, 'Team Lead');

-- Task 3: Update: Updated records in the customer table.    
UPDATE Employees 
SET 
	gender = 'male', hire_date = curdate()
WHERE
	employee_id = 1;

UPDATE Performance_Reviews 
SET 
	review_date = current_date() ,comments='excellent' 
WHERE 
	review_id = 15 and employee_id = 4;

-- Task 4: Delete: Removed records from the cusomter table as needed.

-- Step 1: Delete from Attendance
DELETE FROM Attendance WHERE employee_id = 1;

-- Step 2: Delete from Performance_Reviews (both as employee and reviewer)
DELETE FROM Performance_Reviews WHERE employee_id = 1 OR reviewer_id = 1;

-- Step 3: Delete from Employee_Projects
DELETE FROM Employee_Projects WHERE employee_id = 1;

-- Step 4: Now delete from Employees
DELETE FROM Employees WHERE employee_id = 1;


-- Step: Data Analysis

-- Task 5:   List all employees with their department names

SELECT 
    e.employee_id,
    e.name,
    d.department_name
FROM 
    employees AS e join Departments AS d
ON
    e.department_id = d.department_id;

-- Task 6. Count the number of employees in each department
SELECT 
    d.department_name,
    count(e.employee_id) AS 'No_of_Employees'
FROM 
    employees AS e join Departments AS d
ON
    e.department_id = d.department_id
GROUP BY
    d.department_name;

-- Task 7. Get average salary by department
SELECT 
    d.department_name,
    round(avg(e.salary),0) AS 'avg_salary'
FROM 
    employees AS e join Departments AS d
ON
    e.department_id = d.department_id
GROUP BY
    d.department_name;


-- Task 8. Find employees who have never received a performance review
SELECT 
    name
FROM employees
WHERE employee_id NOT IN (SELECT DISTINCT employee_id FROM Performance_Reviews);


-- Task 9.  Get the top 5 highest paid employees
SELECT * FROM Employees
ORDER BY salary DESC
LIMIT 5;


-- Task 10. Show employees working on more than 1 project
SELECT  
    employee_id,
    count(*) AS count_of_project
FROM
    Employee_Projects
GROUP BY 
    employee_id
HAVING 
    count_of_project > 1;


-- Task 11. List all employees with their latest performance review
SELECT
    e.employee_id,
    e.name,
    max(p.review_date) AS last_review_date,
    p.rating
    
FROM
    employees AS e JOIN Performance_Reviews AS p
    ON
    e.employee_id = p.employee_id
GROUP BY
    e.employee_id,
    e.name,
    p.rating
ORDER BY
   p.rating DESC;


-- Task 12. Get attendance summary (present/absent/leave) for each employee

SELECT
    e.employee_id,
    e.name,
    SUM(a.status = 'Present') AS count_Present,
    SUM(a.status = 'Leave') AS count_Leave,
    SUM(a.status = 'Absent') AS count_Absent
FROM  
    Employees AS e JOIN Attendance AS a
    ON
    e.employee_id = a.employee_id
GROUP BY
     e.employee_id,
     e.name;


-- Task 13. List employees who joined in the last 6 months
SELECT MAX(hire_date) FROM employees;
SELECT '2024-11-28' - INTERVAL 6 MONTH;

SELECT * FROM employees
WHERE hire_date >= (CURRENT_DATE - INTERVAL 6 MONTH);
   

-- Task 14. Find the department with the highest average salary
SELECT 
    d.department_name,
    round(avg(e.salary),0) AS avg_salary
FROM 
    employees AS e join Departments AS d
ON
    e.department_id = d.department_id
GROUP BY
    d.department_name
ORDER BY
    avg_salary DESC 
LIMIT 1;


-- Task 15: Show number of reviews each reviewer has conducted

SELECT 
    reviewer_id,
    count(*) AS reviews_given
FROM 
    Performance_Reviews
GROUP BY
     reviewer_id
ORDER BY
    reviews_given DESC;


-- Task 16: Get total number of employees in each gender
SELECT
    gender,
    COUNT(*) AS count
FROM
    Employees
GROUP BY
    gender;


-- Task 17: Get average rating received by each employee
SELECT
    e.employee_id,
    e.name,
    avg(p.rating) as avg_rating
    
FROM
    employees AS e JOIN Performance_Reviews AS p
    ON
    e.employee_id = p.employee_id
GROUP BY
    e.employee_id,
    e.name
ORDER BY
    avg_rating ASC;


-- Task 18: Show employee count for each project
SELECT  
    p.project_name,
    count(employee_id) as employee_count
FROM
    Employee_Projects AS ep JOIN Projects AS p
    ON
    ep.project_id = p.project_id
GROUP BY
    p.project_name
ORDER BY
    employee_count DESC;



-- Task 19: List employees assigned as 'Manager' in any project

SELECT
    e.employee_id,
    e.name,
    p.project_id,
    p.project_name

FROM
    Employees AS e JOIN Employee_Projects AS ep
    ON
    e.employee_id = ep.employee_id
    JOIN Projects p
    ON
    ep.project_id = p.project_id
WHERE
    ep.role = 'Manager';



-- Task 20: List all employees who are both reviewers and have been reviewed

SELECT DISTINCT e.name
FROM Employees e
WHERE e.employee_id IN (
    SELECT reviewer_id FROM Performance_Reviews
)
AND e.employee_id IN (
    SELECT employee_id FROM Performance_Reviews
);


-- Task 21: Find employees absent more than 5 times
SELECT
    e.employee_id,
    e.name,
    sum(a.status = 'Absent') AS count_Absent
FROM  
    Employees AS e JOIN Attendance AS a
    ON
    e.employee_id = a.employee_id

GROUP BY
     e.employee_id,
     e.name
     
HAVING
    count_Absent > 5;


-- Task 22: List employees and the number of projects they are involved in
SELECT 
     e.employee_id,
     e.name,
     count(ep.project_id) as count_of_project

FROM
    Employees AS e JOIN Employee_Projects AS ep
    ON
    e.employee_id = ep.employee_id
    
GROUP BY
    e.employee_id,
    e.name;


-- Task 23: Find projects that ended before today.
SELECT 
    project_name,
    end_date
FROM
    Projects
WHERE
     end_date < CURRENT_DATE;



-- Task 24: Show employee(s) with the maximum salary
SELECT 
    employee_id,
    name,
    ROUND(max(salary),0) AS high_salary
FROM 
    Employees
GROUP BY
    employee_id,
    name
ORDER BY
    high_salary DESC;


-- Step 3: Stored Procedure
-- Task 25: Get Employee Reviews

DELIMITER $$

CREATE PROCEDURE GetReviews(IN emp_id INT)
BEGIN
    SELECT * FROM Performance_Reviews WHERE employee_id = emp_id;
END $$

DELIMITER ;

call GetReviews(1);


-- Task 26: Get Employee details & attendence.
DELIMITER $$
CREATE PROCEDURE Get_employee_attendence(IN emp_id INT)
BEGIN

WITH get_Employee_attendence_detains as (
  SELECT
        e.employee_id,
        e.name,
        e.department_id,
        e.salary,
        SUM(a.status = 'Present') as count_Presnt,
        SUM(a.status = 'Leave') as count_Leave,
        SUM(a.status = 'Absent') as count_Absent
    FROM
        Employees AS e JOIN Attendance AS a
        ON
        e.employee_id = a.employee_id
    GROUP BY
        e.employee_id,
        e.name,
        e.department_id,
        e.salary  
)
select * from get_Employee_attendence_detains where employee_id = emp_id;

END $$
DELIMITER ;


CALL Get_employee_attendence(2);
CALL Get_employee_attendence(3);
CALL Get_employee_attendence(4);


-- Task 27: Get employee - id, name & department.

DELIMITER $$
CREATE PROCEDURE get_employee_department(IN emp_id INT)
BEGIN
WITH get_ed as (
SELECT 
    e.employee_id,
    e.name,
    d.department_name
FROM 
    employees AS e join Departments AS d

ON
    e.department_id = d.department_id
)
SELECT * FROM get_ed WHERE employee_id = emp_id;

END $$
DELIMITER ;

CALL get_employee_department(2);
CALL get_employee_department(3);
CALL get_employee_department(4);


-- Task 28: trigger: Insert Default Attendance on New Employee

DELIMITER $$

CREATE TRIGGER insert_attendance_after_employee
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Attendance(employee_id, date, status)
    VALUES (NEW.employee_id, CURDATE(), 'Present');
END $$

DELIMITER ;

select * from employees;
insert into employees values (40, 'baskar','male','2025-06-06',2,20000);

-- Step 4: views

-- Task 29: View: Get Summary of Average Salary by Department
CREATE VIEW get_avg_salary_department as (
SELECT 
    d.department_name,
    round(avg(e.salary),0) AS 'avg_salary'
FROM 
    employees AS e join Departments AS d
ON
    e.department_id = d.department_id
GROUP BY
    d.department_name
);

SELECT * FROM get_avg_salary_department;

-- Task 30: View: Get Summary of project Name along with no.of employees working in it.

CREATE VIEW pro_count_emp as (
    SELECT
    p.project_name,
    COUNT(ep.employee_id) AS employees_counts
FROM 
    Projects AS p JOIN Employee_Projects AS ep
    ON
    p.project_id = EP.project_id
GROUP BY
    p.project_name
ORDER BY
    employees_counts DESC
);

SELECT * FROM pro_count_emp;

-- Task 40: View: Get Summary of no.of employess working in each department.
CREATE VIEW department_count_employee AS (
    SELECT
    d.department_name,
    count(e.employee_id) AS employee_count
FROM
    Departments AS d JOIN Employees AS e
    ON
    d.department_id = e.department_id
GROUP BY
    d.department_name
ORDER BY
    employee_count DESC

);

SELECT * FROM department_count_employee;

-- Task 41:  Employee Summary Report with Attendance, Project Role, and Latest Performance Review using CTAS (COMMON TABLE AS SELECT)

CREATE TABLE employee_summary as (
    
SELECT
    e.employee_id,
    e.name,
    d.department_name,
  --  ep.project_id,
    p.project_name,
    ep.role,
    SUM(a.status = 'Present') AS count_Present,
    SUM(a.status = 'Leave') AS count_Leave,
    SUM(a.status = 'Absent') AS count_Absent,
    MAX(pr.review_date) AS lastest_review_date,
    pr.rating,
    e.salary

FROM
    Employees AS e JOIN Departments AS d ON e.department_id = d.department_id
    JOIN Employee_Projects AS ep ON e.employee_id = ep.employee_id
    JOIN Projects AS p ON ep.project_id = p.project_id
    JOIN Attendance AS A ON e.employee_id = a.employee_id 
    JOIN Performance_Reviews AS pr ON  e.employee_id = pr.employee_id

GROUP BY
    e.employee_id,
    e.name,
    d.department_name,
  --  ep.project_id,
    p.project_name,
    ep.role,
    pr.rating,
    e.salary
);

SELECT * FROM employee_summary;
select DISTINCT department_name from employee_summary;
SELECT * FROM employee_summary where department_name = 'Sales';
SELECT * FROM employee_summary where department_name = 'Research and Development';
SELECT * FROM employee_summary where department_name = 'Engineering';
SELECT * FROM employee_summary where department_name = 'Finance';

-- TASK 42: Top Earners in Each Department – Ranked Overview
SELECT 
    employee_id,
    name,
    department_name,
    salary,
   -- max(salary) as high_salary,
    RANK() OVER(
        PARTITION BY department_name
        ORDER BY salary DESC
    ) AS salary_ranking
FROM
    employee_summary
ORDER BY 
    salary_ranking ASC;







