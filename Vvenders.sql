use FinanceP3
ALTER VIEW Vvendors AS (select VendorID,LTRIM(RTRIM(VendorName)) As VendorName,VendorCategory,
CASE  WHEN  city is NULL THEN 'Unknown' ELSE CITY End AS City,
case when  State ='maharashtra' or State ='MH' THEN 'Maharashtra'
WHEN STATE ='Gujrat' THEN 'Gujarat' ELSE State end as State ,PaymentTermsDays,Status
from vendors);
 
 
 