--funkcje:
CREATE OR REPLACE FUNCTION get_job_title(selected_job_id IN string)
RETURN VARCHAR2
IS
    selected_job_title VARCHAR2(35);
BEGIN
    SELECT JOBS.JOB_TITLE INTO selected_job_title
    FROM JOBS
    WHERE JOBS.JOB_ID = selected_job_id;
    RETURN selected_job_title;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Job with that ID does not exist'); 
        RETURN 'Job not found';
END;


CREATE OR REPLACE FUNCTION employee_annual_income(selected_employee_id IN number)
RETURN number
IS
    selected_employee EMPLOYEES%ROWTYPE;
    income NUMBER(10,2);
BEGIN
    SELECT * INTO selected_employee
    FROM EMPLOYEES
    WHERE EMPLOYEES.EMPLOYEE_ID = selected_employee_id;
    income := selected_employee.salary * (12.0 + NVL(selected_employee.commission_pct, 0));
    RETURN income;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Employee with that ID does not exist'); 
        RETURN 0;
END;


CREATE OR REPLACE FUNCTION capitalises_first_and_last(string_to_edit IN string)
RETURN string
IS
    first_letter string(1);
    last_letter string(1);
    middle string(32765);
BEGIN
    IF LENGTH(string_to_edit) > 2 THEN
        first_letter := SUBSTR(string_to_edit, 1, 1);
        last_letter := SUBSTR(string_to_edit, -1, 1);
        middle := SUBSTR(string_to_edit, 2, LENGTH(string_to_edit) - 2);
        RETURN UPPER(first_letter) || LOWER(middle) || UPPER(last_letter);
    ELSE
        RETURN UPPER(string_to_edit);
    END IF;
END;

--wyzwalacze:



DECLARE
    some_job_title VARCHAR2(35);
    some_salary NUMBER(10,2);
    some_string string(20);
BEGIN
    some_job_title := get_job_title('SA_MAN');
    dbms_output.put_line(some_job_title); 
    some_job_title := get_job_title('SA_MANY');
    dbms_output.put_line(some_job_title); 
    
    some_salary := employee_annual_income(115);
    dbms_output.put_line(some_salary); 
    some_salary := employee_annual_income(170);
    dbms_output.put_line(some_salary); 
    some_salary := employee_annual_income(404);
    dbms_output.put_line(some_salary); 
    
    some_string := capitalises_first_and_last('stRIng');
    dbms_output.put_line(some_string); 
END;



