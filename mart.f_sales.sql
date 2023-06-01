insert into mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount, status)
select dc.date_id, item_id, customer_id, city_id, quantity, payment_amount, uol.status from staging.user_order_log uol
left join mart.d_calendar as dc on uol.date_time::Date = dc.date_actual
where uol.date_time::Date = '{{ds}}';
UPDATE mart.f_sales
SET status = 'shipped'
WHERE status is null;
UPDATE mart.f_sales
SET payment_amount = payment_amount*(-1)
WHERE status= 'refunded';