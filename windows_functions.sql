SELECT *
  FROM windows_functions.salary;
  
  
-- THIS IS HOW TO GET MAX SALARY FROM DEPARTMENT AND FIND NAMES
SELECT  s.first_name
       ,s.department
	   ,s.gross_salary
  FROM windows_functions.salary AS s
  JOIN (SELECT MAX(gross_salary) AS salary
	   ,department
  	    FROM windows_functions.salary
        GROUP BY department) AS max_salary
	ON  s.gross_salary = max_salary.salary AND s.department = max_salary.department;
	
-- SAME RESULT BUT USING WINDOWS FUNCTIONS

SELECT first_name
       ,department
	   ,gross_salary
	   ,MAX(gross_salary) OVER(PARTITION BY department) AS max_gross_salary
  FROM windows_functions.salary;
  
  
-- 
SELECT *
  FROM (SELECT s.id,
	         s.first_name,
	         s.department,
	  		 s.gross_salary,
	         MAX(gross_salary) OVER(PARTITION BY department) AS max_gross_salary
	    FROM windows_functions.salary AS s
		) AS ms
 WHERE ms.gross_salary = ms.max_gross_salary
   AND ms.department = ms.department;
   
--- SUM OF ALL SALARY
WITH gross_by_department AS
	(SELECT s.department
		   ,SUM(s.gross_salary) AS department_gross_salary
	  FROM windows_functions.salary AS s
	 GROUP BY department)
	 
SELECT s.id
	   ,s.first_name
	   ,s.department
	   ,s.gross_salary
	   ,ROUND((s.gross_salary::numeric / gbd.department_gross_salary)*100, 2) AS department_ration   -- ::numeric это перевод данных в тип numeric
	   ,ROUND(((s.gross_salary::numeric / (SELECT SUM(s.gross_salary) FROM windows_functions.salary AS s))*100), 2) AS total_ratio
  FROM windows_functions.salary AS s
  JOIN gross_by_department AS gbd
  USING(department)
  ORDER BY s.department
  		   ,department_ration DESC;
		   
		   
--- SAME QUERY BUT USING WINDOW FUNCTIONS

SELECT id
	   ,first_name
	   ,department
	   ,gross_salary
	   ,ROUND((gross_salary::numeric / SUM(gross_salary) OVER(PARTITION BY department)*100),2) AS department_ratio
	   ,ROUND(((gross_salary::numeric / SUM(gross_salary) OVER())*100),2) AS total_ratio
  FROM windows_functions.salary;



-- GETTING INFORMATION ABOUT EMPLOYEE WITL LOWEST SALARY BY DEPARTMENT 
SELECT s.id
	   ,s.first_name
	   ,s.department
	   ,s.gross_salary
	   ,LAST_VALUE(s.first_name) OVER(PARTITION BY s.department ORDER BY s.gross_salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) lowest_gross_salary
  FROM windows_functions.salary AS s;
  
  
SELECT UPPER('This is how to get max salary from department and find names')
 
		   
