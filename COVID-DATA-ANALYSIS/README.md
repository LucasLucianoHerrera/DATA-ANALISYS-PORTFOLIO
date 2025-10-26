# 🦠 COVID-19 Global Data Analysis

## 🎯 PROJECT GOAL
The primary goal of this project is to perform a comprehensive exploratory **analysis** of global COVID-19 datasets to calculate and track key metrics, including:
1. Global Death Percentage and Infection Rates.
2. Rolling Count of People Vaccinated by Country/Continent.
3. Identifying the highest infection rates relative to population.

## 💾 DATA SOURCE
* **Files:** `CovidDeaths.csv` and `CovidVaccinations.csv`.
* **Source:** Our World in Data (Original Source - State the actual source if known).
* **Initial State:** Data required cleaning and strict type casting during the import process to handle NULLs and ensure correct decimal division.

## 💻 WORKFLOW PHASES

### Phase 1: Setup & Data Ingestion (SQL)
* **Script:** `database-and-tables-creation.sql` 
* **Action:** Used to create the `PortfolioProject` database, define strict table schemas, and execute **`BULK INSERT`** after moving the CSV files into the Docker container via `docker cp`. Special attention was given to the `DATE` and `DECIMAL` types.

### Phase 2: Exploratory Analysis (SQL)
* **Script:** `exploratory-analysis.sql` 
* **Action:** This script contains the core T-SQL queries:
    * **Data Cleaning:** Filtering out non-essential rows (`continent IS NOT NULL`).
    * **Rate Calculation:** Using `CAST(numerator AS DECIMAL(18,4))` to correctly calculate death and infection percentages.
    * **Complex Joins:** Joining the Deaths and Vaccinations tables on `location` and `date`.
    * **Window Functions:** Using the `SUM() OVER (PARTITION BY ... ORDER BY ...)` clause to calculate a rolling/cumulative count of total people vaccinated.

### Phase 3: Visualization (Planned - Tableau)
* **Action:** The resulting aggregate tables will be connected to Tableau to create dynamic dashboards illustrating the findings.

---

## 📊 KEY FINDINGS (To be completed)

* [To be completed]
* [To be completed]

**(Link to Tableau Dashboard here once complete 👇🏼)**