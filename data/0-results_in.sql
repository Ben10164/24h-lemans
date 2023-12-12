DROP TABLE IF EXISTS results_in;
-- NOTE: THIS PART WAS NOT WRITTEN BY ME! This is in the documentation for how to
--       read the data that I scrapped.
-- Create the 'results_in' table
CREATE TABLE results_in (
    id INT NOT NULL AUTO_INCREMENT,
    race_yr INT NOT NULL,
    pos VARCHAR(3) NOT NULL,
    car_class VARCHAR(12) NOT NULL,
    car_nbr VARCHAR(3) NOT NULL,
    team_cntry VARCHAR(16) NOT NULL,
    team_name VARCHAR(128) NOT NULL,
    drivers_cntry VARCHAR(32) NOT NULL,
    drivers_name VARCHAR(256) NOT NULL,
    car_chassis VARCHAR(64) NOT NULL,
    car_engine VARCHAR(64) NOT NULL,
    car_tyres VARCHAR(16) NULL,
    laps INT NULL,
    distance DECIMAL(8, 3) NULL,
    racing_time TIME(3) NULL,
    reason VARCHAR(128) NULL,
    processed TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);
-- Load data from CSV file into the 'results_in' table
LOAD DATA LOCAL INFILE 'data/results_in.csv' INTO TABLE results_in FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES (
    race_yr,
    pos,
    car_class,
    car_nbr,
    team_cntry,
    team_name,
    drivers_cntry,
    drivers_name,
    car_chassis,
    car_engine,
    @car_tyres,
    laps,
    distance,
    @racing_time,
    @reason
)
SET car_tyres = NULLIF(TRIM(@car_tyres), ''),
    racing_time = NULLIF(TRIM(@racing_time), ''),
    reason = NULLIF(TRIM(@reason), '');