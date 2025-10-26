-- seleccionar data a usar
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null -- en algunas entradas el continente esta vacio y aparece como location
order by 1,2

-- ver casos totales vs muertos totales por pais, viendo la posibilidad de muerte contrayendo la enfermedad
select location, date, total_cases, total_deaths, (cast(total_deaths as decimal(18,4))/total_cases)*100 as DeathPercentage -- hay que castear aunque sea uno como decimal para que me de resultado decimal
from PortfolioProject..CovidDeaths
where location like '%argentina%'
order by 1,2

-- casos totales vs población
select location, date, population, total_cases, (cast(total_cases as decimal(18,4))/population)*100 as InfectionRate 
from PortfolioProject..CovidDeaths
where location like '%argentina%'
order by 1,2

-- cuales fueron los paises con mayor porcentaje de infección?
select location, population, MAX(total_cases) as HighestInfectionCount, (cast(max(total_cases) as decimal(18,4))/population)*100 as InfectionRate 
from PortfolioProject..CovidDeaths
group by location, population
order by InfectionRate desc

-- cuales fueron los paises con mayor porcentaje de muerte por infección?
select location, MAX(total_deaths) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by HighestDeathCount desc

-- cuales fueron los continentes con mayor porcentaje de muerte por infección?
select continent, MAX(total_deaths) as HighestDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc

-- casos totales vs población
select continent, date, population, total_cases, (cast(total_cases as decimal(18,4))/population)*100 as InfectionRate 
from PortfolioProject..CovidDeaths
where continent is not null
--where location like '%argentina%'
order by 1,2

-- cuales fueron los continentes con mayor porcentaje de infección? ARREGLAR
select continent, population, MAX(total_cases) as HighestInfectionCount, (cast(max(total_cases) as decimal(18,4))/population)*100 as InfectionRate 
from PortfolioProject..CovidDeaths
where continent is not null
group by continent, population
order by InfectionRate desc

-- Numeros Globales
select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, (sum(cast(new_deaths as decimal(18,4)))/sum(new_cases))*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
--order by 1,2

-- Población Vacunada. "RollingPeopleVaccinated" cuenta la cantidad de gente vacunada dia a dia por pais y continente
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location =  vac.location
    and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- usando CTEs
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location =  vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (cast(RollingPeopleVaccinated as decimal(18,4))/population)*100
from PopvsVac
--where location like '%albania%'

-- usando temp tables

drop table if exists #PercentPopulationVaccinated --por si necesito sobreescribirla
create table #PercentPopulationVaccinated
(
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date datetime,
    population numeric,
    new_vaccinations numeric,
    RollingPeopleVaccinated numeric
    )
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location =  vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (cast(RollingPeopleVaccinated as decimal(18,4))/population)*100
from #PercentPopulationVaccinated
where location like '%albania%'

-- crear view para visualizar despues

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
    on dea.location =  vac.location
    and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated