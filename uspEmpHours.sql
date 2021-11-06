/* =============================================
   Author: Prabakar
   Description:	MySQL stored procedure for phpMyAdmin environment (XAMPP session)
    For a given employee SSN, check if this employee exists.
     If so, find the total number of hours worked on all projects by this emp.
      
    Execution steps:
       execute \xampp\xampp_start.exe (on Windows Explorer)
       visit localhost:88/phpmyadmin (on a browser)
       click company (on the left panel)
       click SQL tab
         copy the content of this entire file inside the SQL box
	 In the Delimiter box: replace ";" with "$$"
	 click GO button (at the lower right)
       The stored procedure will be created successfully
       
       If the current MariaDB version is different compared to the mariaDB version in which user databases had been created, there will be an error message
         like " corrupted database or tables ..."
       To upgrade user databases to the current MariaDB version,
         - make sure xampp session is active (\xampp\xampp_start.exe)
	 - start a command prompt
	 - cd \xampp\mysql\bin
	   mysql_upgrade.exe -u root --force (execute this only one time)
	     Phase 2/5  will take about 5 mins
             ignore the error "Could not create the upgrade info file ..."
	This will ensure the databases are upgraded to the current MariaDB version.
	
       Click the desired database on the left panel
       Click Routines tab and check if the Routines list includes the new stored procedure
       If the new procedure is not listed,
          correct the procedure code and repeat the above process.
       To modify the procedure, click "Edit" link (next to the procedure name)
          change the Definition segment and click GO

    Testing the procedure:
       Interactive mode:
        Click the desired database on the left panel
         click Routines tab
	   click Execute link of the stored procedure
	     enter value string (without any quote) in Value box
	   click GO
       SQL mode:
         click SQL tab and enter SQL code like
           SET @inpssn='333445555';
           CALL `uspEmpHours`(@inpssn);
	 click GO
	 If the query output is not fully displayed,
	   click "+Options" and choose "Full texts" (do this only one time)
	   and run the query again.
   At the completion of the phyMyAdmin session,
   execute \xampp\xampp_stop.exe (on Windows Explorer)
   =============================================
*/

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `uspEmpHours`(
	-- Add the parameters for the stored procedure here
	IN empSSN char(9) )
BEGIN
/* Only session variables are prefixed with '@'
http://stackoverflow.com/questions/1009954/mysql-variable-vs-variable-whats-the-difference
*/
	-- Declare local variables
	declare currEmp char(9);
	declare totHours Decimal (5,1);

    -- Insert statements for procedure here
	SELECT ssn INTO currEmp
	From employee
	where ssn = empSSN;
	IF (currEmp is NULL) THEN
	  SELECT concat('The input SSN value ', empSSN, ' is not a valid SSN') As ErrorMessage;
	ELSE

	  select sum(hours) INTO totHours
	  from works_on
	  where essn = empSSN;
	  -- cast function to varchar data type causes compilation error
	  SELECT concat('Total work hours for ', empSSN, ' is ', cast(totHours as char(10))) as Answer;
	END IF;
END$$
DELIMITER ;
