-- Data Cleaning


/* 1. Remove Duplicates*/ 
SELECT * /*  Review of the data set */
FROM layoffs;

CREATE TABLE layoffs_staging /* Creating a duplicate table so data cleaning process can be done, without altering the actual raw*/
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT INTO layoffs_staging -- Filling the raw data into the newly created table.
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off,percentage_laid_off,  `date`) AS row_num
FROM layoffs_staging;

WITH row_num_set AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off, percentage_laid_off,   `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM row_num_set
WHERE row_num >1;


SELECT *
FROM layoffs_staging2
WHERE company = 'Loft';


CREATE TABLE layoffs_staging2(
company varchar(225),
location varchar(225),
industry varchar(225),
total_laid_off varchar(225),
percentage_laid_off varchar(225),
`date`  varchar(225),
stage varchar(225),
country varchar(225),
funds_raised_millions varchar(225),
row_num varchar(225)
);

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location, industry, total_laid_off, percentage_laid_off,   `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE -- DELETING all the records that contain duplicates
FROM layoffs_staging2
WHERE row_num >1;

/* Standardizing Data*/

SELECT DISTINCT (TRIM(company)), company
FROM layoffs_staging2;

-- updating the table
UPDATE layoffs_staging2
set company = TRIM(company);

SELECT DISTINCT(Industry)
FROM layoffs_staging2
order by industry ASC;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE "Crypto%";

SELECT DISTINCT(country)
FROM layoffs_staging
ORDER BY country ASC;

SELECT TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE(`date`, "%m/%d/%Y")
FROM layoffs_staging2;

-- Updating date to proper date format
UPDATE  layoffs_staging2
SET `date` = STR_TO_DATE(`date`,"%m/%d/%Y");

SELECT `date`
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2;

-- Altering the column datatype of date column
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` date;

-- Important finding out the empty values in industry
SELECT *
FROM layoffs_staging2
WHERE industry is null or industry = '';


SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- There are multiple records of identical companies with missing industry records column
SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry is NULL or t1.industry = ''
and t2.industry is not NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
AND t2.industry is NOT NULL;


UPDATE layoffs_staging2
SET industry = null
WHERE industry = '';

-- Deleting records 

SELECT COUNT(*) /* Total 361 records found out be deleted*/
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Deleting row_num column
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;
