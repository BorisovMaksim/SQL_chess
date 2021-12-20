DROP FUNCTION help_customer(CHARACTER varying,CHARACTER varying);

-- 1. Найти самую дорогую машину и самую дешевую для каждого класса.
-- Вывести результат в виде таблицы я полями: класс, самая дорогая машина (цена, марка, модель)
-- и самая дешевая машина (цена, марка, модель).

CREATE OR REPLACE VIEW max_min_price AS
  (WITH max_price AS
     (SELECT DISTINCT ON (TYPE) TYPE,
                                model AS model_max,
                                price AS price_max,
                                manufacturer AS manufacturer_max
      FROM cars_info
      ORDER BY TYPE,
               price DESC),
        min_price AS
     (SELECT DISTINCT ON (TYPE) TYPE,
                                model AS model_min,
                                price AS price_min,
                                manufacturer AS manufacturer_min
      FROM cars_info
      WHERE price > 100
      ORDER BY TYPE,
               price ASC) SELECT max_price.type,
                                 max_price.manufacturer_max,
                                 max_price.model_max,
                                 max_price.price_max,
                                 min_price.manufacturer_min,
                                 min_price.model_min,
                                 min_price.price_min
   FROM max_price
   JOIN min_price ON max_price.type = min_price.type);

-- Проследить динамику падения цен на автомобиль.
-- Вывести все модели, имеющиеся на вторичном рынке,
-- в порядке убывания скорости падения цены.

CREATE OR REPLACE VIEW dynamics_view AS
  (WITH diffs AS
     (SELECT model,
             price - lag(price) OVER (PARTITION BY model
                                      ORDER BY posting_date) AS difference
      FROM used_cars_data) SELECT model,
                                  SUM(difference)::decimal/ COUNT(difference) AS all_diffs
   FROM diffs
   WHERE difference < 0
   GROUP BY model
   ORDER BY all_diffs);

-- Помогите потенциальному покупателю, который подобрал автомобиль на первичном рынке,
-- найти альтернативы на вторичном:
-- по ID автомобиля (или по марке/модели) найти предложения на вторичном рынке,
-- ближайшие по цене (вывести top10)

CREATE OR REPLACE FUNCTION help_customer(manufacturer_new VARCHAR(100), model_new VARCHAR(100)) 
RETURNS TABLE(manufacturer VARCHAR(100), model VARCHAR(100), price BIGINT, price_diff BIGINT) AS $$
DECLARE
model_id_new INT = (SELECT model_id FROM new_cars_data
				WHERE new_cars_data.model = model_new
			   AND new_cars_data.manufacturer = manufacturer_new LIMIT 1);
price_new INT =  (SELECT new_cars_data.price FROM new_cars_data
				WHERE new_cars_data.model = model_new
			   AND new_cars_data.manufacturer = manufacturer_new LIMIT 1);
BEGIN
RETURN QUERY
SELECT  used_cars_data.manufacturer,used_cars_data.model, used_cars_data.price, ABS(used_cars_data.price - price_new) as price_diff
        FROM used_cars_data
		WHERE used_cars_data.model = used_cars_data.model AND
		used_cars_data.manufacturer = used_cars_data.manufacturer
		ORDER BY price_diff
		LIMIT 10;
END;
$$ LANGUAGE PLPGSQL;


SELECT *
FROM help_customer('ford', 'ranger');

-- Триггер
-- При выпуске новой версии модели автомобиля уменьшить
-- стоимость б/у автомобилей той же модели на 5%

CREATE OR REPLACE FUNCTION update_price() RETURNS TRIGGER AS $func$
BEGIN
UPDATE used_cars SET price = 0.95*price
WHERE model_id = NEW.model_id;
   RETURN NEW;
END
$func$ LANGUAGE PLPGSQL;


DROP TRIGGER IF EXISTS reduce_used_cars_price ON new_cars;


CREATE TRIGGER reduce_used_cars_price
BEFORE
INSERT ON new_cars
FOR EACH ROW EXECUTE PROCEDURE update_price();


INSERT INTO new_cars
VALUES (1039,'orange county', 10000,'6 cylinders','gas', 6775, 'clean', 'automatic', '3N6CM0KN8JK702570', 'fwd', 'compact', 'white', 'ca', 33.806416, -117.863946, '2021-04-27 14:31:14', 'some_url', 'another_url', 1004);


SELECT *
FROM used_cars
WHERE model_id = 1039;









