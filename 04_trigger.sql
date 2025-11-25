-- 5) trigger to maintain summary on INSERT

DROP FUNCTION IF EXISTS reporting.trgfn_rental_detail_after_insert();

CREATE OR REPLACE FUNCTION reporting.trgfn_rental_detail_after_insert()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO reporting.rental_summary (
      category_name,
      rental_month,
      total_rentals,
      total_revenue
  )
  VALUES (
      NEW.category_name,
      NEW.rental_month,
      1,
      NEW.amount_usd
  )
  ON CONFLICT (category_name, rental_month)
  DO UPDATE SET
     total_rentals = reporting.rental_summary.total_rentals + 1,
     total_revenue = reporting.rental_summary.total_revenue + EXCLUDED.total_revenue;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_rental_detail_after_insert ON reporting.rental_detail;

CREATE TRIGGER trg_rental_detail_after_insert
AFTER INSERT ON reporting.rental_detail
FOR EACH ROW
EXECUTE FUNCTION reporting.trgfn_rental_detail_after_insert();
