--zadanie 1 i 2

DECLARE
    nazwa departments.department_name%TYPE := 'EDUCATION';
    numer_max departments.department_id%TYPE;
BEGIN
    SELECT MAX(DEPARTMENT_ID) INTO numer_max FROM DEPARTMENTS;
    dbms_output.enable;
    dbms_output.put_line(numer_max); 
    INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)
    VALUES (numer_max+10, nazwa);
    UPDATE DEPARTMENTS
    SET location_id = 3000
    WHERE department_id = numer_max+10;
END;

--zadanie 3

CREATE TABLE NOWA (
    pole VARCHAR(255)
);


DECLARE
    x INT:= 1;
BEGIN
    LOOP
        IF x NOT IN (4, 6) THEN
            INSERT INTO NOWA (pole)
            VALUES (x);
        END IF;
        x := x+1;
        IF x >10 THEN
            EXIT;
        END IF;
    END LOOP;
END;

--zadanie 4
DECLARE
    row_data countries%ROWTYPE;
BEGIN
    SELECT * INTO row_data
    FROM COUNTRIES
    WHERE country_id = 'CA';
    dbms_output.enable;
    dbms_output.put_line(row_data.country_name); 
    dbms_output.put_line(row_data.region_id); 
END;

--zadanie 7
DECLARE
    CURSOR salaries IS 
    SELECT SALARY, LAST_NAME FROM EMPLOYEES
    WHERE department_id = 50;
    salary salaries%ROWTYPE;
BEGIN
    OPEN salaries;
    dbms_output.enable;
    LOOP
        FETCH salaries INTO salary;
        EXIT WHEN salaries%NOTFOUND;
        IF salary.salary > 3100 THEN
            dbms_output.put_line(salary.last_name || ' nie dawać podwyżki'); 
        ELSE
            dbms_output.put_line(salary.last_name || ' dać podwyżkę'); 
        END IF;
    END LOOP;
    CLOSE salaries;
END;

--zadanie 8
DECLARE
    CURSOR salaries(salary_min NUMBER, salary_max NUMBER, last_name_str STRING) IS 
    SELECT SALARY, LAST_NAME FROM EMPLOYEES
    WHERE LOWER(last_name) LIKE '%'||last_name_str||'%' AND salary BETWEEN salary_min AND salary_max;
    salary salaries%ROWTYPE;
BEGIN
    OPEN salaries(1000,5000,'a');
    dbms_output.enable;
    LOOP
        FETCH salaries INTO salary;
        EXIT WHEN salaries%NOTFOUND;
        dbms_output.put_line(salary.last_name); 
    END LOOP;
    CLOSE salaries;
    dbms_output.put_line('----------------'); 
    OPEN salaries(5000,20000,'u');
    dbms_output.enable;
    LOOP
        FETCH salaries INTO salary;
        EXIT WHEN salaries%NOTFOUND;
        dbms_output.put_line(salary.last_name); 
    END LOOP;
END;

--zadanie 9
CREATE OR REPLACE PROCEDURE procedura_a (new_job_id IN STRING, new_job_title IN STRING)
AS
BEGIN
    INSERT INTO JOBS (JOB_ID, JOB_TITLE) VALUES (new_job_id, new_job_title);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.enable;
        dbms_output.put_line('wystąpił błąd nr ' || SQLCODE); 
END;

EXECUTE procedura_a('NEW_JOB', 'New Job Title');
EXECUTE procedura_a('NEW_JOB', 'New Job Title2');

CREATE OR REPLACE PROCEDURE procedura_b (edited_job_id IN STRING, new_job_title IN STRING)
AS
    NO_JOBS_UPDATED EXCEPTION;
BEGIN
    UPDATE JOBS
    SET JOB_TITLE = new_job_title
    WHERE JOB_ID = edited_job_id;
    IF SQL%NOTFOUND THEN 
        RAISE NO_JOBS_UPDATED;
    END IF;
EXCEPTION
    WHEN NO_JOBS_UPDATED THEN
        dbms_output.enable;
        dbms_output.put_line('wystąpił błąd nr ' || SQLCODE); 
END;

EXECUTE procedura_b('NEW_JOB2', 'New Job Title');
EXECUTE procedura_b('NEW_JOB', 'New Job Title2');

CREATE OR REPLACE PROCEDURE procedura_c (job_id_to_delete IN STRING)
AS
    NO_JOBS_DELETED EXCEPTION;
BEGIN
    DELETE FROM JOBS
    WHERE JOB_ID = job_id_to_delete;
    IF SQL%NOTFOUND THEN 
        RAISE NO_JOBS_DELETED;
    END IF;
EXCEPTION
    WHEN NO_JOBS_DELETED THEN
        dbms_output.enable;
        dbms_output.put_line('wystąpił błąd nr ' || SQLCODE); 
END;

EXECUTE procedura_c('NEW_JOB');

CREATE OR REPLACE PROCEDURE procedura_d (searched_employee_id IN NUMBER, last_name OUT STRING, salary OUT NUMBER)
AS
    row_data employees%ROWTYPE;
BEGIN
    SELECT * INTO row_data
    FROM EMPLOYEES
    WHERE employees.employee_id = searched_employee_id;
    last_name := row_data.last_name;
    salary := row_data.salary;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.enable;
        dbms_output.put_line('wystąpił błąd nr ' || SQLCODE); 
END;

DECLARE
    last_name STRING(25);
    salary NUMBER;
BEGIN
    procedura_d(999, last_name, salary);
END;

DECLARE
    last_name STRING(25);
    salary NUMBER;
BEGIN
    procedura_d(101, last_name, salary);
    dbms_output.enable;
    dbms_output.put_line('nazwisko: ' || last_name); 
    dbms_output.put_line('zarobki ' || salary); 
END;

CREATE OR REPLACE PROCEDURE procedura_e (
    new_first_name IN STRING DEFAULT 'Jan', 
    new_last_name IN STRING DEFAULT 'Kowalski', 
    new_email IN STRING DEFAULT 'JKOWAL',
    new_salary IN NUMBER DEFAULT 5000,
    new_job_id IN STRING DEFAULT 'SA_REP',
    new_date IN DATE DEFAULT SYSDATE
)
AS
salary_too_big EXCEPTION;
new_id NUMBER;
BEGIN
    IF new_salary>20000 THEN
        RAISE salary_too_big;
    END IF;
    SELECT MAX(EMPLOYEE_ID) INTO new_id FROM EMPLOYEES;
    new_id := new_id + 1;
    INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, SALARY, HIRE_DATE, JOB_ID) 
    VALUES (new_id, new_first_name, new_last_name, new_email, new_salary, new_date, new_job_id);
EXCEPTION
    WHEN salary_too_big THEN
        dbms_output.enable;
        dbms_output.put_line('wynagrodzenie jest zbyt wysokie'); 
    WHEN OTHERS THEN
        dbms_output.enable;
        dbms_output.put_line('wystąpił błąd: ' || SQLERRM); 
END;

EXECUTE procedura_e;