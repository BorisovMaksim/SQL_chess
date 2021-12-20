DROP VIEW IF EXISTS used_cars_data;


DROP VIEW IF EXISTS new_cars_data;


DROP TABLE IF EXISTS used_cars;


DROP TABLE IF EXISTS new_cars;


CREATE TABLE IF NOT EXISTS new_cars AS
  (SELECT model_id,
          region,
          raw_data.price,
          cylinders,
          fuel,
          odometer,
          title_status,
          transmission,
          VIN,
          drive,
          SIZE,
          paint_color,
          state,
          lat, long,posting_date,
                    image_url,
                    url
   FROM cars_info
   JOIN raw_data ON cars_info.manufacturer = raw_data.manufacturer
   AND cars_info.model = raw_data.model
   WHERE CONDITION = 'new'
     AND raw_data.price > 0 );


ALTER TABLE new_cars ADD COLUMN IF NOT EXISTS new_cars_id SERIAL PRIMARY KEY;


CREATE TABLE IF NOT EXISTS used_cars AS
  (SELECT model_id,
          region,
          raw_data.price,
          cylinders,
          fuel,
          odometer,
          title_status,
          transmission,
          VIN,
          drive,
          SIZE,
          paint_color,
          state,
          lat, long,posting_date,
                    image_url,
                    url,
                    raw_data.condition
   FROM cars_info
   JOIN raw_data ON cars_info.manufacturer = raw_data.manufacturer
   AND cars_info.model = raw_data.model
   WHERE CONDITION != 'new'
     AND raw_data.price > 0);


ALTER TABLE used_cars ADD COLUMN IF NOT EXISTS used_cars_id SERIAL PRIMARY KEY;


ALTER TABLE used_cars ADD COLUMN IF NOT EXISTS new_cars_id INT;


UPDATE used_cars
SET new_cars_id = temp_id.new_cars_id
FROM
  (SELECT new_cars.new_cars_id,
          new_cars.model_id
   FROM new_cars
   JOIN used_cars ON new_cars.model_id = used_cars.model_id) AS temp_id
WHERE used_cars.model_id = temp_id.model_id;


ALTER TABLE used_cars ADD
FOREIGN KEY (new_cars_id) REFERENCES new_cars(new_cars_id);

