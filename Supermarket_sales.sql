-- Querying for all data in the table
(SELECT 
    *
FROM
    `supermarket_sales - sheet1`);


-- Checking for data types of variables
DESCRIBE
	`supermarket_sales - sheet1`;
    
    
-- changing the time data type
UPDATE `supermarket_sales - sheet1` 
SET 
    `Date` = STR_TO_DATE(`Date`, '%m/%d/%Y');
ALTER TABLE 
	`supermarket_sales - sheet1`
MODIFY 
	`Date` DATE;
    
    
-- checking for null values in gross income
SELECT 
    `gross income`
FROM
    `supermarket_sales - sheet1`
WHERE
    `gross income` IS NULL;
 
 -- checking for null values in Total column
 SELECT 
    `Total`
FROM
    `supermarket_sales - sheet1`
WHERE
    `Total` IS NULL;


-- checking for null values in Branch Column
SELECT 
    `Branch`
FROM
    `supermarket_sales - sheet1`
WHERE
    `Branch` IS NULL;


-- checking for null values in the product line column
SELECT 
    `Product line`
FROM
    `supermarket_sales - sheet1`
WHERE
    `Product line` IS NULL;
    
    
-- to determine the total gross income of the supermarket
(SELECT 
    ROUND(SUM(`gross income`), 2)
FROM
    `supermarket_sales - sheet1` AS `gross income sum`);


-- to determine total quantity sold
(SELECT 
    SUM(`Quantity`)
FROM
    `supermarket_sales - sheet1` AS `total quantity sold`);

-- to determine total amount from sales
(SELECT 
    ROUND(SUM(`Total`), 2)
FROM
    `supermarket_sales - sheet1` AS `total sales sum`);


-- Product line sold
(SELECT DISTINCT
    `product line`
FROM
    `supermarket_sales - sheet1`);


-- Supermarket Branches
(SELECT 
	DISTINCT
		`Branch` 
	FROM  `supermarket_sales - sheet1`);
  
  
-- Highest gross income Branch
SELECT 
    Branch, sum_gross AS max_income
FROM
    (SELECT 
        Branch, ROUND(SUM(`gross income`), 2) AS sum_gross
    FROM
        `supermarket_sales - sheet1`
    GROUP BY Branch
    ORDER BY sum_gross DESC) AS gross_income_sums
LIMIT 1;


-- Highest Quantity Branch
SELECT 
    Branch, sum_qty AS max_quantity
FROM
    (SELECT 
        Branch, ROUND(SUM(`Quantity`), 2) AS sum_qty
    FROM
        `supermarket_sales - sheet1`
    GROUP BY Branch
    ORDER BY sum_qty DESC) AS gross_qty_sums
LIMIT 1;


-- Highest Total sales amount Branch
SELECT 
    Branch, sum_total AS max_total
FROM
    (SELECT 
        Branch, ROUND(SUM(`Total`), 2) AS sum_total
    FROM
        `supermarket_sales - sheet1`
    GROUP BY Branch
    ORDER BY sum_total DESC) AS gross_total_sums
LIMIT 1;


-- Highest gross income product line
SELECT 
    `Product line`, sum_gross AS max_total
FROM
    (SELECT 
        `Product line`, ROUND(SUM(`gross income`), 2) AS sum_gross
    FROM
        `supermarket_sales - sheet1`
    GROUP BY `Product line`
    ORDER BY sum_gross DESC) AS gross_income_sums
LIMIT 1;


-- Highest Total amount by product line
SELECT 
    `Product line`, sum_total AS max_total
FROM
    (SELECT 
        `Product line`, ROUND(SUM(`Total`), 2) AS sum_total
    FROM
        `supermarket_sales - sheet1`
    GROUP BY `Product line`
    ORDER BY sum_total DESC) AS gross_total_sums
LIMIT 1;


-- Quantity of each Product line sold by Branch
SELECT 
    Branch, `Product line`, SUM(Quantity) AS qty
FROM
    `supermarket_sales - sheet1`
GROUP BY `Product line` , `Branch`
ORDER BY Branch ASC , qty DESC;


-- Gross income by S month
SELECT 
    `Month`, ROUND(SUM(`gross income`),2) AS `gross income`
FROM
    (SELECT 
        `gross income`,
            `Date`,
            CASE
                WHEN
                    `Date` >= '2019-01-01'
                        AND `Date` <= '2019-01-31'
                THEN
                    'Jan'
                WHEN
                    `Date` >= '2019-02-01'
                        AND `Date` <= '2019-02-28'
                THEN
                    'Feb'
                ELSE 'Mar'
            END AS `Month`
    FROM
        `supermarket_sales - sheet1`) AS months
GROUP BY `Month`
ORDER BY `Month`;


-- gross income rank for each product line in each Branch for the month of march
SELECT 
	Branch, 
    `Product line`, 
    `Month`,
    `gross income`,
	RANK() OVER 
    (PARTITION BY 
    `Branch` 
    ORDER BY `gross income` DESC) AS ranks 
FROM 
    (SELECT 
		`Branch`,
		`Product line`,
		`Date`,
    CASE
        WHEN
            `Date` >= '2019-03-01'
                AND `Date` <= '2019-03-31'
        THEN
            'Mar'
        ELSE ''
    END AS Month,
    ROUND(SUM(`gross income`), 2) AS `gross income`
FROM
    (SELECT 
        *
    FROM
        `supermarket_sales - sheet1`
    WHERE
        `Date` >= '2019-03-01'
            AND `Date` <= '2019-03-31') AS quantity_sum
GROUP BY `Product line` , `Branch`) AS branch_product_total_ranks;


-- Gross income for January
SELECT 
    `Month`,
    ROUND(SUM(`gross income`), 2) AS `gross income`
FROM
    (SELECT 
        Branch,
            `Product line`,
            `gross income`,
            `Date`,
            CASE
                WHEN
                    `Date` >= '2019-01-01'
                        AND `Date` <= '2019-01-31'
                THEN
                    'Jan'
                ELSE ''
            END AS `Month`
    FROM
        (SELECT 
        *
    FROM
        `supermarket_sales - sheet1`
    WHERE
        `Date` >= '2019-01-01'
            AND `Date` <= '2019-01-31') AS selections) AS Jan_gross;
  
  
-- sum gross income for each Gender in each branch
SELECT 
    Branch, Gender, ROUND(SUM(`gross income`)) AS `gross income`
FROM
    (SELECT 
        *
    FROM
        `supermarket_sales - sheet1`) AS all_data
GROUP BY Branch , Gender
ORDER BY Branch , Gender;






            

            

    

