SELECT *
FROM worldstaging;

CREATE TABLE stage
LIKE worldstaging;

SELECT *
FROM stage;

INSERT stage
SELECT *
FROM worldstaging;

-- 1.REMOVING  DUPLICATES

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions
) AS row_num
FROM stage
)-- WITH is used as tmporary table for complex query
-- ROW_NUBER() used to assign number for rows
-- OVER used for how a operation works over a set of rows
-- PARTITON BY used to order or divide rows based on values


SELECT *
FROM duplicate_cte
WHERE row_num > 1;

select *
from stage
where company = 'Casper';


CREATE TABLE `stage2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM stage2;

INSERT INTO stage2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions
) AS row_num
FROM stage;

SELECT *
FROM stage2;
  
SELECT * 
FROM stage2
WHERE row_num > 1;

DELETE
FROM stage2
WHERE row_num > 1;

SELECT * 
FROM stage2;

-- 2. STANDARDIZING DATA
 -- 2.1 removing white spaes
 
 SELECT TRIM(company),company
 FROM stage2;

UPDATE stage2
SET company = TRIM(company);

SELECT TRIM(company),company
 FROM stage2;
 
 -- 2.2 standardizing industry
 
 SELECT DISTINCT industry
 FROM stage2
 ORDER BY 1;

SELECT *
FROM stage2
WHERE industry LIKE 'Crypto%';

UPDATE stage2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- USES OF PERCENTAGE
--    1. name% - it shows all the string starting with that nam in a particular column
--    2. %name - it shows all the string ending with that nam in a particular column
--    3. %name% - it shows all the string where ever with that nam in a particular column

SELECT DISTINCT location
FROM stage2; -- no correction in location

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM stage2
ORDER BY 1;
-- TRAILING is used to remove the specified element within single quotes 


UPDATE stage2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country,TRIM(TRAILING '.' FROM country),`date`
FROM stage2 
ORDER BY 1;

SELECT `date`
FROM stage2;

SELECT `date`,REPLACE(`date`,'-','/')
FROM stage2
WHERE `date` LIKE '%-%'
ORDER BY 1;

UPDATE stage2
SET `date` = REPLACE(`date`,'-','/')
WHERE `date` LIKE '%-%';

SELECT `date`
FROM stage2;

SELECT `date`,STR_TO_DATE(`date`, '%m/%d/%Y')
FROM stage2
ORDER BY 1;

UPDATE stage2
SET `date` =STR_TO_DATE(`date`, '%m/%d/%Y');

-- ALTERING TABLE STRUCTURE----------------------------------------------------------------------------------

ALTER TABLE stage2
MODIFY COLUMN `date` DATE;

-- 3.  REMOVING NULL AND BLANK CELLS

SELECT *
FROM stage2;

-- 3.1  
SELECT *
FROM stage2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE stage2
SET industry = null
WHERE industry = '' ;

-- 3.2
SELECT *
FROM stage2
WHERE industry IS NULL
OR industry = '';

-- using joins
SELECT *
FROM stage2
WHERE company = 'Airbnb';

SELECT t1.industry,t2.industry,t1.industry
FROM stage2 AS t1
JOIN stage2 AS T2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE stage2 AS t1
JOIN stage2 AS T2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM stage2
WHERE company LIKE 'Bally%';

-- DELETING NULL ROWS BASED ON SAMPLE TEST FORMULAE

SELECT *
FROM stage2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM stage2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE stage2
DROP COLUMN row_num;
