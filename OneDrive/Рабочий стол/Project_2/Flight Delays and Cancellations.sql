------- flights.airline = airlines.iata_code ----
------- flights.ORIGIN_AIRPORT = airports.IATA_CODE ----

-------Total Number of Flights
SELECT COUNT(*) AS total_flights
FROM flights;

-------Number of Flights by Airline:
SELECT airlines.airline, COUNT(*) AS flight_count
FROM flights
JOIN airlines ON flights.airline = airlines.iata_code
GROUP BY airlines.airline;

-------Joining Flights and Airlines Data
SELECT f.flight_number, a.airline
FROM flights f
JOIN airlines a ON f.airline = a.iata_code;


-------Grouping Flight Data by Airline and Origin Airport	
SELECT f.airline, a.iata_code, f.origin_airport
FROM flights f
JOIN airlines a ON f.airline = a.iata_code
GROUP BY f.airline, a.iata_code, f.origin_airport
ORDER BY f.airline;

-------Calculating Average Departure Delays by Origin Airport
SELECT o.airport AS origin_airport, AVG(f.departure_delay) AS average_departure_delay
FROM flights f
JOIN airports o ON f.origin_airport = o.iata_code
WHERE f.departure_delay IS NOT NULL
GROUP BY o.airport;

-------Ranking Airports by Average Departure Delays
SELECT 
    o.airport AS origin_airport, 
   round( AVG(f.departure_delay)) AS average_departure_delay
FROM 
    flights f
JOIN 
    airports o ON f.origin_airport = o.iata_code
WHERE 
    f.departure_delay IS NOT NULL
GROUP BY 
    o.airport
ORDER BY 
    average_departure_delay desc;


-------Counting Flights in October
SELECT COUNT(*) 
FROM flights
WHERE MONTH = 10;

-------Counting Delayed Flights by Airline
SELECT AIRLINE, COUNT(*) AS NUMBER_OF_DELAYED_FLIGHTS
FROM flights
WHERE ARRIVAL_DELAY > 0
GROUP BY AIRLINE;



-------Counting Cancelled Flights by Airline
select airline, count(cancelled) from flights
where  cancelled=1
group by airline


-------Counting Cancelled Flights by Airline with Joins
SELECT a.airline, f.(count(cancelled))
FROM flights f
JOIN airlines a ON f.airline = a.iata_code
group by a.airline


-------Number of Airports in Each City
SELECT city, COUNT(*) AS airport_count
FROM airports
GROUP BY city
ORDER BY airport_count DESC;


SELECT COUNT(*) AS delay_count
FROM flights
WHERE departure_DELAY > 0;



------------Cancelled Flights by City
SELECT a.CITY, COUNT(*) AS cancelled_flights
FROM flights f
JOIN airports a ON f.ORIGIN_AIRPORT = a.IATA_CODE
WHERE f.CANCELLED = 1
GROUP BY a.CITY
ORDER BY cancelled_flights DESC;

-------Count of Cancelled Flights by Scheduled Departure Time
SELECT SCHEDULED_DEPARTURE, COUNT(*) AS cancelled_flights
FROM flights
WHERE CANCELLED = 1
GROUP BY SCHEDULED_DEPARTURE
ORDER BY SCHEDULED_DEPARTURE;




----------Top 10 Departure Times with the Highest Number of Cancelled Flights
SELECT 
  LPAD(CAST(SCHEDULED_DEPARTURE / 100 AS TEXT), 2, '0') || ':' || LPAD(CAST(SCHEDULED_DEPARTURE % 100 AS TEXT), 2, '0') AS formatted_departure_time, 
  COUNT(*) AS cancelled_flights
FROM flights
WHERE CANCELLED = 1
GROUP BY formatted_departure_time
ORDER BY cancelled_flights DESC
LIMIT 10;




----------Cancelled Flights by 2-Hour Departure Time Range
SELECT 
  CASE 
    WHEN SCHEDULED_DEPARTURE BETWEEN 0 AND 159 THEN '00:00-02:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 200 AND 359 THEN '02:00-04:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 400 AND 559 THEN '04:00-06:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 600 AND 759 THEN '06:00-08:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 800 AND 959 THEN '08:00-10:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 1000 AND 1159 THEN '10:00-12:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 1200 AND 1359 THEN '12:00-14:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 1400 AND 1559 THEN '14:00-16:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 1600 AND 1759 THEN '16:00-18:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 1800 AND 1959 THEN '18:00-20:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 2000 AND 2159 THEN '20:00-22:00'
    WHEN SCHEDULED_DEPARTURE BETWEEN 2200 AND 2359 THEN '22:00-24:00'
  END AS time_range, 
  COUNT(*) AS cancelled_flights
