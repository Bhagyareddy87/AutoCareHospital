-- Q3.Total discharge 
SELECT COUNT(*) AS Total_Discharge
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'

-- Q4.Average Daily Discharge rate 
-- total discharges / Total lenght of stay
SELECT
(SELECT COUNT(*) AS Total_Discharge
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE')/ (SELECT SUM(DURATION_OF_STAY) AS Total_lenght_of_stay
FROM vw_AdmissionData)
-- gives "zero" so, to get numeric value float value
--must do casting this as float
SELECT
   CAST(
	CAST((SELECT COUNT(*) AS Total_Discharge
	FROM vw_AdmissionData
	WHERE OUTCOME = 'DISCHARGE') AS FLOAT)/ CAST((SELECT SUM(DURATION_OF_STAY) AS Total_lenght_of_stay
	FROM vw_AdmissionData)AS FLOAT)
  AS DECIMAL(10,2)) * 100 AS Average_Daily_Discharge

--Avoding Subquery
SELECT 
	ROUND(SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END)/
	SUM(DURATION_OF_STAY),2) * 100 AS Average_Daily_Discharge
FROM vw_AdmissionData

--Q5.Average length of stay (ALOS)
--it's Total lenght of stay / Total discharges 
SELECT 
	ROUND(SUM(DURATION_OF_STAY)/
	SUM(CASE WHEN OUTCOME = 'DISCHARGE' THEN 1.0 ELSE 0.0 END),0) As ALOS
FROM vw_AdmissionData

--Q6.Distribution of discharges by age 
SELECT AGE, COUNT(OUTCOME) FROM vw_AdmissionData 
WHERE OUTCOME = 'DISCHARGE'
GROUP BY AGE
ORDER BY AGE asc

--Distribution of discharges by age 
SELECT CASE
	WHEN AGE < 16 THEN 'Paediatric'
	WHEN AGE < 65 THEN 'Adults'
	WHEN AGE >= 65 THEN 'Senior Citizen'
	ELSE 'Unknown'
   END AS Age_group, COUNT(*) AS Age_Distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY CASE
	WHEN AGE < 16 THEN 'Paediatric'
	WHEN AGE < 65 THEN 'Adults'
	WHEN AGE >= 65 THEN 'Senior Citizen'
	ELSE 'Unknown'
   END

--Q6.Distribution of Discharges by gender 
SELECT GENDER, count(*) AS Total_Discharges FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY GENDER

--Q7.Distribution of Discharges by day of the week 
SELECT DATEPART(WEEKDAY,D_O_D) as Day_of_the_week,COUNT(*) AS Day_distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE'
GROUP BY DATEPART(WEEKDAY,D_O_D) 
ORDER BY 1 asc
--Get date name 
SELECT FORMAT(D_O_D, 'ddd') as Day_of_the_week,COUNT(*) AS Day_distribution
FROM vw_AdmissionData
WHERE OUTCOME = 'DISCHARGE' AND D_O_D IS NOT NULL
GROUP BY FORMAT(D_O_D, 'ddd') 
ORDER BY 1 desc