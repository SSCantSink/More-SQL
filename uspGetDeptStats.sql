-- input: department_name (var char of 15 character text string)
-- output: following statistics if given department_name exists

-- The firstname and lastname of the manager of this department.
-- The number of employees work for this department
-- The total salary for all employess work for this department
-- The total number of dependents of all employees who work for this department
-- The total weekly workhours of employees who belong to this department
-- and who work on the projects that are controlled by this department.

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `uspGetDeptStats`(
	-- Add the parameters for the stored procedure here
	IN DepName varchar(15) -- DepartmentNumber as input parameter
	)
BEGIN

	-- local variables to be outputted.
	declare realDeptName varchar(15);
	declare firstName varchar(15);
	declare lastName varchar(15);
	declare numOfEmployees int;
	declare totalSalary decimal(10,2);
	declare numOfDependents int;
	declare totalHours decimal(5,2);
	
	-- intermediate variables.
	declare mgSSN char(9);
	declare departmentNumber int;
	
	-- see if the department_name matches
	select dname into realDeptName
	from department
	where dname = DepName;
	
	if (realDeptName is null) then -- prints no such deptname if input doesn't exist
		select concat('No department exists with the name ', '\"',  DepName, '\"') as '';
	else -- otherwise...
	
		-- get manager's ssn
		select mgrssn into mgSSN
		from department
		where dname = realDeptName;
		
		-- get firstname and lastname
		select fname into firstName
		from employee
		where ssn = mgSSN;
		
		select lname into lastName
		from employee
		where ssn = mgSSN;
		
		-- get number of employees that work in said department
		
		-- first get department number which matches the name.
		select dnumber into departmentNumber
		from department
		where dname = realDeptName;
		
		-- then get the count for all employees
		select count(*) into numOfEmployees
		from employee
		where dno = departmentNumber
		group by dno;
		
		-- get the total salary
		select sum(salary) into totalSalary
		from employee
		where dno = departmentNumber -- from employee from said department
		group by dno;
		
		-- get the number of dependents
		select count(*) into numOfDependents
		from dependent
		where essn in 
			(select ssn -- from employees who belong to said department.
			from employee
			where dno = departmentNumber);
			
		-- get the total weekly hours
		select sum(hours) into totalHours
		from works_on
		where (essn in
		(	select ssn -- from employees who belong to said department
			from employee
			where dno = departmentNumber)) and pno in
			(	select pnumber -- and who work on projects controlled by said department
			from project
			where dnum = departmentNumber);
			
		-- Then print out all the stats
		select concat('Statistics of the department ', '\"', realDeptName, '\"') as '';
		select concat('Manager: ', firstName, ' ', lastName) as '';
		select concat('Number of employees: ', numOfEmployees) as '';
		select concat('Total salary of these employees: ', totalSalary) as '';
		select concat('Number of dependents: ', numOfDependents) as '';
		select concat('Total weekly hours of these employees: ', totalHours) as '';
		
	end if;
	
END$$
DELIMITER ;


	