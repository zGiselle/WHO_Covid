select "WHO_region", "Country", "Country_code", to_date("Date_reported",'YYYY-MM-DD') as Date1,"New_cases" as Cases, "New_deaths" as Deaths
, avg("New_cases") over(partition by "WHO_region", "Country" order by "WHO_region", "Country", to_date("Date_reported",'YYYY-MM-DD') rows between 6 preceding and current row) as rolling_cases
, avg("New_deaths") over(partition by "WHO_region", "Country" order by "WHO_region", "Country", to_date("Date_reported",'YYYY-MM-DD') rows between 6 preceding and current row) as rolling_deaths
, case when Country1 is null then 0 else 1 end as "More than 2M cases"
into WHO_Covid_Data_rolling7
from  "WHO-COVID-19-global-data" a
left join  (select "Country" as Country1
                    from "WHO-COVID-19-global-data"
                    group by "Country"
                    having  max("Cumulative_cases") >2000000) b on "Country"=Country1
order by 1,2,4;


