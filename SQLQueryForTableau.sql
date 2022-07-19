-- First Query for Global Death Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2

--Second Query for Total Death count per Continent

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
and location not like '%income%'
Group by location
order by TotalDeathCount desc

--Third Query for Percentage of population infected per Country MAX

Select Location, Population, MAX(Cast(total_cases as bigint)) as HighestInfectionCount,  Max((Cast(total_cases as bigint)/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

--Fourth Query for percetage of population infected per country ROLLING

Select Location, Population,date, MAX(Cast(total_cases as bigint)) as HighestInfectionCount,  Max((
Cast(total_cases as bigint)/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc
