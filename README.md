# Global COVID-19 Exploratory Data Analysis (SQL Server)

[![SQL Server](https://img.shields.io/badge/SQL_Server-T--SQL-CC2927?style=flat&logo=microsoftsqlserver&logoColor=white)](https://www.microsoft.com/sql-server)

---

## Project Overview

* Tools and Technologies: SQL Server (T-SQL), SSMS
* Dataset Scope: Daily country-level COVID-19 data from 1 January 2020 to 30 April 2021 (85,171 rows), held in two tables: `CovidDeaths` (cases, deaths, population) and `CovidVaccinations` (vaccination counts).
* Script: `covid19_eda.sql`

---

## Business Problem

Public health teams and policy analysts need to know how heavily each country has been hit by COVID-19, how deadly the disease has been, and how far vaccination has progressed. The raw data is daily, cumulative and mixes countries with continent and world aggregates. This project uses SQL to turn it into clear comparisons of infection rates, death counts, global trends and vaccination progress.

---

## Business Questions

| # | Business question | SQL query |
|---|---|---|
| 1 | What share of confirmed cases ended in death (Myanmar example)? | Total cases vs total deaths |
| 2 | Which countries have the highest share of their population infected? | Highest infection rate vs population |
| 3 | Which countries and continents have the highest death counts? | Highest death count; continent breakdown |
| 4 | How did new cases and deaths move across the world over time? | Global numbers (by date and overall) |
| 5 | How much of each country's population has been vaccinated over time? | Rolling vaccinations (CTE, temp table, view) |

---

## Key Insights

Figures below come from the queries in `covid19_eda.sql`, over data up to 30 April 2021.

1. **Globally, about 2.1% of recorded cases ended in death.** The "Across the world" query gives 150,574,977 cases and 3,180,206 deaths, a death percentage of 2.11%.
2. **Myanmar's death percentage started very high and fell.** It peaked at 13.64% on 8 April 2020, when case counts were tiny, and was 2.25% by 30 April 2021. Early percentages are unreliable because the denominator is small.
3. **Small European countries have the highest infection rates.** The top five are Andorra (17.13% of population), Montenegro (15.51%), Czechia (15.23%), San Marino (14.93%) and Slovenia (11.56%).
4. **The highest death counts are in a handful of large countries.** United States 576,232, Brazil 403,781, Mexico 216,907, India 211,853 and United Kingdom 127,775.
5. **Global daily cases and deaths peaked in different months.** New cases peaked at 905,992 on 28 April 2021, while new deaths peaked at 17,906 on 20 January 2021.
6. **Vaccination progress is very uneven.** By 30 April 2021 the cumulative doses per population were 121% in Israel, 69% in the United States, 68% in the United Kingdom, 10% in India and 0.01% in Myanmar. The first doses in the data are on 15 December 2020.

---

## Recommendations

1. **Target resources at the countries with the highest death counts and infection rates.** A few large countries account for the biggest absolute burden, while some small European countries have the highest share of population infected.
2. **Judge severity on a consistent basis.** Compare death percentages only once case counts are large, because early figures (such as Myanmar in April 2020) swing sharply.
3. **Prioritise vaccine supply for countries far behind.** Countries such as India (10%) and Myanmar (0.01%) are far below Israel, the US and the UK.

---

## SQL Techniques Applied

* Filtering and sorting: `WHERE continent IS NOT NULL` to exclude continent and world aggregate rows.
* Aggregation: `MAX`, `SUM`, `GROUP BY`
* Type handling: `CAST(... AS INT)` for text-typed death and vaccination columns
* Joins: `CovidDeaths` joined to `CovidVaccinations` on location and date
* Window function: running total `SUM(...) OVER (PARTITION BY location ORDER BY date)`
* CTE: `population_vs_vaccinations`
* Temporary table: `#PercentPeopleVaccinated`
* View: `PercentPeopleVaccinated`, ready for a BI tool such as Tableau or Power BI

---

## Data Notes

* **The continent query returns the largest single-country figure, not a continent total.** `MAX(total_deaths)` grouped by continent gives for example 576,232 for North America (the US alone). Summing the latest total per country gives 847,942 for North America, 1,016,750 for Europe and 520,286 for Asia. Use `SUM` over each country's maximum for a true continent total.
* **`rolling_people_vaccinated` is cumulative doses, not people.** It sums `new_vaccinations`, so a person with two doses counts twice. This is why Israel reaches 121% and Gibraltar 182%.
* **The temp-table query has no `WHERE continent IS NOT NULL`.** It also loads 4,111 aggregate rows (World, continents, European Union, International). The CTE and the view do filter them out.
* **Death percentage is deaths divided by confirmed cases**, so it depends on testing and is not the risk of dying if infected.
* **Data ends on 30 April 2021**, so the findings do not reflect later waves or vaccine rollouts.

---

## How to Run

1. Import the two source files into a SQL Server database named `PortfolioProject` as `CovidDeaths` and `CovidVaccinations`.
2. Open `covid19_eda.sql` in SSMS and run the queries one at a time.
3. Run the final `CREATE VIEW` once. To recreate it, drop the view first.

---

## Repository Contents

| File | Description |
|---|---|
| `covid19_eda.sql` | All SQL queries |
| `covid_deaths.xlsx` | Dataset: daily cases, deaths and population by location (loads into `CovidDeaths`) |
| `covid_vaccinations.xlsx` | Dataset: daily tests and vaccinations by location (loads into `CovidVaccinations`) |
| `README.md` | Project documentation |
