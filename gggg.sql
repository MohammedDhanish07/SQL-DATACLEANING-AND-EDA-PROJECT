-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM stage2;

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM stage2;

SELECT *
FROM stage2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT company,SUM(total_laid_off)
FROM stage2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`),MAX(`date`)
FROM stage2;

SELECT industry,SUM(total_laid_off)
FROM stage2
GROUP BY industry
ORDER BY 2 DESC;

SELECT *
FROM stage2;

SELECT country,SUM(total_laid_off)
FROM stage2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`),SUM(total_laid_off)
FROM stage2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


SELECT stage,SUM(total_laid_off)
FROM stage2
GROUP BY stage
ORDER BY 1 DESC;

SELECT company,AVG(percentage_laid_off)
FROM stage2
GROUP BY company -- we can't able to use percentage becz we didn't know the total employee in the company
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM stage2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_total AS (
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM stage2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;

SELECT company,SUM(total_laid_off)
FROM stage2
GROUP BY company
ORDER BY 2 DESC;

SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM stage2
GROUP BY company,YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_year (company, years, total_laid_off)AS
 (
SELECT company,YEAR(`date`),SUM(total_laid_off)
FROM stage2
GROUP BY company,YEAR(`date`)
),
Company_Year_Rank AS(
SELECT *,DENSE_RANK() OVER(PARTITION BY  years ORDER BY total_laid_off DESC) AS RANKING
FROM Company_year
WHERE years IS NOT NULL
ORDER BY RANKING
)
SELECT *
FROM Company_Year_Rank
WHERE RANKING <= 5;











