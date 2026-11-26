--select TOP 5 * FROM VAging;select TOP 5 * FROM Vvendors
ALTER VIEW  VAgeVendor as  (SELECT VendorID ,VendorName,VendorCategory,
isnull ([Not Yet Dues],0) as [Not Yet Dues],
isnull ([Between 01 to 30 Days],0) as [Between 01 to 30 Days],
isnull ([Between 31 to 60 Days],0) as [Between 31 to 60 Days],
isnull ([Between 61 to 90 Days],0) as [Between 61 to 90 Days],
isnull ([Above 90 Days],0) as [Above 90 Days],
isnull ([Not Yet Dues],0) +isnull ([Between 01 to 30 Days],0) +
isnull ([Between 31 to 60 Days],0)+ isnull ([Between 61 to 90 Days],0)+ isnull ([Above 90 Days],0) AS TotalOutstanding
FROM
(
SELECT A.VendorID,V.VendorName ,v.VendorCategory,A.AgingBucket,A.Outstanding
FROM VAging A JOIN Vvendors V ON A.VendorID=V.VendorID
) AS ST
PIVOT 
( 
SUM(Outstanding)
FOR AgingBucket IN (
 [Not Yet Dues],
[Between 01 to 30 Days],
 [Between 31 to 60 Days],
 [Between 61 to 90 Days],
 [Above 90 Days]

)) AS PT)

