CREATE OR REPLACE VIEW used_cars_data AS
  (SELECT cars_info.manufacturer,
          cars_info.model,
          used_cars.price,
          cars_info.year,
          used_cars.cylinders,
          used_cars.fuel,
          used_cars.odometer,
          used_cars. title_status,
          used_cars.transmission,
          used_cars.vin,
          used_cars.drive,
          used_cars.size,
          used_cars.paint_color,
          used_cars.state,
          used_cars.lat,
          used_cars.long,
          used_cars.posting_date,
          used_cars.image_url,
          used_cars.url,
          used_cars.new_cars_id,
          cars_info.model_id,
          used_cars.condition,
          cars_info.type
   FROM used_cars
   JOIN cars_info ON used_cars.model_id = cars_info.model_id);


CREATE OR REPLACE VIEW new_cars_data AS
  (SELECT cars_info.manufacturer,
          cars_info.model,
          new_cars.price,
          cars_info.year,
          new_cars.cylinders,
          new_cars.fuel,
          new_cars.odometer,
          new_cars.title_status,
          new_cars.transmission,
          new_cars.vin,
          new_cars.drive,
          new_cars.size,
          new_cars.paint_color,
          new_cars.state,
          new_cars.lat,
          new_cars.long,
          new_cars.posting_date,
          new_cars.image_url,
          new_cars.url,
          new_cars.new_cars_id,
          cars_info.model_id,
          cars_info.type
   FROM new_cars
   JOIN cars_info ON new_cars.model_id = cars_info.model_id);

-- 1.Найдите производителей Sports Cars. Вывести: марка, модель
-- SUV means sport utility vehicle

SELECT manufacturer,
       model
FROM cars_info
WHERE TYPE = 'SUV';

-- 2.Найти все б/у автомобили 2008 года выпуска.

SELECT *
FROM used_cars_data
WHERE YEAR = 2008;

-- 3.Найдите марки автомобилей, которые не обновлялись с 2007 года.

SELECT used_cars_data.manufacturer,
       used_cars_data.model,
       used_cars_data.year
FROM used_cars_data
JOIN new_cars_data ON used_cars_data.new_cars_id = new_cars_data.new_cars_id
WHERE new_cars_data.year < 2007;

-- 4.Найти всех производителей, которые выпускают и Off Roaders, и Luxory cars.

SELECT DISTINCT manufacturer
FROM cars_info
WHERE TYPE = 'offroad'
  AND manufacturer in
    (SELECT manufacturer
     FROM cars_info
     WHERE TYPE = 'convertible');

-- 5.Найти все автосалоны, торгующие автомобилями трех  и более марок. Вывести название салона и количество представленных марок.
-- У меня в данных нет автосолонов, нашел вместо штаты, торгующие более 1000 марками

SELECT state,
       COUNT(*)
FROM used_cars_data
GROUP BY state
HAVING COUNT(*) >= 1000;

-- 6.Найти автомобили, которые не продаются б/у. Вывести марку, модель.

SELECT manufacturer,
       model
FROM new_cars_data
WHERE model_id NOT IN
    (SELECT model_id
     FROM used_cars);

-- 7.Найдите б/у автомобили, которые потеряли в цене (сравнить с минимальной) более 20%.  Вывести марку, цену нового автомобиля и цену б/у автомобиля.

SELECT used_cars_data.manufacturer,
       used_cars_data.model,
       new_cars_data.price AS new_car_price,
       used_cars_data.price AS used_car_price
FROM used_cars_data
JOIN new_cars_data ON used_cars_data.model_id =new_cars_data.model_id
WHERE used_cars_data.price < 0.8*new_cars_data.price;

-- 8.Найдите минимальную стоимость и название автосалона, где можно посмотреть внедорожник (Off Roaders)до 30000 (из новых).
-- У меня не было новых внедорожников, нашел новые грузовики в штатах (вместо автосалонов)

SELECT DISTINCT state,
                price
FROM new_cars_data
WHERE price =
    (SELECT MIN(price) AS min_price
     FROM new_cars_data
     WHERE TYPE = 'truck')
  AND price < 30000;

-- 9.Найти количество моделей и среднюю цену для каждого класса машин (из новых). Вывести класс, количество моделей и цену. Начать с самого дорогого.

SELECT TYPE,
       COUNT(model) AS count_model,
       AVG(price) AS mean_price
FROM new_cars_data
GROUP BY TYPE
ORDER BY mean_price;

-- 10.Найти модели автомобилей, у которых минимальная цена отличается от максимальной в 2 и более раза.

SELECT model,
       MAX(price),
       MIN(price)
FROM used_cars_data
GROUP BY model
HAVING MAX(price) > 2*MIN(price);

-- 11.Найдите производителя, выпускающего внедорожники, но не выпускающего спортивные машины.

SELECT manufacturer
FROM cars_info
WHERE TYPE = 'truck'
  AND manufacturer NOT in
    (SELECT manufacturer
     FROM cars_info
     WHERE TYPE = 'SUV');

-- 12.Какую долю среди б/у машин составляют машины марки Toyota?

SELECT round(
               (SELECT COUNT(*)
                FROM used_cars_data
                WHERE manufacturer='toyota')::decimal/COUNT(*) * 100, 2)
FROM used_cars_data;

-- 13.Найти наиболее популярный автомобиль для каждого класса (по количеству представленных б/у автомобилей). Вывести марку и модель.
WITH tmp_count AS
  (SELECT TYPE,
          model,
          COUNT(model) AS count_model
   FROM used_cars_data
   GROUP BY TYPE,
            model)
SELECT DISTINCT ON (TYPE) TYPE,
                          model,
                          count_model
FROM tmp_count
ORDER BY TYPE,
         count_model DESC;


