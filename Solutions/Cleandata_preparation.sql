--Q1.Create a view from the Cleandata
CREATE OR ALTER VIEW vw_AdmissionData AS
-- DUPLICATE  FINDING AND REMOVING -- creating CTE temp table to extract non duplivcate data 
WITH Cleandata AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY MRD_No,D_O_A,D_O_D ORDER BY MRD_No) Dup_No
FROM [Admission data]
--ORDER BY MRD_No
)
-- Q2.Select non duplaicate data
SELECT * FROM Cleandata
WHERE Dup_no = 1 AND MRD_No IS NOT NULL
--ORDER BY MRD_No
