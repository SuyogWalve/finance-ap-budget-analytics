alter  VIEW VAging AS WITH PAY AS (SELECT InvoiceID,SUM(PaidAmount)AS PaidAmount 
FROM VPayments Group by InvoiceID) ,Acte As (
SELECT I.InvoiceID,I.VendorID,I.InvoiceDate,I.DueDate,I.TotalAmount,isnull(
P.PaidAmount,0) as PaidAmount ,I.TotalAmount-isnull(P.PaidAmount,0) as Outstanding,
CASE WHEN DATEDIFF (DAY, I.DueDate,'2026-09-30')>0 THEN DATEDIFF (DAY ,I.DueDate,'2026-09-30')
ELSE 0 END AS  DaysOverdue
FROM Vinvoices I LEFT JOIN PAY P ON I.InvoiceID=P.InvoiceID )
select * ,CASE WHEN Outstanding <=0 Then 'Paid'
			   WHEN DaysOverdue=0 THEN 'Not Yet Dues'
			   WHEN DaysOverdue BETWEEN 1 AND 30  THEN 'Between 01 to 30 Days'
			   WHEN DaysOverdue BETWEEN 31 AND 60 THEN 'Between 31 to 60 Days'
		       WHEN DaysOverdue BETWEEN 61 AND 90  THEN 'Between 61 to 90 Days'
			   WHEN DaysOverdue >90  THEN 'Above 90 Days' END AS AgingBucket,
			   CASE WHEN Outstanding <=0 Then 0 
			   WHEN DaysOverdue =0 THEN   1
			   WHEN DaysOverdue BETWEEN 1 AND 30  THEN 2 
			   WHEN DaysOverdue BETWEEN 31 AND 60 THEN  3
		       WHEN DaysOverdue BETWEEN 61 AND 90  THEN 4
			   WHEN DaysOverdue >90  THEN  5 END AS AgingBucketSort
FROM Acte

 SELECT ISNULL (AgingBucket,'Total') AS AgingBucket ,Count(*) AS Invoices , sum(Outstanding) AS Outstanding from VAging
 WHERE Outstanding>0 
 GROUP BY   ROLLUP (AgingBucket)  
 SELECT AgingBucket,VendorID,COUNT(*),SUM(Outstanding) FROM VAging
 WHERE  VENDORID =9
 GROUP BY AgingBucket,VendorID
 ORDER BY AgingBucket 
 
 