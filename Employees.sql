
CREATE TABLE TitlesT (
    title_id VARCHAR(30)   NOT NULL,
    title VARCHAR(255)   NOT NULL,
    CONSTRAINT pk_TitlesT PRIMARY KEY (
        title_id
     )
);

CREATE TABLE EmployeesT (
    emp_no INTEGER   NOT NULL,
    emp_title_id VARCHAR(30)   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR(255)   NOT NULL,
    last_name VARCHAR(255)   NOT NULL,
    sex VARCHAR(10)   NOT NULL,
    hire_date DATE   NOT NULL,
    FOREIGN KEY(emp_title_id) REFERENCES TitlesT(title_id),
    CONSTRAINT pk_EmployeesT PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE SalariesT (
    emp_no INTEGER   NOT NULL,
    salary INTEGER   NOT NULL, 
    FOREIGN KEY(emp_no) REFERENCES EmployeesT(emp_no)
);

CREATE TABLE DepartmentsT (
    dept_no VARCHAR(30)   NOT NULL,
    dept_name VARCHAR(255)   NOT NULL,
    CONSTRAINT pk_DepartmentsT PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE Dept_EmpT (  
    emp_no INTEGER   NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES EmployeesT(emp_no),
    dept_no VARCHAR(30)   NOT NULL,
    FOREIGN KEY (dept_no) REFERENCES DepartmentsT(dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE Dept_ManagerT (
    dept_no VARCHAR(30)   NOT NULL,
    FOREIGN KEY (dept_no) REFERENCES DepartmentsT(dept_no),
    emp_no INTEGER   NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES EmployeesT(emp_no),
    PRIMARY KEY (dept_no, emp_no)
);

-- verify the data is populated from the .csv file in each newly created table --

select * from EmployeesT

select * from TitlesT

select * from SalariesT

select * from DepartmentsT

select * from Dept_EmpT

select * from Dept_ManagerT 