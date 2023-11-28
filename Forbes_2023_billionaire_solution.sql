CREATE DATABASE billionaires;

-- */create table named billionaires/

CREATE TABLE IF NOT EXISTS billionaires (
	rank INT,
	finalWorth INT,
	category VARCHAR(100),
	personName VARCHAR(150),
	age INT,
	country VARCHAR(80),
	city VARCHAR(80),
	source VARCHAR(80),
	industries VARCHAR(100),
	countryOfCitizenship VARCHAR(80),
	organization VARCHAR(100),
	selfMade BOOLEAN,
	status VARCHAR(5),
	gender VARCHAR(10),
	birthDate TIMESTAMP,
	lastName VARCHAR(100),
	firstName VARCHAR(100),
	title VARCHAR(100),
	date TIMESTAMP,
	state VARCHAR(50),
	residenceStateRegion VARCHAR(50),
	birthYear INT,
	birthMonth INT,
	birthDay INT,
	cpi_country FLOAT,
	cpi_change_country FLOAT,
	gdp_country MONEY,
	gross_tertiary_education_enrollment FLOAT,
	gross_primary_education_enrollment_country FLOAT,
	life_expectancy_country FLOAT,
	tax_revenue_country_country FLOAT,
	total_tax_rate_country FLOAT,
	population_country FLOAT,
	latitude_country DOUBLE PRECISION,
	longitude_country DOUBLE PRECISION

);

ALTER TABLE billionaires
ALTER COLUMN status TYPE VARCHAR(50);

-- */To view the imported CSV data/
SELECT * FROM billionaires;

-- */To determine the youngest and oldest billionaire/
(SELECT
	'Yougest' AS billionaire_age_class,
	MIN(age) AS age
FROM
	billionaires)
UNION ALL	
(SELECT
	'Oldest' AS billionaire_age_class,
	MAX(age) AS age
FROM
	billionaires);

-- */To determine the Top 10 richest billionaire/
SELECT 
	personName,
	finalworth AS billionaire_total_worth
FROM
	billionaires
ORDER BY
	2 DESC
LIMIT 10;

-- */To determine the Top 10 Richest Male billionaires by age, country, industries(category)/
SELECT
	personname,
	age,
	country,
	industries,
	gender,
	SUM(finalworth) AS total_worth
FROM
	billionaires
WHERE 
	gender = 'M' AND age IS NOT NULL AND country IS NOT NULL
GROUP BY
	1, 2, 3, 4, 5
ORDER BY
	6 DESC
LIMIT 10;

-- */To determine the top 10 Male Richest Billionaires in Technology Industries/
SELECT
	personname,
	age,
	country,
	industries,
	gender,
	SUM(finalworth * 10e5) AS total_worth
FROM
	billionaires
WHERE 
	gender = 'M' AND age IS NOT NULL AND country IS NOT NULL AND industries = 'Technology'
GROUP BY
	1, 2, 3, 4, 5
ORDER BY
	6 DESC
LIMIT 10;

-- */To determine the Top 10 Richest Female billionaires by age, country, industries(category)/
SELECT
	personname,
	age,
	country,
	industries,
	gender,
	SUM(finalworth) AS total_worth
FROM
	billionaires
WHERE 
	gender = 'F' AND age IS NOT NULL AND country IS NOT NULL
GROUP BY
	1, 2, 3, 4, 5
ORDER BY
	6 DESC
LIMIT 10;

-- */To determine actual billionaires networth/
SELECT
	personname,
    Gender,
    Country,
    selfmade,
    SUM(finalworth * 10e5) AS networth
FROM
	billionaires
GROUP BY
	1, 2, 3, 4
ORDER BY
	5 DESC;

-- */To track the wealth origin of all the Billionaires/
SELECT
	selfmade,
	COUNT(*) AS total_billionairenotselfmade
FROM
	billionaires
GROUP BY 
	1;
	
-- */To determine the Total number of Billionaires/
SELECT
	COUNT(*) AS total_billionaires
FROM
	billionaires;

-- */To determine Billionaires average age distribution/
SELECT
	CEIL(AVG(age)) AS avg_billionaires_age
FROM
	billionaires;

-- */To determine billionaires distribution by gender over the years/
SELECT
	gender,
	age,
	TO_CHAR(date, 'dd/mm/yyy') AS year,
	COUNT(*) AS billionaires_count
FROM
	billionaires
WHERE
	age IS NOT NULL
GROUP BY
	2, 3, gender
