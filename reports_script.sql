-- 1. Показать всех должников (чей товар доставлен, а сумма по договору
-- не совпадает с суммой по платежам) по договорам с сортировкой по максимальному долгу.
SELECT org.id, org.name, (ct.amount - pt.amount) AS Debt FROM organization org
  INNER JOIN payment pt on org.id = pt.organization_id
  INNER JOIN contract ct on pt.contract_id = ct.id
  INNER JOIN shipment sh on pt.shipment_id = sh.id
WHERE sh.is_delivered = TRUE
ORDER BY (ct.amount - pt.amount) DESC



-- 4. Показать самый популярный город доставки.

SELECT Count(*) AS trips_num, loc.id, loc.city FROM location loc
  INNER JOIN payment pt on loc.id = pt.location_id
GROUP BY loc.id
ORDER BY trips_num DESC LIMIT 1;
