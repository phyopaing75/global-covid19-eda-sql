COVID-19 Global Data Exploration Using SQL

An exploratory data analysis (EDA) of global COVID-19 mortality and vaccination metrics using SQL. This project transforms raw pandemic tracking data into actionable insights covering infection spread, death rates, and rolling vaccination rollouts.

---

Project Overview

This project analyzes the impact of the COVID-19 pandemic across countries and continents by querying and joining historical death and vaccination datasets.

Core Objectives
Measure mortality rates relative to total confirmed cases globally and at country level (e.g., Myanmar).
Identify countries with the highest infection rates per capita.
Calculate cumulative death tolls across continents and countries.
Track rolling daily vaccination numbers and measure population vaccination percentages over time using SQL window functions.
Build reusable SQL structures (CTEs, Temp Tables, and Views) suitable for downstream visualization tools like Tableau or Power BI.

---

Datasets

The analysis is based on two datasets sourced and staged into the `PortfolioProject` database:

| File Name | Description | Key Fields |
| :--- | :--- | :--- |
| `covid_deaths.xlsx` | Pandemic case and mortality metrics | `continent`, `location`, `date`, `population`, `total_cases`, `new_cases`, `total_deaths`, `new_deaths` |
| `covid_vaccinations.xlsx` | Global vaccination rollout metrics | `location`, `date`, `new_vaccinations`, `total_vaccinations` |

---

SQL Techniques Applied

Data Filtering & Sorting: `WHERE continent IS NOT NULL`, `ORDER BY`, `LIKE`
Data Aggregations: `SUM()`, `MAX()`, `GROUP BY`
Data Type Conversion: `CAST()`
Multi-Table Operations: `INNER JOIN` on composite keys (`location` and `date`)
Window Functions: Cumulative rolling sum using `SUM(...) OVER (PARTITION BY ... ORDER BY ...)`
Advanced Structuring:
  Common Table Expressions (CTEs):** `WITH population_vs_vaccinations AS (...)`
  Temporary Tables:** `#PercentPeopleVaccinated`
  Database Views:** `CREATE VIEW PercentPeopleVaccinated AS (...)`

---
