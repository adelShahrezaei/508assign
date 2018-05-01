--Query 1
select d.DEPARTMENT_ID,d.DEPARTMENT_NAME, COUNT(*) count , AVG(e.SALARY) salary from DEPARTMENTS d join EMPLOYEES e on e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_ID,d.DEPARTMENT_NAME HAVING count(*)>9 AND avg(e.salary)>5000;

--Query 2
CREATE VIEW view_avg_salary
AS
select d.DEPARTMENT_ID, AVG(e.SALARY) avg_salary 
from DEPARTMENTS d join EMPLOYEES e on e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_ID;

-- Query3
CREATE VIEW view_employee_count as 
select d.DEPARTMENT_ID,COUNT(*) employee_count from DEPARTMENTS d join EMPLOYEES e on e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_ID;

-- Query4 (wit function)
create or replace function GET_EMPLOYEE_NAME 
(
  EMP_ID IN NUMBER 
)
return employees.first_name%TYPE is
em_fullname employees.first_name%TYPE;
BEGIN
  SELECT e.FIRST_NAME||' '||e.LAST_NAME into em_fullname from employees e where e.EMPLOYEE_ID= EMP_ID;
  return em_fullname;  
END GET_EMPLOYEE_NAME ;

-- Query4 (with precedures)
create or replace procedure GET_EMPLOYEE_NAME_PR
(
  EMP_ID IN NUMBER,
  FULL_NAME out employees.first_name%TYPE
)

as
BEGIN
  SELECT e.FIRST_NAME||' '||e.LAST_NAME into FULL_NAME from employees e where e.EMPLOYEE_ID= EMP_ID;
END GET_EMPLOYEE_NAME_PR ;

-- Query5
create or replace procedure INCREASE_10P
(
  EMP_ID IN NUMBER
)

as
man_id number;
man_salary number;
BEGIN
  SELECT manager_ID into man_id FROM EMPLOYEES where EMPLOYEE_ID=EMP_ID;
  SELECT salary into man_salary from Employees where EMPLOYEE_ID=man_id;
  UPDATE EMPLOYEES SET salary = man_salary+(man_salary/10) where employee_id = man_id;
  
  
END INCREASE_10P;

-- Query6
CREATE TABLE PROJECTS 
(
  MANAGER_ID NUMBER 
, DURATION NUMBER 
, COST NUMBER 
);



create or replace TRIGGER PROJECT_TRIGGER 
BEFORE INSERT OR UPDATE OF MANAGER_ID,COST,DURATION ON PROJECTS 
FOR EACH ROW
DECLARE 
avg_salary number;
BEGIN
   
  select avg(salary) into avg_salary from employees 
  group by DEPARTMENT_ID
  having DEPARTMENT_ID in (select DEPARTMENT_ID from EMPLOYEES where employees.employee_id = :new.MANAGER_ID);
  if :new.cost/:new.duration>500 OR :new.cost > avg_salary THEN
     
     RAISE_APPLICATION_ERROR (-20225,'PROJECT COST IS TOO HIGH'||avg_salary || 'lfkdl;fdf' );
  end if;
END PROJECT_TRIGGER ;