ORDER BY
	4 DESC;
	
-- */Age Distribution of Billionaires by gender/
SELECT
    gender,
    CASE
        WHEN EXTRACT(YEAR FROM birthdate) - birthyear BETWEEN 18 AND 30 THEN '18-30'
		WHEN EXTRACT(YEAR FROM birthdate) - birthyear BETWEEN 31 AND 40 THEN '31-40'
		WHEN EXTRACT(YEAR FROM birthdate) - birthyear BETWEEN 41 AND 50 THEN '41-50'
		WHEN EXTRACT(YEAR FROM birthdate) - birthyear BETWEEN 51 AND 60 THEN '51-60'
		WHEN EXTRACT(YEAR FROM birthdate) - birthyear BETWEEN 61 AND 70 THEN '61-70'
		WHEN EXTRACT(YEAR FROM birthdate) - birthyear BETWEEN 71 AND 80 THEN '71-80'
        ELSE '80+'
    END AS age_group,
    COUNT(*) AS count
FROM
    billionaires
GROUP BY
    gender, age_group
ORDER BY
    gender, age_group;

-- */To determine the top 10 Industries with the highest number of billionaires/
SELECT
	industries,
	COUNT(*) AS billionaires_count
FROM
	billionaires
GROUP BY
	industries
ORDER BY
	2 DESC;

-- */To determine billionaires distribution by source/
SELECT
	source,
	COUNT(*) AS billionaires_count
FROM
	billionaires
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT 10;

-- */To determine billionaires distribution by industries/
SELECT
	industries,
	COUNT(*) AS billionaires_count
FROM
	billionaires
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT 10;
	
-- */To determine Selfmade wealth Vs Inherited wealth/
SELECT
	status,
	COUNT(*) AS billionaires_count
FROM
	billionaires
WHERE 
	status = 'U'
	OR status = 'D'
GROUP BY 
	1
ORDER BY
	2 DESC;	

-- */To determine the distribution of billionaires' wealth across different industries, 
-- countries, and regions/
SELECT
	industries,
	country,
	residencestateregion,
	COUNT(*) AS billionaires_count
FROM
	billionaires
WHERE 
	residencestateregion IS NOT NULL
GROUP BY
	1, 2, 3
ORDER BY
	4 DESC;

-- */Trends over time, track changes in billionaire demographics and wealth over the years/
SELECT
	source,
	TO_CHAR(date, 'dd/mm/yyyy') AS year,
	finalworth AS billionaires_wealth
FROM
	billionaires
GROUP BY
	1, 2, 3
ORDER BY
	3 DESC;
	
-- */To determine the presence of billionaires per country/
SELECT
	country,
	latitude_country,
	longitude_country,
	COUNT(*) AS billionaires_count
FROM
	billionaires
WHERE
	country IS NOT NULL AND latitude_country IS NOT NULL AND longitude_country IS NOT NULL
GROUP BY
	1, 2, 3
ORDER BY
	4 DESC;
	
-- /Using CTE to determine the total finalworth of billionaires by top industries country/
WITH top_industries AS(
	SELECT
		country,
		industries,
		SUM(finalworth) AS billionaires_total_worth,
		RANK() OVER (PARTITION BY country ORDER BY 3 DESC)
	FROM
		billionaires
	GROUP BY 1, 2)
	SELECT
		country,
		industries,
		billionaires_total_worth
	FROM
		top_industries
	WHERE 
		country IS NOT NULL 
	ORDER BY 3 DESC
	OFFSET 0 FETCH FIRST 20 ROW ONLY;
	
-- */To determine the correlations between billionaire wealth and economic 
-- indicators such as GDP, CPI, and tax rates/
SELECT
	CORR(finalworth, gdp_country::NUMERIC) AS finalworth_gdp_correlation,
	CORR(finalworth, cpi_country::NUMERIC) AS finalworth_cpi_country_correlation,
	CORR(finalworth, cpi_change_country::NUMERIC) AS finalworth_cpi_change_correlation,
	CORR(finalworth, tax_revenue_country_country::NUMERIC) AS finalworth_tax_revenue_correlation,
	CORR(finalworth, total_tax_rate_country::NUMERIC) AS finalworth_total_tax_correlation
FROM
	billionaires;

-- */To determine the average billionaire worth/
SELECT
	CEIL(AVG(finalworth)) AS avg_billionaires_worth
FROM
	billionaires;
	
-- */*To query the billionaires table/
SELECT
	*
FROM 
	billionaires;