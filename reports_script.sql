-- 1. Показать всех должников (чей товар доставлен, а сумма по договору
-- не совпадает с суммой по платежам) по договорам с сортировкой по максимальному долгу.

SELECT DISTINCT(org.id), org.name, (ct.amount - pt.amount) AS Debt FROM organization org
  INNER JOIN payment pt on org.id = pt.organization_id
  INNER JOIN contract ct on pt.contract_id = ct.id
  INNER JOIN shipment_product shpr on pt.shipment_product_id = shpr.id
  INNER JOIN shipment sh on shpr.shipment_id = sh.id
WHERE sh.is_delivered = TRUE AND (ct.amount - pt.amount) > 0
ORDER BY (ct.amount - pt.amount) DESC;



-- 2. Показать самых лучших клиентов (принесших большую прибыль)

SELECT org.id, org.name, SUM(pt.amount) AS profit FROM organization org
  INNER JOIN payment pt ON org.id = pt.organization_id
GROUP BY org.id
ORDER BY profit DESC ;

-- 3. Показать самый популярный продукт доставки и количество за месяц

SELECT pr.id, pr.name, SUM(shpr.product_counter) AS total FROM product pr
  INNER JOIN shipment_product shpr on pr.id = shpr.product_id
  INNER JOIN shipment sh on shpr.shipment_id = sh.id
GROUP BY pr.id, sh.date_real
HAVING EXTRACT(MONTH FROM CURRENT_DATE) = EXTRACT(MONTH FROM sh.date_real)
ORDER BY total DESC;

-- 4. Показать самый популярный город доставки.

SELECT Count(*) AS trips_num, loc.id, loc.city FROM location loc
  INNER JOIN payment pt on loc.id = pt.location_id
GROUP BY loc.id
ORDER BY trips_num DESC LIMIT 1;

-- 5. Показать информацию по самым долгим, в плане доставки, направлениям

SELECT loc.id, loc.city, EXTRACT(DAYS FROM MAX(sh.receipt_date_real - sh.shipment_date_real)) AS days FROM location loc
  INNER JOIN payment pt on loc.id = pt.location_id
  INNER JOIN shipment_product shpr on pt.shipment_product_id = shpr.id
  INNER JOIN shipment sh on shpr.shipment_id = sh.id
GROUP BY loc.id;