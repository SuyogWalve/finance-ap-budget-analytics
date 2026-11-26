SELECT Status COLLATE Latin1_general_cs_as AS P FROM Vvendors
GROUP BY sTATUS  COLLATE Latin1_General_CS_AS

SELECT Status   COLLATE LATIN1_GENERAL_CS_AS AS P  
FROM expense_claims GROUP BY Status  COLLATE LATIN1_GENERAL_CS_AS

SELECT ClaimCategory   COLLATE LATIN1_GENERAL_CS_AS AS P  
FROM vclaim GROUP BY ClaimCategory  COLLATE LATIN1_GENERAL_CS_AS



alter VIEW Vclaim as (SELECT ClaimID,EmployeeID,DeptID,ClaimDate,
case ClaimCategory WHEN 'Travelling' THEN 'Travel' ELSE ClaimCategory END AS ClaimCategory,ClaimAmount, 
case Status WHEN 'pending' THEN 'Pending' 
			WHEN 'approved' THEN 'Approved'
			WHEN 'reimbursed' THEN 'Reimbursed'
			WHEN 'rejected' THEN 'Rejected' ELSE STATUS END AS Status ,
ApprovedDate,ReimbursedDate FROM expense_claims)