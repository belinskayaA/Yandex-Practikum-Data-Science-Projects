SELECT
    subq.week_number,
    subq.ticket_amount,
    EXTRACT(week FROM (f.festival_date :: date)) AS festival_week,
    f.festival_name
FROM
    (SELECT
        EXTRACT(week FROM (flights.arrival_time :: date)) AS week_number,
        COUNT(ticket_flights.ticket_no) AS ticket_amount
    FROM
        flights
        JOIN airports ON flights.arrival_airport = airports.airport_code
        JOIN ticket_flights ON ticket_flights.flight_id = flights.flight_id
    WHERE
        (flights.arrival_time :: date) BETWEEN  '2018-07-23' AND '2018-09-30'
        AND airports.city = 'Москва'
    GROUP BY
        EXTRACT(week FROM (flights.arrival_time :: date))) as subq
        
    LEFT JOIN 
    (SELECT * 
     FROM festivals 
     WHERE 
        festivals.festival_city = 'Москва') as f
     
     ON EXTRACT(week FROM (f.festival_date :: date)) = subq.week_number;