FROM flights
WHERE CANCELLED = 1
GROUP BY time_range
ORDER BY cancelled_flights DESC;




----------Total Number of Diverted Flights
SELECT 
    COUNT(*) AS diverted_flights
FROM flights
WHERE DIVERTED = 1;



----Number of flights per airline
SELECT airline, COUNT(*) 
FROM flights
GROUP BY airline
order by count



----total count of flights per month
SELECT MONTH, COUNT(*) AS flight_count
FROM flights
GROUP BY MONTH
ORDER BY MONTH;

------total count of flights per month_name
SELECT 
    month_name,
    flight_count
FROM (
    SELECT  
        CASE 
            WHEN MONTH = 1 THEN 'January'
            WHEN MONTH = 2 THEN 'February'
            WHEN MONTH = 3 THEN 'March'
            WHEN MONTH = 4 THEN 'April'
            WHEN MONTH = 5 THEN 'May'
            WHEN MONTH = 6 THEN 'June'
            WHEN MONTH = 7 THEN 'July'
            WHEN MONTH = 8 THEN 'August'
            WHEN MONTH = 9 THEN 'September'
            WHEN MONTH = 10 THEN 'October'
            WHEN MONTH = 11 THEN 'November'
            WHEN MONTH = 12 THEN 'December'
        END AS month_name,
        COUNT(*) AS flight_count,
        MONTH
    FROM flights
    GROUP BY  MONTH
) AS subquery
ORDER BY  MONTH;



------To group the flights per season (sksvum e ashnanic)
SELECT  
    CASE 
        WHEN MONTH IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH IN (9, 10, 11) THEN 'Fall'
    END AS season, 
    COUNT(*) AS flight_count
FROM flights
GROUP BY  season
ORDER BY  season;




-------To group the flights per season
SELECT 
    season,
    SUM(flight_count) AS total_flights
FROM (
    SELECT 
        CASE 
            WHEN MONTH IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH IN (6, 7, 8) THEN 'Summer'
            WHEN MONTH IN (9, 10, 11) THEN 'Fall'
        END AS season, 
        COUNT(*) AS flight_count
    FROM flights
    GROUP BY YEAR, 
        CASE 
            WHEN MONTH IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH IN (6, 7, 8) THEN 'Summer'
            WHEN MONTH IN (9, 10, 11) THEN 'Fall'
    END
) AS subquery
GROUP BY season
ORDER BY 
    CASE 
        WHEN season = 'Spring' THEN 1
        WHEN season = 'Summer' THEN 2
        WHEN season = 'Fall' THEN 3
        WHEN season = 'Winter' THEN 4
    END;


------To count the number of flights for each day of the month
SELECT DAY, COUNT(*) AS flight_count
FROM flights
GROUP BY  DAY


-----Count the number of flights departing from each state----------
SELECT airports.STATE, COUNT(flights.FLIGHT_NUMBER) as flight_count
FROM flights
JOIN airports ON flights.ORIGIN_AIRPORT = airports.IATA_CODE
GROUP BY airports.STATE;


---------Identify the flights with the most cancellations
SELECT AIRLINE, COUNT(*) as cancellation_count
FROM flights
WHERE CANCELLED = 1
GROUP BY AIRLINE
ORDER BY cancellation_count DESC;

-------Average Departure Delay by Airline
FROM flights
GROUP BY AIRLINE
ORDER BY avg_delay ASC


--Find the total distance traveled by flights from each airline
SELECT AIRLINE, ROUND(SUM(DISTANCE * 1.60934), 0) as total_distance_km
FROM flights
GROUP BY AIRLINE;


