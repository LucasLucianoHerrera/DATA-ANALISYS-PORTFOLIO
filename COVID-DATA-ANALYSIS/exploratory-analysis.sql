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

-- TABLA PARA TABLEAU
-- 1. Crear tabla final de métricas para Tableau (Full-Stack Load)
USE PortfolioProject; -- asegurarse que está en la bbdd correcta
GO

DROP TABLE IF EXISTS GlobalMetrics; 
SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population,
    -- Tasa de infección (EDA)
    (CAST(dea.total_cases AS DECIMAL(18, 4))/dea.population)*100 AS InfectionRate, 
    -- Porcentaje de muerte (EDA)
    (CAST(dea.total_deaths AS DECIMAL(18, 4))/dea.total_cases)*100 AS DeathPercentage, 
    -- Rolling Count de Vacunación (Core Query)
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
INTO GlobalMetrics  -- 🚨 Esto crea la tabla permanente y final
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac 
        ON dea.location = vac.location AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
ORDER BY 
    dea.location, dea.date;
GO

-- 2. Verificar la tabla final
SELECT * FROM GlobalMetrics;


-- 3. Crear tabla de análisis de Embudo (Funnel) de Vacunación a Nivel Continental
USE PortfolioProject; -- asegurarse que está en la bbdd correcta
GO
DROP TABLE IF EXISTS FunnelVaccinationMetrics;

-- 1. CTE: Calcula la población máxima y la vacunación final por ubicación (para desduplicar)
WITH LocationMetrics AS 
(
    SELECT 
        dea.continent,
        dea.location,
        -- Obtiene la población única y los máximos de vacunación para cada ubicación
        MAX(dea.population) AS MaxPopulation,
        MAX(vac.people_vaccinated) AS MaxPeopleVaccinated,
        MAX(vac.people_fully_vaccinated) AS MaxPeopleFullyVaccinated
    FROM 
        PortfolioProject..CovidDeaths dea
    JOIN 
        PortfolioProject..CovidVaccinations vac
            ON dea.location = vac.location AND dea.date = vac.date
    WHERE 
        dea.continent IS NOT NULL
    GROUP BY
        dea.continent, dea.location -- Agrupamos por ubicación
)
-- 2. Consulta Final: Suma los máximos de población y calcula las tasas de conversión
SELECT
    continent,
    SUM(MaxPopulation) AS TotalPopulation, -- Ahora SUMA sobre el MAX ya calculado
    SUM(MaxPeopleVaccinated) AS PeopleWithFirstDose,
    SUM(MaxPeopleFullyVaccinated) AS PeopleFullyVaccinated,
    
    -- Tasa de conversion del 1er paso (poblacion total a primera dosis)
    (CAST(SUM(MaxPeopleVaccinated) AS DECIMAL(18, 4)) / SUM(MaxPopulation)) * 100 AS FirstDoseRate,
    
    -- Tasa de conversion del 2do paso (Primera Dosis -> Dosis Completa)
    (CAST(SUM(MaxPeopleFullyVaccinated) AS DECIMAL(18, 4)) / SUM(MaxPeopleVaccinated)) * 100 AS FullVaccinationConversionRate
INTO FunnelVaccinationMetrics -- Crea la tabla final para el Funnel
FROM
    LocationMetrics -- Usamos los resultados del CTE
GROUP BY
    continent
ORDER BY
    TotalPopulation DESC;
GO

-- Verificar la tabla de Funnel
SELECT * FROM FunnelVaccinationMetrics;

