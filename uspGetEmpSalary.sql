/* =============================================
   Author: Prabakar, FIU-SCIS
   Description:	MySQL procedure to Get the salary of an employee
     in phpMyAdmin environment (XAMPP session) 
    Execution steps:
       execute \xampp\xampp_start.exe (on Windows Explorer)
       visit localhost:88/phpmyadmin (on a browser)
       click company (on the left panel)
       click SQL tab
         copy this entire file inside the SQL box
	 In the Delimiter box: replace ";" with "$$"
	 click GO button (at the lower right)
       The stored procedure would have been created successfully
       
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
	   SET @input='Wong';
           SET @output='';
           CALL `uspGetEmpSalary`(@input, @output);
           SELECT @output AS `Answer`;
	 click GO
	 If the query output is not fully displayed,
	   click "+Options" and choose "Full texts" (do this only one time)
	   and run the query again.
   At the completion of the phyMyAdmin session,
   execute \xampp\xampp_stop.exe (on Windows Explorer)
  =============================================
*/

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `uspGetEmpSalary`(
	-- Add the parameters for the stored procedure here
	IN LastName char(15), -- Last name as input parameter
	OUT Answer char(60) -- result as output parameter
	)
BEGIN
    -- Declare the local variable here
    DECLARE Income decimal(10,2);

    Select salary INTO Income
    from employee
    where lname = LastName;
    
    -- check if the income value is present
    IF ( Income is null ) THEN
      SET Answer = concat('No employee exists with the last name ', LastName);
    ELSE
      SET Answer = concat('Salary of the employee with last name ',
	               LastName, ' is ', cast(Income as char(10)));
    END IF;
END$$
DELIMITER ;
