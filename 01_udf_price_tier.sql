-- 1) UDF
DROP FUNCTION IF EXISTS reporting.price_tier_for_rate(NUMERIC);

CREATE OR REPLACE FUNCTION reporting.price_tier_for_rate(rate NUMERIC)
RETURNS TEXT
LANGUAGE plpgsql
IMMUTABLE
STRICT
AS $$
BEGIN
  IF rate < 1.99 THEN
    RETURN 'Budget';
  ELSIF rate < 4.00 THEN
    RETURN 'Standard';
  ELSE
    RETURN 'Premium';
  END IF;
END;
$$;
