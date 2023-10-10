CREATE TABLE jobs(
    job_id INT,
    job_title VARCHAR2(50),
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2)
    );

CREATE TABLE employees(
    employee_id INT,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    email VARCHAR2(255),
    phone_number VARCHAR2(15),
    hire_date DATE,
    job_id INT,
    salary DECIMAL(10,2),
    commision_pct DECIMAL(10,2),
    manager_id INT,
    department_id INT
    );

CREATE TABLE job_history(
    employee_id INT,
    start_date DATE,
    end_date DATE,
    job_id INT,
    department_id INT
    );
    
CREATE TABLE departments(
    department_id INT,
    department_name VARCHAR2(50),
    manager_id INT,
    location_id INT
    );
    
CREATE TABLE regions(
    region_id INT,
    region_name VARCHAR2(50)
    );

CREATE TABLE countries(
    country_id INT,
    country_name VARCHAR2(50),
    region_id INT
    );
    
CREATE TABLE locations(
    location_id INT,
    street_address VARCHAR2(50),
    postal_code VARCHAR2(10),
    city VARCHAR2(200),
    state_province VARCHAR2(50),
    country_id INT
    );

ALTER TABLE jobs
    ADD PRIMARY KEY(job_id)
    ADD CHECK(min_salary<(max_salary-2000));

ALTER TABLE employees
    ADD PRIMARY KEY(employee_id);
    
ALTER TABLE job_history
    ADD PRIMARY KEY(employee_id, start_date);
    
ALTER TABLE departments
    ADD PRIMARY KEY(department_id);
    
ALTER TABLE regions
    ADD PRIMARY KEY(region_id);
    
ALTER TABLE countries
    ADD PRIMARY KEY(country_id);
    
ALTER TABLE locations
    ADD PRIMARY KEY(location_id);

ALTER TABLE employees
    ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id)
    ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id)
    ADD FOREIGN KEY(department_id) REFERENCES departments(department_id);

ALTER TABLE job_history
    ADD FOREIGN KEY(employee_id) REFERENCES employees(employee_id)
    ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id)
    ADD FOREIGN KEY(department_id) REFERENCES departments(department_id);

ALTER TABLE departments
    ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id)
    ADD FOREIGN KEY(location_id) REFERENCES locations(location_id);

ALTER TABLE countries
    ADD FOREIGN KEY(region_id) REFERENCES regions(region_id);

ALTER TABLE locations
    ADD FOREIGN KEY(country_id) REFERENCES countries(country_id);


DROP TABLE job_history;

FLASHBACK TABLE job_history TO BEFORE DROP;


