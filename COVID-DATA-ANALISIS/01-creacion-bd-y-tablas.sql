--Crear base de datos del proyecto
CREATE DATABASE PortfolioProject;
GO

-- verificar que se creo correctamente
select name
from sys.databases
where name = 'PortfolioProject'; 

-- pararme en la base de datos correcta
USE PortfolioProject;
GO

-- Crear la tabla ajustada a los datos de CovidDeaths.csv
drop table if exists CovidDeaths
CREATE TABLE CovidDeaths (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    -- La fecha viene en formato MM/DD/YYYY, el BULK INSERT debe manejar esto.
    date DATE,
    population BIGINT, -- Población es un número grande sin decimales
    total_cases INT,
    new_cases INT,
    -- Campos que tienen valores decimales (smoothed, per_million, rate)
    new_cases_smoothed DECIMAL(18, 3),
    total_deaths INT,
    new_deaths INT,
    new_deaths_smoothed DECIMAL(18, 3),
    total_cases_per_million DECIMAL(18, 3),
    new_cases_per_million DECIMAL(18, 3),
    new_cases_smoothed_per_million DECIMAL(18, 3),
    total_deaths_per_million DECIMAL(18, 3),
    new_deaths_per_million DECIMAL(18, 3),
    new_deaths_smoothed_per_million DECIMAL(18, 3),
    reproduction_rate DECIMAL(18, 3),
    icu_patients INT,
    icu_patients_per_million DECIMAL(18, 3),
    hosp_patients INT,
    hosp_patients_per_million DECIMAL(18, 3),
    weekly_icu_admissions DECIMAL(18, 3),
    weekly_icu_admissions_per_million DECIMAL(18, 3),
    weekly_hosp_admissions DECIMAL(18, 3),
    weekly_hosp_admissions_per_million DECIMAL(18, 3)
);
GO

-- Insertar archivo csv en tabla
BULK INSERT CovidDeaths
FROM '/tmp/proyectos-data-analisis/CovidDeaths.csv' 
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2            -- Ignora la fila de encabezados
);
GO

-- Verificar que se creo correctamente
SELECT TOP 5 * 
FROM CovidDeaths;

-- Crear la tabla ajustada a los datos de CovidVaccinations.csv
drop table if exists CovidVaccinations
CREATE TABLE CovidVaccinations (
    iso_code VARCHAR(10),
    continent VARCHAR(50),
    location VARCHAR(100),
    date DATE,
    new_tests INT,
    total_tests BIGINT,
    total_tests_per_thousand DECIMAL(18, 3),
    new_tests_per_thousand DECIMAL(18, 3),
    new_tests_smoothed DECIMAL(18, 3),
    new_tests_smoothed_per_thousand DECIMAL(18, 3),
    positive_rate DECIMAL(18, 3),
    tests_per_case DECIMAL(18, 3), -- Puede ser decimal o texto vacío
    tests_units VARCHAR(50),
    total_vaccinations BIGINT,
    people_vaccinated BIGINT,
    people_fully_vaccinated BIGINT,
    new_vaccinations INT,
    new_vaccinations_smoothed INT,
    total_vaccinations_per_hundred DECIMAL(18, 3),
    people_vaccinated_per_hundred DECIMAL(18, 3),
    people_fully_vaccinated_per_hundred DECIMAL(18, 3),
    new_vaccinations_smoothed_per_million DECIMAL(18, 3),
    stringency_index DECIMAL(18, 3),
    population_density DECIMAL(18, 3),
    median_age DECIMAL(18, 3),
    aged_65_older DECIMAL(18, 3),
    aged_70_older DECIMAL(18, 3),
    gdp_per_capita DECIMAL(18, 3),
    extreme_poverty DECIMAL(18, 3),
    cardiovasc_death_rate DECIMAL(18, 3),
    diabetes_prevalence DECIMAL(18, 3),
    female_smokers DECIMAL(18, 3),
    male_smokers DECIMAL(18, 3),
    handwashing_facilities DECIMAL(18, 3),
    hospital_beds_per_thousand DECIMAL(18, 3),
    life_expectancy DECIMAL(18, 3),
    human_development_index DECIMAL(18, 3)
);
GO

-- Insertar archivo csv en tabla
BULK INSERT CovidVaccinations
FROM '/tmp/proyectos-data-analisis/CovidVaccinations.csv' 
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    FIRSTROW = 2            -- Para ignorar la fila de encabezados
);
GO

-- Verificar que se creo correctamente
SELECT TOP 5 * FROM CovidVaccinations;