
# 📊 SQL Data Cleaning Project: Layoffs Dataset

## 🧾 Overview

This project focuses on **cleaning and preparing a raw dataset of global layoffs** for analysis using SQL. The original dataset (`layoffs.csv`) contains duplicate records, inconsistent formatting, and missing values. The goal is to transform it into a reliable and standardized format suitable for data analysis.

---

## 🧰 Tools Used

- **MySQL**
- **ROW_NUMBER()** window function
- **CTEs (Common Table Expressions)**
- **String manipulation functions** (e.g., `TRIM`, `LIKE`)
- **Date formatting** (`STR_TO_DATE`)
- **Data type alteration**
- **Join-based imputation**

---

## 📂 Project Structure

- `layoffs.csv`: Raw dataset (uploaded)
- `layoffs`: Original table created from the CSV
- `layoffs_staging`: Temporary table to preserve raw data while cleaning
- `layoffs_staging2`: Final cleaned dataset

---

## 🧼 Data Cleaning Steps

### 1. ✅ Remove Duplicates

- Used `ROW_NUMBER()` to detect duplicate rows based on relevant columns.
- Created a CTE to isolate rows with `row_num > 1`.
- Deleted duplicate entries in the staging table.

### 2. 🧽 Standardize Text Fields

- Trimmed leading/trailing whitespaces in `company` and `country`.
- Standardized inconsistent values (e.g., all "Crypto*" entries in `industry` updated to `"Crypto"`).
- Removed trailing punctuation (e.g., `country` values like `"United States."`).

### 3. 🗓️ Fix Date Format

- Converted date column from string to proper `DATE` type using `STR_TO_DATE`.
- Altered column type using `ALTER TABLE` for correct formatting.

### 4. 🔍 Impute Missing Values

- Filled missing `industry` values using a **self-join** strategy (matching company names with known industry values).
- Set all remaining blank strings in `industry` to `NULL`.

### 5. 🗑️ Remove Irrelevant Rows

- Deleted 361 records with **no layoff information** (i.e., both `total_laid_off` and `percentage_laid_off` are `NULL`).

### 6. 🔧 Final Touches

- Dropped helper column `row_num` after cleaning was completed.

---

## 📈 Outcome

- The final cleaned dataset is stored in the `layoffs_staging2` table.
- It is free from duplicates, has consistent formatting, standardized dates, and missing fields intelligently imputed or removed.
