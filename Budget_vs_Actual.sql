alter view VBudgetActual as
WITH A AS (
select DATEFROMPARTS(YEAR(InvoiceDate),MONTH(InvoiceDate),1) AS MonthStart,DeptID,
(ExpCategory ) AS ExpenseCategory,sum(BaseAmount) AS BaseAmount
FROM Vinvoices I
GROUP BY DATEFROMPARTS(YEAR(InvoiceDate),MONTH(InvoiceDate),1) ,DeptID,ExpCategory)
,B  AS
(SELECT BudgetMonth AS MonthStart ,DeptID,ExpenseCategory,sum(BudgetAmount) AS BudgetAmount
 FROM budget 
 GROUP BY BudgetMonth ,DeptID,ExpenseCategory
) ,C as 
(
SELECT COALESCE(A.DeptID,B.DeptID) as DeptID,d.DeptName ,COALESCE(A.MonthStart, B.MonthStart) AS MonthStart,
COALESCE (A.ExpenseCategory ,B.ExpenseCategory) as ExpenseCategory,ISNULL (B.BudgetAmount,0) As BudgetExp,
ISNULL(A.BaseAmount,0) ActualExp,ISNULL(A.BaseAmount,0)-ISNULL(B.BudgetAmount,0) AS Variance ,
(ISNULL(A.BaseAmount -B.BudgetAmount,0) *100.0)/ISNULL(B.BudgetAmount,0) As VariancePct

 FROM A FULL OUTER JOIN B  ON A.DeptID=B.DeptID AND A.ExpenseCategory=B.ExpenseCategory AND A.MonthStart=B.MonthStart
 JOIN departments D ON D.DeptID=A.DeptID AND D.DeptID=B.DeptID )
 SELECT *,
 CASE WHEN BudgetExp=0 AND ActualExp>0 THEN 'No Budget'
	  WHEN BudgetExp>0 AND ActualExp=0 THEN 'No Actual'
	  WHEN BudgetExp>ActualExp THEN 'Under Budget'
	  WHEN BudgetExp<ActualExp THEN 'Over Budget'
	  END AS Flag , CASE WHEN MONTH(MonthStart)>=4 THEN CONCAT('Fy',Year(MonthStart),'-',Year(MonthStart)+1)
					WHEN MONTH(MonthStart)<4 THEN CONCAT('Fy',Year(MonthStart)-1,'-',Year(MonthStart))
					END AS FY,
					CASE WHEN MONTH(MonthStart) BETWEEN 4 AND 6 THEN 'Q1'
						 WHEN MONTH(MonthStart) BETWEEN 7 AND 9 THEN 'Q2'
						 WHEN MONTH(MonthStart) BETWEEN 10 AND 12 THEN 'Q3'
						 WHEN MONTH(MonthStart) BETWEEN 1 AND 3 THEN 'Q4'
						 END AS Quarter 

 FROM C

 select* from VBudgetActual


 
 
