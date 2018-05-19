-- Test all constraints.

-- 1. Максимальный доступный платеж - 500р.
-- Таблица должна быть занесена в БД.
INSERT INTO payment(id, type, date, amount, organization_id, product_id, location_id, contract_id, shipment_id)
VALUES (101, 'some type', '2018-05-15', 300, 10,10,10,10,10);
-- Таблица не должна быть занесена в БД, т.к. не удовлетворяет ограничению.
INSERT INTO payment(id, type, date, amount, organization_id, product_id, location_id, contract_id, shipment_id)
VALUES (103, 'some type', '2018-05-15', 600, 10,10,10,10,10);

-- 2. При заключении договора на сумму, превышающую 1000р вносить информацию по договору в таблицу аудита.
INSERT INTO contract(id, amount, details)
VALUES (101, 1500, 'Some details.');
-- Должна добавиться строка с номером контракта 101.
SELECT * FROM audit;

-- 3. При организации доставки при количестве товаров больше 10, разбивать на 2 доставки с максимальным вложением 10.
INSERT INTO shipment_product(id, shipment_id, product_id, product_counter)
VALUES ((SELECT nextval('shipment_product_id_seq')), 10, 12, 35);
-- В таблице shipment_product вместо одной записи (id, 10, 12, 35)
--  должно появиться 3 записи (id, 10, 12, 10)
--                            (id, 10, 12, 10)
--                            (id, 10, 12, 10)
--                            (id, 10, 12, 5).
SELECT * FROM shipment_product;