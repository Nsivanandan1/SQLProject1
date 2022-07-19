Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
and location not like '%income%'
Group by location
order by TotalDeathCount desc

Select Location, Population, MAX(Cast(total_cases as bigint)) as HighestInfectionCount,  Max((Cast(total_cases as bigint)/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(Cast(total_cases as bigint)) as HighestInfectionCount,  Max((
Cast(total_cases as bigint)/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, date
order by PercentPopulationInfected desc