--number of flights for each day of the week,
SELECT 
    CASE 
        WHEN DAY = 1 THEN 'Monday'
        WHEN DAY = 2 THEN 'Tuesday'
        WHEN DAY = 3 THEN 'Wednesday'
        WHEN DAY = 4 THEN 'Thursday'
        WHEN DAY = 5 THEN 'Friday'
        WHEN DAY = 6 THEN 'Saturday'
        WHEN DAY = 7 THEN 'Sunday'
    END as DAY_OF_WEEK,
    COUNT(*) as flight_count
FROM flights
WHERE DAY BETWEEN 1 AND 7
GROUP BY DAY
ORDER BY flight_count DESC;

-----Delayed Flights by Airline
SELECT AIRLINE, COUNT(*) as delayed_flights
FROM flights
WHERE DEPARTURE_DELAY > 0
GROUP BY AIRLINE
ORDER BY delayed_flights DESC


-------Average Taxi-Out Time by Airline
SELECT AIRLINE, round(AVG(TAXI_OUT),0) as avg_taxi_out_time
FROM flights
GROUP BY AIRLINE
ORDER BY avg_taxi_out_time DESC;

--------Average Departure Delay by Origin Airport
SELECT o.airport AS origin_airport, AVG(f.departure_delay) AS average_departure_delay
FROM flights f
JOIN airports o ON f.origin_airport = o.iata_code
WHERE f.departure_delay IS NOT NULL
GROUP BY o.airport;



-------Total Arrival Delays by Airline
SELECT a.airline, COUNT(f.arrival_delay) AS total_delays
FROM flights f
JOIN airlines a ON f.airline = a.iata_code
WHERE f.arrival_delay > 0
GROUP BY a.airline;


---------Average Taxi-Out Time by Airline
SELECT AIRLINE, round(AVG(TAXI_OUT),0) as avg_taxi_out_time
FROM flights
GROUP BY AIRLINE
ORDER BY avg_taxi_out_time DESC;


-----------Average Taxi-IN Time by Airline
SELECT AIRLINE, round(AVG(TAXI_IN),0) as avg_taxi_in_time
FROM flights
GROUP BY AIRLINE
ORDER BY avg_taxi_in_time DESC;


-----Cancellation Count by Season
SELECT 
    CASE 
        WHEN MONTH IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH IN (9, 10, 11) THEN 'Fall'
    END AS SEASON,
    COUNT(*) AS CANCELLATION_COUNT
FROM flights
WHERE CANCELLED = 1
GROUP BY SEASON
ORDER BY CANCELLATION_COUNT DESC;



--------Flight Count by Season
SELECT 
    CASE 
        WHEN MONTH IN (12, 1, 2) THEN 'Winter'
        WHEN MONTH IN (3, 4, 5) THEN 'Spring'
        WHEN MONTH IN (6, 7, 8) THEN 'Summer'
        WHEN MONTH IN (9, 10, 11) THEN 'Fall'
    END AS SEASON,
    COUNT(*) AS flight_count
FROM flights
GROUP BY SEASON
ORDER BY flight_count DESC;


--------Monthly Flight Count
SELECT 
    month_name,
    flight_count
FROM (
    SELECT  
        CASE 
            WHEN MONTH = 1 THEN 'January'
            WHEN MONTH = 2 THEN 'February'
            WHEN MONTH = 3 THEN 'March'
            WHEN MONTH = 4 THEN 'April'
            WHEN MONTH = 5 THEN 'May'
            WHEN MONTH = 6 THEN 'June'
            WHEN MONTH = 7 THEN 'July'
            WHEN MONTH = 8 THEN 'August'
            WHEN MONTH = 9 THEN 'September'
            WHEN MONTH = 10 THEN 'October'
            WHEN MONTH = 11 THEN 'November'
            WHEN MONTH = 12 THEN 'December'
        END AS month_name,
        COUNT(*) AS flight_count,
        MONTH
    FROM flights
	
    GROUP BY  MONTH
) AS subquery
ORDER BY  MONTH;



------Count of Flight Cancellations by Reason"
select cancellation_reason , count(*) 
from flights
where cancellation_reason in ('A','B','C','D')
group by  cancellation_reason


------Count of Flight Cancellations by Detailed Reason
SELECT   
    CASE 
        WHEN CANCELLATION_REASON = 'A' THEN 'Carrier related(A)' 
        WHEN CANCELLATION_REASON = 'B' THEN 'Weather related(B)' 
        WHEN CANCELLATION_REASON = 'C' THEN 'National Air System related(C)' 
        WHEN CANCELLATION_REASON = 'D' THEN 'Security related(D)' 
    END AS Reason_Name,
	COUNT(CANCELLATION_REASON) AS Count
