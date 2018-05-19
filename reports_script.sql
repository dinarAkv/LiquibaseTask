-- 1. Показать всех должников (чей товар доставлен, а сумма по договору
-- не совпадает с суммой по платежам) по договорам с сортировкой по максимальному долгу.

CREATE MATERIALIZED VIEW debtors_list AS
  SELECT DISTINCT(org.id), org.name, (ct.amount - pt.amount) AS Debt FROM organization org
    INNER JOIN payment pt on org.id = pt.organization_id
    INNER JOIN contract ct on pt.contract_id = ct.id
    INNER JOIN shipment_product shpr on pt.shipment_product_id = shpr.id
    INNER JOIN shipment sh on shpr.shipment_id = sh.id
  WHERE sh.is_delivered = TRUE AND (ct.amount - pt.amount) > 0
  ORDER BY (ct.amount - pt.amount) DESC;

REFRESH MATERIALIZED VIEW debtors_list;



-- 2. Показать самых лучших клиентов (принесших большую прибыль)

CREATE MATERIALIZED VIEW best_clients AS
  SELECT org.id, org.name, SUM(pt.amount) AS profit FROM organization org
    INNER JOIN payment pt ON org.id = pt.organization_id
  GROUP BY org.id
  ORDER BY profit DESC;

REFRESH MATERIALIZED VIEW best_clients;

-- 3. Показать самый популярный продукт доставки и количество за месяц

CREATE MATERIALIZED VIEW most_popular_product_in_current_month AS
  SELECT pr.id, pr.name, SUM(shpr.product_counter)
    AS total, to_char(sh.shipment_date_real, 'Month') AS Month FROM product pr
    INNER JOIN shipment_product shpr on pr.id = shpr.product_id
    INNER JOIN shipment sh on shpr.shipment_id = sh.id
  GROUP BY pr.id, sh.shipment_date_real
  HAVING EXTRACT(MONTH FROM CURRENT_DATE) = EXTRACT(MONTH FROM sh.shipment_date_real)
  ORDER BY total DESC;

REFRESH MATERIALIZED VIEW most_popular_product_in_current_month;

-- 4. Показать самый популярный город доставки.

CREATE MATERIALIZED VIEW most_popular_city AS
  SELECT Count(*) AS trips_num, loc.id, loc.city FROM location loc
    INNER JOIN payment pt on loc.id = pt.location_id
  GROUP BY loc.id
  ORDER BY trips_num DESC LIMIT 1;

REFRESH MATERIALIZED VIEW most_popular_city;

-- 5. Показать информацию по самым долгим, в плане доставки, направлениям

CREATE MATERIALIZED VIEW longest_destination AS
  SELECT loc.id, loc.city, EXTRACT(DAYS FROM MAX(sh.receipt_date_real - sh.shipment_date_real)) AS days FROM location loc
    INNER JOIN payment pt on loc.id = pt.location_id
    INNER JOIN shipment_product shpr on pt.shipment_product_id = shpr.id
    INNER JOIN shipment sh on shpr.shipment_id = sh.id
  GROUP BY loc.id;

REFRESH MATERIALIZED VIEW longest_destination;