-- 6) stored procedure: one-button rebuild

DROP PROCEDURE IF EXISTS reporting.refresh_rental_reports();

CREATE OR REPLACE PROCEDURE reporting.refresh_rental_reports()
LANGUAGE plpgsql
AS $$
BEGIN
  TRUNCATE TABLE reporting.rental_summary;
  TRUNCATE TABLE reporting.rental_detail;

  INSERT INTO reporting.rental_detail (
    rental_id, rental_date, return_date, billed_days,
    customer_id, customer_name, store_id, staff_id,
    film_id, film_title, category_name, rental_rate,
    price_tier, amount_usd, payment_count, rental_month
  )
  SELECT
    r.rental_id,
    r.rental_date,
    r.return_date,
    GREATEST(1, (r.return_date::date - r.rental_date::date)) AS billed_days,
    c.customer_id,
    (c.first_name || ' ' || c.last_name) AS customer_name,
    st.store_id,
    r.staff_id,
    f.film_id,
    f.title AS film_title,
    cat.name AS category_name,
    f.rental_rate,
    reporting.price_tier_for_rate(f.rental_rate) AS price_tier,
    ROUND(COALESCE(SUM(p.amount), 0)::numeric, 2) AS amount_usd,
    COUNT(p.payment_id) AS payment_count,
    date_trunc('month', r.rental_date)::date AS rental_month
  FROM public.rental r
  JOIN public.inventory i ON i.inventory_id = r.inventory_id
  JOIN public.film f ON f.film_id = i.film_id
  JOIN public.film_category fc ON fc.film_id = f.film_id
  JOIN public.category cat ON cat.category_id = fc.category_id
  JOIN public.customer c ON c.customer_id = r.customer_id
  JOIN public.store st ON st.store_id = i.store_id
  LEFT JOIN public.payment p ON p.rental_id = r.rental_id
  WHERE r.return_date IS NOT NULL
  GROUP BY
    r.rental_id, r.rental_date, r.return_date,
    c.customer_id, c.first_name, c.last_name,
    st.store_id, r.staff_id,
    f.film_id, f.title, cat.name, f.rental_rate,
    date_trunc('month', r.rental_date)::date;

END;
$$;

-- optional test
-- CALL reporting.refresh_rental_reports();