FROM 
    flights
WHERE 
    CANCELLATION_REASON IN ('A', 'B', 'C', 'D')
GROUP BY 
    CANCELLATION_REASON;




-----Creating and Populating the Cancellation Reason Table
drop table if exists cancellation_reason;
create table cancellation_reason (
	reason_id serial primary key,
	reason_class varchar(1),
	reason_name varchar(50)
);

-- flight_id(serial)
-- airline - airline_id
-- origin_airport - airport_id
-- destination_airport - airport_id

insert into cancellation_reason(reason_class, reason_name)
values ('A', 'Carrier'), ('B', 'Weather'), ('C', 'NAS'), ('D', 'Security');


-------Viewing Cancellation Reason Table and Yearly Flight Cancellations
select * from cancellation_reason

SELECT 
    YEAR, 
    COUNT(*) AS total_flights, 
    SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) AS total_cancellations
FROM 
    flights
GROUP BY 
    YEAR;


-------Quarterly Flight and Cancellation Totals by Year
SELECT 
    YEAR, 
    CEILING(MONTH / 3.0) AS quarter,
    COUNT(*) AS total_flights, 
    SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) AS total_cancellations
FROM 
    flights
GROUP BY 
    YEAR, 
    CEILING(MONTH / 3.0);


-----------Average Departure and Arrival Delays by Airline
SELECT 
    AIRLINE, 
    ROUND(AVG(DEPARTURE_DELAY), 1) AS avg_departure_delay,
    ROUND(AVG(ARRIVAL_DELAY), 1) AS avg_arrival_delay
FROM 
    flights
GROUP BY 
    AIRLINE
ORDER BY 
    avg_departure_delay ASC, 
    avg_arrival_delay ASC;


-------Average Arrival Delay by Airline with Airline Names
SELECT 
    airlines.AIRLINE AS Airline, 
    round(AVG(flights.ARRIVAL_DELAY),1) AS Average_Delay
FROM 
    flights
JOIN 
    airlines 
ON 
    flights.AIRLINE = airlines.IATA_CODE
GROUP BY 
    airlines.AIRLINE;


--------Top 10 Origin Airports by Number of Flights
SELECT ORIGIN_AIRPORT, COUNT(*) AS NUMBER_OF_FLIGHTS
FROM flights
GROUP BY ORIGIN_AIRPORT
ORDER BY NUMBER_OF_FLIGHTS DESC
LIMIT 10;



-----Average Delay by Month and Airline   
SELECT
    MONTH,
    AIRLINE,
    AVG(ARRIVAL_DELAY) AS AVERAGE_DELAY
FROM
    flights
WHERE
    ARRIVAL_DELAY IS NOT NULL
GROUP BY
    MONTH,
    AIRLINE
ORDER BY
    MONTH,
    AIRLINE;




---Total Delay by Month and Airline
SELECT
    MONTH,
    AIRLINE,
    SUM(ARRIVAL_DELAY) AS TOTAL_DELAY
FROM
    flights
WHERE
    ARRIVAL_DELAY IS NOT NULL
GROUP BY
    MONTH,
    AIRLINE
ORDER BY
    MONTH,
    AIRLINE;


-----Number of Delayed Flights by Month and Airline
SELECT
    MONTH,
    AIRLINE,
    COUNT(*) AS NUMBER_OF_DELAYED_FLIGHTS
FROM
    flights
WHERE
    ARRIVAL_DELAY > 0
GROUP BY
    MONTH,
    AIRLINE
ORDER BY
    MONTH,
    AIRLINE;


------Total Arrival Delay by Taxi-in Time for Each Airline
SELECT
    AIRLINE,
    TAXI_IN,
    SUM(ARRIVAL_DELAY) AS total_arrival_delay
FROM
    flights
GROUP BY
    AIRLINE, TAXI_IN
ORDER BY
    AIRLINE, TAXI_IN;


--- Departure and Arrival Delay by Month
SELECT
    MONTH,
    SUM(DEP_DELAY) AS total_departure_delay,
    SUM(ARRIVAL_DELAY) AS total_arrival_delay
