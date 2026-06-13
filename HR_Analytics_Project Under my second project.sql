CREATE DATABASE HR_Analytics_project;
USE HR_Analytics_Project;

 -- Checking/Verifying 50000 Employees, in both the table-
SELECT 
    (SELECT COUNT(*) FROM hr_1) AS Table1_Count,
    (SELECT COUNT(*) FROM hr_2) AS Table2_Count;
    
 -- Text Columns se extra space hatane ke liye (TRIM) =
    UPDATE hr_1 SET Department = TRIM(Department), JobRole = TRIM(JobRole), Attrition = TRIM(Attrition);    
    
    -- Safe update mode ko temporarily off karne ke liye
    SET SQL_SAFE_UPDATES = 0;
    
    UPDATE hr_1 
SET Department = TRIM(Department), 
    JobRole = TRIM(JobRole), 
    Attrition = TRIM(Attrition);
    
-- TO ENSURE THAT IN ATTRITION TABLE HAVE TWO VALUES AS YES OR NO(DISTINCT VALUE-
    SELECT DISTINCT Attrition FROM hr_1;
    
    
    SELECT Attrition, COUNT(*) 
FROM hr_1 
GROUP BY Attrition;
    
  -- KPI 1: Attrition Rate by Department-

SELECT Department, 
      concat( ROUND((COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) / COUNT(*)) * 100, 2),"%") AS Avg_Attrition_Rate
FROM hr_1
GROUP BY Department
ORDER BY Avg_Attrition_Rate DESC;

-- KPI 2: Avg Hourly Rate (Male Research Scientists)-

SELECT ROUND(AVG(HourlyRate), 2) AS Avg_Hourly_Rate
FROM hr_1
WHERE Gender = 'Male' AND JobRole = 'Research Scientist';

--  ---------------------------------------------------------------
select gender, jobrole, ROUND(AVG(HourlyRate), 2) AS Avg_Hourly_Rate
FROM hr_1
WHERE Gender = 'Male' AND JobRole = 'Research Scientist';
-- --------------------------------------------------------------

-- KPI 3: Attrition rate Vs Monthly income stats
 -- (JOIN concept) we use here
 
  -- Monthly Income ke Groups (Bins) banana
SELECT 
    CASE 
        WHEN h2.MonthlyIncome BETWEEN 0 AND 10000 THEN '0-10K'
        WHEN h2.MonthlyIncome BETWEEN 10001 AND 20000 THEN '10K-20K'
        WHEN h2.MonthlyIncome BETWEEN 20001 AND 30000 THEN '20K-30K'
        WHEN h2.MonthlyIncome BETWEEN 30001 AND 40000 THEN '30K-40K'
        ELSE '40K-50K' 
    END AS Income_Bin,
    
    
    -- . Attrition Rate Calculation (Excel match ~50%)
    
CONCAT(ROUND((COUNT(CASE WHEN h1.Attrition = 'Yes' THEN 1 END) / COUNT(*)) * 100, 2), '%') AS Attrition_Rate_Percentage
FROM hr_1 h1
JOIN hr_2 h2 ON h1.EmployeeNumber = h2.`Employee ID` 
GROUP BY Income_Bin
ORDER BY Income_Bin;


-- KPI 4: Average Working Years for each Department-

SELECT h1.Department, 
       CONCAT(ROUND(AVG(h2.TotalWorkingYears), 2), '%') AS Avg_Working_Years
FROM hr_1 h1
JOIN hr_2 h2 ON h1.EmployeeNumber = h2.`Employee ID`
GROUP BY h1.Department;

-- KPI 5: Job Role Vs Work Life Balance-

SELECT h1.JobRole, 
       -- % Hatane ke liye CONCAT hata diya gaya hai
       ROUND(AVG(h2.WorkLifeBalance), 2) AS Avg_WLB_Value
FROM hr_1 h1
JOIN hr_2 h2 ON h1.EmployeeNumber = h2.`Employee ID`
GROUP BY h1.JobRole
-- Value ko bade se chote (Descending) order mein karne ke liye
ORDER BY Avg_WLB_Value DESC;

-- KPI 6: Attrition Rate Vs Years Since Last Promotion-

SELECT 
    h2.YearsSinceLastPromotion, 
    -- Attrition Rate calculation (Bina % symbol ke)
    ROUND((COUNT(CASE WHEN h1.Attrition = 'Yes' THEN 1 END) / COUNT(*)) * 100, 2) AS Attrition_Rate_Value
FROM hr_1 h1
JOIN hr_2 h2 ON h1.EmployeeNumber = h2.`Employee ID`
GROUP BY h2.YearsSinceLastPromotion
-- Years ko 0 se 1, 2, 3... ke sequence mein lagane ke liye
ORDER BY h2.YearsSinceLastPromotion ASC;
    


    
    
    
    