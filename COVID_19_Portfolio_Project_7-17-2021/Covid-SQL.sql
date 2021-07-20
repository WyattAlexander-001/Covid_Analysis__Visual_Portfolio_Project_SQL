Select *
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
Where continent is not null
order by 3,4

--Look at all the data
--Filtering out continents



Select location, date, total_cases, new_cases,total_deaths, population
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
order by 1,2

-- Looking at Data in a general sense.



Select location, date, total_cases, new_cases,total_deaths, (total_deaths/total_cases)* 100 as Death_Percentage
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
order by 1,2

-- Looking at Total Cases vs Total Deaths "Percentage of (Deaths/Cases) * 100 "

Select location, date, total_cases, new_cases,total_deaths, (total_deaths/total_cases)* 100 as Death_Percentage
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
Where location like '%Philippines%'
order by 1,2

--Looking at a specific country, here it is my home country of the Philippines

Select location, date, total_cases, new_cases,total_deaths, population, (total_deaths/total_cases)* 100 as Death_Percentage, (total_cases/population) * 100 as Percent_of_Population_Infected 
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
Where location like '%States%'
order by 1,2

--Looking at a specific country, here it is my home country of the United States, can use '%States%' for short
--Seeing percentage of people who died from total cases
--Seeing percentage of people who are infected relative to the entire country

Select location, MAX(total_cases) as Highest_Infection_Count, population, MAX((total_cases/population)) * 100 as Percent_of_Population_Infected 
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
--Where location like '%States%'
Group by Location, population
order by 1,2

--Looking at countries with HIGHEST infection rate compared to population, defaulted to alphabetical order

Select location, MAX(total_cases) as Highest_Infection_Count, population, MAX((total_cases/population)) * 100 as Percent_of_Population_Infected 
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
--Where location like '%States%'
--Where location like '%Philippines%'
Group by Location, population
order by Percent_of_Population_Infected desc

--Looking at countries with HIGHEST infection rate compared to population, now looking in desc order

Select location, Max(cast(Total_deaths as int)) as Total_Death_Count
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
Where continent is not null
Group by Location
order by Total_Death_Count desc

--Looking at countries with HIGHEST death toll compared to population, now looking in desc order

Select location, Max(cast(Total_deaths as int)) as Total_Death_Count
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
Where continent is null
Group by location
order by Total_Death_Count desc

--Looking at continent with the highest death toll compared to population, now looking in desc order

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Global Numbers
Select date, SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_Deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as Death_Percentage
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
where continent is not null
Group By date
order by 1,2

--Worldwide cases, total deaths, and death percent by day

Select SUM(new_cases) as Total_Cases, SUM(CAST(new_deaths as int)) as Total_Deaths, SUM(CAST(new_deaths as int))/SUM(new_cases) * 100 as Death_Percentage
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$']
where continent is not null
order by 1,2

--Worldwide cases, total deaths, and death percent SUM

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$'] dea
Join Covid_Project_Portfolio..['COVID_Vaccination_Table_7-17-20$'] vac
	On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--Total population vs vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$'] dea
Join Covid_Project_Portfolio..['COVID_Vaccination_Table_7-17-20$'] vac
	On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--Rolling count of vaccinations




With Population_Vs_Vac(Continent, Location, Date, Population, new_vaccinations ,Rolling_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$'] dea
Join Covid_Project_Portfolio..['COVID_Vaccination_Table_7-17-20$'] vac
	On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

Select *, (Rolling_People_Vaccinated/Population) *100 as Percent_of_People_Vac
From Population_Vs_Vac
--Using CTE



Drop Table if exists #Percent_Population_Vacc
Create Table #Percent_Population_Vacc
(
Continent nvarchar (255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert into #Percent_Population_Vacc
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$'] dea
Join Covid_Project_Portfolio..['COVID_Vaccination_Table_7-17-20$'] vac
	On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *, (Rolling_People_Vaccinated/population) * 100
From #Percent_Population_Vacc

--Temp Table



Create View Percent_Population_Vacc as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int)) OVER(Partition by dea.location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
From Covid_Project_Portfolio..['COVID_DEATHS_Table_7-17-2021$'] dea
Join Covid_Project_Portfolio..['COVID_Vaccination_Table_7-17-20$'] vac
	On  dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null



--Creating View to store data for later visualization