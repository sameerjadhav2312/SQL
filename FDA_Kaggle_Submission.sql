use db_kaggle;
/*Part - 1 SQL Queries:*/
/*Task 1: Identifying Approval Trends*/

/*  Determine the number of drugs approved each year and provide insights into the yearly trends.*/

SELECT
  YEAR(rad.ActionDate) AS YEAR,COUNT(DISTINCT P.ApplNo) AS Approved_Drugs
FROM product AS P
  JOIN regactiondate AS RAD ON P.ApplNo = RAD.ApplNo
GROUP BY
  YEAR (rad.ActionDate)
ORDER BY
  YEAR ASC;
  
  /* Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.*/
SELECT
YEAR (ActionDate) AS YEAR,COUNT(*) AS Approvals
FROM regactiondate
GROUP BY
  YEAR
ORDER BY
  Approvals DESC
LIMIT
  3;
  
SELECT
YEAR (ActionDate) AS YEAR,COUNT(*) AS Approvals
FROM regactiondate
GROUP BY
  YEAR
ORDER BY
  Approvals ASC
LIMIT
  3;
  
  /* Explore approval trends over the years based on sponsors.*/
SELECT
YEAR (rad.ActionDate) AS YEAR,a.SponsorApplicant,COUNT(*) AS Approvals
FROM application a JOIN product p ON a.ApplNo = p.ApplNo
  JOIN regactiondate rad ON a.ApplNo = rad.ApplNo
GROUP BY
  YEAR (rad.ActionDate),
  a.SponsorApplicant
ORDER BY
  YEAR (rad.ActionDate),
  a.SponsorApplicant;
  
  /* Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.*/
  
SELECT
SponsorApplicant,COUNT(*) AS Total_Approvals
FROM application
  JOIN regactiondate ON application.ApplNo = regactiondate.ApplNo
WHERE
  YEAR (regActionDate.ActionDate) BETWEEN 1939 AND 1960
GROUP BY
  SponsorApplicant
ORDER BY
  Total_Approvals DESC;
  
  /*Task 2: Segmentation Analysis Based on Drug MarketingStatus*/
  /*Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.*/
SELECT
  p.ProductMktStatus,COUNT(*) AS Total_Products
FROM product p
GROUP BY
  p.ProductMktStatus
  order by Total_Products DESC;
  
  /*Calculate the total number of applications for each MarketingStatus year-wise after the year 2010*/
SELECT
  YEAR (rad.ActionDate) AS YEAR,p.ProductMktStatus,COUNT(*) AS Total_Applications
FROM application a
  JOIN regactiondate rad ON a.ApplNo = rad.ApplNo
  JOIN product p ON a.ApplNo = p.ApplNo
WHERE
  p.ProductMktStatus IS NOT NULL
  AND YEAR (rad.ActionDate) > 2010
GROUP BY
  YEAR,
  p.ProductMktStatus
ORDER BY
  YEAR,
  p.ProductMktStatus;
  
  /*Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time*/
SELECT
  ProductMktStatus,COUNT(*) AS MAX_Num_Applications
FROM product
GROUP BY
  ProductMktStatus
ORDER BY
  MAX_Num_Applications DESC
LIMIT
  1;
  
 /*Task 3: Analyzing Products*/
 /*Categorize Products by dosage form and analyze their distribution.*/
SELECT
  Dosage,COUNT(*) AS Total
FROM product
GROUP BY
  Dosage
  order by
  Total DESC;
  
  /*Calculate the total number of approvals for each dosage form and identify the most successful forms.*/
SELECT
 Form,COUNT(*) AS Total_no_Approvals
FROM product
GROUP BY
  Form
ORDER BY
  Total_no_Approvals DESC
LIMIT
  1;
  
  /*Investigate yearly trends related to successful forms.*/
SELECT
  YEAR (rad.ActionDate) AS YEAR,p.Form,COUNT(*) AS Total
FROM regactiondate rad
  JOIN application a ON rad.ApplNo = a.ApplNo
  JOIN product p ON a.ApplNo = p.ApplNo
WHERE
  p.ProductMktStatus = 1
GROUP BY
  YEAR (rad.ActionDate),
  p.Form
ORDER BY
  YEAR,
  p.Form;
  
  /*Task 4: Exploring Therapeutic Classes and Approval Trends*/  
  /*Analyze drug approvals based on therapeutic evaluation code (TE_Code)*/
SELECT
  p.TECode,COUNT(*) AS ApprovalCount
FROM product p
GROUP BY
  p.TECode;
  
  /*Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.*/

  /*Part - 2 Power BI Visualizations:*/
  /*visualize the yearly approval trends of drugs. Highlight any significant patterns and/or fluctuations, if any.*/
  
SELECT
  YEAR (rad.ActionDate) AS YEAR,COUNT(*) AS Approval_Count
FROM regactiondate rad
  JOIN application a ON rad.ApplNo = a.ApplNo
  JOIN product p ON a.ApplNo = p.ApplNo
WHERE
  p.ProductMktStatus = 1
GROUP BY
  YEAR (rad.ActionDate)
ORDER BY
  YEAR (rad.ActionDate) DESC;
  
  /*Explore approval trends over the years based on different sponsors. Uncover patterns and changes in approval rates among sponsors.*/
SELECT
  YEAR (rad.ActionDate) AS YEAR,a.SponsorApplicant,COUNT(*) AS Approval_Count
FROM application a JOIN regactiondate rad ON a.ApplNo = rad.ApplNo
WHERE
  rad.ActionType = 'AP' 
GROUP BY
  YEAR (rad.ActionDate),
  a.SponsorApplicant
ORDER BY
  YEAR (rad.ActionDate),
  a.SponsorApplicant DESC;
  
  /*Visualize the segmentation of products based on MarketingStatus.*/
  SELECT
  ProductMktStatus,COUNT(*) AS COUNT
FROM
  Product
GROUP BY
  ProductMktStatus;
  
  /* Show the total number of applications for each MarketingStatus. Enable users to filter by years and MarketingStatus for detailed analysis.*/
SELECT
  ProductMktStatus,
  COUNT(*) AS Total_Applications
FROM product
GROUP BY
  ProductMktStatus
ORDER BY Total_Applications;

/*analyze the grouping of drugs by dosage form. Visualize the distribution of approvals across different forms. Identify the most successful dosage form.*/
SELECT
  Form,COUNT(*) AS Approval_Count
FROM product
GROUP BY
  Form
  order by 
  Approval_Count DESC;
  
SELECT
  Form,COUNT(*) AS Approval_Count
FROM product
GROUP BY
  Form
ORDER BY
  Approval_Count DESC
LIMIT
  1;

/* Visualize drug approvals based on therapeutic classes. Identify classes with the highest number of approvals.*/

SELECT
  r.LongDescription AS TherapeuticClass,COUNT(*) AS Approval_Count
FROM application a
  JOIN reviewclass_lookup r ON a.Ther_Potential = r.ReviewCode
GROUP BY
  TherapeuticClass
ORDER BY
  Approval_Count DESC;
  

