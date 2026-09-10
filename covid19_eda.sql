--SELECT *
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--ORDER by 3,4
--;

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--WHERE continent IS NOT NULL
--ORDER by 3,4
--;

-- Select data to be used
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2
;

-- Looking at total cases vs total deaths
-- Shows likelihood of dying if infected in Myanmar
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE 'Myanmar'
AND continent IS NOT NULL
ORDER BY 1, 2
;

-- Looking at total cases vs population
-- Shows what percentage of population infected
SELECT location, date, population, total_cases, (total_cases/population)*100 AS case_percentage
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE 'Myanmar'
WHERE continent IS NOT NULL
ORDER BY 1, 2
;

-- Looking at countries with highest infection rate compared to population
SELECT location, population, MAX(total_cases) AS highest_infection_count, MAX(total_cases/population)*100 AS highest_case_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY highest_case_percentage DESC
;

-- Showing countries with highest death counts per population
SELECT location, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC
;

-- Breaking things down by continent
SELECT continent, MAX(CAST(total_deaths AS INT)) AS total_death_count
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC
;

-- Global numbers
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2
;
 -- Across the world
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2
;

--Looking at total population vs vaccination
SELECT death.continent,
death.location,
death.date,
death.population,
vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER(PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_people_vaccinated
FROM PortfolioProject..CovidDeaths death
JOIN PortfolioProject..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
WHERE death.continent IS NOT NULL
ORDER BY 2,3
;

--Using CTE
WITH population_vs_vaccinations(Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
AS
(
SELECT death.continent,
death.location,
death.date,
death.population,
vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER(PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_people_vaccinated
FROM PortfolioProject..CovidDeaths death
JOIN PortfolioProject..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
WHERE death.continent IS NOT NULL
)
SELECT *, (Rolling_People_Vaccinated/Population)*100 AS Rolling_People_Vaccinated_Per_Population
FROM population_vs_vaccinations;

-- Temp table
DROP TABLE IF EXISTS #PercentPeopleVaccinated
CREATE TABLE #PercentPeopleVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
NewVaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPeopleVaccinated
SELECT death.continent,
death.location,
death.date,
death.population,
vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER(PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_people_vaccinated
FROM PortfolioProject..CovidDeaths death
JOIN PortfolioProject..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date

SELECT *, (RollingPeopleVaccinated/Population)*100 AS Rolling_People_Vaccinated_Per_Population
FROM #PercentPeopleVaccinated;

--Creating view  to store data for later visualization
CREATE VIEW PercentPeopleVaccinated AS
SELECT death.continent,
death.location,
death.date,
death.population,
vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS INT)) OVER(PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_people_vaccinated
FROM PortfolioProject..CovidDeaths death
JOIN PortfolioProject..CovidVaccinations vac
	ON death.location = vac.location
	AND death.date = vac.date
WHERE death.continent IS NOT NULL;

--USE PortfolioProject;
--GO
--DROP VIEW IF EXISTS PercentPeopleVaccinated;
--GO

SELECT *
FROM PercentPeopleVaccinated;