DROP TABLE IF EXISTS Cars;
DROP TABLE IF EXISTS raw_data;

CREATE TABLE IF NOT EXISTS raw_data (
	id BIGINT PRIMARY KEY,
	url VARCHAR(200),
	region VARCHAR(100),
	region_url VARCHAR(200),
	price BIGINT,
	year int,
	manufacturer  VARCHAR(100),
	model  VARCHAR(500),
	condition  VARCHAR(100),
	cylinders  VARCHAR(100),
	fuel  VARCHAR(100),
	odometer INT,
	title_status  VARCHAR(100),
	transmission  VARCHAR(100),
	VIN  VARCHAR(100),
	drive  VARCHAR(100),
	size  VARCHAR(100),
	type  VARCHAR(100),
	paint_color  VARCHAR(100),
	image_url  VARCHAR(200),
	description  text,
	county  VARCHAR(100),
	state  VARCHAR(100),
	lat FLOAT,
	long FLOAT,
	posting_date timestamp
);

COPY raw_data(id, url, region, region_url, price, YEAR, manufacturer, model, CONDITION, cylinders, fuel, odometer, title_status, transmission, VIN, drive, SIZE, TYPE, paint_color, image_url, description, county, state, lat, long,posting_date)
FROM '/home/maksim/Downloads/vehicles.csv'
DELIMITER ',' CSV HEADER;


DELETE
FROM raw_data
WHERE manufacturer IS NULL
  OR model IS NULL
  OR vin IS NULL
  OR cylinders IS NULL
  OR fuel IS NULL
  OR transmission IS NULL
  OR drive IS NULL
  OR SIZE IS NULL
  OR TYPE IS NULL
  OR paint_color IS NULL
  OR YEAR IS NULL;


ALTER TABLE raw_data
DROP COLUMN county,
DROP COLUMN description,
DROP COLUMN url,
DROP COLUMN region_url,
            ADD CONSTRAINT null_check CHECK (NOT (price,
                                                  YEAR,
                                                  manufacturer,
                                                  model,
                                                  CONDITION ,
                                                  cylinders,
                                                  fuel,
                                                  odometer,
                                                  title_status,
                                                  transmission,
                                                  VIN,
                                                  drive,
                                                  SIZE,
                                                  TYPE,
                                                  paint_color,
                                                  state,
                                                  lat, long, posting_date) IS NULL);


SELECT COUNT(*)
FROM raw_data;
