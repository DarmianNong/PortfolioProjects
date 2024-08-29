SQL Data Exploration
--------------------

SELECT
	Location,
	date,
	total_cases,
	new_cases,
	total_deaths,
	population
FROM 
	Covid..CovidDeaths$
Order By
	1,2

	--Total Cases vs Total Deaths

SELECT
	Location,
	date,
	total_cases,
	total_deaths,
	(total_deaths)/(total_cases)*100 as death_percnt 
FROM 
	Covid..CovidDeaths$
Order By
	1,2


	--Countries with highest infection rate
SELECT
	Location,
	population,
	Max(total_cases) HighestInfectionCount,
	Max((total_cases)/(population)*100) as infected_pop_percnt 
FROM
	Covid..CovidDeaths$
Group by
	location, population
Order by
	4 desc

	-- Contries with the highest death count per pop
SELECT
	Location,
	Max(cast(total_deaths as integer)) TotalDeathCount
FROM
	Covid..CovidDeaths$
WHERE
	continent is not null
GROUP BY
	location
Order by
	TotalDeathCount desc

-- break things down by continent

-- highest continent with highest death count per population

SELECT
	continent,
	Max(cast(total_deaths as integer)) TotalDeathCount
FROM
	Covid..CovidDeaths$
WHERE
	continent is not null
GROUP BY
	continent
Order by
	TotalDeathCount desc


	-- Global numbers
SELECT
	date,
	sum(new_cases) total_cases,
	sum(cast(new_deaths as integer)) total_deaths,
	sum(cast(new_deaths as integer))/sum(new_cases)*100 as death_percnt 
FROM 
	Covid..CovidDeaths$
WHERE
	continent is not null
GROUP BY
	date
Order By
	1,2

--Total population and vacinations

SELECT 
	dea.continent,
	dea.location,
	dea.date,
	population,
	vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int))over(partition by dea.location Order by dea.Location, dea.date) RollingPeopleVacinated
FROM
	Covid..CovidVaccinations$ vac
JOIN
	Covid..CovidDeaths$ dea
	ON
		vac.location = dea.location
	AND
		vac.date = dea.date
where
	dea.continent is not null
Order by
	2,3



	-- Use CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVacinated)
as
(
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	population,
	vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int))over(partition by dea.location Order by dea.Location, dea.date) RollingPeopleVacinated
FROM
	Covid..CovidVaccinations$ vac
JOIN
	Covid..CovidDeaths$ dea
	ON
		vac.location = dea.location
	AND
		vac.date = dea.date
where
	dea.continent is not null
)
SELECT
	*,
	(RollingPeopleVacinated/population)*100 VaccinatePercnt
FROM 
	PopvsVac

--Temp Table

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVacinated numeric)

INSERT INTO #PercentPopulationVaccinated
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	population,
	vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as int))over(partition by dea.location Order by dea.Location, dea.date) RollingPeopleVacinated
FROM
	Covid..CovidVaccinations$ vac
JOIN
	Covid..CovidDeaths$ dea
	ON
		vac.location = dea.location
	AND
		vac.date = dea.date
where
	dea.continent is not null

SELECT
	*,
	(RollingPeopleVacinated/population)*100 VaccinatePercnt
FROM 
	#PercentPopulationVaccinated
