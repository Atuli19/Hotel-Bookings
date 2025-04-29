create database hotelbookings;
use hotelbookings;
show tables;

select * from hotel;
--  1.Which hotel has the highest average daily rate (ADR)?
SELECT hotel, AVG(adr) AS avg_adr
FROM hotel
GROUP BY hotel
ORDER BY avg_adr DESC
LIMIT 1;

-- 2. What is the cancellation rate per hotel type?
SELECT hotel,
       ROUND(SUM(is_canceled) * 100.0 / COUNT(*), 2) AS cancellation_rate
FROM hotel
GROUP BY hotel;

-- 3. Which months have the highest number of bookings (excluding cancellations)?
SELECT arrival_date_month,
       COUNT(*) AS total_bookings
FROM hotel
WHERE is_canceled = 0
GROUP BY arrival_date_month
ORDER BY total_bookings DESC;

-- 4. Top 5 countries by number of guests (excluding cancellations)?
SELECT country,
       COUNT(*) AS total_guests
FROM hotel
WHERE is_canceled = 0
GROUP BY country
ORDER BY total_guests DESC
LIMIT 5;

-- 5. Most frequently reserved room type and its average price (CTE example)?
WITH room_stats AS (
  SELECT reserved_room_type, COUNT(*) AS count, AVG(adr) AS avg_price
  FROM hotel
  GROUP BY reserved_room_type
)
SELECT *
FROM room_stats
ORDER BY count DESC
LIMIT 1;

-- 6.How many bookings are repeated guests vs. new?
SELECT is_repeated_guest, COUNT(*) AS booking_count
FROM hotel
GROUP BY is_repeated_guest;

-- 7. Which distribution channels result in the highest cancellations?
SELECT distribution_channel,
       COUNT(*) AS total_bookings,
       SUM(is_canceled) AS total_cancellations,
       ROUND(SUM(is_canceled)*100.0 / COUNT(*), 2) AS cancellation_rate
FROM hotel
GROUP BY distribution_channel
ORDER BY cancellation_rate DESC;

-- 8. Bookings that stayed more than 7 nights (week + weekend)?
SELECT *
FROM hotel
WHERE stays_in_weekend_nights + stays_in_week_nights > 7;

-- 9. Which customer type generates the most revenue (based on ADR)?
SELECT customer_type,
       ROUND(SUM(adr), 2) AS total_revenue
FROM hotel
WHERE is_canceled = 0
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- 10. Car parking demand per hotel (JOIN simulation with summary)?
SELECT hotel,
       SUM(required_car_parking_spaces) AS total_parking_spaces
FROM hotel
GROUP BY hotel;

-- 11. Top 5 agents by confirmed bookings (exclude canceled)?
SELECT agent, COUNT(*) AS confirmed_bookings
FROM hotel
WHERE is_canceled = 0 AND agent IS NOT NULL
GROUP BY agent
ORDER BY confirmed_bookings DESC
LIMIT 5;

-- 12.Compare average lead time by hotel type (CTE and grouping)? 
WITH avg_lead AS (
  SELECT hotel, AVG(lead_time) AS avg_lead_time
  FROM hotel
  GROUP BY hotel
)
SELECT * FROM avg_lead;
