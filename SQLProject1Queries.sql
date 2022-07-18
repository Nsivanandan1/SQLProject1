Select * 
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4


-- Getting the data we need
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2
-- Comparing total cases to total deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
and location like '%Kingdom%'
order by 1,2

--Comparing total cases to population
Select location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
From PortfolioProject..CovidDeaths
Where continent is not null
and location like '%Kingdom%'
order by 1,2

-- Finding countries withs most cases against population
Select location, MAX(total_cases) as InfectionCount, population, MAX(total_cases/population)*100 as CasePercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location, population
order by 4 desc


--Countries with the highest death count 
Select location , MAX(cast(total_deaths as bigint)) as deathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by 2 desc

--Continents with the highest death count 
Select location , MAX(cast(total_deaths as bigint)) as deathCount
From PortfolioProject..CovidDeaths
Where continent is null
and location not like '%income%'
Group by location
order by 2 desc

--Global numbers
Select date, SUM(new_cases) as totalCases,SUM(cast(new_deaths as bigint)) as totalDeaths, 
SUM(cast(new_deaths as bigint)) / SUM(new_cases) *100 as totaldeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
Group by date
order by 1

--Global numbers total
Select SUM(new_cases) as totalCases,SUM(cast(new_deaths as bigint)) as totalDeaths, 
SUM(cast(new_deaths as bigint)) / SUM(new_cases) *100 as totaldeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1

--Joining vaccinations and deaths tables

Select * 
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

-- Looking for Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingVaccinationCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--Using CTE

With PopvsVac(continent, location, date, population,new_vaccinations, RollingVaccinationCount) as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingVaccinationCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

)
Select *, (RollingVaccinationCount/population)*100 as RollingPercentVaccinated
From PopvsVac
Order by 2,3


--Temp Table insted
Drop Table  if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric, 
new_vaccinations numeric, 
RollingVaccinationCount numeric, 
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingVaccinationCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

Select *, (RollingVaccinationCount/population)*100 as RollingPercentVaccinated
From #PercentPopulationVaccinated
Order by 2,3

--Creating View to store data


Create View PercentPopulationVaccinated as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingVaccinationCount
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)

Select * 
From PercentPopulationVaccinated
