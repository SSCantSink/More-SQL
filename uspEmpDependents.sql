/* =============================================
   Author: Prabakar
   Description:	MySQL stored procedure for phpMyAdmin environment (XAMPP session)
    For a given employee SSN, check if this employee exists.
     If so, find all dependents for this employee.
   =============================================
USE company;
DROP PROCEDURE IF EXISTS `uspEmpDependents`;
*/

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `uspEmpDependents`(
	-- Add the parameters for the stored procedure here
	IN empSSN CHAR(9) )
	
myModule: BEGIN
  -- Declare local variables
  DECLARE currEmp VARCHAR(30);
  DECLARE family_tie VARCHAR(8);
  DECLARE dep_name VARCHAR(15);
  DECLARE resultLine VARCHAR(30);
  DECLARE more_rows BOOLEAN DEFAULT TRUE;
  DECLARE num_rows INT DEFAULT 0;

  -- Declare the cursor
  DECLARE dependent_cur CURSOR FOR
    SELECT relationship, dependent_name
    FROM dependent
    WHERE essn = empSSN;

  -- Declare 'handlers' for exceptions
  DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET more_rows = FALSE;
	
  -- Insert all necessary statements for the procedure
  SELECT CONCAT(fname, ' ', lname) INTO currEmp
  FROM employee
  WHERE ssn = empSSN;
  IF (currEmp is NULL) THEN
    SELECT CONCAT('The input SSN value ', empSSN, ' is not a valid SSN') As ErrorMessage;
  ELSE
    -- 'open' the cursor and capture the number of rows returned
    -- (the 'select' gets invoked when the cursor is 'opened')
    OPEN dependent_cur;
    SELECT FOUND_ROWS() INTO num_rows;
    IF (num_rows = 0) THEN
	 SELECT CONCAT(CurrEmp, ' has no dependent.') As Result;
	 LEAVE myModule; -- exit from this stored procedure
    END IF;
	IF (num_rows = 1) THEN
	   SELECT CONCAT(CurrEmp, ' has the following 1 dependent:') As Result;
	ELSE
       SELECT CONCAT(CurrEmp, ' has the following ', num_rows, ' dependents:') As Result;
	END IF;
    WHILE (num_rows > 0) Do
	  -- retrieve one row of the result of the query through the cursor
      FETCH dependent_cur INTO family_tie, dep_name;

      -- check if we've processed them all
	  IF more_rows = FALSE THEN
          CLOSE dependent_cur;
		  LEAVE myModule; -- exit from this stored procedure
	  END IF;

	  -- "SELECT" is the equivalent of a 'print statement' in a stored procedure
	  -- SET resultLine = concat(RPAD(family_tie, 10, '*'), dep_name);
	  SET resultLine = CONCAT(family_tie, ' ', dep_name);
	  SELECT resultLine as '';

	  -- decrement the number of rows to be fetched
	  SET num_rows = num_rows - 1;
	END WHILE;
  END IF;
END$$
DELIMITER ;
