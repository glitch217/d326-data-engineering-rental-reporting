-- 2) tables

DROP TABLE IF EXISTS reporting.rental_detail CASCADE;

CREATE TABLE reporting.rental_detail (
  rental_id      INTEGER       PRIMARY KEY,
  rental_date    TIMESTAMP     NOT NULL,
  return_date    TIMESTAMP,
  billed_days    INTEGER       NOT NULL,
  customer_id    INTEGER       NOT NULL,
  customer_name  TEXT          NOT NULL,
  store_id       INTEGER       NOT NULL,
  staff_id       INTEGER       NOT NULL,
  film_id        INTEGER       NOT NULL,
  film_title     TEXT          NOT NULL,
  category_name  TEXT          NOT NULL,
  rental_rate    NUMERIC(5,2)  NOT NULL,
  price_tier     TEXT          NOT NULL,
  amount_usd     NUMERIC(10,2) NOT NULL DEFAULT 0,
  payment_count  INTEGER       NOT NULL DEFAULT 0,
  rental_month   DATE          NOT NULL
);

DROP TABLE IF EXISTS reporting.rental_summary CASCADE;

CREATE TABLE reporting.rental_summary (
  category_name  TEXT          NOT NULL,
  rental_month   DATE          NOT NULL,
  total_rentals  INTEGER       NOT NULL,
  total_revenue  NUMERIC(10,2) NOT NULL,
  PRIMARY KEY (category_name, rental_month)
);

-- Index
CREATE INDEX IF NOT EXISTS ix_rental_detail_month_cat
  ON reporting.rental_detail (rental_month, category_name);

-- Integrity checks
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'ck_return_after_rental'
      AND conrelid = 'reporting.rental_detail'::regclass
  ) THEN
    ALTER TABLE reporting.rental_detail
      ADD CONSTRAINT ck_return_after_rental
      CHECK (return_date IS NULL OR return_date >= rental_date);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'ck_billed_days_min'
      AND conrelid = 'reporting.rental_detail'::regclass
  ) THEN
    ALTER TABLE reporting.rental_detail
      ADD CONSTRAINT ck_billed_days_min
      CHECK (billed_days >= 1);
  END IF;
END$$;
