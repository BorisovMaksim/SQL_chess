DROP TABLE IF EXISTS paint_color;


DROP TABLE IF EXISTS drive;


DROP TABLE IF EXISTS transmission;


DROP TABLE IF EXISTS cylinders;


DROP TABLE IF EXISTS SIZE;


DROP TABLE IF EXISTS fuel;


DROP TABLE IF EXISTS cars_info;


CREATE TABLE IF NOT EXISTS cars_info AS
  (SELECT manufacturer,
          model,
          AVG(Price) AS price,
          MAX(TYPE) AS TYPE,
          MIN(YEAR) AS YEAR
   FROM raw_data
   GROUP BY manufacturer,
            model);


ALTER TABLE cars_info ADD COLUMN IF NOT EXISTS model_id SERIAL PRIMARY KEY;


CREATE TABLE IF NOT EXISTS cylinders(id SERIAL REFERENCES cars_info(model_id),
                                                          num_cylinders VARCHAR(100));


CREATE TABLE IF NOT EXISTS fuel(id SERIAL REFERENCES cars_info(model_id),
                                                     fuel VARCHAR(100));


CREATE TABLE IF NOT EXISTS transmission(id SERIAL REFERENCES cars_info(model_id),
                                                             transmission VARCHAR(100));


CREATE TABLE IF NOT EXISTS drive(id SERIAL REFERENCES cars_info(model_id),
                                                      drive VARCHAR(100));


CREATE TABLE IF NOT EXISTS size(id SERIAL REFERENCES cars_info(model_id),
                                                     SIZE VARCHAR(100));


CREATE TABLE IF NOT EXISTS paint_color(id SERIAL REFERENCES cars_info(model_id),
                                                            paint_color VARCHAR(100));


INSERT INTO cylinders
  (SELECT
     (SELECT model_id
      FROM cars_info
      WHERE cars_info.manufacturer = raw_data.manufacturer
        AND cars_info.model = raw_data.model ), cylinders
   FROM raw_data
   GROUP BY manufacturer, model, cylinders);


INSERT INTO fuel
  (SELECT
     (SELECT model_id
      FROM cars_info
      WHERE cars_info.manufacturer = raw_data.manufacturer
        AND cars_info.model = raw_data.model ), fuel
   FROM raw_data
   GROUP BY manufacturer, model, fuel);


INSERT INTO transmission
  (SELECT
     (SELECT model_id
      FROM cars_info
      WHERE cars_info.manufacturer = raw_data.manufacturer
        AND cars_info.model = raw_data.model ), transmission
   FROM raw_data
   GROUP BY manufacturer, model, transmission);


INSERT INTO drive
  (SELECT
     (SELECT model_id
      FROM cars_info
      WHERE cars_info.manufacturer = raw_data.manufacturer
        AND cars_info.model = raw_data.model ), drive
   FROM raw_data
   GROUP BY manufacturer, model, drive);


INSERT INTO size
  (SELECT
     (SELECT model_id
      FROM cars_info
      WHERE cars_info.manufacturer = raw_data.manufacturer
        AND cars_info.model = raw_data.model ), SIZE
   FROM raw_data
   GROUP BY manufacturer, model, SIZE);


INSERT INTO paint_color
  (SELECT
     (SELECT model_id
      FROM cars_info
      WHERE cars_info.manufacturer = raw_data.manufacturer
        AND cars_info.model = raw_data.model ), paint_color
   FROM raw_data
   GROUP BY manufacturer, model, paint_color);


SELECT *
FROM paint_color;
























