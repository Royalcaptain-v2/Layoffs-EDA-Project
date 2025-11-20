
SELECT * FROM layoffs_staging2;

SELECT MAX(total_laid_off) , MAX(percentage_laid_off)
FROM layoffs_staging2; 
#what we know from this
#maximum people laid off from a company is 12000
#max percentage laid off is 1 which means whole company laid off or shut down 

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
#self explanatory

SELECT company , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;
#companies with highest laidoff employees -> Amazon	18150

#now select minimum and maximum date which tells when did the layoffs start and last layoff done 
SELECT MIN(`date`) , MAX(`date`)
FROM layoffs_staging2; #2020-03-11	2023-03-06  , when corona striked 

#See which industry is hit the most and which is hit the least 
SELECT industry , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

#check which country has highest laid off employees and the lowest 
SELECT country , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC; 

SELECT YEAR(`date`) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;  #Highest layoffs in 2022 

SELECT stage , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;  #companies of which stage has highest layoffs

SELECT * FROM layoffs_staging2;
WITH ROLLING_TOTAL AS
(
SELECT substring(`date` ,1 ,7) AS `MONTH` , SUM(total_laid_off) AS total_off
FROM  layoffs_staging2 
WHERE substring(`date` ,1 ,7) IS NOT NULL
GROUP BY MONTH
ORDER BY 1 ASC
)

SELECT `MONTH` , SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM ROLLING_TOTAL;

SELECT company , YEAR(`date`) , SUM(total_laid_off) 
FROM layoffs_staging2 
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC;
#this is for which compny laid off the most in which YEAR 
#From some previous statements the total laid off per company is highest for AMAZON 
#but when we did dig deep we got to know number of laid off employees was high per year for GOOGLE 

WITH Company_Year (company , years, total_laid_off) AS (
SELECT company , YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company , YEAR(`date`)
) , Company_Year_Rank AS 
(
SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking 
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * FROM Company_Year_Rank
WHERE Ranking <= 5; #tells top 5 companies who laid of most employees for a particular year
#can be done for a particular company



