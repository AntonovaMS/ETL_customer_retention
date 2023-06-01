CREATE OR REPLACE VIEW mart.f_customer_retention AS
select new_customers_count, 
	   returning_customers_count, 
	   refunded_customer_count,
	   'weekly' as period_name,
	   t10.week_of_year as period_id, 
	   new_customers_revenue, 
	   returning_customers_revenue,
	   customers_refunded 
-----------new_customers_count------------
from (SELECT week_of_year, count(*) as new_customers_count
FROM(SELECT customer_id, DC.WEEK_OF_YEAR, COUNT(customer_id) AS C
FROM mart.f_sales fs2 
JOIN mart.d_calendar dc 
ON DC.DATE_ID = FS2.DATE_ID
WHERE STATUS = 'shipped'
GROUP BY customer_id,DC.WEEK_OF_YEAR)T1
WHERE C = 1
group by week_of_year)t10
------------returning_customers_count----------
join (SELECT week_of_year, count(*) as returning_customers_count
FROM(SELECT customer_id, DC.WEEK_OF_YEAR, COUNT(customer_id) AS C
FROM mart.f_sales fs2 
JOIN mart.d_calendar dc 
ON DC.DATE_ID = FS2.DATE_ID
WHERE STATUS = 'shipped'
GROUP BY customer_id,DC.WEEK_OF_YEAR)T1
WHERE C between 1 and 4
group by week_of_year)t11
on t10.week_of_year = t11.week_of_year
------------refunded_customer_count-------
join(SELECT week_of_year, count(*) as refunded_customer_count
FROM(SELECT customer_id, DC.WEEK_OF_YEAR, COUNT(customer_id) AS C
FROM mart.f_sales fs2 
JOIN mart.d_calendar dc 
ON DC.DATE_ID = FS2.DATE_ID
WHERE STATUS = 'refunded'
GROUP BY customer_id,DC.WEEK_OF_YEAR)T1
group by week_of_year)t12
on t10.week_of_year = t12.week_of_year
--------------new_customers_revenue-------------
join(select t2.week_of_year, sum(fs3.payment_amount) as new_customers_revenue
from(SELECT week_of_year, customer_id
FROM(SELECT customer_id, DC.WEEK_OF_YEAR, COUNT(customer_id) AS C
FROM mart.f_sales fs2 
JOIN mart.d_calendar dc 
ON DC.DATE_ID = FS2.DATE_ID
WHERE STATUS = 'shipped'
GROUP BY customer_id,DC.WEEK_OF_YEAR)T1
WHERE C = 1)t2
join mart.f_sales fs3 on fs3.customer_id= t2.customer_id
group by t2.week_of_year)t13
on t10.week_of_year = t13.week_of_year
----------------returning_customers_revenue-------------
join(select t2.week_of_year, sum(fs3.payment_amount) as returning_customers_revenue
from(SELECT week_of_year, customer_id
FROM(SELECT customer_id, DC.WEEK_OF_YEAR, COUNT(customer_id) AS C
FROM mart.f_sales fs2 
JOIN mart.d_calendar dc 
ON DC.DATE_ID = FS2.DATE_ID
WHERE STATUS = 'shipped'
GROUP BY customer_id,DC.WEEK_OF_YEAR)T1
WHERE C between 1 and 4)t2
join mart.f_sales fs3 on fs3.customer_id= t2.customer_id
group by t2.week_of_year)t14
on t10.week_of_year = t14.week_of_year
------------customers_refunded-----------
join(SELECT week_of_year, sum(C) as customers_refunded
FROM(SELECT customer_id, DC.WEEK_OF_YEAR, COUNT(customer_id) AS C
FROM mart.f_sales fs2 
JOIN mart.d_calendar dc 
ON DC.DATE_ID = FS2.DATE_ID
WHERE STATUS = 'refunded'
GROUP BY customer_id,DC.WEEK_OF_YEAR)T1
group by week_of_year)t15
on t10.week_of_year = t15.week_of_year;