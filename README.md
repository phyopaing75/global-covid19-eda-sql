Project Overview

This project analyzes the impact of the COVID-19 pandemic across countries and continents by querying and joining historical death and vaccination datasets.

Core Objectives
1. Measure mortality rates relative to total confirmed cases globally and at country level (e.g., Myanmar).
2. Identify countries with the highest infection rates per capita.
3. Calculate cumulative death tolls across continents and countries.
4. Track rolling daily vaccination numbers and measure population vaccination percentages over time using SQL window functions.
5. Build reusable SQL structures (CTEs, Temp Tables, and Views) suitable for downstream visualization tools like Tableau or Power BI.

---

Datasets

The analysis is based on two datasets sourced and staged into the `PortfolioProject` database:

| File Name | Description | Key Fields |
| :--- | :--- | :--- |
| `covid_deaths.xlsx` | Pandemic case and mortality metrics | `continent`, `location`, `date`, `population`, `total_cases`, `new_cases`, `total_deaths`, `new_deaths` |
| `covid_vaccinations.xlsx` | Global vaccination rollout metrics | `location`, `date`, `new_vaccinations`, `total_vaccinations` |

---

SQL Techniques Applied

1. Data Filtering & Sorting: `WHERE continent IS NOT NULL`, `ORDER BY`, `LIKE`
2. Data Aggregations: `SUM()`, `MAX()`, `GROUP BY`
3. Data Type Conversion: `CAST()`
4. Multi-Table Operations: `INNER JOIN` on composite keys (`location` and `date`)
5. Window Functions: Cumulative rolling sum using `SUM(...) OVER (PARTITION BY ... ORDER BY ...)`
6. Advanced Structuring:
  1. Common Table Expressions (CTEs): `WITH population_vs_vaccinations AS (...)`
  2. Temporary Tables: `#PercentPeopleVaccinated`
  3. Database Views: `CREATE VIEW PercentPeopleVaccinated AS (...)`