FROM
    flights
WHERE
    CANCELLED = 0 -- Exclude cancelled flights
    AND DIVERTED = 0 -- Exclude diverted flights
GROUP BY
    MONTH
ORDER BY
    MONTH;


---- Average Delays by Month
SELECT
    MONTH,
    AVG(DEP_DELAY) AS avg_departure_delay,
    AVG(ARRIVAL_DELAY) AS avg_arrival_delay
FROM
    flights
WHERE
    CANCELLED = 0 -- Exclude cancelled flights
    AND DIVERTED = 0 -- Exclude diverted flights
GROUP BY
    MONTH
ORDER BY
    MONTH;


----------Delays by Origin Airport
SELECT
    ORIGIN_AIRPORT,
    SUM(DEP_DELAY) AS total_departure_delay,
    SUM(ARRIVAL_DELAY) AS total_arrival_delay
FROM
    flights
WHERE
    CANCELLED = 0
    AND DIVERTED = 0
GROUP BY
    ORIGIN_AIRPORT
ORDER BY
    ORIGIN_AIRPORT;



--------Count of Different Delay Types in Flights
SELECT
    COUNT(AIR_SYSTEM_DELAY) AS air_system_delay_count,
    COUNT(CASE WHEN SECURITY_DELAY IS NOT NULL THEN 1 END) AS security_delay_count,
    COUNT(CASE WHEN AIRLINE_DELAY IS NOT NULL THEN 1 END) AS airline_delay_count,
    COUNT(CASE WHEN LATE_AIRCRAFT_DELAY IS NOT NULL THEN 1 END) AS late_aircraft_delay_count,
    COUNT(CASE WHEN WEATHER_DELAY IS NOT NULL THEN 1 END) AS weather_delay_count
FROM
    flights;



-----Number of Departure Delays by Airline
SELECT AIRLINE, COUNT(*) AS number_of_departure_delays
FROM flights
WHERE DEPARTURE_DELAY > 0
GROUP BY AIRLINE;



--------- Arrival Delays By Full Airline Name
SELECT a.AIRLINE, COUNT(*) AS number_of_arrival_delays
FROM flights f
JOIN airlines a ON f.AIRLINE = a.IATA_CODE
WHERE ARRIVAL_DELAY > 0
GROUP BY a.AIRLINE;



-------Departure Delays By Full Airline Name
SELECT a.AIRLINE, COUNT(*) AS number_of_departure_delays
FROM flights f
JOIN airlines a ON f.AIRLINE = a.IATA_CODE
WHERE DEPARTURE_DELAY > 0
GROUP BY a.AIRLINE;


-------Count of Diverted Flights by Airline
SELECT airline,COUNT(*) AS diverted_flights_count
FROM flights
WHERE DIVERTED = 1
group by airline


--------Monthly Count of Delayed Flights
SELECT month, count(arrival_delay) AS delayed_flights_count
FROM flights
WHERE ARRIVAL_DELAY > 0
group by month


------Total Arrival Delays by State
SELECT a.STATE, count(f.ARRIVAL_DELAY) AS TOTAL_DELAY
FROM flights f
JOIN airports a ON f.ORIGIN_AIRPORT = a.IATA_CODE
GROUP BY a.STATE
ORDER BY TOTAL_DELAY DESC



-----Top 10 States with the Fewest Delayed Flights
SELECT a.STATE, COUNT(f.ARRIVAL_DELAY) AS DELAY_COUNT
FROM flights f
JOIN airports a ON f.ORIGIN_AIRPORT = a.IATA_CODE
WHERE f.ARRIVAL_DELAY > 0
GROUP BY a.STATE
ORDER BY DELAY_COUNT ASC
LIMIT 10;



-----Top 10 Cities with the Most Arrival Delays
SELECT 
    airports.CITY,
    count(flights.ARRIVAL_DELAY) AS ARRIVAL_DELAY
FROM 
    flights
JOIN 
    airports ON   flights.DESTINATION_AIRPORT = airports.IATA_CODE
WHERE 
    flights.ARRIVAL_DELAY > 0
GROUP BY 
    airports.CITY
ORDER BY 
    ARRIVAL_DELAY DESC
LIMIT 10;








